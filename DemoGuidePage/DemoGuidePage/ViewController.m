//
//  ViewController.m
//  DemoGuidePage
//
//  Created by zhangshaoyu on 15/8/21.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "SYGuideView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"引导页";
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

- (void)setUI
{
    NSArray *array = @[@"按钮全屏-放大消失", @"按钮自定义大小-缩小消失", @"滑动"];
    for (int i = 0; i < array.count; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10.0, (i * (40.0 + 10.0) + 10.0), (CGRectGetWidth(self.view.bounds) - 10.0 *2), 40.0)];
        [self.view addSubview:button];
        button.backgroundColor = [UIColor clearColor];
        button.layer.cornerRadius = 10.0;
        button.layer.borderColor = [UIColor brownColor].CGColor;
        button.layer.borderWidth = 1.0;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buttonClick:(UIButton *)button
{
    NSArray *images = @[@"guideImage_1", @"guideImage_2", @"guideImage_3", @"guideImage_4"];
    SYGuideView *guideView = [[SYGuideView alloc] initWithImages:images];
    if (0 == button.tag - 1000)
    {
        // 隐藏动画类型
        guideView.animationType = SYGuideAnimationTypeZoomIn;
        // 按钮响应回调
        guideView.buttonClick = ^(){ };
    }
    else if (1 == button.tag - 1000)
    {
        // 隐藏动画类型
        guideView.animationType = SYGuideAnimationTypeZoomOut;
        // 按钮属性设置
        guideView.button.frame = CGRectMake((self.view.frame.size.width - 100.0) / 2, (self.view.frame.size.height - 40.0), 100.0, 40.0);
        [guideView.button setTitle:@"隐藏" forState:UIControlStateNormal];
        guideView.button.backgroundColor = [UIColor brownColor];
        guideView.button.layer.cornerRadius = 10.0;
        guideView.button.layer.borderWidth = 1.0;
        guideView.button.layer.borderColor = [UIColor redColor].CGColor;
        // 按钮响应回调
        guideView.buttonClick = ^(){ };
    }
    else if (2 == button.tag - 1000)
    {
        // 隐藏响应类型
        guideView.isSlide = YES;
    }
}

@end
