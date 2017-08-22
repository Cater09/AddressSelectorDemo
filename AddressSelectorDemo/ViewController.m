//
//  ViewController.m
//  AddressSelectorDemo
//
//  Created by Ethan on 2017/8/22.
//  Copyright © 2017年 Ethan. All rights reserved.
//

#import "ViewController.h"
#import "AddressSelector.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(UIButton *)sender {
    
    NSArray *array = [self.addressLab.text componentsSeparatedByString:@"-"];
    
    [self.view.window addSubview: [[AddressSelector alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 256, kSCREEN_WIDTH, 256) province:array.count ? array[0] : @"" city:array.count > 1 ? array[1] : @"" county:array.count > 2 ? array[2] : @"" selectedAddress:^(NSDictionary *province, NSDictionary *city, NSDictionary *county) {
        
        self.addressLab.text = [NSString stringWithFormat:@"%@-%@-%@",province[pcctvname],city[pcctvname],county[pcctvname]];
        
        
        NSLog(@"\n%@:%@  \n%@:%@  \n%@:%@",province[pcctvname],province[pcctvId],
              city[pcctvname],city[pcctvId],
              county[pcctvname],county[pcctvId]);
        
    }]];

}

@end
