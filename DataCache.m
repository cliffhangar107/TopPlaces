//
//  DataCache.m
//  TopPlaces
//
//  Created by kliff on 1/13/13.
//  Copyright (c) 2013 kliff. All rights reserved.
//

#import "DataCache.h"

@implementation DataCache

//URL of caches directory
static NSURL *cachesURL;

//file properties that we are interested in
static NSArray *fileProperties;




//returns a file manager
+ (NSFileManager *)fileManager {
  //use a new FileManager each time to ensure thread safety?
  return [[NSFileManager alloc] init];
}


//Returns the URL for caches directory
+ (NSURL *)cachesURL {
  if (!cachesURL) {
    //create a handle to the URL for the caches directory (if none already)
        
    //retrieve the URL of the Caches directory
    NSArray *cachesArray = [[self fileManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
        
    cachesURL = [cachesArray lastObject];
  }

  return cachesURL;
}


//Returns the file properties we have access to
+ (NSArray *)fileProperties {
  if (!fileProperties) {
    //create file properties array (if none already)
    
    fileProperties = [NSArray arrayWithObjects:NSURLNameKey, NSURLIsDirectoryKey, NSURLCreationDateKey, nil];
  }
  
  return fileProperties;
}


//trims the cache to within the max cache size limit, set in the header
+ (void)trimCache {
  //trim stuff here
}


//helper method that returns the full URL for a given file name
+ (NSURL *)getURLForFile:(NSString *)fileName {
  //return the url for the fil we are interested in
  return [NSURL URLWithString:fileName relativeToURL:[self cachesURL]];
}


//returns data from the file system
+ (NSData *)fetchData:(NSString *)key {
  //return the file from the file system
  return [NSData dataWithContentsOfURL:[self getURLForFile:key]];
}


//used to store data in the cache
+ (void)storeData:(NSData *)data withKey:(NSString *)key {
  //write data to the file system, will rewrite and get a new date stamp
  [data writeToURL:[self getURLForFile:key] atomically:true];
  
  //trim stuff here!
  //multithread... [self trimCache];
}



@end
















          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          




















