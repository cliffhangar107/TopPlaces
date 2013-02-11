//
//  FlickrPhotoAnnotation.h
//  TopPlaces
//
//  Created by kliff on 1/20/13.
//  Copyright (c) 2013 kliff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrPhotoAnnotation : NSObject <MKAnnotation>

+ (FlickrPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo;

@property (nonatomic, strong) NSDictionary *photo;


@end