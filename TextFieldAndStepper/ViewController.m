//
//  ViewController.m
//  TextFieldAndStepper
//
//  Created by aron on 16/2/20.
//  Copyright © 2016年 aron. All rights reserved.
//

#import "ViewController.h"
#import "DBStepper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField* tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, 200, 30)];
    tf.backgroundColor = [UIColor lightGrayColor];
    tf.textAlignment = NSTextAlignmentCenter;
    tf.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:tf];
    
    DBStepper* stepper = [[DBStepper alloc] initWithFrame:CGRectMake(100, 200, 100, 30)];
    stepper.minValue = 2;
    stepper.maxValue = 99;
    stepper.step = 5;
    stepper.curValue = 23;
    [self.view addSubview:stepper];
    
    stepper.stepperValueDidChangedBlock = ^(int value) {
        NSLog(@"==stepperValueDidChangedBlock== %d", value);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
