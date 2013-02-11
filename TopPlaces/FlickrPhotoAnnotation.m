//
//  FlickrPhotoAnnotation.m
//  TopPlaces
//
//  Created by kliff on 1/20/13.
//  Copyright (c) 2013 kliff. All rights reserved.
//

#import "FlickrPhotoAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrPhotoAnnotation

@synthesize photo = _photo;

+ (FlickrPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo {
  FlickrPhotoAnnotation *annotation = [[FlickrPhotoAnnotation alloc] init];
  annotation.photo = photo;
  return annotation;
}

- (CLLocationCoordinate2D)coordinate {
  CLLocationCoordinate2D coordinate;
  coordinate.latitude = [[self.photo objectForKey:FLICKR_LATITUDE] doubleValue];
  coordinate.longitude = [[self.photo objectForKey:FLICKR_LONGITUDE] doubleValue];
  return coordinate;
}

- (NSString *)title {
  return [self.photo objectForKey:FLICKR_PHOTO_TITLE];
}

- (NSString *)subtitle {
  return [self.photo objectForKey:FLICKR_PHOTO_DESCRIPTION];
}

@end