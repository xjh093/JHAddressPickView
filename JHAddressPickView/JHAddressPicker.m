//
//  JHAddressPicker.m
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

#import "JHAddressPicker.h"

@interface JHAddressPicker()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,  strong) UIPickerView *pickView;
@property (nonatomic,  strong) NSArray *provinceArray;
@property (nonatomic,  strong) NSArray *cityArray;
@property (nonatomic,  strong) NSArray *townArray;
@property (nonatomic,  assign) NSInteger  selectRow1;
@property (nonatomic,  assign) NSInteger  selectRow2;
@property (nonatomic,  assign) NSInteger  selectRow3;
@end

@implementation JHAddressPicker

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 200);
    self = [super initWithFrame:frame];
    if (self) {
        _columns = 3;
        [self xjh_setupViews];
    }
    return self;
}

- (void)xjh_setupViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.pickView];
}

- (UIPickerView *)pickView{
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] init];
        _pickView.frame = self.bounds;
        _pickView.delegate = self;
    }
    return _pickView;
}

- (void)setColumns:(NSInteger)columns{
    if (_columns == 2 || _columns == 3) {
        _columns = columns;
    }
}

- (void)loadData{
    
    _provinceArray = [_dataArray valueForKey:@"name"];
    _cityArray = [_dataArray[_selectRow1] valueForKeyPath:@"children.name"];
    if (_columns == 3) {
        NSDictionary *dic = [_dataArray[_selectRow1] valueForKey:@"children"][_selectRow2];
        _townArray = [dic valueForKeyPath:@"grandChildren.name"];
    }
    
    [_pickView reloadAllComponents];
    [_pickView selectRow:_selectRow1 inComponent:0 animated:YES];
    [_pickView selectRow:_selectRow2 inComponent:1 animated:YES];
    if (_columns == 3) {
        [_pickView selectRow:_selectRow3 inComponent:2 animated:YES];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(addressPickerDidSelectedRow:row2:row3:)]) {
        [_delegate addressPickerDidSelectedRow:_selectRow1 row2:_selectRow2 row3:_selectRow3];
    }
}

#pragma mark - UIPickerViewDataSource
/// 几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return _columns;
}

/// 一列几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_dataArray.count == 0) {
        return 0;
    }
    
    if (component == 0) {
        return _provinceArray.count;
    }else if (component == 1) {
        return _cityArray.count;
    }else if (component == 2) {
        return _townArray.count;
    }

    return 0;
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        _selectRow1 = row;
        _selectRow2 = 0;
        _selectRow3 = 0;
        _cityArray = [_dataArray[row] valueForKeyPath:@"children.name"];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        if (_columns == 3) {
            NSDictionary *dic = [_dataArray[row] valueForKey:@"children"][0];
            _townArray = [dic valueForKeyPath:@"grandChildren.name"];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
    }else if (component == 1) {
        _selectRow2 = row;
        _selectRow3 = 0;
        if (_columns == 3) {
            NSDictionary *dic = [_dataArray[_selectRow1] valueForKey:@"children"][row];
            _townArray = [dic valueForKeyPath:@"grandChildren.name"];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
        
    }else if (component == 2) {
        _selectRow3 = row;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(addressPickerDidSelectedRow:row2:row3:)]) {
        [_delegate addressPickerDidSelectedRow:_selectRow1 row2:_selectRow2 row3:_selectRow3];
    }
}

#if 0
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        return _provinceArray[row];
    }else if (component == 1) {
        return _cityArray[row];
    }else if (component == 2) {
        return _townArray[row];
    }
    
    return @"";
}
#endif

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return CGRectGetWidth([UIScreen mainScreen].bounds)/3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = 1;
        //label.textColor = [UIColor whiteColor];
    }
    if (component == 0) {
        if (row < _provinceArray.count) {
            label.text = _provinceArray[row];
        }
    }else if (component == 1) {
        if (row < _cityArray.count) {
            label.text = _cityArray[row];
        }
    }else if (component == 2) {
        if (row < _townArray.count) {
            label.text = _townArray[row];
        }
    }
    //[label sizeToFit];
    return label;
}

@end
