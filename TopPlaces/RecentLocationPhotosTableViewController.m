//
//  RecentLocationPhotosTableViewController.m
//  TopPlaces
//
//  Created by kliff on 12/12/12.
//  Copyright (c) 2012 kliff. All rights reserved.
//

#import "RecentLocationPhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"
#import "PhotosMapViewController.h"
#import "FlickrPhotoAnnotation.h"




@interface RecentLocationPhotosTableViewController () <PhotosMapViewControllerDelegate>

@end







@implementation RecentLocationPhotosTableViewController


@synthesize locationPhotos = _locationPhotos;



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
    [super viewDidLoad];
}



//PhotoMapViewControllers delegate method to retrieve image for annotation
- (UIImage *)photosMapViewController:(PhotosMapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation {
  FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)annotation;
  NSURL *url = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
  NSData *data = [NSData dataWithContentsOfURL:url];
  return data ? [UIImage imageWithData:data] : nil;
}

- (NSDictionary *)getPhotoFromAnnotation:(MKAnnotationView *)view {
  FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)view.annotation;
  
  return fpa.photo;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"View Photo"]) {
        PhotoViewController *photoViewController = segue.destinationViewController;
        
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        photoViewController.photo = [[NSDictionary alloc] initWithDictionary:[self.locationPhotos objectAtIndex:[myIndexPath row]]];
      
    }
  
  
  
  if ([segue.identifier isEqualToString:@"PhotosInMap"]) {
    PhotosMapViewController *mapViewController = segue.destinationViewController;
    
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:self.locationPhotos.count];
    for (NSDictionary *photo in self.locationPhotos) {
      [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    
    mapViewController.delegate = self;
    mapViewController.annotations = annotations;
  }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.locationPhotos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Location Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *photo = [self.locationPhotos objectAtIndex:indexPath.row];
    
    NSString *title = [photo objectForKey:FLICKR_PHOTO_TITLE];
    NSString *description = [photo objectForKey:FLICKR_PHOTO_DESCRIPTION];
    
    if (title && ![title isEqualToString:@""]) {
        cell.textLabel.text = title;
        cell.detailTextLabel.text = description;
    }
    else if (description && ![description isEqualToString:@""]) {
        cell.textLabel.text = description;
        cell.detailTextLabel.text = @"";
    }
    else {
        cell.textLabel.text = @"Unknown";
        cell.detailTextLabel.text = @"";
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
