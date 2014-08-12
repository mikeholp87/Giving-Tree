//
//  Discover.m
//  Giving Tree
//
//  Created by Michael Holp on 1/4/14.
//  Copyright (c) 2014 Flash. All rights reserved.
//

#import "Discover.h"
#import "SearchDetails.h"

@implementation Discover
@synthesize tagView, charities, nearTable, favorites, locationManager, userCoordinate;

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
    
    charities = [[NSMutableDictionary alloc] init];
    
    [self setUserLocation];
}

-(void)setUserLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [locationManager stopUpdatingLocation];
    CLLocation *location = [locations objectAtIndex:0];
    userCoordinate = location.coordinate;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self fetchReverseGeocodeAddress:userCoordinate.latitude withLongitude:userCoordinate.longitude withCompletionHanlder:^(NSString *city, NSString *state){
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.charitynavigator.org/api/v1/search/?app_key=badc976630b52dfbac6bf02b4de35c38&app_id=4fe02ff1&state=%@&limit=50&format=json", [[NSUserDefaults standardUserDefaults] objectForKey:@"state"]]];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            [request setDelegate:self];
            [request setTag:0];
            [request startAsynchronous];
        }];
    });
}

- (void)fetchReverseGeocodeAddress:(float)pdblLatitude withLongitude:(float)pdblLongitude withCompletionHanlder:(ReverseGeoCompletionBlock)completion {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler completionHandler = ^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        if (placemarks) {
            [placemarks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                CLPlacemark *placemark = placemarks[0];
                NSDictionary *info = placemark.addressDictionary;
                
                NSString *city = [info objectForKey:@"City"];
                NSString *state = [info objectForKey:@"State"];
                
                [[NSUserDefaults standardUserDefaults] setObject:state forKey:@"state"];
                [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"city"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if (completion) {
                    completion(city, state);
                }
                *stop = YES;
            }];
        }
    };
    
    CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:pdblLatitude longitude:pdblLongitude];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:completionHandler];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[charities objectForKey:@"objects"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10.0];
    
    NSString *city = [[[[[charities objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"city"] capitalizedString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *state = [[[charities objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"state"];
    
    cell.textLabel.text = [[[charities objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"Charity_Name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", city, state];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchDetails *details = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchDetails"];
    details.title = [[[charities objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"Charity_Name"];
    details.thisCharity = [[charities objectForKey:@"objects"] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:details animated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    [charities setDictionary:[parser objectWithString:jsonString error:NULL]];
    [nearTable reloadData];
   
    //[self findCharity];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error.localizedDescription);
}

- (void)findCharity
{
    index = rand() % [[charities objectForKey:@"objects"] count];
    
    NSString *name = [[[charities objectForKey:@"objects"] objectAtIndex:index] objectForKey:@"Charity_Name"];
    NSString *tagline = [[[charities objectForKey:@"objects"] objectAtIndex:index] objectForKey:@"Tag_Line"];
    
    [tagView setText:[NSString stringWithFormat:@"%@\n%@", name, tagline]];
}

- (IBAction)goNext:(id)sender
{
    [self findCharity];
}

- (IBAction)likeCharity:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistpath = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"Faves.plist"]];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:charities];
    [data writeToFile:plistpath atomically:YES];
    
    data = [NSData dataWithContentsOfFile:plistpath];
    favorites = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [nearTable reloadData];
}

@end
