//
//  UserSearchDetailsViewController.h
//  MCodingChallenge
//
//  Created by Ranjan on 5/11/16.
//  Copyright © 2016 Ranjan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackendUtility.h"
#import "MBProgressHUD.h"
#import <MapKit/MapKit.h>
#import "Social/Social.h"



@interface UserSearchDetailsViewController : UIViewController<MKMapViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate, UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>{
    
    __weak IBOutlet UITextField *userTextfield;
    
    __weak IBOutlet UIButton *searchButton;
    
    __weak IBOutlet UISegmentedControl *degreeSegmentControl;
    
    __weak IBOutlet UILabel *nameLabel;
    
    __weak IBOutlet UILabel *humidityLevel;
    
    __weak IBOutlet UILabel *seaLevelLabel;
    
    __weak IBOutlet UILabel *maxTempLabel;
    
    __weak IBOutlet UILabel *minTempLabel;
    
    __weak IBOutlet UILabel *summaryLabel;
    
    __weak IBOutlet MKMapView *userMapView;
    
    __weak IBOutlet UIImageView *backgroundImageView;
    
    __weak IBOutlet UITableView *savedAddressTableView;
    
    __weak IBOutlet NSLayoutConstraint *bottomView;
    
    __weak IBOutlet UIButton *shareButton;
    
    __weak IBOutlet UIView *separatorView;
    
    __weak IBOutlet UIView *sharingView;
    
    __weak IBOutlet UIButton *facebookShareButton;
    
    __weak IBOutlet UIButton *twitterShareButton;
    
    
    
    NSArray *listArray;
    
    NSArray *updatedAddressArray;
    
    NSDictionary *temperatureDictionary;
    
    NSDictionary *temporaryDict;
    
    BOOL isFromSearch;
    
    CLLocationManager *locationManager;
    CLGeocoder *geoCoder;
    CLPlacemark *placeMark;
    
    CLLocation *crnLoc;

}

- (IBAction)searchButtonPressed:(UIButton *)sender;

-(UIImage*)checkForImage;



@end
