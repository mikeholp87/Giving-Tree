//
//  TopList.m
//  Giving Tree
//
//  Created by Michael Holp on 1/3/14.
//  Copyright (c) 2014 Flash. All rights reserved.
//

#import "TopList.h"
#import "TopListOrgs.h"

@implementation TopList
@synthesize categories, categoryTable;

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
	
    categories = [[NSMutableDictionary alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"http://api.charitynavigator.org/api/v1/lists/?app_key=badc976630b52dfbac6bf02b4de35c38&app_id=4fe02ff1&format=json"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[categories objectForKey:@"objects"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
    
    cell.textLabel.text = [[[categories objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"listname"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopListOrgs *orgs = [self.storyboard instantiateViewControllerWithIdentifier:@"TopOrgs"];
    orgs.title = [[[categories objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"listname"];
    orgs.listID = [[[categories objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"listid"];
    [self.navigationController pushViewController:orgs animated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    [categories setDictionary:[parser objectWithString:jsonString error:NULL]];
    [categoryTable reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error.localizedDescription);
}

@end
