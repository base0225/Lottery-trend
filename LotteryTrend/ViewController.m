//
//  ViewController.m
//  LotteryTrend
//
//  Created by 朱佳 on 2019/4/2.
//

#import "ViewController.h"
#import "ZJExcelView.h"

#define kScreenSize [UIScreen mainScreen].bounds.size
#define kBarSpace 50
#define kContentW 1000
#define kContentH 1000


@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor orangeColor];
    _scrollView.bounces = NO;
    
    [self.view addSubview:_scrollView];
    
    // 右下角
    _contentView = [[ZJExcelView alloc] initWithFrame:CGRectMake(kBarSpace, kBarSpace, kContentW, kContentH)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_contentView];
    
    // 添加个图片(右下)
    UIImageView *imageViewR = [[UIImageView alloc] initWithFrame:_contentView.bounds];
    NSString *imgStr = [[NSBundle mainBundle] pathForResource:@"1.png" ofType:nil];
    imageViewR.image = [UIImage imageWithContentsOfFile:imgStr];
    imageViewR.contentMode = UIViewContentModeScaleToFill;
    [_contentView addSubview:imageViewR];
    
    // 顶部
    _topView = [[UIView alloc] initWithFrame:CGRectMake(kBarSpace, 0, kContentW, kBarSpace)];
    _topView.backgroundColor = [UIColor yellowColor];
    [_scrollView addSubview:_topView];
    
    // 左边
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, kBarSpace, kBarSpace, kContentH)];
    _leftView.backgroundColor = [UIColor orangeColor];
    [_scrollView addSubview:_leftView];
    
    // 左上角
    _shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kBarSpace, kBarSpace)];
    _shadeView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_shadeView];
    
    // 添加个图片(左上)
    UIImageView *imageViewL = [[UIImageView alloc] initWithFrame:_shadeView.bounds];
    imageViewL.image = [UIImage imageWithContentsOfFile:imgStr];
    imageViewL.contentMode = UIViewContentModeScaleToFill;
    [_shadeView addSubview:imageViewL];
    
    _scrollView.contentSize = CGSizeMake(kContentW + kBarSpace, kContentH + kBarSpace);
    
    // 填充label
    _label1 = [[UILabel alloc] initWithFrame:CGRectMake(kBarSpace, 0, kContentW, kBarSpace)];
    _label1.textAlignment = NSTextAlignmentCenter;
    _label1.textColor = [UIColor redColor];
    _label1.numberOfLines = 1;
    _label1.text = @"11111111111111111111111111111111111111111";
    [_topView addSubview:_label1];
    
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(-kContentW * 0.5 + kBarSpace * 0.5, kContentH * 0.5 + kBarSpace * 0.5, kContentW, kBarSpace)];
    _label2.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _label2.textAlignment = NSTextAlignmentCenter;
    _label2.textColor = [UIColor redColor];
    _label2.numberOfLines = 1;
    _label2.text = @"222222222222222222222222222222222222222222";
    [_leftView addSubview:_label2];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGRect topViewFrame = _topView.frame;
    topViewFrame.origin.y = scrollView.contentOffset.y;
    _topView.frame = topViewFrame;
    
    
    CGRect leftViewFrame = _leftView.frame;
    leftViewFrame.origin.x = scrollView.contentOffset.x;
    _leftView.frame = leftViewFrame;
    
    
    CGRect shadeViewFrame = _shadeView.frame;
    shadeViewFrame.origin.x = scrollView.contentOffset.x;
    shadeViewFrame.origin.y = scrollView.contentOffset.y;
    _shadeView.frame = shadeViewFrame;
    
}


@end
