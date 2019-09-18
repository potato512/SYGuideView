//
//  AppDelegate.m
//  DemoGuidePage
//
//  Created by zhangshaoyu on 15/8/21.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SYGuideController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    sleep(3);
    
    SYGuideController *guideVC = [SYGuideController new];
    guideVC.filePath = [NSBundle.mainBundle pathForResource:@"denza" ofType:@"mp4"];
    guideVC.guideType = UIGuideViewTypeVideo;
    //
    guideVC.guideComplete = ^{
        NSLog(@"放完了");
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"denza"]];
        [self.window addSubview:imageView];
        imageView.frame = self.window.bounds;
//        sleep(5);
        [UIView animateWithDuration:0.6 animations:^{
            imageView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            ViewController *vc = [[ViewController alloc] init];
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
            self.window.rootViewController = navVC;
        }];
    };
    [guideVC reloadData];
    self.window.rootViewController = guideVC;
    self.window.backgroundColor = UIColor.clearColor;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
