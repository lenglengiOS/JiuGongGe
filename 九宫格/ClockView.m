//
//  ClockView.m
//  36-手势解锁
//
//  Created by admin on 16/9/8.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ClockView.h"

@interface ClockView ()

@property (nonatomic, strong) NSMutableArray *selectedBtnArray;
//当前手指所在的点
@property (nonatomic, assign) CGPoint curP;

@end


@implementation ClockView

- (NSMutableArray *)selectedBtnArray{
    if (_selectedBtnArray == nil) {
        _selectedBtnArray = [NSMutableArray array];
    }
    return _selectedBtnArray;
}

- (void)awakeFromNib{
    
    // 添加子控件
    [self setUp];
 
    
}
// 开始触摸
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 获取到第一次触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point =[touch locationInView:self];
    
    // 取出按钮
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            btn.selected = YES;
            [self.selectedBtnArray addObject:btn];
        }
    }
    
}
// 移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 取出当前触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.curP = point;

    // 取出按钮
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point) && btn.selected == NO) {
            btn.selected = YES;
            [self.selectedBtnArray addObject:btn];
        }
    }
    
    // 重绘
    [self setNeedsDisplay];
    
    
}
// 触摸结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSMutableString *str = [NSMutableString string];
    // 取消所有选中的按钮
    for(int i = 0; i < self.selectedBtnArray.count; i++){
        
        UIButton *btn = self.selectedBtnArray[i];
        btn.selected = NO;
        NSLog(@"%ld", (long)btn.tag);
        [str appendFormat:@"%ld", (long)btn.tag];
    }

    // 移除所有线
    [self.selectedBtnArray removeAllObjects];
    [self setNeedsDisplay];
    
    NSLog(@"%@", str);
    if (![str isEqualToString:@"03678"]) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您输入的密码有误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
    }else{
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"密码正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
    }
    
}

- (void)setUp{
    
    for(int i = 0; i < 9; i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.userInteractionEnabled = NO;
        btn.tag = i;
        
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_selected"] forState:UIControlStateSelected];
        [self addSubview:btn];
    }

    
    
    
    
}

- (void)drawRect:(CGRect)rect {

    if (self.selectedBtnArray.count) {
        // 画线
        
        // 绘制路径
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        // 取出每个按钮
        for(int i = 0; i < self.selectedBtnArray.count; i++){
            UIButton *btn = self.selectedBtnArray[i];
            // 判断是不是第一个按钮
            if (i == 0) {
                [path moveToPoint:btn.center];
            }else{
                [path addLineToPoint:btn.center];
            }
        }
        
        [path addLineToPoint:self.curP];
        
        [path setLineWidth:10];
        [[UIColor redColor] set];
        [path setLineJoinStyle:kCGLineJoinRound];
        
        [path stroke];

    }
    
    
    
}


// 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
//    NSLog(@"%@", self.btn);
    int colnum = 3;
//    int row = 3;
    int btnWH = 74;
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGFloat margin = (self.bounds.size.width - (btnWH * colnum)) / (colnum + 1);

    int curC = 0;
    int curR = 0;
    
    for(int i = 0; i < self.subviews.count; i++){
        
        // 求出当前所在列
        curC = i % colnum;
        curR = i / colnum;
        x = margin + curC * (margin + btnWH);
        y = margin + curR * (margin + btnWH);
        
        // 取出每个按钮
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(x, y, btnWH, btnWH);
        
        
        
    }


    
    
}



@end
