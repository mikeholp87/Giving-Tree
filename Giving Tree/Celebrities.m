//
//  Celebrities.m
//  Giving Tree
//
//  Created by Michael Holp on 1/7/14.
//  Copyright (c) 2014 Flash. All rights reserved.
//

#import "Celebrities.h"

@implementation Celebrities
@synthesize celebs, celebTable;

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
    
    celebs = [[NSMutableDictionary alloc] init];
	
    NSURL *url = [NSURL URLWithString:@"http://api.charitynavigator.org/api/v1/celebrities/?app_key=badc976630b52dfbac6bf02b4de35c38&app_id=4fe02ff1&format=json"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[celebs objectForKey:@"objects"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[[celebs objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"fname"], [[[celebs objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"lname"]];
    cell.detailTextLabel.text = [[[celebs objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"type"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    [celebs setDictionary:[parser objectWithString:jsonString error:NULL]];
    [celebTable reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error.localizedDescription);
}

@end
