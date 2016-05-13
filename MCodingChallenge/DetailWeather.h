//
//  DetailWeather.h
//  MCodingChallenge
//
//  Created by Ranjan on 5/11/16.
//  Copyright © 2016 Ranjan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailWeather : NSObject

@property (strong, nonatomic) NSDictionary *dataDict;

@property (strong, nonatomic) NSString *humidity;

@property (strong, nonatomic) NSString *pressure;

@property (strong, nonatomic) NSString *cloud;

@property (strong, nonatomic) NSString *maxTemp;

@property (strong, nonatomic) NSString *minTemp;

@property (strong, nonatomic) NSString *summary;

@property (strong, nonatomic) NSString *time;

@property (strong, nonatomic) NSString *cityName;

@property (strong, nonatomic) NSString *currentTemp;

@property (strong, nonatomic) NSString *countryName;

@property (strong, nonatomic) NSString *latitude;

@property (strong, nonatomic) NSString *longitude;


-(instancetype)initWithDictionary:(NSDictionary*)dict;



@end
