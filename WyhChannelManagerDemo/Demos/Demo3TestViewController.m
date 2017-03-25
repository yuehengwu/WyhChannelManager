//
//  Demo3TestViewController.m
//  WyhChannelManagerDemo
//
//  Created by wyh on 2017/3/25.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "Demo3TestViewController.h"
#import "WyhChannelManager.h"
@interface Demo3TestViewController ()

@property (nonatomic, weak) WyhChannelManager *manager;

@property (nonatomic, strong) WyhChannelManagerView *managerView;

@end

@implementation Demo3TestViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.manager = [WyhChannelManager defaultManager];
    [self.view addSubview:self.managerView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"close" style:(UIBarButtonItemStyleDone) target:self action:@selector(closeAction:)];
    
}

-(void)closeAction:(id)sender{
    
    [WyhChannelManager setUpdateIfNeeds];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - lazy

-(WyhChannelManagerView *)managerView{
    if (!_managerView) {
        
        WyhChannelManagerView *channelView = [WyhChannelManagerView channelViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64.0) Manager:self.manager];
        _managerView = channelView;
        
        [channelView chooseChannelCallBack:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
    }
    return _managerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
