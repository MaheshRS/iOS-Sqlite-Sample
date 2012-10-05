//
//  DSAppDelegate.h
//  Database Sample
//
//  Created by Mahesh on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSViewController;

@interface DSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DSViewController *rootViewController;

@end
