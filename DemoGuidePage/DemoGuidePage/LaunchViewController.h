//
//  LaunchViewController.h
//  DemoGuidePage
//
//  Created by zhangshaoyu on 2019/9/22.
//  Copyright © 2019 zhangshaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYGuideView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LaunchViewController : UIViewController

@property (nonatomic, copy) void (^complete)(void);

@end

NS_ASSUME_NONNULL_END
