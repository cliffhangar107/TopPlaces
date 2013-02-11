//
//  DataCache.h
//  TopPlaces
//
//  Created by kliff on 1/13/13.
//  Copyright (c) 2013 kliff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCache : NSObject

//constant to define the max size of the cache
#define MAXIMUM_CACHE_SIZE 10485760

//contant to define the trim size of the cache
#define TRIM_CACHE_SIZE 5242880

//used to fetch data from the cache
+ (NSData *)fetchData:(NSString *)key;

//used to store data in the cache
+ (void)storeData:(NSData *)data withKey:(NSString *)key;

@end
