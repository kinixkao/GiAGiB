//
//  AppDelegate.h
//  GiAGiB
//
//  Created by kinix on 2018/8/2.
//  Copyright © 2018 kinix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

