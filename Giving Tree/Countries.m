//
//  Countries.m
//  Giving Tree
//
//  Created by Michael Holp on 1/3/14.
//  Copyright (c) 2014 Flash. All rights reserved.
//

#import "Countries.h"

@implementation Countries
@synthesize countries, countryTable;

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
	
    countries = [[NSMutableDictionary alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"http://api.charitynavigator.org/api/v1/regions/?app_key=badc976630b52dfbac6bf02b4de35c38&app_id=4fe02ff1&format=json"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[countries objectForKey:@"objects"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
    
    cell.textLabel.text = [[[countries objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"region"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[[countries objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"charity_count"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    [countries setDictionary:[parser objectWithString:jsonString error:NULL]];
    [countryTable reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error.localizedDescription);
}

@end
