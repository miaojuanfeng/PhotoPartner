//
//  ViewController.m
//  PhotoPartner
//
//  Created by USER on 6/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import "HomeController.h"

@interface HomeController ()

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    float marginTop = rectStatus.size.height;
    
    float gapWidth = 5;
    float gapHeight = 5;
    
    float viewWidth = self.view.frame.size.width - gapWidth * 2;
    float viewWidth_1_2 = ( viewWidth - gapWidth ) / 2;
    
    float viewHeight = self.view.frame.size.height - marginTop - gapHeight * 4;
    float viewHeight_1_2 = viewHeight / 2;
    float viewHeight_1_4 = viewHeight_1_2 / 2;
    float viewHeight_1_6 = viewHeight_1_2 / 3;
    
    UIView *topBoxView = [[UIView alloc] initWithFrame:CGRectMake(gapWidth, marginTop+gapHeight, viewWidth, viewHeight_1_4-20)];
    topBoxView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:topBoxView];
    
    UIView *centerBoxView = [[UIView alloc] initWithFrame:CGRectMake(gapWidth, topBoxView.frame.origin.y+topBoxView.frame.size.height+gapHeight, viewWidth, viewHeight_1_2)];
    centerBoxView.backgroundColor = [UIColor redColor];
    UIView *centerLeftBoxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (centerBoxView.frame.size.width-gapWidth)/2, centerBoxView.frame.size.height)];
    centerLeftBoxView.backgroundColor = [UIColor lightGrayColor];
    [centerBoxView addSubview:centerLeftBoxView];
    UIView *centerRightBoxView = [[UIView alloc] initWithFrame:CGRectMake(centerLeftBoxView.frame.size.width+gapWidth, 0, (centerBoxView.frame.size.width-gapWidth)/2, centerBoxView.frame.size.height)];
    centerRightBoxView.backgroundColor = [UIColor yellowColor];
    [centerBoxView addSubview:centerRightBoxView];
    [self.view addSubview:centerBoxView];
    
    UIView *bottomBoxView = [[UIView alloc] initWithFrame:CGRectMake(gapWidth, centerBoxView.frame.origin.y+centerBoxView.frame.size.height+gapHeight, viewWidth, viewHeight_1_4+20)];
//    bottomBoxView.backgroundColor = [UIColor yellowColor];
    UIButton *bindDeviceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, bottomBoxView.frame.size.width, (bottomBoxView.frame.size.height-gapHeight)/2)];
    bindDeviceButton.backgroundColor = [UIColor redColor];
    [bottomBoxView addSubview:bindDeviceButton];
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, bindDeviceButton.frame.size.height+gapHeight, bottomBoxView.frame.size.width, (bottomBoxView.frame.size.height-gapHeight)/2)];
    settingButton.backgroundColor = [UIColor blueColor];
    [bottomBoxView addSubview:settingButton];
    [self.view addSubview:bottomBoxView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

@end
