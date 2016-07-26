//
//  ViewController.m
//  DemoGuidePage
//
//  Created by zhangshaoyu on 15/8/21.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "SYGuideScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"引导页";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"guide" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClick
{
    NSArray *images = @[@"guideImage_1", @"guideImage_2", @"guideImage_3", @"guideImage_4"];
    SYGuideScrollView *guideView = [[SYGuideScrollView alloc] initWithImages:images];
    guideView.animationType = SYGuideAnimationTypeZoomIn;
    guideView.buttonClick = ^(){
        
    };
}

@end
