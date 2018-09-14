# JHAddressPickView
省市区选择器，省市二级选择，省市区三级选择，PickView

# Example

```
    _pickView = [[JHAddressPickView alloc] init];
    _pickView.hideWhenTapGrayView = YES;
    _pickView.columns = 2;    // 省市二级选择
    //_pickView.columns = 3;  // 省市区三级选择
    [_pickView showInView:self.view];
    
    // 选择结果
    
     {
       city = "北京市";
       cityCode = 110100;
       province = "北京";
       provinceCode = 110000;
    }
    
    {
      city = "北京市";
      cityCode = 110100;
      province = "北京";
      provinceCode = 110000;
      town = "东城区";
      townCode = 110101;
    }
```

# What is it?
## 省市二级选择
![image](https://github.com/xjh093/JHAddressPickView/blob/master/image/image2.png)

## 省市区三级选择
![image](https://github.com/xjh093/JHAddressPickView/blob/master/image/image3.png)
