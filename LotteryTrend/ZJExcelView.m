//
//  ZJExcelView.m
//  LotteryTrend
//
//  Created by 朱佳 on 2019/4/6.
//

#import "ZJExcelView.h"

#define maxNum 20
#define FormWidth [[UIScreen mainScreen] bounds].size.width/(10+1)
#define FormHeight FormWidth

@interface ZJExcelView()

@property (nonatomic, copy) NSArray *xDatas;

@property (nonatomic, copy) NSArray *yDatas;

@property (nonatomic, strong) NSMutableArray *fillDatas;    // 填充的数据

@property (nonatomic, strong) NSMutableArray *frameArr;

@end

@implementation ZJExcelView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _yDatas = @[@"01期",@"02期",@"03期",@"04期",@"05期",@"06期",@"07期",@"08期",@"09期",@"10期",@"11期",@"12期",@"13期",@"14期",@"15期",@"16期",@"17期",@"18期",@"19期"];
        _xDatas = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19"];
        _fillDatas = [NSMutableArray array];
        _frameArr = [NSMutableArray new];
        
        for (NSInteger i=0; i<_xDatas.count; i++) {
            NSString *number = [self randomFormArray:_xDatas];
            [_fillDatas addObject:number];
        }
    }
    return self;
}
- (NSString *)randomFormArray:(NSArray *)array{
    
    NSInteger count = array.count;
    NSInteger index = arc4random()%count;
    
    return [NSString stringWithFormat:@"%ld",index];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i = 0; i<= _yDatas.count+1; i++) {
        // 设置画笔颜色
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextSetLineWidth(context, .4);
        // 画笔的起始坐标
        CGContextMoveToPoint(context, FormHeight, i*FormHeight + 7);
        CGContextAddLineToPoint(context, 21 * FormWidth, i*FormHeight+7);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    for (int j=0; j <= _yDatas.count+2; j++) {
        if (j<maxNum) {
            for (int i=0; i<maxNum; i++) {
                NSString *period = _xDatas[j];
                CGSize size = [self calculaTetextSize:period andSize:CGSizeMake(FormWidth, FormHeight)];
                [period drawInRect:CGRectMake((FormWidth-size.width)/2.0+j*FormWidth+FormWidth,(FormHeight-size.height)/2.0+i*FormHeight+7, FormWidth, FormHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor blackColor]}];
            }
        }
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextSetLineWidth(context, .4);
        CGContextMoveToPoint(context, j*FormWidth, 7);
        CGContextAddLineToPoint(context, j*FormWidth, maxNum*FormHeight+7);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    // 画填充圆
    for (int i = 0; i<_fillDatas.count; i++) {
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextSetLineWidth(context, .4);
        NSString *number = _fillDatas[i];
        for (int x = 0; x < _xDatas.count; x++) {
            if ([number intValue] ==x) {
                //画圆圈
                CGContextAddArc(context, FormWidth*x+FormWidth/2+FormWidth, FormHeight*i+FormHeight/2+7, FormHeight/2, 0, M_PI*2, 1);
                CGPoint point = CGPointMake(FormWidth*x+FormWidth/2+FormWidth, FormHeight*i+FormHeight/2+7);
                NSString *str = NSStringFromCGPoint(point);
                //保存圆中心的位置 给下面的连线
                [_frameArr addObject:str];
                CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
                CGContextDrawPath(context, kCGPathStroke);
                
                //填满整个圆
                CGContextAddArc(context, FormWidth*x+FormWidth/2+FormWidth, FormHeight*i+FormHeight/2+7, FormHeight/2, 0, M_PI*2, 1);
                CGContextSetFillColorWithColor(context, [UIColor purpleColor].CGColor);
                CGContextDrawPath(context, kCGPathFill);
                NSString *numberStr = [NSString stringWithFormat:@"%@",number];
                CGSize size = [self calculaTetextSize:numberStr andSize:CGSizeMake(FormWidth, FormHeight)];
                //画内容
                [numberStr drawInRect:CGRectMake((FormWidth-size.width)/2.0+x*FormWidth+FormWidth,(FormHeight-size.height)/2.0+i*FormHeight+7, FormWidth, FormHeight) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor redColor]}];
            }
        }
    }
    
    for (int i=0; i<_frameArr.count; i++) {
        NSString *str = [_frameArr objectAtIndex:i];
        CGPoint point = CGPointFromString(str);
        // 设置画笔颜色
        CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
        CGContextSetLineWidth(context, .4);
        if (i==0) {
            // 画笔的起始坐标
            CGContextMoveToPoint(context, point.x, point.y);
        }else{
            NSString *str1 = [_frameArr objectAtIndex:i-1];
            CGPoint point1 = CGPointFromString(str1);
            CGContextMoveToPoint(context, point1.x, point1.y);
            CGContextAddLineToPoint(context, point.x,  point.y);
        }
        CGContextDrawPath(context, kCGPathStroke);
    }
}

- (CGSize )calculaTetextSize:(NSString *)text andSize:(CGSize)size{
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{NSFontAttributeName :[UIFont systemFontOfSize:12],
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [text boundingRectWithSize:CGSizeMake(size.width, MAXFLOAT)
                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes:attributes
                                            context:nil].size;
    return contentSize;
}

@end
