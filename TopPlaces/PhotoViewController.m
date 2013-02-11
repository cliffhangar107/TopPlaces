//
//  PhotoViewController.m
//  TopPlaces
//
//  Created by kliff on 12/15/12.
//  Copyright (c) 2012 kliff. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"
#import "DataCache.h"

#define PHOTO_TITLE_KEY @"title"
#define RECENT_PHOTOS_KEY @"recentPhotos"
#define PHOTO_ID_KEY @"id"
#define TOO_MANY_PHOTOS 20

@interface PhotoViewController () <UIScrollViewDelegate>
//make private outlets for the scroll view and image view
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PhotoViewController

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize photo = _photo;
@synthesize url = _url;








//UISCROLLVIEWDELEGAGE

- (void)viewWillLayoutSubviews {
    //width ratio compares the width of the viewing area with the width of the image
    float widthRatio = self.view.bounds.size.width / self.imageView.image.size.width;
    
    //some for height
    float heightRatio = self.view.bounds.size.height / self.imageView.image.size.height;
    
    //update the zoom scale
    self.scrollView.zoomScale = MAX(widthRatio, heightRatio);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

//END DELEGATE



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set this instance as the scroll view delegate
    //self is the delegate for scroll view
    self.scrollView.delegate = self;
    
    //place image into view
    //self.url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
    //NSData *imageData = [NSData dataWithContentsOfURL:self.url];
    self.imageView.image = [UIImage imageWithData:[self fetchImage]];
    
    //se the title of the image
    self.title = [self.photo objectForKey:PHOTO_TITLE_KEY];
    
    //set scroll views content size to be the images size
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    
}


- (NSData *)fetchImage {
  //fetch the image from the cache
  NSData *image = [DataCache fetchData:[self.photo objectForKey:PHOTO_ID_KEY]];
  
  if (!image) {
    //retrieve the image from Flickr
    self.url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
    image = [NSData dataWithContentsOfURL:self.url];
  }
  
  return image;
}


- (void)viewWillAppear:(BOOL)animated {
    
    
    //we need to store the photo as an NSUserDefault, since it is recently viewed
    //first get a handle to the standard user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    //bring out the current list of recently viewed photos
    NSMutableArray *recentlyViewedPhotos = [[defaults objectForKey:RECENT_PHOTOS_KEY] mutableCopy];
    
    //if we dont have any yet, then create an empty collection
    if (!recentlyViewedPhotos) recentlyViewedPhotos = [NSMutableArray array];
    
    //if we have too many photos already in our recently viewed list, then remove the one that
    //was first in the list (max 20)
    if (recentlyViewedPhotos.count > TOO_MANY_PHOTOS) {
        [recentlyViewedPhotos removeObjectAtIndex:0];
    }
    
    //we needa check if the photo is already stored in defaults so first get a handle to the id of the photo we are viewing.
    NSString *photoID = [self.photo objectForKey:PHOTO_ID_KEY];
    
    //then iterate over our recently viewed photos
    for (int i = 0; i < recentlyViewedPhotos.count; i++) {
        NSDictionary *photo = [recentlyViewedPhotos objectAtIndex:i];
        if ([[photo objectForKey:PHOTO_ID_KEY] isEqualToString:photoID]) {
            //and remove the instance from the photo if we should find one
            [recentlyViewedPhotos removeObject:photo];
            continue;
        }
    }
    
    //add the photo to the top of recently viewed photo list
    [recentlyViewedPhotos addObject:self.photo];
    
    //add the updated collection back into user defaults
    [defaults setObject:recentlyViewedPhotos forKey:RECENT_PHOTOS_KEY];
    
    [defaults synchronize];
    
    
    //Cache the image!
    NSData *imageData = [NSData dataWithContentsOfURL:self.url];
    [DataCache storeData:imageData withKey:photoID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end










































