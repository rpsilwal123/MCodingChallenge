//
//  BackendUtility.h
//  MCodingChallenge
//
//  Created by Ranjan on 5/11/16.
//  Copyright © 2016 Ranjan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define API_KEY @"3b535043693316ba125a0513276aa62d"
#define WEATHER_BASE_URL @"http://api.openweathermap.org/data/2.5/forecast/daily?"
#define API_TIME_OUT_PERIOD         30.0
#define WEATHER_BASE_URL_USER @"http://api.openweathermap.org/data/2.5/find?q="
#define STORED_ADDRESS @"storedAddress"



typedef void(^receivedData)(id receivedData);


@interface BackendUtility : NSObject

+ (id)sharedHelper;

+ (void)callWeatherApiWithLatitude:(float)latitude longitude:(float)longitude andCompletionBlock:(receivedData)compblock;

+ (void)callWeatherApiWithUserInputData:(NSString *)inputs andCompletionBlock:(receivedData)compblock;

-(NSString *)dateFromMilliseconds:(NSString *)currentDate withFormat:(NSString *)format;

-(float)convertToFahrenheitFromKelvin:(float)kelvin andCondition:(int)number;


@end
