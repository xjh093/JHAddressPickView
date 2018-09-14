//
//  JHAddressPickView.m
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

#import "JHAddressPickView.h"
#import "JHAddressToolBar.h"
#import "JHAddressPicker.h"

@interface JHAddressPickView()<JHAddressToolBarDelegate,JHAddressPickerDelegate>
@property (nonatomic,  strong) UIView *grayView;
@property (nonatomic,  strong) UIButton *dissmissButton;
@property (nonatomic,  strong) UIView *contentView;

@property (nonatomic,  strong) JHAddressToolBar *toolBar;
@property (nonatomic,  strong) JHAddressPicker *picker;

@property (nonatomic,  strong) NSArray *dataArray;

@property (nonatomic,  strong) NSMutableDictionary *resultDic;

@end

@implementation JHAddressPickView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        _grayViewAlpha = 0.3;
        _columns = 3;
        _resultDic = @{}.mutableCopy;
        _dataArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"]];
        [self xjh_setupViews];
    }
    return self;
}

- (void)xjh_setupViews
{
    [self addSubview:self.grayView];
    [self addSubview:self.contentView];
    [_contentView addSubview:self.toolBar];
    [_contentView addSubview:self.picker];
}

- (UIView *)grayView{
    if (!_grayView) {
        _grayView = [[UIView alloc] init];
        _grayView.frame = self.bounds;
        _grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }
    return _grayView;
}

- (UIButton *)dissmissButton{
    if (!_dissmissButton) {
        _dissmissButton = [[UIButton alloc] init];
        _dissmissButton.frame = self.bounds;
        [_dissmissButton addTarget:self action:@selector(hide) forControlEvents:1<<6];
        [_grayView addSubview:_dissmissButton];
    }
    return _dissmissButton;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.frame = CGRectMake(0, CGRectGetMaxY(self.bounds), CGRectGetWidth(self.bounds), 250);
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (JHAddressToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[JHAddressToolBar alloc] init];
        _toolBar.delegate = self;
    }
    return _toolBar;
}

- (JHAddressPicker *)picker{
    if (!_picker) {
        _picker = [[JHAddressPicker alloc] init];
        _picker.frame = CGRectMake(0, 50, CGRectGetWidth(self.bounds), 200);
        _picker.delegate = self;
        _picker.dataArray = _dataArray;
    }
    return _picker;
}

#pragma mark - public

- (void)setHideWhenTapGrayView:(BOOL)hideWhenTapGrayView{
    _hideWhenTapGrayView = hideWhenTapGrayView;
    if (hideWhenTapGrayView) {
        self.dissmissButton.hidden = NO;
    }else{
        self.dissmissButton.hidden = YES;
    }
}

- (void)setColumns:(NSInteger)columns{
    if (_columns == 2 || _columns == 3) {
        _columns = columns;
        _picker.columns = columns;
        [_picker loadData];
    }
}

- (void)showInView:(UIView *)view{
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        [self viewAnimation:_grayViewAlpha height:-CGRectGetHeight(_contentView.frame)];
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        [self viewAnimation:0 height:CGRectGetHeight(_contentView.frame)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - private

- (void)viewAnimation:(CGFloat)alpha height:(CGFloat)height
{
    _grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
    
    CGRect frame = _contentView.frame;
    frame.origin.y += height;
    _contentView.frame = frame;
}

#pragma mark - JHAddressToolBarDelegate
- (void)toolBarDidClickButton:(NSInteger)leftOrRight{
    // left - 0, right - 1
    if (leftOrRight == 1) {
        if (_pickBlock) {
            _pickBlock(_resultDic);
        }
    }
    [self hide];
}

#pragma mark - JHAddressPickerDelegate
- (void)addressPickerDidSelectedRow:(NSInteger)row1 row2:(NSInteger)row2 row3:(NSInteger)row3{
    //NSLog(@"row1:%@, row2:%@, row3:%@",@(row1),@(row2),@(row3));
    
    NSString *province = nil;
    NSString *provinceCode = nil;
    NSString *city = nil;
    NSString *cityCode = nil;
    NSString *town = nil;
    NSString *townCode = nil;
    NSMutableString *mstr = @"".mutableCopy;
    
    NSDictionary *dic1 = _dataArray[row1];
    province = dic1[@"name"];
    provinceCode = dic1[@"code"];
    
    [mstr appendString:province];
    
    NSArray *array2 = [dic1 valueForKeyPath:@"children"];
    if (row2 < array2.count) {
        NSDictionary *dic2 = array2[row2];
        city = dic2[@"name"];
        cityCode = dic2[@"code"];
        [mstr appendString:city];
        
        if (_columns == 3) {
            NSArray *array3 = [dic2 valueForKeyPath:@"grandChildren"];
            if (row3 < array3.count) {
                NSDictionary *dic3 = array3[row3];
                town = dic3[@"name"];
                townCode = dic3[@"code"];
                [mstr appendString:town];
            }
        }
    }
    
    _toolBar.titleLable.text = mstr;

    [_resultDic setValue:province forKey:@"province"];
    [_resultDic setValue:provinceCode forKey:@"provinceCode"];
    [_resultDic setValue:city forKey:@"city"];
    [_resultDic setValue:cityCode forKey:@"cityCode"];
    [_resultDic setValue:town forKey:@"town"];
    [_resultDic setValue:townCode forKey:@"townCode"];
    
    //NSLog(@"%@",_resultDic);
}

@end
