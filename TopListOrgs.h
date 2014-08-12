//
//  TopListOrgs.h
//  Giving Tree
//
//  Created by Michael Holp on 1/3/14.
//  Copyright (c) 2014 Flash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "SBJson.h"

@interface TopListOrgs : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,retain) IBOutlet UITableView *orgsTable;
@property(nonatomic,retain) NSMutableDictionary *topOrgs;
@property(assign) NSString *listID;

@end
