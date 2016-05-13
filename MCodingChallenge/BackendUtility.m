//
//  BackendUtility.m
//  MCodingChallenge
//
//  Created by Ranjan on 5/11/16.
//  Copyright © 2016 Ranjan. All rights reserved.
//

#import "BackendUtility.h"

@implementation BackendUtility


+ (id)sharedHelper
{
    static BackendUtility *sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

+ (void)callWeatherApiWithLatitude:(float)latitude longitude:(float)longitude andCompletionBlock:(receivedData)compblock
{
    NSString *url =[NSString stringWithFormat:@"%@lat=%f&lon=%f&cnt=7&APPID=%@",WEATHER_BASE_URL,latitude,longitude,API_KEY];
    
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    
    NSString *urlString = [url stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    [request setHTTPMethod:@"GET"];
    
    [request setTimeoutInterval:API_TIME_OUT_PERIOD];
    
    NSLog(@"=============================CALLING API=============================: %@", urlString);
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        // handle response
        NSError *jsonError;
        
        if(data)
        {
            id dict =
            [NSJSONSerialization JSONObjectWithData:data
                                            options:NSJSONReadingAllowFragments
                                              error:&jsonError];
            
            if (!jsonError )
            {
                compblock(dict);
            }
        }
        else
        {
            NSLog(@"The data from the request is empty.");
        }
    }] resume];
}


+ (void)callWeatherApiWithUserInputData:(NSString *)inputs andCompletionBlock:(receivedData)compblock
{
    NSString *url =[NSString stringWithFormat:@"%@%@&type=like&mode=json&APPID=%@",WEATHER_BASE_URL_USER,inputs,API_KEY];
    
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    
    NSString *urlString = [url stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    [request setHTTPMethod:@"GET"];
    
    [request setTimeoutInterval:API_TIME_OUT_PERIOD];
    
    NSLog(@"=============================CALLING API=============================: %@", urlString);
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        // handle response
        NSError *jsonError;
        
        if(data)
        {
            id dict =
            [NSJSONSerialization JSONObjectWithData:data
                                            options:NSJSONReadingAllowFragments
                                              error:&jsonError];
            
            if (!jsonError )
            {
                compblock(dict);
            }
        }
        else
        {
            NSLog(@"The data from the request is empty.");
        }
    }] resume];
}

-(NSString *)dateFromMilliseconds:(NSString *)currentDate withFormat:(NSString *)format
{
    int currentNumber = [currentDate intValue];
    
    NSDate *cDate = [NSDate dateWithTimeIntervalSince1970:currentNumber];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    
    [formatter setDateFormat:format];
    
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    
    NSString *date =  [formatter stringFromDate:cDate];
    
    return  date;
}

-(float)convertToFahrenheitFromKelvin:(float)kelvin andCondition:(int)number{
    
    if(number == 1){
        
        float fahrenheit = ((kelvin - 273) * 1.8) + 32;
        
        return fahrenheit;
    }
    
    else{
        
        float celcius = kelvin - 273;
        
        return celcius;
    }
}



@end
