//
//  ViewController.h
//  YosiTracker
//
//  Created by Mary Rose Oh on 3/10/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface ViewController : UIViewController
{
  sqlite3 *db;
}

@property (strong, nonatomic) IBOutlet UILabel *ISmokedLabel;
@property (strong, nonatomic) IBOutlet UILabel *cigaretteLabel;
@property (strong, nonatomic) IBOutlet UITextField *cigaretteNumberField;
@property (nonatomic, readonly) NSDate *currentDate;

/* Represent the location of the database with the project files */
-(NSString *) filePath;

/* Method to open the database in the filePath */
-(void) openDB;

/* Create a table in the database
   Field names: date, yosiNumber
*/
-(void) createTable: (NSString *) tableName
         withField1: (NSString *) field1
         withField2: (NSString *) field2;

/* Method to add the record to db */
- (IBAction)addRecord:(id)sender;


@end
