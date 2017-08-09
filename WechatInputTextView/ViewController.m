//
//  ViewController.m
//  WechatInputTextView
//
//  Created by MJ on 2017/8/9.
//  Copyright © 2017年 韩明静. All rights reserved.
//

#import "ViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITextViewDelegate>

@property(nonatomic,strong)UITextView *textView;

@property(nonatomic,strong)UIView *inputBackgroundView;

@property(nonatomic,strong)UIView *toolView;

@property(nonatomic,assign)CGFloat keyboardHeight;

@end

@implementation ViewController

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(UIView *)toolView{
    
    if (_toolView==nil) {
        _toolView=[UIView new];
        _toolView.backgroundColor=[UIColor colorWithRed:210/255.0 green:213/255.0 blue:219/255.0 alpha:1];
        _toolView.frame=CGRectMake(0, 0, ScreenWidth, 40);
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"收起键盘" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:13];
        [button setBackgroundImage:[UIImage imageNamed:@"button_share"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        button.frame=CGRectMake(ScreenWidth-60-15, (40-30)/2.0, 60, 30);
        [_toolView addSubview:button];
        
        UIView *topLineView=[UIView new];
        topLineView.backgroundColor=[UIColor grayColor];
        topLineView.frame=CGRectMake(0, 0, ScreenWidth, 1);
        [_toolView addSubview:topLineView];
    }
    return _toolView;
}

-(void)buttonAction{
    
    [self.view endEditing:YES];
}

-(UIView *)inputBackgroundView{
    
    if (_inputBackgroundView==nil) {
        _inputBackgroundView=[UIView new];
        _inputBackgroundView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    }
    return _inputBackgroundView;
}

-(UITextView *)textView{
    
    if (_textView==nil) {
        _textView=[[UITextView alloc]init];
        _textView.font=[UIFont systemFontOfSize:15];
        _textView.layer.cornerRadius=5;
        _textView.layer.masksToBounds=YES;
        _textView.layer.borderWidth=1;
        _textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _textView.delegate=self;
    }
    return _textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //414
    CGFloat width=ScreenWidth;
    //736
    CGFloat height=ScreenHeight-40;
    
    self.inputBackgroundView.frame=CGRectMake(0, height, width, 40);
    [self.view addSubview:self.inputBackgroundView];
    
    self.textView.frame=CGRectMake(15, 5, width-30, 30);
    [self.inputBackgroundView addSubview:self.textView];
    
    self.textView.inputAccessoryView=self.toolView;
    //键盘的frame即将发生变化时立刻发出该通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

-(void)keyboardChanged:(NSNotification *)notification{
    
    NSLog(@"%@",notification);
    //键盘即将消失的字典
    NSDictionary *willDisAppeardic=@{@"name":@"UIKeyboardWillChangeFrameNotification",
                                     @"userInfo": @{
                                             
                                             @"UIKeyboardAnimationCurveUserInfoKey" : @7,
                                             //键盘离开或进入屏幕的时间
                                             @"UIKeyboardAnimationDurationUserInfoKey": @"0.25",
                                             //键盘大小
                                             @"UIKeyboardBoundsUserInfoKey" : @"NSRect: {{0, 0}, {414, 311}}",
                                             @"UIKeyboardCenterBeginUserInfoKey" : @"NSPoint: {207, 580.5}",
                                             @"UIKeyboardCenterEndUserInfoKey" : @"NSPoint: {207, 891.5}",
                                             //键盘位置改变前的frame
                                             @"UIKeyboardFrameBeginUserInfoKey" : @"NSRect: {{0, 425}, {414, 311}}",
                                             //键盘位置改变后的frame
                                             @"UIKeyboardFrameEndUserInfoKey" : @"NSRect: {{0, 736}, {414, 311}}",
                                             @"UIKeyboardIsLocalUserInfoKey" : @1
                                             }
                                     };
    //键盘即将展示的字典
    NSDictionary *willAppeardic=@{@"name":@"UIKeyboardWillChangeFrameNotification",
                                  @"userInfo": @{
                                          
                                          @"UIKeyboardAnimationCurveUserInfoKey" : @7,
                                          @"UIKeyboardAnimationDurationUserInfoKey": @"0.25",
                                          @"UIKeyboardBoundsUserInfoKey" : @"NSRect: {{0, 0}, {414, 266}}",
                                          @"UIKeyboardCenterBeginUserInfoKey" : @"NSPoint: {207, 869}",
                                          @"UIKeyboardCenterEndUserInfoKey" : @"NSPoint: {207, 603}",
                                          @"UIKeyboardFrameBeginUserInfoKey" : @"NSRect: {{0, 736}, {414, 266}}",
                                          @"UIKeyboardFrameEndUserInfoKey" : @"NSRect: {{0, 470}, {414, 266}}",
                                          @"UIKeyboardIsLocalUserInfoKey" : @1
                                          }
                                  };
    
    CGRect frame=[notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    CGRect currentFrame=self.inputBackgroundView.frame;
    
    [UIView animateWithDuration:0.25 animations:^{
        //输入框最终的位置
        CGRect resultFrame;
        
        if (frame.origin.y==ScreenHeight) {
            resultFrame=CGRectMake(currentFrame.origin.x, ScreenHeight-currentFrame.size.height, currentFrame.size.width, currentFrame.size.height);
            self.keyboardHeight=0;
        }else{
            resultFrame=CGRectMake(currentFrame.origin.x,ScreenHeight-currentFrame.size.height-frame.size.height , currentFrame.size.width, currentFrame.size.height);
            self.keyboardHeight=frame.size.height;
        }
        
        self.inputBackgroundView.frame=resultFrame;
    }];
    
}

-(void)textViewDidChange:(UITextView *)textView{
    
    NSString *str=textView.text;
    
    CGSize maxSize=CGSizeMake(textView.bounds.size.width, MAXFLOAT);
    //NSStringDrawingUsesLineFragmentOrigin:用于多行绘制，因为默认是单行绘制，如果不指定，那么绘制出来的高度就是0，也就是啥都不显示出来。
    
    //NSStringDrawingUsesFontLeading:计算行高时使用自体的间距，也就是行高=行距+字体高度
    
    //NSStringDrawingUsesDeviceMetrics:计算布局时使用图元字形（而不是印刷字体）
    
    //NSStringDrawingTruncatesLastVisibleLine:设置的string的bounds放不下文本的话，就会截断，然后在最后一个可见行后面加上省略号。如果NSStringDrawingUsesLineFragmentOrigin不设置的话，只设置这一个选项是会被忽略的。因为如果不设置NSStringDrawingUsesLineFragmentOrigin，默认是单行显示的。
    //(注意：我在弹出框的内容string中设置了这个字串，但是最后显示出来的时候并没有打省略号…,这是因为在当前方法boundingRectWithSize..中设置这个option并不会起作用的，因为当前方法只是测量string的大小，并不是绘制string，在drawWithRect:(CGRect)rect options:(NSStringDrawingOptions)options attributes:...这个方法中设置这个option就会起作用)
    
    
    //测量string的大小
    CGRect frame=[str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textView.font} context:nil];
    //设置self.textView的高度，默认是30
    CGFloat tarHeight=30;
    //如果文本框内容的高度+10大于30也就是初始的self.textview的高度的话，设置tarheight的大小为文本的内容+10，其中10是文本框和背景view的上下间距；
    if (frame.size.height+10>30) {
        tarHeight=frame.size.height+10;
    }
    //如果self.textView的高度大于200时，设置为200，即最高位200
    if (tarHeight>200) {
        tarHeight=200;
    }
    
    CGFloat width=ScreenWidth;
    //设置输入框背景的frame
    self.inputBackgroundView.frame=CGRectMake(0, (ScreenHeight-self.keyboardHeight)-(tarHeight+10), width, tarHeight+10);
    //设置输入框的frame
    self.textView.frame=CGRectMake(15,(self.inputBackgroundView.bounds.size.height-tarHeight)/2 , width-30, tarHeight);
}

@end
