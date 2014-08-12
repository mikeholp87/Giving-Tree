//
//  SearchDetails.h
//  Giving Tree
//
//  Created by Michael Holp on 1/3/14.
//  Copyright (c) 2014 Flash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIHTTPRequest.h"
#import "SBJson.h"

@interface SearchDetails : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>

@property(nonatomic,retain) IBOutlet MKMapView *map;
@property(nonatomic,retain) IBOutlet UITextView *descView;
@property(nonatomic,retain) IBOutlet UILabel *ratingLbl;
@property(nonatomic,retain) IBOutlet UILabel *scoreLbl;
@property(nonatomic,retain) IBOutlet UILabel *rankLbl;
@property(nonatomic,retain) IBOutlet UIView *colorView;

@property(nonatomic,retain) NSMutableDictionary *thisCharity;

@end
