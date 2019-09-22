//
//  ViewController.m
//  DemoGuidePage
//
//  Created by zhangshaoyu on 15/8/21.
//  Copyright (c) 2015年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "SYGuideView.h"
#import "LaunchViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SYGuideView *guideView;
@property (nonatomic, strong) NSArray *array;

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
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

- (void)setUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.tableFooterView = [UIView new];
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (0 == indexPath.row) {
        SYGuideView *guideView = [SYGuideView new];
        [UIApplication.sharedApplication.delegate.window addSubview:guideView];
//        [self.view addSubview:guideView.view];
        guideView.images = @[@"guideImage_1", @"guideImage_2", @"guideImage_3", @"guideImage_4"];
        guideView.autoLayout = YES;
        guideView.guideComplete = ^{
            NSLog(@"done %ld", indexPath.row);
        };
        [guideView reloadData];
    } else if (1 == indexPath.row) {
        SYGuideView *guideView = [SYGuideView new];
        [UIApplication.sharedApplication.keyWindow addSubview:guideView];
        guideView.images = @[@"guideImage_11", @"guideImage_12", @"guideImage_13", @"guideImage_14"];
        guideView.animationType = UIGuideAnimationTypeZoomIn;
        guideView.guideComplete = ^{
            NSLog(@"done %ld", indexPath.row);
        };
        [guideView reloadData];
    } else if (2 == indexPath.row) {
        SYGuideView *guideView = [SYGuideView new];
        [UIApplication.sharedApplication.delegate.window addSubview:guideView];
        guideView.images = @[@"guideImage_21", @"guideImage_22", @"guideImage_23", @"guideImage_24"];
        guideView.animationType = UIGuideAnimationTypeZoomOut;
        guideView.button.frame = CGRectMake((self.view.frame.size.width - 100.0) / 2, (self.view.frame.size.height - 40.0), 100.0, 40.0);
        [guideView.button setTitle:@"隐藏" forState:UIControlStateNormal];
        guideView.button.backgroundColor = [UIColor greenColor];
        guideView.button.layer.cornerRadius = 10.0;
        guideView.button.layer.borderWidth = 1.0;
        guideView.button.layer.borderColor = [UIColor redColor].CGColor;
        guideView.guideComplete = ^{
            NSLog(@"done %ld", indexPath.row);
        };
        [guideView reloadData];
    } else if (3 == indexPath.row) {
        SYGuideView *guideView = [SYGuideView new];
        [UIApplication.sharedApplication.delegate.window addSubview:guideView];
        guideView.images = @[@"guideImage_41", @"guideImage_42", @"guideImage_43", @"guideImage_44"];
        guideView.isSlide = YES;
        guideView.guideComplete = ^{
            NSLog(@"done %ld", indexPath.row);
        };
        [guideView reloadData];
    } else if (4 == indexPath.row) {
        SYGuideView *guideView = [SYGuideView new];
        [UIApplication.sharedApplication.delegate.window addSubview:guideView];
        guideView.images = @[@"guideImage_31", @"guideImage_32", @"guideImage_33", @"guideImage_34"];
        guideView.animationType = UIGuideAnimationTypeDown;
        guideView.guideComplete = ^{
            NSLog(@"done %ld", indexPath.row);
        };
        [guideView reloadData];
    } else if (5 == indexPath.row) {
        SYGuideView *guideView = [SYGuideView new];
        [UIApplication.sharedApplication.delegate.window addSubview:guideView];
        guideView.images = @[@"guideImage_31"];
        guideView.animationType = UIGuideAnimationTypeDown;
        guideView.hideType = UIGuideHideTypeCountdown;
        guideView.guideComplete = ^{
            NSLog(@"done %ld", indexPath.row);
        };
        [guideView reloadData];
    } else if (6 == indexPath.row) {
        SYGuideView *guideView = [SYGuideView new];
        [UIApplication.sharedApplication.delegate.window addSubview:guideView];
        guideView.images = @[@"guideImage_33"];
        guideView.animationType = UIGuideAnimationTypeDown;
        guideView.hideType = UIGuideHideTypeCountdownShould;
        guideView.guideComplete = ^{
            NSLog(@"done %ld", indexPath.row);
        };
        [guideView reloadData];
    } else if (7 == indexPath.row) {
        SYGuideView *guideView = [SYGuideView new];
        [UIApplication.sharedApplication.delegate.window addSubview:guideView];
        guideView.images = @[@"guideImage_34"];
        guideView.animationType = UIGuideAnimationTypeDown;
        guideView.hideType = UIGuideHideTypeCountdownDid;
        guideView.guideComplete = ^{
            NSLog(@"done %ld", indexPath.row);
        };
        [guideView reloadData];
    } else if (8 == indexPath.row) {
//        SYGuideView *guideView = [SYGuideView new];
//        [UIApplication.sharedApplication.delegate.window addSubview:guideView];
//        guideView.filePath = [NSBundle.mainBundle pathForResource:@"denza" ofType:@"mp4"];
//        guideView.guideType = UIGuideViewTypeVideo;
//        guideView.guideComplete = ^{
//            NSLog(@"done %ld", indexPath.row);
//        };
//        [guideView reloadData];
        
        LaunchViewController *nextVC = [LaunchViewController new];
        nextVC.complete = ^{
            [nextVC dismissViewControllerAnimated:YES completion:NULL];
        };
        [self presentViewController:nextVC animated:YES completion:NULL];
    }
}

- (NSArray *)array
{
    if (_array == nil) {
        _array = @[@"默认", @"按钮全屏-放大消失", @"按钮自定义大小-缩小消失", @"滑动", @"向下消失", @"倒计时自动消失", @"倒计时可关闭", @"倒计时后才关闭", @"视频"];
    }
    return _array;
}

@end
