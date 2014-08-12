//
//  Celebrities.h
//  Giving Tree
//
//  Created by Michael Holp on 1/7/14.
//  Copyright (c) 2014 Flash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "SBJson.h"

@interface Celebrities : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,retain) IBOutlet UITableView *celebTable;
@property(nonatomic,retain) NSMutableDictionary *celebs;

@end
