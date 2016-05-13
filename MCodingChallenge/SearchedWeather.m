//
//  SearchedWeather.m
//  MCodingChallenge
//
//  Created by Ranjan on 5/11/16.
//  Copyright © 2016 Ranjan. All rights reserved.
//

#import "SearchedWeather.h"

@implementation SearchedWeather

-(instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    
    if(!self)
        return nil;
    
    _dataDict = dict;
    
    _name = dict[@"name"];
    
    _country = dict[@"sys"][@"country"];
    
    _humidity = dict[@"main"][@"humidity"];
    
    _pressure = dict[@"main"][@"pressure"];
    
    _cloud = dict[@"clouds"];
    
    _currentTemp = dict[@"main"][@"temp"];
    
    _maxTemp = dict[@"main"][@"temp_max"];
    
    _minTemp = dict[@"main"][@"temp_min"];
    
    _summary = [dict[@"weather"]firstObject][@"description"];
    
    _seaLevel = dict[@"main"][@"sea_level"];
    
    _latitude = dict[@"coord"][@"lat"];
    
    _longitude = dict[@"coord"][@"lon"];
    
    
    return self;
}


@end
