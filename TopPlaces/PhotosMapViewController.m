//
//  PhotosMapViewController.m
//  TopPlaces
//
//  Created by kliff on 1/20/13.
//  Copyright (c) 2013 kliff. All rights reserved.
//

#import "PhotosMapViewController.h"
#import "FlickrPhotoAnnotation.h"
#import "PhotoViewController.h"
#import <MapKit/MapKit.h>

@interface PhotosMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation PhotosMapViewController

@synthesize annotations = _annotations;
@synthesize mapView = _mapView;
@synthesize delegate = _delegate;

- (void)setAnnotations:(NSArray *)annotations {
  _annotations = annotations;
  [self updateMapView];
}

- (void)setMapView:(MKMapView *)mapView {
  _mapView = mapView;
  [self updateMapView];
}



- (void)updateMapView {
  if (self.mapView.annotations) {
    [self.mapView removeAnnotations:self.mapView.annotations];
  }
  if (self.annotations) {
    [self.mapView addAnnotations:self.annotations];
  }
}



//one of MKMapViewDelegates optional methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
  if (!aView) {
    aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
    aView.canShowCallout = YES;
    aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //have to hardcore 30px by 30px
  }
  aView.annotation = annotation;
  [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
  
  return aView;
}

//another mkmapview delegate methods
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
 
  //trying to get the annotations photo dict out so we can then segue
  
  NSDictionary *photo = [self.delegate getPhotoFromAnnotation:view];
  [self performSegueWithIdentifier:@"ViewPhoto" sender:photo];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ViewPhoto"]) {
    PhotoViewController *pvc = segue.destinationViewController;
    pvc.photo = sender;
  }
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView {
  //everytime an annotation is clicked. this method is called for that annotation
  
  
  
  //now.. how are we going to get the image from flickr...
  //this controller is flickr free (no import or using methods of it)
  //what we want to do... delegation
    //so this controller needs to make a protocol for some other class to be its delegate
  UIImage *image = [self.delegate photosMapViewController:self imageForAnnotation:aView.annotation];
  [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
}



#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360


- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated
{
  NSArray *annotations = mapView.annotations;
  int count = [mapView.annotations count];
  if ( count == 0) { return; } //bail if no annotations
  
  //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
  //can't use NSArray with MKMapPoint because MKMapPoint is not an id
  MKMapPoint points[count]; //C array of MKMapPoint struct
  for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
  {
    CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
    points[i] = MKMapPointForCoordinate(coordinate);
  }
  //create MKMapRect from array of MKMapPoint
  MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
  //convert MKCoordinateRegion from MKMapRect
  MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
  
  //add padding so pins aren't scrunched on the edges
  region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
  region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
  //but padding can't be bigger than the world
  if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
  if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
  
  //and don't zoom in stupid-close on small samples
  if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
  if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
  //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
  if( count == 1 )
  {
    region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
    region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
  }
  [mapView setRegion:region animated:animated];
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

- (void)viewWillAppear:(BOOL)animated {
  
  [self zoomMapViewToFitAnnotations:self.mapView animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
