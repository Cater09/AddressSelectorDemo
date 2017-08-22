//
//  AddressSelector.h
//  AddressSelectorDemo
//
//  Created by Ethan on 2017/8/22.
//  Copyright © 2017年 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//回调参数中取值 name
extern NSString *const pcctvname;
// ID
extern NSString *const pcctvId;

@interface AddressSelector : UIView

/**
 自动选中的省市县
 */
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *county;
/**
 选中后的回调
 */
@property (nonatomic, copy) void(^selectedAddress)(NSDictionary *province, NSDictionary *city, NSDictionary *county);


/**
 构造函数

 @param frame 选择器的frame
 @param province 默认选中的省  可以是 name || code
 @param city 默认选中的市 可以是 name || code  必须传入有效的省级参数
 @param county 默认选中的县 可以是 name || code 必须传入有效的省级和市级参数
 @param selectedAddress 选中回调
 @return view 最好贴在window上
 */
-(instancetype)initWithFrame:(CGRect)frame province:(NSString *)province city:(NSString *)city county:(NSString *)county selectedAddress:(void(^)(NSDictionary *province, NSDictionary *city, NSDictionary *county))selectedAddress;


@end
