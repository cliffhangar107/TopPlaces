//
//  PhotosMapViewController.h
//  TopPlaces
//
//  Created by kliff on 1/20/13.
//  Copyright (c) 2013 kliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class PhotosMapViewController;

@protocol PhotosMapViewControllerDelegate <NSObject>
- (UIImage *)photosMapViewController:(PhotosMapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
- (NSDictionary *)getPhotoFromAnnotation:(MKAnnotationView *)view;
@end




@interface PhotosMapViewController : UIViewController
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, weak) id <PhotosMapViewControllerDelegate> delegate;
@end
