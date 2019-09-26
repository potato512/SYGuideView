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

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, SYGuideViewDelegate>

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
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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

static NSInteger const tagGuideView = 1000;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (0 == indexPath.row) {
        SYGuideView *guideView = [[SYGuideView alloc] initWithFrame:UIApplication.sharedApplication.delegate.window.bounds];
        [UIApplication.sharedApplication.delegate.window addSubview:guideView];
        //
        [guideView timerStart:6.0 complete:^(SYGuideView *view, NSTimeInterval time) {
            NSString *title = [NSString stringWithFormat:@"%.0fs", time];
            NSLog(@"%@", title);
            if (time <= 0.0) {
                [view removeFromSuperview];
            }
        }];
        //
        guideView.tag = indexPath.row + tagGuideView;
        guideView.delegate = self;
        [guideView reloadData];
    } else if (1 == indexPath.row) {
        SYGuideView *guideView = [SYGuideView new];
        [UIApplication.sharedApplication.keyWindow addSubview:guideView];
        guideView.tag = indexPath.row + tagGuideView;
        guideView.delegate = self;
        [guideView reloadData];
    } else if (2 == indexPath.row) {
        SYGuideView *guideView = [[SYGuideView alloc] init];
        [UIApplication.sharedApplication.delegate.window addSubview:guideView];
        guideView.filePath = [NSBundle.mainBundle pathForResource:@"denza" ofType:@"mp4"];
        guideView.guideType = UIGuideViewTypeVideo;
        guideView.tag = indexPath.row + tagGuideView;
        guideView.delegate = self;
        [guideView reloadData];
    }
}

- (NSArray *)array
{
    if (_array == nil) {
        _array = @[@"单图", @"多图", @"视频"];
    }
    return _array;
}

- (NSInteger)guideViewPages:(SYGuideView *)guideView
{
    if (guideView.tag - tagGuideView == 0) {
        return self.arraySingle.count;
    } else if (guideView.tag - tagGuideView == 1) {
        return self.arrayMore.count;
    }
    return 1;
}

- (UIView *)guideView:(SYGuideView *)guideView page:(NSInteger)index
{
    if (guideView.tag - tagGuideView == 0) {
        UIImageView *view = self.arraySingle[index];
        return view;
    } else if (guideView.tag - tagGuideView == 1) {
        UIImageView *view = self.arrayMore[index];
        return view;
    }
    return nil;
}

- (void)guideView:(SYGuideView *)guideView didClickPage:(NSInteger)index
{
    NSLog(@"index = %ld", index);
    if (guideView.tag - tagGuideView == 0) {
        // 放大淡化再消失
        [UIView animateWithDuration:0.6 animations:^{
            guideView.transform = CGAffineTransformMakeScale(1.6, 1.6);
            guideView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [guideView removeFromSuperview];
        }];
    } else if (guideView.tag - tagGuideView == 1) {
        // 向下淡化再消失
        [UIView animateWithDuration:0.6 animations:^{
            guideView.frame = CGRectMake(guideView.frame.origin.x, guideView.frame.size.height, guideView.frame.size.width, guideView.frame.size.height);
            guideView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [guideView removeFromSuperview];
        }];
    }
}

- (BOOL)guideView:(SYGuideView *)guideView shouldClickPage:(NSInteger)index
{
    if (guideView.tag - tagGuideView == 0) {
        if (index == self.arraySingle.count - 1) {
            return YES;
        }
    } else if (guideView.tag - tagGuideView == 1) {
        if (index == self.arrayMore.count - 1) {
            return YES;
        }
    }
    return NO;
}

- (void)guideViewComplete:(SYGuideView *)guideView
{
    if (guideView.tag - tagGuideView == 2) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"denza"]];
        [guideView.superview addSubview:imageView];
        imageView.frame = guideView.superview.bounds;
        guideView.alpha = 0.0;
        sleep(2);
        [UIView animateWithDuration:0.6 animations:^{
            imageView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            [guideView removeFromSuperview];
        }];
    }
}

- (NSArray *)arraySingle
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *images = @[@"guideImage_31"];
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:obj]];
        imageView.frame = UIScreen.mainScreen.bounds;
        [array addObject:imageView];
    }];
    return array;
}

- (NSArray *)arrayMore
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *images = @[@"guideImage_31", @"guideImage_32", @"guideImage_33", @"guideImage_34"];
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:obj]];
        imageView.frame = UIScreen.mainScreen.bounds;
        [array addObject:imageView];
    }];
    return array;
}

@end
