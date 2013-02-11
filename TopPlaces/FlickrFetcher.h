//
//  FlickrFetcher.h
//
//  Created for Stanford CS193p Fall 2011.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FLICKR_PHOTO_TITLE @"title"
#define FLICKR_PHOTO_DESCRIPTION @"description._content"
#define FLICKR_PLACE_NAME @"_content"
#define FLICKR_PHOTO_ID @"id"
#define FLICKR_PHOTO_OWNER @"ownername"
#define FLICKR_LATITUDE @"latitude"
#define FLICKR_LONGITUDE @"longitude"


#define FLICKR_PLACE_CONTENT @"_content"
#define FLICKR_PLACE_LATITUDE @"latitude"
#define FLICKR_PLACE_LONGITUDE @"longitude"
#define FLICKR_PLACE_ID @"place_id"
#define FLICKR_PLACE_URL @"place_url"
#define FLICKR_PLACE_WOE_NAME @"woe_name"


/*
(NSDictionary *) $1 = 0x08544d00 {
  "_content" = "Amiens, Picardie, France";
  latitude = "49.894";
  longitude = "2.293";
  "photo_count" = 75;
  "place_id" = "ymOQFY1UVb.ktQY";
  "place_type" = locality;
  "place_type_id" = 7;
  "place_url" = "/France/Picardie/Amiens";
  timezone = "Europe/Paris";
  "woe_name" = Amiens;
  woeid = 575961;
}*/



typedef enum {
	FlickrPhotoFormatSquare = 1,
	FlickrPhotoFormatLarge = 2,
	FlickrPhotoFormatOriginal = 64
} FlickrPhotoFormat;

@interface FlickrFetcher : NSObject

+ (NSArray *)topPlaces;
+ (NSArray *)photosInPlace:(NSDictionary *)place maxResults:(int)maxResults;
+ (NSURL *)urlForPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format;

@end
