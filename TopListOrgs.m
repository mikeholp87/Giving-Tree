//
//  TopListOrgs.m
//  Giving Tree
//
//  Created by Michael Holp on 1/3/14.
//  Copyright (c) 2014 Flash. All rights reserved.
//

#import "TopListOrgs.h"
#import "SearchDetails.h"

@implementation TopListOrgs
@synthesize orgsTable, topOrgs, listID;

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
	
    topOrgs = [[NSMutableDictionary alloc] init];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.charitynavigator.org/api/v1/lists-orgs/?app_key=badc976630b52dfbac6bf02b4de35c38&app_id=4fe02ff1&format=json&listid=%@", listID]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[topOrgs objectForKey:@"objects"] count];
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
    
    cell.textLabel.text = [[[topOrgs objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"charity_name"];
    cell.detailTextLabel.text = [[[topOrgs objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"tag_line"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchDetails *details = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchDetails"];
    details.title = [[[topOrgs objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"charity_name"];
    details.thisCharity = [[topOrgs objectForKey:@"objects"] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:details animated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    [topOrgs setDictionary:[parser objectWithString:jsonString error:NULL]];
    [orgsTable reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error.localizedDescription);
}

@end
