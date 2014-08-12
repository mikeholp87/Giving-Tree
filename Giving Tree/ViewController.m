//
//  ViewController.m
//  Giving Tree
//
//  Created by Michael Holp on 1/3/14.
//  Copyright (c) 2014 Flash. All rights reserved.
//

#import "ViewController.h"
#import "SearchDetails.h"
#import "CategoryDetails.h"

@implementation ViewController
@synthesize searchDisplayController, searchResults, searchBar, searchTable, categories;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    searchResults = [[NSMutableDictionary alloc] init];
    categories = [[NSMutableDictionary alloc] init];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.charitynavigator.org/api/v1/categories/?app_key=badc976630b52dfbac6bf02b4de35c38&app_id=4fe02ff1&format=json"]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setTag:1];
    [request startAsynchronous];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(searchEditing)
        return [[searchResults objectForKey:@"objects"] count];
    else
        return [[categories objectForKey:@"objects"] count];
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
    
    if(searchEditing){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.text = [[[searchResults objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"Charity_Name"];
        cell.detailTextLabel.text = [[[searchResults objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"Category"];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.text = [[[categories objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"category"];
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(searchEditing){
        SearchDetails *details = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchDetails"];
        details.title = [[[searchResults objectForKey:@"objects"] objectAtIndex:indexPath.row] objectForKey:@"Charity_Name"];
        details.thisCharity = [[searchResults objectForKey:@"objects"] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:details animated:YES];
    }else{
        CategoryDetails *details = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryDetails"];
        details.title = [searchTable cellForRowAtIndexPath:indexPath].textLabel.text;
        details.listID = [NSString stringWithFormat:@"%d", indexPath.row+1];
        [self.navigationController pushViewController:details animated:YES];
    }
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.charitynavigator.org/api/v1/search/?app_key=badc976630b52dfbac6bf02b4de35c38&app_id=4fe02ff1&term=%@&format=json", searchText]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setTag:0];
    [request startAsynchronous];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self filterContentForSearchText:self.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    [self.searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchEditing = TRUE;
    searchTable.userInteractionEnabled = FALSE;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchEditing = FALSE;
    searchTable.userInteractionEnabled = TRUE;
}

- (void)goBack:(id)sender
{
    searchEditing = FALSE;
    searchBar.text = nil;
    self.navigationItem .leftBarButtonItem = nil;
    [searchTable reloadData];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    if(request.tag == 0){
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(goBack:)];
        [self.navigationItem setLeftBarButtonItem:back];
        
        [searchResults setDictionary:[parser objectWithString:jsonString error:NULL]];
    }else if(request.tag == 1)
        [categories setDictionary:[parser objectWithString:jsonString error:NULL]];
    
    [searchTable reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error.localizedDescription);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end
