//
//  AppDelegate.h
//  iOS_SuperBlocks
//
//  Created by ModouTechnology on 16/9/13.
//  Copyright © 2016年 EdwinChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//登录页面
- (void)setupLoginViewController;
//跳转到首页
- (void)setupHomeViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

