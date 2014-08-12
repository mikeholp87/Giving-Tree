//
//  CategoryDetails.m
//  Giving Tree
//
//  Created by Michael Holp on 1/7/14.
//  Copyright (c) 2014 Flash. All rights reserved.
//

#import "CategoryDetails.h"
#import "SearchDetails.h"

@implementation CategoryDetails
@synthesize charities, charityTable, listID;

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
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.charitynavigator.org/api/v1/search/?app_key=badc976630b52dfbac6bf02b4de35c38&app_id=4fe02ff1&category=%@&format=json", listID]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
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
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    
    cell.textLabel.text = [[[charities objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"Charity_Name"];
    cell.detailTextLabel.text = [[[charities objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"Tag_Line"];
    
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
    
    [charityTable reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error.localizedDescription);
}

@end
