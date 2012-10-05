//
//  DSViewController.m
//  Database Sample
//
//  Created by Mahesh on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DSViewController.h"
#import "DSDatabaseUtlities.h"

@interface DSViewController ()
{
  DSDatabaseUtlities *_databaseUtils;
}
@end

@implementation DSViewController

#pragma mark - LifeCycle

- (id)init
{
  self = [super init];
  if (self) {
    // Custom initialization
    [[self view]setBackgroundColor:[UIColor redColor]];
    _databaseUtils = [[DSDatabaseUtlities alloc]init];
    
  }
  return self;
}

- (void)dealloc
{
  RELEASE_SAFELY(_databaseUtils);
  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  //    // inserting the data into the data base
  //    // the insertion statement
  //    NSString *insertStmt = @"INSERT INTO CONTACTS (name,address,indv) VALUES (?,?,?)";
  //    
  //    // the parameters
  //    NSMutableArray *array = [[NSMutableArray alloc]init];
  //    [array addObject:@"shanbhag"];
  //    [array addObject:@"Hubli"];
  //    [array addObject:[NSNumber numberWithInt:99]];
  //    
  //    // the execution
  //    [_databaseUtils insertTheData:array withInsertionStatement:insertStmt];
  //    RELEASE_SAFELY(array);
  
  // retrive the data from the data base
  // retrival statement
  NSString *retriveData = @"SELECT * FROM CONTACTS";
  
  // execution and get the data
  NSArray *retrivedData =[[NSArray alloc]initWithArray:[_databaseUtils getTheData:nil withIretrivalStatement:retriveData]];
  NSLog(@"Retrived Data %@",retrivedData);
  RELEASE_SAFELY(retrivedData);
}

@end
