//
//  JHAddressToolBar.m
//  JHKit
//
//  Created by HaoCold on 2018/9/13.
//  Copyright © 2018年 HaoCold. All rights reserved.
//
//  MIT License
//
//  Copyright (c) 2018 xjh093
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "JHAddressToolBar.h"

#define kJHAddressToolBar_Button_Width 70

@interface JHAddressToolBar()
@property (nonatomic,  strong) UIButton *leftButton;
@property (nonatomic,  strong) UILabel *titleLable;
@property (nonatomic,  strong) UIButton *rightButton;
@end

@implementation JHAddressToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 50);
    self = [super initWithFrame:frame];
    if (self) {
        [self xjh_setupViews];
    }
    return self;
}

- (void)xjh_setupViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.leftButton];
    [self addSubview:self.titleLable];
    [self addSubview:self.rightButton];
}

- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _leftButton.frame = CGRectMake(0, 0, kJHAddressToolBar_Button_Width, 50);
        _leftButton.tag = 100;
        [_leftButton setTitle:@"取消" forState:0];
        [_leftButton addTarget:self action:@selector(buttonEvent:) forControlEvents:1<<6];
    }
    return _leftButton;
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.frame = CGRectMake(kJHAddressToolBar_Button_Width, 0, CGRectGetWidth(self.bounds)-2*kJHAddressToolBar_Button_Width, 50);
        _titleLable.textAlignment = 1;
    }
    return _titleLable;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _rightButton.frame = CGRectMake(CGRectGetWidth(self.bounds)-kJHAddressToolBar_Button_Width,0,kJHAddressToolBar_Button_Width, 50);
        _rightButton.tag = 200;
        [_rightButton setTitle:@"确定" forState:0];
        [_rightButton addTarget:self action:@selector(buttonEvent:) forControlEvents:1<<6];
    }
    return _rightButton;
}

- (void)buttonEvent:(UIButton *)button
{
    NSInteger type = 0;
    if (button.tag == 200) {
        type = 1;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(toolBarDidClickButton:)]) {
        [_delegate toolBarDidClickButton:type];
    }
}

@end
