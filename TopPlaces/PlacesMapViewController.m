//
//  PlacesMapViewController.m
//  TopPlaces
//
//  Created by kliff on 1/20/13.
//  Copyright (c) 2013 kliff. All rights reserved.
//

#import "PlacesMapViewController.h"
#import "RecentLocationPhotosTableViewController.h"
#import "FlickrFetcher.h"
#import <MapKit/MapKit.h>

@interface PlacesMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation PlacesMapViewController

@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize deletate = _deletate;

- (void)setMapView:(MKMapView *)mapView {
  _mapView = mapView;
  [self updateMapView];
}

- (void)setAnnotations:(NSArray *)annotations {
  _annotations = annotations;
  [self updateMapView];
}


- (void)updateMapView {
  if (self.mapView.annotations) {
    //if any existing annotations, remove
    [self.mapView removeAnnotations:self.mapView.annotations];
  }
  if (self.annotations) {
    //then set annotations of any new annotations
    [self.mapView addAnnotations:self.annotations];
  }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
  if (!aView) {
    aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
    aView.canShowCallout = YES;
    aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //have to hardcore 30px by 30px
  }
  aView.annotation = annotation;
  
  return aView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  //we want to get the place dictionary.
  //and call segue on it
  NSDictionary *place = [self.deletate getPlaceFromAnnotation:view];
  
  [self performSegueWithIdentifier:@"PhotosOfLocation" sender:place];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"PhotosOfLocation"]) {
    RecentLocationPhotosTableViewController *rc = segue.destinationViewController;
    
    NSDictionary *place = sender;
    
    
    dispatch_queue_t dispatchQueue = dispatch_queue_create("q_photosInPlace", NULL);
    //[self.spinner startAnimating];
    
    dispatch_async(dispatchQueue, ^{
      NSArray *photos = [FlickrFetcher photosInPlace:place maxResults:50];
    
      
      //use main queue to prepare for segue
      dispatch_async(dispatch_get_main_queue(), ^{
        rc.locationPhotos = photos;
        rc.title = [place objectForKey:@"_content"];
        [rc.tableView reloadData];
        //[self.spinner stopAnimating];
      });
    });
    
  }
}


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
  self.mapView.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
