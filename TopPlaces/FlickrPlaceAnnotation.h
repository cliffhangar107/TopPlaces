//
//  FlickrAnnotation.h
//  TopPlaces
//
//  Created by kliff on 1/20/13.
//  Copyright (c) 2013 kliff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


//THESE OBJECTS ARE PART OF THE CONTROLLER


//annotation has title, subtitle, and coordinates

@interface FlickrPlaceAnnotation : NSObject <MKAnnotation>

+ (FlickrPlaceAnnotation *)annotationForPlace:(NSDictionary *)place; //flickr place dictionary

@property (nonatomic, strong) NSDictionary *place;

@end
