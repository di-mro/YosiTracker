//
//  ViewController.m
//  YosiTracker
//
//  Created by Mary Rose Oh on 3/10/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize ISmokedLabel;
@synthesize cigaretteLabel;

@synthesize cigaretteNumberField;
@synthesize currentDate;

#pragma mark - Create SQLite table
-(void) createTable: (NSString *) tableName
         withField1: (NSString *) field1
         withField2: (NSString *) field2
{
  char *err;
  NSString *sql = [NSString stringWithFormat:
                   @"CREATE TABLE IF NOT EXISTS '%@' ('%@' " "TEXT PRIMARY KEY, '%@' TEXT);", tableName, field1, field2];
  
  if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
  {
    sqlite3_close(db);
    NSAssert(0, @"Could not create table");
  }
  else
  {
    NSLog(@"Table Created");
  }
  
}

#pragma mark - Define File path to db
-(NSString *) filePath
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
  return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"yosiTracker.sql"];
}

#pragma mark - Open the db
-(void) openDB
{
  if(sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK)
  {
    sqlite3_close(db);
    NSAssert(0, @"Database failed to open");
  }
  else
  {
    NSLog(@"Database opened");
  }
}

#pragma mark - Collect data and save to db
- (IBAction)addRecord:(id)sender
{
  NSDate   *theDate    = [NSDate date];
  NSString *yosiNumber = cigaretteNumberField.text;
 
  if([yosiNumber isEqualToString:@""] || [yosiNumber isEqualToString:@"0"])
  {
    UIAlertView *yosiNumberFieldAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Yosi number field is empty"
                                               message:@"Please enter a number first."
                                              delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
    [yosiNumberFieldAlert show];
  }
  else
  {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO yosiRecord ('date','yosiNumber') VALUES ('%@', '%@')", theDate, yosiNumber];
    
    char *err;
    if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
    {
      sqlite3_close(db);
      NSAssert(0, @"Could not update the table");
    }
    else
    {
      NSLog(@"Table Updated");
    }
    
    cigaretteNumberField.text = @"";
  }
}

#pragma mark - Dismiss the onscreen keyboard when not in use
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.view endEditing:YES];
}

#pragma mark - Define table
- (void)viewDidLoad
{
  [self openDB];
  [self createTable : @"yosiRecord"
         withField1 : @"date"
         withField2 : @"yosiNumber"];
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
