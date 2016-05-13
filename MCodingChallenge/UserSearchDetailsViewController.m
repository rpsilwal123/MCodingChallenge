//
//  UserSearchDetailsViewController.m
//  MCodingChallenge
//
//  Created by Ranjan on 5/11/16.
//  Copyright © 2016 Ranjan. All rights reserved.
//

#import "UserSearchDetailsViewController.h"
#import "SearchedWeather.h"
#import "ViewController.h"
#import "DetailWeather.h"

@interface UserSearchDetailsViewController ()


@end

@implementation UserSearchDetailsViewController

#pragma mark - ViewController Life Cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setting up ViewController

-(void)setupViewController{
    
    searchButton.layer.cornerRadius = 5;
    
    userTextfield.delegate = self;
    
    if([self checkForImage]){
        [backgroundImageView setImage:[self checkForImage]];
    }
    else{
        [backgroundImageView setImage:[UIImage imageNamed:@"Paris"]];
    }
    
    [self performBlurEffectWithImageView:backgroundImageView];
    
    NSUserDefaults *savedAddress = [NSUserDefaults standardUserDefaults];
    
    updatedAddressArray = [savedAddress objectForKey:STORED_ADDRESS];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    savedAddressTableView.tableFooterView = [UIView new];
    
    shareButton.layer.cornerRadius = shareButton.layer.frame.size.width/2;
    
    [self getUserPermissionToAccessCurrentLocation];

}


#pragma mark Getting Location methods

-(void)getUserPermissionToAccessCurrentLocation
{
    locationManager = [[CLLocationManager alloc] init];
    
    geoCoder = [[CLGeocoder alloc]init];
    
    [locationManager setDelegate:self];
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    [locationManager requestAlwaysAuthorization];
    
    [locationManager startUpdatingLocation];

}

-(void)loadSetupViewWithCondition:(int) number{
    
    NSDictionary *userDict = [listArray firstObject];
    
    SearchedWeather *weather = [[SearchedWeather alloc] initWithDictionary:userDict];
    
    nameLabel.text = [NSString stringWithFormat:@"%@, %@", weather.name, weather.country];
    humidityLevel.text = [NSString stringWithFormat:@"Humidity: %f%@", [weather.humidity floatValue],@"%"];
    seaLevelLabel.text = [NSString stringWithFormat:@"Sea Level: %f", [weather.seaLevel floatValue]];
    maxTempLabel.text = [NSString stringWithFormat:@"Max Temp: %.fº", [[BackendUtility sharedHelper] convertToFahrenheitFromKelvin:[weather.maxTemp intValue] andCondition:number]];
    minTempLabel.text = [NSString stringWithFormat:@"Min Temp: %.fº", [[BackendUtility sharedHelper] convertToFahrenheitFromKelvin:[weather.minTemp intValue] andCondition: number]];
    summaryLabel.text = [NSString stringWithFormat:@"Summary: %@", weather.summary];
    
     [self getUserPermissionToAccessCurrentLocation];
    
    [self loadMapKitInfo];
}


#pragma mark - MapViewDelegate

- (void)loadMapKitInfo{
    
    userMapView.hidden = NO;
    userMapView.showsUserLocation = YES;
    userMapView.mapType = MKMapTypeStandard;
    userMapView.delegate = self;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    NSDictionary *userDict = [listArray firstObject];
    
    SearchedWeather *weather = [[SearchedWeather alloc] initWithDictionary:userDict];
    
    NSNumber *latitude = [NSNumber numberWithFloat:[weather.latitude floatValue]];
    NSNumber *longitude = [NSNumber numberWithFloat:[weather.longitude floatValue]];
    
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    myAnnotation.coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
    
    myAnnotation.title = weather.name;
    myAnnotation.subtitle = [NSString stringWithFormat:@"Current Temp: %.fº", [[BackendUtility sharedHelper] convertToFahrenheitFromKelvin:[weather.currentTemp intValue] andCondition:1]];
    
    MKCoordinateRegion region;
    region.center.latitude = [latitude floatValue];
    region.center.longitude = [longitude floatValue];
    region.span.latitudeDelta = 1;
    region.span.longitudeDelta = 1;
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:TRUE];
    
    [userMapView addAnnotation:myAnnotation];
}

#pragma mark - IBActions ApiCalls

- (IBAction)searchButtonPressed:(UIButton *)sender {
    
    if(userTextfield.text.length ==5){
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        savedAddressTableView.hidden = YES;
        
        isFromSearch = YES;
        
        [BackendUtility callWeatherApiWithUserInputData:userTextfield.text andCompletionBlock:^(id receivedData) {
            
            if(receivedData && [receivedData isKindOfClass:[NSDictionary class]]){
                
                int status = [receivedData[@"cod"] intValue];
                
                if(status == 200){
                    
                    listArray = receivedData[@"list"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        temporaryDict = [listArray firstObject];
                        
                        NSString *latitudeString = temporaryDict[@"coord"][@"lat"];
                        NSString *longitudeString = temporaryDict[@"coord"][@"lon"];
                        NSString *cityName = temporaryDict[@"name"];
                        NSString *countryName = temporaryDict[@"sys"][@"country"];
                        
                        NSDictionary *savingDict = @{@"lat":latitudeString,
                                                     @"lon":longitudeString,
                                                     @"cityName":cityName,
                                                     @"country":countryName};
                        
                        NSMutableArray *mArray = [NSMutableArray new];
                        
                        [mArray addObject:savingDict];
                        
                        NSMutableArray *uniqueArray = [NSMutableArray new];
                        
                        
                        for (NSDictionary *dict in updatedAddressArray) {
                            
                            [uniqueArray addObject:dict[@"cityName"]];
                            
                        }
                        
                        if(![uniqueArray containsObject:cityName]){
                            
                            [mArray addObjectsFromArray:updatedAddressArray];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:mArray forKey:STORED_ADDRESS];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            updatedAddressArray = [mArray copy];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [savedAddressTableView reloadData];
                                
                            });
                        }
                        
                        [self loadSetupViewWithCondition:1];
                        
                        userMapView.hidden = NO;
                        
                        degreeSegmentControl.hidden = NO;
                        
                        separatorView.hidden = NO;
                        
                        UITextField *dataTextfield = (UITextField *)[self.view viewWithTag:1];
                        
                        [dataTextfield resignFirstResponder];
                        
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                    });
                }
            }
            
        }];
        
    }
    else{
        
        [self showAlertWithTitle:@"Error" andMessage:@"Please check your zipcode and try again."];
    }
}

#pragma mark - AlertMethods


-(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        bottomView.constant = keyboardSize.height;
        
        CGRect f = self.view.frame;
        f.origin.y = 0;
        self.view.frame = f;
        
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
        bottomView.constant = 0;
        
    }];
}


#pragma mark - UITableView Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return updatedAddressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(!cell)
        cell = [(UITableViewCell *)[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    NSDictionary *dict = [updatedAddressArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", dict[@"cityName"],dict[@"country"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [userTextfield resignFirstResponder];
    
    NSDictionary *dict = [updatedAddressArray objectAtIndex:indexPath.row];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [BackendUtility callWeatherApiWithLatitude:[dict[@"lat"]floatValue] longitude:[dict[@"lon"] floatValue] andCompletionBlock:^(id receivedData) {
        
        if(receivedData){
            
            temperatureDictionary = [receivedData[@"list"]firstObject];
            
            DetailWeather * detail = [[DetailWeather alloc]initWithDictionary:temperatureDictionary];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                nameLabel.text = [NSString stringWithFormat:@"%@, %@", dict[@"cityName"],dict[@"country"]];
                humidityLevel.text = [NSString stringWithFormat:@"Humidity: %@%@", detail.humidity,@"%"];
                summaryLabel.text = [NSString stringWithFormat:@"Daily Summary: %@", detail.summary];
                maxTempLabel.text = [NSString stringWithFormat:@"Max Temp: %.fº", [[BackendUtility sharedHelper] convertToFahrenheitFromKelvin:[detail.maxTemp floatValue] andCondition:1]];
                minTempLabel.text = [NSString stringWithFormat:@"Min Temp: %.fº", [[BackendUtility sharedHelper] convertToFahrenheitFromKelvin:[detail.minTemp floatValue] andCondition:1]];
                
                degreeSegmentControl.hidden = NO;
                
                [self.view reloadInputViews];
                
                savedAddressTableView.hidden = YES;
                
                separatorView.hidden = NO;
                
                /*
                 
                 Need to work on loading maps for saved addresses
                 
                 [self loadMapKitInfo];
                 
                 */
                
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            });
        }
    }];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSUserDefaults *savedAddress = [NSUserDefaults standardUserDefaults];
        
        NSArray *array = [savedAddress objectForKey:STORED_ADDRESS];
        
        NSMutableArray *newArray = [array mutableCopy];
        
        if(newArray.count){
            
            [newArray removeObjectAtIndex:indexPath.row];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:STORED_ADDRESS];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        updatedAddressArray = [newArray copy];
        
        [savedAddressTableView reloadData];
    }
}

#pragma mark - Helper Methods

-(void)loadMinMaxTemperatureFromDictionary:(NSDictionary*)dict andCondition:(int)number{
    
    DetailWeather * detail = [[DetailWeather alloc]initWithDictionary:dict];
    
    maxTempLabel.text = [NSString stringWithFormat:@"Max Temp: %.fº", [[BackendUtility sharedHelper] convertToFahrenheitFromKelvin:[detail.maxTemp floatValue] andCondition:number]];
    minTempLabel.text = [NSString stringWithFormat:@"Min Temp: %.fº", [[BackendUtility sharedHelper] convertToFahrenheitFromKelvin:[detail.minTemp floatValue] andCondition:number]];
}

-(void)loadMaxMinTemperatureFromDictionary:(NSDictionary*)dict andCondition:(int)number{
    
    SearchedWeather * detail = [[SearchedWeather alloc]initWithDictionary:dict];
    
    maxTempLabel.text = [NSString stringWithFormat:@"Max Temp: %.fº", [[BackendUtility sharedHelper] convertToFahrenheitFromKelvin:[detail.maxTemp floatValue] andCondition:number]];
    minTempLabel.text = [NSString stringWithFormat:@"Min Temp: %.fº", [[BackendUtility sharedHelper] convertToFahrenheitFromKelvin:[detail.minTemp floatValue] andCondition:number]];
}


#pragma mark - UITextfields delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [userTextfield resignFirstResponder];
    
    return YES;
}


-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField{
    
    userTextfield.keyboardType = UIKeyboardTypePhonePad;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackOpaque;
    numberToolbar.alpha = 0.8;
    numberToolbar.tintColor = [UIColor whiteColor];
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                            style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(doneButtonPressed:)]];
    
    textField.inputAccessoryView = numberToolbar;
    
    [numberToolbar sizeToFit];
    
    
    savedAddressTableView.hidden = NO;
    
    return YES;
}

-(void)doneButtonPressed :(id)sender{
    
    [userTextfield resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
    
}

#pragma mark IBActions Goto Nextpage and CameraSettings

- (IBAction)CurrentButtonClicked:(UIBarButtonItem *)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ViewController * vc = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)cameraButtonClicked:(UIBarButtonItem *)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Add a Photo"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                                                             picker.delegate = (id) self;
                                                             picker.allowsEditing = YES;
                                                             
                                                             if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                                 
                                                                 picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                 
                                                                 picker.mediaTypes = [NSArray arrayWithObjects:@"public.image",nil];
                                                                 
                                                                 [self.navigationController presentViewController:picker animated:YES
                                                                                                       completion:nil];
                                                                 
                                                             }
                                                             else{
                                                                 
                                                                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                message:@"Please check your device and try again with camera compatible device."
                                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                                 
                                                                 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                                       handler:^(UIAlertAction * action) {}];
                                                                 
                                                                 [alert addAction:defaultAction];
                                                                 [self presentViewController:alert animated:YES completion:nil];
                                                             }
                                                             
                                                             
                                                             
                                                             
                                                         }];
    
    UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   
                                                                   UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                                                                   picker.delegate = (id) self;
                                                                   picker.allowsEditing = YES;
                                                                   picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                   picker.mediaTypes = [NSArray arrayWithObjects:@"public.image",nil];
                                                                   
                                                                   [self.navigationController presentViewController:picker animated:YES
                                                                                                         completion:nil];
                                                                   
                                                                   
                                                                   
                                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       [self dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
    
    
    [alert addAction:cameraAction];
    [alert addAction:photoLibraryAction];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma  mark - UIImagePicker Delegate Method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *storagePath = [NSString stringWithFormat:@"%@/image.jpeg",[paths firstObject]];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0);
    
    [imageData writeToFile:storagePath atomically:YES];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    
    backgroundImageView.image = image;
}

-(UIImage*)checkForImage{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *storagePath = [NSString stringWithFormat:@"%@/image.jpeg",[paths firstObject]];
    
    NSFileHandle* myFileHandle = [NSFileHandle fileHandleForReadingAtPath:storagePath];
    
    UIImage* loadedImage = [UIImage imageWithData:[myFileHandle readDataToEndOfFile]];
    
    return loadedImage;
    
}

#pragma mark BlurEffect method

- (void)performBlurEffectWithImageView:(UIView *) myView
{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *bluredView = [[UIVisualEffectView alloc] initWithEffect:effect];
    
    bluredView.frame = self.view.bounds;
    
    if (bluredView != nil)
    {
        [UIView animateWithDuration:0.1f animations:^{
            [bluredView setAlpha:1.0f];
            
        } completion:^(BOOL finished) {
            [myView addSubview:bluredView];
        }];
    }
}

#pragma mark - SegmentControl methods

- (IBAction)switchTemperatures:(UISegmentedControl *)sender {
    
    if(sender.selectedSegmentIndex == 0){
        
        if(!isFromSearch){
            [self loadMinMaxTemperatureFromDictionary:temperatureDictionary andCondition:1];
            
        }
        else{
            [self loadMaxMinTemperatureFromDictionary:temporaryDict andCondition:1];
        }
    }
    else{
        
        if(!isFromSearch){
            [self loadMinMaxTemperatureFromDictionary:temperatureDictionary andCondition:2];
            
        }
        else{
            [self loadMaxMinTemperatureFromDictionary:temporaryDict andCondition:2];
        }
    }
}

#pragma mark - Social media sharing methods

-(void)loadTwitterSharingMessagewithDictionary:(NSDictionary *)dict{
    
    SearchedWeather *weather = [[SearchedWeather alloc] initWithDictionary:dict];
    
    NSString *cityName = [NSString stringWithFormat:@"%@, %@", dict[@"cityName"],dict[@"country"]];
    NSString *maxTemp = [NSString stringWithFormat:@"Max Temperature: %.fº", [[BackendUtility sharedHelper] convertToFahrenheitFromKelvin:[weather.maxTemp intValue] andCondition:1]];
    NSString *minTemp = [NSString stringWithFormat:@"Min Temperature: %.fº", [[BackendUtility sharedHelper] convertToFahrenheitFromKelvin:[weather.minTemp intValue] andCondition: 1]];
    NSString *summaryText = [NSString stringWithFormat:@"Summary: %@", weather.summary];
    
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:[NSString stringWithFormat:@"Hi Everybody! Look out my weather here in %@. MaxTemperature is %@ and minTemp is %@. Summary of the day: %@",cityName,maxTemp,minTemp,summaryText]];
    
    [self presentViewController:tweetSheet animated:YES completion:nil];
}

- (IBAction)facebookShareButtonClicked:(UIButton *)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        if([self checkForImage]){
            [backgroundImageView setImage:[self checkForImage]];
        }
        
        [controller addImage:[self checkForImage]];
        
    } else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry"
                                                                       message:@"You can't post right now, make sure your device has an internet connection and you have at least one facebook account setup."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    
}


- (IBAction)twitterShareButtonClicked:(UIButton *)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        NSDictionary *userDict = [listArray firstObject];
        
        [self loadTwitterSharingMessagewithDictionary:userDict];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sorry"
                                                                       message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}


-(IBAction)FBPressed{
    
    if(sharingView.hidden){
        sharingView.hidden = NO;
    }
    else{
        sharingView.hidden = YES;
    }
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
