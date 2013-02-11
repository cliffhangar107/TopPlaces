//
//  FlickrPhotoTableViewController.h
//  TopPlaces
//
//  Created by kliff on 12/9/12.
//  Copyright (c) 2012 kliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPhotoTableViewController : UITableViewController

//@property (nonatomic, strong) NSArray *photos; // array of flickr photo dictionaries


@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end
