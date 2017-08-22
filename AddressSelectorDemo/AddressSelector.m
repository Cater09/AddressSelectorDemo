//
//  AddressSelector.m
//  AddressSelectorDemo
//
//  Created by Ethan on 2017/8/22.
//  Copyright © 2017年 Ethan. All rights reserved.
//

#import "AddressSelector.h"

NSString *const pcctvname = @"areaName";
NSString *const pcctvId = @"areaCode";

@interface AddressSelector ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) CGRect initialFrame;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIPickerView *pickerView;
//所有的省
@property (nonatomic, copy) NSArray *provinces;

/**
 选中的省市
 */
@property (nonatomic, strong) NSDictionary *provinceDic;
@property (nonatomic, strong) NSDictionary *cityDic;
@property (nonatomic, strong) NSDictionary *countyDic;
@property (nonatomic, assign) BOOL isVaild;

@end

NSString *childs = @"childs";

NSInteger component = 3;

@implementation AddressSelector

-(instancetype)initWithFrame:(CGRect)frame province:(NSString *)province city:(NSString *)city county:(NSString *)county selectedAddress:(void (^)(NSDictionary *, NSDictionary *, NSDictionary *))selectedAddress {
    
    self.isVaild = false;
    self.province = province;
    self.city = city;
    self.county = county;
    self.selectedAddress = selectedAddress;
    return [self initWithFrame:frame];
}


-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    
    if (self) {
        self.isVaild = false;
        self.initialFrame = CGRectMake(frame.origin.x, kSCREEN_HEIGHT, frame.size.width, frame.size.height);
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:singleTap];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self customView:frame];
    }
    return self;
}


-(void)customView:(CGRect)frame {
    
    self.view.frame = CGRectMake(frame.origin.x, kSCREEN_HEIGHT, frame.size.width, frame.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = frame;
    }];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    //        view.alpha = 1.f;
    view.backgroundColor = [UIColor redColor];
    UIButton *tureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tureButton.frame = CGRectMake(kSCREEN_WIDTH - 70, 10, 50, 20);
    //        tureButton.layer.cornerRadius = 5.0;
    //        tureButton.clipsToBounds = YES;
    [tureButton setTitle:@"完成" forState:UIControlStateNormal];
    [tureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tureButton addTarget:self action:@selector(tureBtClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:tureButton];
    
    UIButton *cancelBt = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBt.frame = CGRectMake(20, 10, 50, 20);
    //        cancelBt.layer.cornerRadius = 5.0;
    //        cancelBt.clipsToBounds = YES;
    [cancelBt setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBt addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelBt];
    
    [self.view addSubview:view];
    
    self.pickerView.frame = CGRectMake(0, 40, frame.size.width, frame.size.height-40);
    
    [self.view addSubview:self.pickerView];
}



#pragma mark - Acction

-(void)singleTap:(UITapGestureRecognizer *)tgr {
    [self remove];
}

- (void)tureBtClick:(UIButton *)button {
    if (self.selectedAddress) {
        self.selectedAddress(
                    @{pcctvname:self.provinceDic[pcctvname], pcctvId:self.provinceDic[pcctvId]},
                    @{pcctvname:self.cityDic[pcctvname], pcctvId:self.cityDic[pcctvId]},
                    self.countyDic);
    }
    [self remove];
}

- (void)cancelClick:(UIButton *)button {
    [self remove];
}

-(void)remove {
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = _initialFrame;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.selectedAddress = nil;
    }];
}

#pragma mark - pickerView 代理

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return component;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return self.provinces.count;
    }else if(component == 1){
        return [self citys].count;
    }else if(component == 2){
        return [self countys].count;
    }
    return 0;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        return self.provinces[row][pcctvname];
    }else if (component == 1){
        return [self citys][row][pcctvname];
    }else if (component == 2) {
        return [self countys][row][pcctvname];
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        self.provinceDic = self.provinces[row];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [self pickerView:pickerView didSelectRow:0 inComponent:1];
    }else if (component == 1){
        self.cityDic = [self citys][row];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        [self pickerView:pickerView didSelectRow:0 inComponent:2];
    }else if (component == 2){
        self.countyDic = [self countys][row];
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        //        pickerLabel.minimumFontSize = 8;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
        
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


#pragma mark - setter && getter

/**
 所有的省
 */
-(NSArray *)provinces {
    
    if (!_provinces) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            _provinces = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        }
    }
    return _provinces;
}

/**
 选中的省，默认选中第一个
 */
-(NSDictionary *)provinceDic {
    if (!_provinceDic) {
        _provinceDic = [self.provinces firstObject];
    }
    return _provinceDic;
}

/**
 选中省的所有市
 */
-(NSArray *)citys {
    return self.provinceDic[childs];
}

/**
 选中市的所有县，区
 */
-(NSArray *)countys {
    return self.cityDic[childs];
}





/**
 默认选中的省
 */
-(void)setProvince:(NSString *)province {

    _province = province;

    if (province == nil) {
        return;
    }else {
        for (NSInteger i = 0; i < self.provinces.count; i++) {
            @autoreleasepool {
                NSDictionary *dict = self.provinces[i];
                if ([_province isEqualToString:dict[pcctvname]] || [_province isEqualToString:dict[pcctvId]]) {
                    self.isVaild = true;
                    [self.pickerView selectRow:i inComponent:0 animated:YES];
                    [self pickerView:self.pickerView didSelectRow:i inComponent:0];
                    break;
                }else if (self.isVaild) {
                    self.isVaild = false;
                }
            }
        }
    }
}

/**
 默认选中的市
 */
-(void)setCity:(NSString *)city {
   
    _city = city;
    if (city == nil) {
        return;
    }else if (self.isVaild) {
        for (NSInteger i = 0; i < [self citys].count; i++) {
            @autoreleasepool {
                NSDictionary *dict = [self citys][i];
                if ([_city isEqualToString:dict[pcctvname]] || [_city isEqualToString:dict[pcctvId]]) {
                    self.isVaild = true;
                    [self.pickerView selectRow:i inComponent:1 animated:YES];
                    [self pickerView:self.pickerView didSelectRow:i inComponent:1];
                    break;
                }else {
                    self.isVaild = false;
                }
            }
        }
    }
}


/**
 默认选中的县
 */
-(void)setCounty:(NSString *)county {
    _county = county;
    if (county == nil) {
        return;
    }else if(self.isVaild){
        for (NSInteger i = 0; i < [self countys].count; i++) {
            
            @autoreleasepool {
                NSDictionary *dict = [self countys][i];
                if ([_county isEqualToString:dict[pcctvname]] || [_county isEqualToString:dict[pcctvId]]) {
                    [self.pickerView selectRow:i inComponent:2 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:i inComponent:2];
                    break;
                }
            }
        }
    }
}


-(UIView *)view {
    if (!_view) {
        _view = [[UIView alloc] init];
        _view.backgroundColor = [UIColor whiteColor];
        [self addSubview:_view];
    }
    return _view;
}

-(UIPickerView *)pickerView {

    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        [_pickerView selectRow:0 inComponent:0 animated:YES];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
