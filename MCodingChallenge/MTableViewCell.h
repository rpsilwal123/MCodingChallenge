//
//  MTableViewCell.h
//  MCodingChallenge
//
//  Created by Ranjan on 5/11/16.
//  Copyright © 2016 Ranjan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;

@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;

@property (weak, nonatomic) IBOutlet UILabel *cloudLabel;

@property (weak, nonatomic) IBOutlet UILabel *maxTempLabel;

@property (weak, nonatomic) IBOutlet UILabel *minTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
