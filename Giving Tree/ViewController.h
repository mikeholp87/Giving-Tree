//
//  ViewController.h
//  Giving Tree
//
//  Created by Michael Holp on 1/3/14.
//  Copyright (c) 2014 Flash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "SBJson.h"

@interface ViewController : UIViewController<UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    BOOL searchEditing;
}

@property(nonatomic,retain) UISearchDisplayController *searchDisplayController;
@property(nonatomic,retain) IBOutlet UISearchBar *searchBar;
@property(nonatomic,retain) IBOutlet UITableView *searchTable;
@property(nonatomic,retain) NSMutableDictionary *searchResults;
@property(nonatomic,retain) NSMutableDictionary *categories;

@end
