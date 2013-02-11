//
//  FlickrPhotoTableViewController.m
//  TopPlaces
//
//  Created by kliff on 12/9/12.
//  Copyright (c) 2012 kliff. All rights reserved.
//

#import "FlickrPhotoTableViewController.h"
#import "FlickrFetcher.h"
#import "RecentLocationPhotosTableViewController.h"
#import "PlacesMapViewController.h"
#import "FlickrPlaceAnnotation.h"

#define CONTENT_KEY @"_content"

@interface FlickrPhotoTableViewController () <PlacesMapViewControllerDelegate>

@end



@implementation FlickrPhotoTableViewController

@synthesize places = _places;
@synthesize spinner = _spinner;

- (UIActivityIndicatorView *)spinner {
    //if we dont have a spinner, then set one up
    if (!_spinner) {
        
        //setup spinner
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        //add the spinner to the tab bar
        [self.tabBarController.tabBar addSubview:_spinner];
    }
    
    return _spinner;
}


- (void)setPlaces:(NSArray *)places {
    if (_places != places) {
        _places = places;
        [self.tableView reloadData];
    }
    
    //possible issue with this if both are not even set at all in the first place
}





//Another button going to the map
- (NSDictionary *)getPlaceFromAnnotation:(MKAnnotationView *)view {
  FlickrPlaceAnnotation *fpa = (FlickrPlaceAnnotation *)view.annotation;
  
  
  
  
  
  
  
  return fpa.place;
}





//when refreshing. the request can take a while especially for the demo method
//and can lag the program. so we need to use GCD for this.
//the request blocks
//need to have it run on another thread
- (IBAction)refresh:(id)sender {
    //for the spinner to show that the action is happening
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    
    //initialize the queue used to download from flickr
    dispatch_queue_t downloadQueue = dispatch_queue_create("q_refreshTopPlaces", NULL);
    
    //use the download queue to asynchronously ge the list of top places
    dispatch_async(downloadQueue, ^{
        NSArray *places = [self orderedTopPlaces];
        
        //doing just (self.places = places;) without nesting this in the main queue is bad.
        //because it will call setPlaces() which will call the table view
        //do nested calls. needs to be done in the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = sender; //put the button back instead of spinner
            self.places = places;
        });
    });
}


- (NSArray *)orderedTopPlaces {
    //create a sorted array of place descriptions
    NSArray *sortDescriptors = [NSArray arrayWithObject:
                                [NSSortDescriptor sortDescriptorWithKey:CONTENT_KEY ascending:YES]];

    return [[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:sortDescriptors];
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PlaceToPhoto"]) {
        //this gets the destination view controller
        RecentLocationPhotosTableViewController *recentLocationController = segue.destinationViewController;
        
        //get the index of the row pressed
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        
        
        NSDictionary *place = [[NSDictionary alloc] initWithDictionary:[self.places objectAtIndex:[myIndexPath row]]];
      
      
        
        dispatch_queue_t dispatchQueue = dispatch_queue_create("q_photosInPlace", NULL);
        [self.spinner startAnimating];
        
        dispatch_async(dispatchQueue, ^{
            NSArray *photos = [FlickrFetcher photosInPlace:place maxResults:50];
            
            //use main queue to prepare for segue
            dispatch_async(dispatch_get_main_queue(), ^{
                recentLocationController.locationPhotos = photos;
                recentLocationController.title = [place objectForKey:@"_content"];
                [recentLocationController.tableView reloadData];
                [self.spinner stopAnimating];
            });
        });
    }
  
  
  if ([segue.identifier isEqualToString:@"PlacesMapView"]) {
    //SEGUE TO MAPVIEW
    PlacesMapViewController *mapViewController = segue.destinationViewController;
    
    //make annotations
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:self.places.count];
    for (NSDictionary *place in self.places) {
      [annotations addObject:[FlickrPlaceAnnotation annotationForPlace:place]];
    }
    
    mapViewController.deletate = self;
    mapViewController.annotations = annotations;
  }
}





//AUTO GENERATED STUFF

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //THIS FOR WHEN THE VIEW INITIALIZES!!!!!!
    [super viewDidLoad];
    
    
    //initialize queue used to download from flicker
    dispatch_queue_t dispatchQueue = dispatch_queue_create("q_loadTopPlaces", NULL);
    [self.spinner startAnimating];
    
    dispatch_async(dispatchQueue, ^{
        self.places = [self orderedTopPlaces];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.spinner stopAnimating];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






#pragma mark - Table view data source

/*
 NO SECTIONS. THIS CODE NOT NEEDED
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.places count];
}

//gets a UITAbleCell to display
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Place";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDictionary *place = [self.places objectAtIndex:indexPath.row];
    NSString *location = [place objectForKey:CONTENT_KEY];
    
    NSRange firstComma = [location rangeOfString:@","];
    
    if (firstComma.location == NSNotFound) {
        cell.textLabel.text = location;
        cell.detailTextLabel.text = @"";
    }
    else {
        cell.textLabel.text = [location substringToIndex:firstComma.location];
        cell.detailTextLabel.text = [location substringFromIndex:firstComma.location + 1];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
