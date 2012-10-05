//
//  DSDatabaseUtlities.h
//  Database Sample
//
//  Created by Mahesh on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

typedef enum _DSDataType
{
  DSNumericIntValue = 0,
  DSTextValue = 1
}DSDataType;

@interface DSDatabaseUtlities : NSObject

// data base operations
- (void)insertTheData:(NSArray *)insertionData withInsertionStatement:(NSString *)insertString;
- (NSArray *)getTheData:(NSArray *)retrivalData withIretrivalStatement:(NSString *)insertString;
@end
