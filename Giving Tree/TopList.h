//
//  TopList.h
//  Giving Tree
//
//  Created by Michael Holp on 1/3/14.
//  Copyright (c) 2014 Flash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "SBJson.h"

@interface TopList : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,retain) IBOutlet UITableView *categoryTable;
@property(nonatomic,retain) NSMutableDictionary *categories;

@end
