//
//  LaunchViewController.m
//  DemoGuidePage
//
//  Created by zhangshaoyu on 2019/9/22.
//  Copyright © 2019 zhangshaoyu. All rights reserved.
//

#import "LaunchViewController.h"
#import "SYGuideView.h"

@interface LaunchViewController () <SYGuideViewDelegate>

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SYGuideView *guideView = [SYGuideView new];
    [self.view addSubview:guideView];
    guideView.filePath = [NSBundle.mainBundle pathForResource:@"denza" ofType:@"mp4"];
    guideView.guideType = UIGuideViewTypeVideo;
    guideView.delegate = self;
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

- (void)guideViewComplete:(SYGuideView *)guideView
{
    NSLog(@"delegate 放完了");
    if (self.complete) {
       self.complete();
    }
}

@end
