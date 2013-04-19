//
//  HistoryPageViewController.h
//  YosiTracker
//
//  Created by Mary Rose Oh on 3/10/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface HistoryPageViewController : UIViewController
{
  sqlite3 *db;
}
@property (strong, nonatomic) IBOutlet UITableView *historyTableView;

@property (nonatomic, retain) NSMutableArray *records;
@property (nonatomic, retain) NSMutableArray *dateRecords;
@property (nonatomic, retain) NSMutableArray *yosiRecords;

-(NSString *) filePath;
-(void) openDB;

- (IBAction)refreshRecords:(id)sender;

@end
