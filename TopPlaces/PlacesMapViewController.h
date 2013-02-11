//
//  PlacesMapViewController.h
//  TopPlaces
//
//  Created by kliff on 1/20/13.
//  Copyright (c) 2013 kliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class PlacesMapViewController;

@protocol PlacesMapViewControllerDelegate <NSObject>

- (NSDictionary *)getPlaceFromAnnotation:(MKAnnotationView *)view;

@end


@interface PlacesMapViewController : UIViewController
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, weak) id <PlacesMapViewControllerDelegate> deletate;
@end

