//
//  HistoryPageViewController.m
//  YosiTracker
//
//  Created by Mary Rose Oh on 3/10/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "HistoryPageViewController.h"

@interface HistoryPageViewController ()

@end

@implementation HistoryPageViewController

@synthesize historyTableView;
@synthesize records;
@synthesize dateRecords;
@synthesize yosiRecords;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

#pragma mark - Retrieve records from yosiRecord table
- (void)viewDidLoad
{
  NSLog(@"Display Yosi Records");
  
  [self openDB];
  [self retrieveRecords];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(void) viewWillAppear: (BOOL) animated
{
  [self.historyTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Retrieve records from db
-(void) retrieveRecords
{
  records = [[NSMutableArray alloc] init];
  dateRecords = [[NSMutableArray alloc] init];
  yosiRecords = [[NSMutableArray alloc] init];
  NSString *sql = [NSString stringWithFormat: @"SELECT * FROM yosiRecord"];
  sqlite3_stmt *statement;
  
  if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
  {
    dateRecords = [[NSMutableArray alloc] init];
    yosiRecords = [[NSMutableArray alloc] init];
    
    while(sqlite3_step(statement) == SQLITE_ROW)
    {
      //date
      char *field1 = (char *) sqlite3_column_text(statement, 0);
      NSString *date = [[NSString alloc] initWithUTF8String:field1];
      [dateRecords addObject:date];
      
      //yosiNumber
      char *field2 = (char *) sqlite3_column_text(statement, 1);
      NSString *yosiNumber = [[NSString alloc] initWithUTF8String:field2];
      [yosiRecords addObject:yosiNumber];
      
      //Concatenated results
      NSString *str = [[NSString alloc] initWithFormat:@"%@ | %@ sticks", date, yosiNumber];
      [records addObject:str];
    }
  }
}

#pragma mark - File path to db
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


#pragma mark - Re-retrieve records / refresh
- (IBAction)refreshRecords:(id)sender
{
  NSLog(@"Refresh table");
  //[self.historyTableView reloadData];
  //[self openDB];
  //[self retrieveRecords];
}

#pragma mark - Table view data source implementation

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Yosi Records"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [records count];
  NSLog(@"%d", [records count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"historyPageCell";
  //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                          reuseIdentifier:CellIdentifier];
  
  //configure the cell
  //cell.textLabel.text = [self.records objectAtIndex:indexPath.row];
  cell.detailTextLabel.text = [self.dateRecords objectAtIndex:indexPath.row];
  
  NSNumber *number = [self.yosiRecords objectAtIndex:indexPath.row];
  NSString *label;
  
  if(number.integerValue > 1)
  {
    label = @"sticks";
  }
  else
  {
    label = @"stick";
  }
  
  cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ %@", [self.yosiRecords objectAtIndex:indexPath.row], label];
  cell.textLabel.numberOfLines = 0;
  
  return cell;
}

//Change the Height of the Cell [Default is 45]:
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  return 50;
}



@end
