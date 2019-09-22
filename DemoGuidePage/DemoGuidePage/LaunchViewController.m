//
//  LaunchViewController.m
//  DemoGuidePage
//
//  Created by zhangshaoyu on 2019/9/22.
//  Copyright © 2019 zhangshaoyu. All rights reserved.
//

#import "LaunchViewController.h"
#import "SYGuideView.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    SYGuideView *guideView = [SYGuideView new];
    [self.view addSubview:guideView];
    guideView.filePath = [NSBundle.mainBundle pathForResource:@"denza" ofType:@"mp4"];
    guideView.guideType = UIGuideViewTypeVideo;
//    guideVC.images = @[@"denza"];
//    guideVC.hideType = UIGuideHideTypeCountdown;
//    guideVC.images = @[@"guideImage_11", @"guideImage_12", @"guideImage_13", @"guideImage_14"];
//    guideVC.isSlide = YES;
    guideView.guideComplete = ^{
        NSLog(@"放完了");
        if (self.complete) {
            self.complete();
        }
    };
    [guideView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
