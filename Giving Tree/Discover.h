//
//  Discover.h
//  Giving Tree
//
//  Created by Michael Holp on 1/4/14.
//  Copyright (c) 2014 Flash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIHTTPRequest.h"
#import "SBJson.h"

typedef void (^ReverseGeoCompletionBlock)(NSString *city, NSString *state);

@interface Discover : UIViewController<CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSUInteger index;
}

@property(nonatomic,retain) IBOutlet UITableView *nearTable;
@property(nonatomic,retain) IBOutlet UITextView *tagView;

@property(nonatomic,retain) CLLocationManager *locationManager;
@property(assign) CLLocationCoordinate2D userCoordinate;

@property(nonatomic,retain) NSMutableDictionary *charities;
@property(nonatomic,retain) NSMutableDictionary *favorites;

@end
