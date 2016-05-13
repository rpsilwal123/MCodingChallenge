//
//  DetailWeather.m
//  MCodingChallenge
//
//  Created by Ranjan on 5/11/16.
//  Copyright © 2016 Ranjan. All rights reserved.
//

#import "DetailWeather.h"

@implementation DetailWeather

-(instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    
    if(!self)
        return nil;
    
    _dataDict = dict;
    
    _humidity = dict[@"humidity"];
    
    _pressure = dict[@"pressure"];

    _cloud = dict[@"clouds"];

    _maxTemp = dict[@"temp"][@"max"];

    _minTemp = dict[@"temp"][@"min"];

    _summary = [dict[@"weather"]firstObject][@"description"];
    
    _time = dict[@"dt"];
    
    _cityName = dict[@"name"];
    
    _countryName = dict[@"country"];
    
    _currentTemp = dict[@"temp"];

    _latitude = dict[@"coord"][@"lat"];
    
    _longitude = dict[@"coord"][@"lon"];

    
    return self;
}


@end
