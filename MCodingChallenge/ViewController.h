//
//  ViewController.h
//  MCodingChallenge
//
//  Created by Ranjan on 5/11/16.
//  Copyright © 2016 Ranjan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController<CLLocationManagerDelegate, UITableViewDelegate,UITableViewDataSource> {
    
    CLLocationManager *locationManager;
    CLGeocoder *geoCoder;
    CLPlacemark *placeMark;
        
    CLLocation *crnLoc;
    
    NSArray *weatherArray;
    
    
    __weak IBOutlet UILabel *cityCountryLabel;

    __weak IBOutlet UITableView *weatherTableview;
}

-(void)getCurrentLocation;

@end

