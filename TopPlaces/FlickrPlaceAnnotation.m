//
//  FlickrAnnotation.m
//  TopPlaces
//
//  Created by kliff on 1/20/13.
//  Copyright (c) 2013 kliff. All rights reserved.
//

#import "FlickrPlaceAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrPlaceAnnotation

@synthesize place = _place;

+ (FlickrPlaceAnnotation *)annotationForPlace:(NSDictionary *)place {
  FlickrPlaceAnnotation *annotation = [[FlickrPlaceAnnotation alloc] init];
  annotation.place = place;
  return annotation;
}


- (CLLocationCoordinate2D)coordinate {
  CLLocationCoordinate2D coordinate;
  coordinate.latitude = [[self.place objectForKey:FLICKR_PLACE_LATITUDE] doubleValue];
  coordinate.longitude = [[self.place objectForKey:FLICKR_PLACE_LONGITUDE] doubleValue];
  return coordinate;
}

- (NSString *)title {
  return [self.place objectForKey:FLICKR_PLACE_CONTENT];
}

@end
