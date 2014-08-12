//
//  SearchDetails.m
//  Giving Tree
//
//  Created by Michael Holp on 1/3/14.
//  Copyright (c) 2014 Flash. All rights reserved.
//

#import "SearchDetails.h"
#import "MapPoint.h"

@implementation SearchDetails
@synthesize thisCharity, descView, ratingLbl, scoreLbl, colorView, rankLbl, map;

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
    
    [[thisCharity objectForKey:@"Tag_Line"] isKindOfClass:[NSNull class]] ? [descView setText:@""] : [descView setText:[thisCharity objectForKey:@"Tag_Line"]];
    
    /*
    [[thisCharity objectForKey:@"Rank"] isKindOfClass:[NSNull class]] ? [rankLbl setText:@""] : [rankLbl setText:[NSString stringWithFormat:@"%@", [thisCharity objectForKey:@"Rank"]]];
    [[thisCharity objectForKey:@"OverallRtg"] isKindOfClass:[NSNull class]] ? [ratingLbl setText:@""] : [ratingLbl setText:[NSString stringWithFormat:@"%@", [thisCharity objectForKey:@"OverallRtg"]]];
    */
    
    [[thisCharity objectForKey:@"OverallScore"] isKindOfClass:[NSNull class]] ? [scoreLbl setText:@"N/A"] : [scoreLbl setText:[NSString stringWithFormat:@"%f", [[thisCharity objectForKey:@"OverallScore"] floatValue]]];
    
    float score = [[thisCharity objectForKey:@"OverallScore"] isKindOfClass:[NSNull class]] ? 0.0 : [[thisCharity objectForKey:@"OverallScore"] floatValue];
    
    if(score > 0 && score < 20)
        colorView.backgroundColor = [UIColor redColor];
    else if(score > 20 && score < 40)
        colorView.backgroundColor = [UIColor yellowColor];
    else if (score > 40)
        colorView.backgroundColor = [UIColor greenColor];
    else
        colorView.hidden = YES;
    
    [self plotLocation];
}

-(void)plotLocation
{
    CLLocationCoordinate2D center = [self getLocationFromAddressString:[thisCharity objectForKey:@"ZIP"]];
    
    NSString *citystate = [NSString stringWithFormat:@"%@, %@", [[[thisCharity objectForKey:@"city"] capitalizedString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]], [thisCharity objectForKey:@"state"]];
    
    MKCoordinateRegion region;
    region.center.latitude = center.latitude;
    region.center.longitude = center.longitude;
    region.span.latitudeDelta = 0.05;
    region.span.longitudeDelta = 0.05;
    region = [map regionThatFits:region];
    [map setRegion:region animated:YES];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = center.latitude;
    coordinate.longitude = center.longitude;
    
    MapPoint *annotation = [[MapPoint alloc] initWithCoordinate:coordinate title:citystate];
    [map addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *identifier = @"myAnnotation";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mv dequeueReusableAnnotationViewWithIdentifier:identifier];
    if(annotationView == nil){
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
        annotationView.pinColor = MKPinAnnotationColorGreen;
    }else{
        annotationView.annotation = annotation;
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *ulv = [mv viewForAnnotation:mv.userLocation];
    ulv.canShowCallout = YES;
    
    id <MKAnnotation> mp = [mv.annotations objectAtIndex:0];
    [mv selectAnnotation:mp animated:YES];
}

-(CLLocationCoordinate2D)getLocationFromAddressString:(NSString*) addressStr {
    
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}

- (IBAction)donate:(id)sender
{
    UIViewController *donate = [self.storyboard instantiateViewControllerWithIdentifier:@"Donate"];
    [self.navigationController pushViewController:donate animated:YES];
}

@end
