//
//  ViewController.m
//  MCodingChallenge
//
//  Created by Ranjan on 5/11/16.
//  Copyright © 2016 Ranjan. All rights reserved.
//

#import "ViewController.h"
#import "BackendUtility.h"
#import "MBProgressHUD.h"
#import "MTableViewCell.h"
#import "DetailWeather.h"
#import "UserSearchDetailsViewController.h"


@interface ViewController ()

@end

@implementation ViewController


#pragma mark ViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getCurrentLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


#pragma mark UITableViewData source and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return weatherArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSDictionary *nowDictionary = [weatherArray objectAtIndex:section];
    
    DetailWeather * detail = [[DetailWeather alloc]initWithDictionary:nowDictionary];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    
    headerView.backgroundColor = [UIColor blackColor];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 300, 40)];
    
    NSString *string = [[BackendUtility sharedHelper] dateFromMilliseconds:[NSString stringWithFormat:@"%@", detail.time] withFormat:@"EEE',' MMM dd yyyy"];
    
    textLabel.text = string;
    
    textLabel.textColor = [UIColor whiteColor];
    
    [headerView addSubview:textLabel];
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *nowDictionary = [weatherArray objectAtIndex:indexPath.section];
    
    static NSString* CellIdentifier = @"MTableViewCell";
    
    MTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(!cell)
        cell = [[MTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    DetailWeather * detail = [[DetailWeather alloc]initWithDictionary:nowDictionary];
    
    cell.humidityLabel.text = [NSString stringWithFormat:@"Humidity: %@%@", detail.humidity,@"%"];
    cell.pressureLabel.text = [NSString stringWithFormat:@"Pressure: %@ in", detail.pressure];
    cell.cloudLabel.text =  [NSString stringWithFormat:@"Clouds: %@", detail.cloud];
    cell.maxTempLabel.text = [NSString stringWithFormat:@"Max Temp: %.fº", [[BackendUtility sharedHelper] convertToFahrenheitFromKelvin:[detail.maxTemp floatValue] andCondition:1]];
    cell.minTempLabel.text = [NSString stringWithFormat:@"Max Temp: %.fº", [[BackendUtility sharedHelper] convertToFahrenheitFromKelvin:[detail.minTemp floatValue] andCondition:1]];
    cell.descriptionLabel.text = [NSString stringWithFormat:@"Daily Summary: %@", detail.summary];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}


#pragma mark - Backend methods

-(void)callBackendApiToRetrieveWeatherWith:(float)longitude andLattitude:(float)latitude{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [BackendUtility callWeatherApiWithLatitude:latitude longitude:longitude andCompletionBlock:^(id receivedData) {
        
        if(receivedData && [receivedData isKindOfClass:[NSDictionary class]]){
            
            int status = [receivedData[@"cod"] intValue];
            
            if(status == 200){
                
                weatherArray = receivedData[@"list"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    cityCountryLabel.text = [NSString stringWithFormat:@"%@, %@", receivedData[@"city"][@"name"],receivedData[@"city"][@"country"]];
                    
                    [weatherTableview reloadData];
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                });
                weatherTableview.delegate = self;
            }
        }
        else{
            
            [self showAlertWithTitle:@"Error" andMessage:@"An error has been occured. Please try again later."];
            
        }
    }];
}

#pragma mark - CLocation methods

-(void)getCurrentLocation
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
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            [locationManager requestAlwaysAuthorization];
        } break;
        case kCLAuthorizationStatusDenied: {
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [locationManager startUpdatingLocation];
            
            [self callBackendApiToRetrieveWeatherWith:locationManager.location.coordinate.longitude andLattitude:locationManager.location.coordinate.latitude];
            
            weatherTableview.delegate = self;
            weatherTableview.dataSource = self;
            
        } break;
        default:
            break;
    }
}


-(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
