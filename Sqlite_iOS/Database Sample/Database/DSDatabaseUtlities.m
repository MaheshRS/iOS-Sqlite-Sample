//
//  DSDatabaseUtlities.m
//  Database Sample
//
//  Created by Mahesh on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DSDatabaseUtlities.h"

#define DATABASE_NAME @"test.db"
#define DATABASE_TITLE @"test"
#define DATABASE_TYPE @"db"

@interface DSDatabaseUtlities()
{
  sqlite3 *_dsDatabase;
  sqlite3_stmt *stmt;
}

// database initializations 
- (void)initializeTheDatabase;
- (NSString *)databasePath;
- (void)openDatabase:(NSString *)databasePath;
- (void)finalizeStatement;
- (void)closeDatabase;
- (void)finalizeAndClose;
- (void)executeInsertion;
- (BOOL)isDataNull:(const char*)data;
// data base operations
- (void)bindData:(id)data andIndex:(NSInteger)index;
@end


@implementation DSDatabaseUtlities


#pragma mark - class lifecycle

- (id)init
{
  self=[super init];
  
  if(self)
  {
    // call necessary function
    [self initializeTheDatabase];  
  }
  return self;
}

- (void)dealloc
{
  [super dealloc];
}


#pragma mark - DataBase(opening/closing)
- (void)initializeTheDatabase
{
  // get the file path and get the file manager and
  // check if the file exists at the path if yes then dont create
  // else create a new file and open the database
  NSString *documentDatabasePath = [self databasePath];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSError *error;
  if([fileManager fileExistsAtPath:documentDatabasePath])
  {
    NSLog(@"file exists here");
  }
  
  else
  {
    NSLog(@"file does not exist here");
    // file does not exist then copy the file if it exists in the 
    // local bundle or else create a new database and opent the 
    // database that is copied at the document directory
    if([fileManager  copyItemAtPath:[[NSBundle mainBundle]pathForResource:DATABASE_TITLE ofType:DATABASE_TYPE] toPath:documentDatabasePath error:&error])
    {
      NSLog(@"Copied the data base successfully");
    }
    else
    {
      NSLog(@"Cannot copy the database error: %@",[error localizedDescription]);
    }
  }
  
  
}

- (NSString *)databasePath
{
  // first get the path for the document directory of the application
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *dbpath = [paths objectAtIndex:0];
  
  // append the database to the path of the the document directory path 
  return [dbpath stringByAppendingPathComponent:DATABASE_NAME];
}

- (void)openDatabase:(NSString *)databasePath
{
  // the path of the database should be in the form of the UTF8 encoding
  // because of the compatibility of the Character set
  const char *dbPath = [databasePath UTF8String];
  
  if(sqlite3_open(dbPath, &_dsDatabase)==SQLITE_OK)
  {
    // the database has opened successfully
    NSLog(@"database is open");
  }
  else
  {
    // the database is not opened due to some error
    NSLog(@"database is not open");
  }
  
}

- (void)finalizeStatement
{
  // finalize the statements
  if(sqlite3_finalize(stmt) == SQLITE_OK)
  {
    NSLog(@"finalized the statement successfully");
  }
}

- (void)finalizeAndClose
{
  [self finalizeStatement];
  [self closeDatabase];
}

- (void)closeDatabase
{
  // close the database
  if(sqlite3_close(_dsDatabase) ==SQLITE_OK)
  {
    NSLog(@"databse successfully closed");
  }
}

#pragma mark - Database Utils
- (void)bindData:(id)data andIndex:(NSInteger)index
{
  // check if the data is of the type nsnumber of the string type
  if([data isKindOfClass:[NSNumber class]])
  {
    // if the data is of the type nsnumber then check if the 
    // value of the data is of which primitive type as follows
    // and bind it to the data base as follows.
    if(strcmp([data objCType], @encode(int))==0)
    {
      sqlite3_bind_int(stmt, index, [data integerValue]);
    }
  }
  else if([data isKindOfClass:[NSString class]])
  {
    // if the data is of the string type then just bind the text to 
    // the text binding as follows.
    sqlite3_bind_text(stmt, index, [data  UTF8String], -1, SQLITE_TRANSIENT);
  }
}

- (BOOL)isDataNull:(const char *)data
{
  if(data!=NULL)
  {
    return YES;
  }
  
  return NO;
}

#pragma mark - Database Operations
- (void)insertTheData:(NSArray *)insertionData withInsertionStatement:(NSString *)insertString
{
  // always open and close the database when required
  // when here is insertion require open the database
  // do the necessary insertions and then close the database
  [self openDatabase:[self databasePath]];
  
  const char* sqlQuerySTatement = [insertString UTF8String];
  stmt=nil;
  
  @synchronized(self)
  {
    if(sqlite3_prepare_v2(_dsDatabase, sqlQuerySTatement, -1, &stmt, NULL)==SQLITE_OK)
    {
      NSLog(@"statement successfully prepared %@",insertString);
      
      for(int i=0;i<[insertionData count];i++)
      {
        [self bindData:[insertionData objectAtIndex:i] andIndex:i+1];
      }
      
      // the statement is prepared successfully  now
      // execute the insertion
      [self executeInsertion];
    }
    else
    {
      NSLog(@"Preparing the insertion statement failed");
      [self finalizeAndClose];
    }
  }
  
}

- (void)executeInsertion
{
  if(sqlite3_step(stmt)==SQLITE_DONE)
  {      
    NSLog(@"execution insertion succeded");
  }
  else
  {
    NSLog(@"execution insertion failed");
  }
  
  [self finalizeAndClose];
}

- (NSArray *)getTheData:(NSArray *)retrivalData withIretrivalStatement:(NSString *)retrivalString
{
  // set the statement to nil
  stmt = nil;  
  
  // open the database
  [self openDatabase:[self databasePath]];
  
  // initiate an array to be returned
  NSMutableArray *resultData = [[[NSMutableArray alloc]init] autorelease];
  
  @synchronized(self)
  {
    // there is no conditional parameters
    if(retrivalData ==nil)
    {
      if(sqlite3_prepare_v2(_dsDatabase, [retrivalString UTF8String], -1, &stmt, NULL)==SQLITE_OK)
      {
        while (sqlite3_step(stmt)==SQLITE_ROW) 
        {
          NSMutableArray *resultSet = [[NSMutableArray alloc] init];
          
          for (int i=0; i<sqlite3_data_count(stmt); i++) {
            const char *str = sqlite3_column_decltype(stmt, i);
            
            if([[NSString stringWithUTF8String:str] isEqualToString:@"text"])
            {
              const unsigned char* strUnsigned =sqlite3_column_text(stmt, i);
              if([self isDataNull:(const char *)strUnsigned])
                [resultSet addObject:[NSString stringWithUTF8String:(const char *)strUnsigned]];
              else
                [resultSet addObject:@""];
            }
            else if([[NSString stringWithUTF8String:str] isEqualToString:@"integer"])
            {
              const unsigned char* strUnsigned =sqlite3_column_text(stmt, i);
              if([self isDataNull:(const char *)strUnsigned])
                [resultSet addObject:[NSNumber numberWithInt:sqlite3_column_int(stmt, i)]];
              else
                [resultSet addObject:@""];
            }
            
          }
          [resultData addObject:resultSet];
          [resultSet release];
        }
      }
    }
    else
    {
      
    }
    [self finalizeAndClose];
    return resultData;
    
  }
}

@end
