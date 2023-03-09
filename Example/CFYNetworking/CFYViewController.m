//
//  CFYViewController.m
//  CFYNetworking
//
//  Created by caofengyang on 03/08/2023.
//  Copyright (c) 2023 caofengyang. All rights reserved.
//

#import "CFYViewController.h"
#import <CFYNetworking/CFYNetworking.h>
#import "CFYDemoAPIManager.h"

@interface CFYViewController () <CFYNetworkAPIManagerDelegate>

@property (nonatomic, strong) CFYDemoAPIManager *manager;

@end

@implementation CFYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.manager = [[CFYDemoAPIManager alloc] init];
    [self.manager addDelegate:self];
    
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeSystem];
    bt.backgroundColor = [UIColor redColor];
    [self.view addSubview:bt];
    [bt addTarget:self action:@selector(request) forControlEvents:UIControlEventTouchUpInside];
    bt.frame = CGRectMake(100, 200, 150, 150);
}

- (void)request {
    [self.manager loadData];
}

- (void)managerCallAPIDidSuccess:(CFYNetworkAPIBaseManager *)manager {
    NSLog(@"请求成功 data = %@",manager.response.responseObject);
}

- (void)managerCallAPIDidFailed:(CFYNetworkAPIBaseManager *)manager {
    NSLog(@"请求失败 error = %@",manager.errorMsg);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
