//
//  DBStepper.m
//  TextFieldAndStepper
//
//  Created by aron on 16/2/20.
//  Copyright © 2016年 aron. All rights reserved.
//

#import "DBStepper.h"

@interface DBStepper ()<UITextFieldDelegate>

@property (nonatomic, weak) UIButton* decreaseBtn;
@property (nonatomic, weak) UIButton* increaseBtn;
@property (nonatomic, weak) UITextField *textField;

@property (nonatomic, assign) CGRect decreaseBtnF;
@property (nonatomic, assign) CGRect increaseBtnF;
@property (nonatomic, assign) CGRect textFieldF;

@end

@implementation DBStepper

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initProperty];
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initProperty];
        [self setupView];
    }
    return self;
}

-(void)initProperty {
    _decreaseBtnF = CGRectMake(0, 0, 30, 30);
    _increaseBtnF = CGRectMake(self.frame.size.width - 30, 0, 30, 30);
    _textFieldF = CGRectMake(30, 0, self.frame.size.width - 30*2, 30);
    
    _minValue = 0;
    _maxValue = 100;
    _step = 1;
    _curValue = 0;
}

-(void)setupView{
   
    UIButton* decreaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [decreaseBtn setImage:[UIImage imageNamed:@"DBStepper.bundle/btndec_normal"] forState:UIControlStateNormal];
    decreaseBtn.layer.borderColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:0.5f].CGColor;
    decreaseBtn.layer.borderWidth = 0.5f;
    [decreaseBtn addTarget:self action:@selector(decrese) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:decreaseBtn];
    _decreaseBtn = decreaseBtn;
    
    UIButton* increaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [increaseBtn setImage:[UIImage imageNamed:@"DBStepper.bundle/btninc_normal"] forState:UIControlStateNormal];
    increaseBtn.layer.borderColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:0.5f].CGColor;
    increaseBtn.layer.borderWidth = 0.5f;
    [increaseBtn addTarget:self action:@selector(increase) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:increaseBtn];
    _increaseBtn = increaseBtn;
    
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.borderStyle = UITextBorderStyleNone;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:0.5f].CGColor;
    textField.layer.borderWidth = 0.5f;
    textField.text = [NSString stringWithFormat:@"%d", _curValue];
    [self addSubview:textField];
    _textField = textField;
    
    textField.delegate = self;
    
    // 注册文字变化监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];

    // 设置按钮状态
    [self setButtonState];

    self.backgroundColor = [UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1];
}

-(void)layoutSubviews {
    _decreaseBtn.frame = _decreaseBtnF;
    _textField.frame = _textFieldF;
    _increaseBtn.frame = _increaseBtnF;
}

- (void)dealloc
{
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
}

#pragma mark - public

-(void)setCurValue:(int)curValue{
    _curValue = curValue;
    _textField.text = [NSString stringWithFormat:@"%d", _curValue];
    // 设置按钮状态
    [self setButtonState];
    
    // 设置Block回调
    if (_stepperValueDidChangedBlock) {
        _stepperValueDidChangedBlock(_curValue);
    }
}

#pragma mark - ui action

-(void)increase {
    if (_curValue < _maxValue) {
        _curValue += _step;
    }
    self.curValue = MIN(_maxValue, _curValue);
    NSString* text = [NSString stringWithFormat:@"%d", _curValue];
    _textField.text = text;
}

-(void)decrese {
    if (_curValue > _minValue) {
        _curValue -= _step;
    }
    self.curValue = MAX(_minValue, _curValue);
    NSString* text = [NSString stringWithFormat:@"%d", _curValue];
    _textField.text = text;
}

-(void)setButtonState {
    if (_curValue >= _maxValue){
        _increaseBtn.enabled = NO;
    }else {
        _increaseBtn.enabled = YES;
    }
    
    if (_curValue <= _minValue) {
        _decreaseBtn.enabled = NO;
    }else {
        _decreaseBtn.enabled = YES;
    }
}

#pragma mark - NSNotification

-(void)textFieldTextDidEndEditing:(NSNotification*)notification {
    // 最后的文字处理
    NSString* text = _textField.text;
    
    NSLog(@"===textFieldTextDidChange: %@", text);
    
    // 处理数据
    int intValue = [text intValue];
    if (intValue < _minValue) {
        intValue = _minValue;
    }
    
    if (intValue > _maxValue) {
        intValue = _maxValue;
    }
    
    self.curValue = intValue;
    _textField.text = [NSString stringWithFormat:@"%d", _curValue];
    
}

-(void)textFieldTextDidChange:(NSNotification*)notification {
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if ([self isContainsNotNumberCharInString:string]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isContainsNotNumberCharInString:(NSString*)text{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^0-9]+" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:text options:0 range:NSMakeRange(0, [text length])];
    if (result) {
        NSLog(@"== result %@", [text substringWithRange:result.range]);
    }
    return (result!=NULL);
}

#pragma mark - Override

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    _decreaseBtnF = CGRectMake(0, 0, 30, 30);
    _increaseBtnF = CGRectMake(self.frame.size.width - 30, 0, 30, 30);
    _textFieldF = CGRectMake(30, 0, self.frame.size.width - 30*2, 30);
    
    [self layoutIfNeeded];
}

@end
