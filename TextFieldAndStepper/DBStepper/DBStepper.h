//
//  DBStepper.h
//  TextFieldAndStepper
//
//  Created by aron on 16/2/20.
//  Copyright © 2016年 aron. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DBStepperValueDidChangedBlock)(int value);

@interface DBStepper : UIView

@property (nonatomic, assign) int maxValue;
@property (nonatomic, assign) int minValue;
@property (nonatomic, assign) int step;
@property (nonatomic, assign) int curValue;

@property (nonatomic, copy) DBStepperValueDidChangedBlock stepperValueDidChangedBlock;

@end
