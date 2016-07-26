//
//  ViewController.m
//  SKTextAnimation
//
//  Created by nachuan on 16/7/25.
//  Copyright © 2016年 nachuan. All rights reserved.
//

#import "ViewController.h"
#import "SKTextAnimationLabel.h"
@interface ViewController ()

@property (nonatomic, strong) SKTextAnimationLabel *textAnimationLabel;

@property (nonatomic, strong) NSArray *textArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textArray = @[
                   @"'What can I do with it?'.",
                   @"Yes",
                   @"What is design?",
                   @"Design Code By Swift",
                   @"Design is not just",
                   @"what it looks like",
                   @"and feels like.",
                   @"Hello,Swift",
                   @"is how it works.",
                   @"- Steve Jobs",
                   @"Older people",
                   @"sit down and ask,",
                   @"'What is it?'",
                   @"but the boy asks,",
                   @"- Steve Jobs",
                   @"Swift",
                   @"iPhone",    @"iPad",    @"Mac Mini",
                   @"MacBook Pro",    @"Mac Pro",
                   @"爱老婆"
                   
                   ];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createUI];

}

- (void)createUI
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"2.jpg"];
    imageView.userInteractionEnabled= YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    _textAnimationLabel = [[SKTextAnimationLabel alloc] init];
    _textAnimationLabel.frame = self.view.bounds;
    _textAnimationLabel.text  = @"Yes Tall";
    _textAnimationLabel.font  = [UIFont systemFontOfSize:48];
    _textAnimationLabel.textColor     = [UIColor greenColor];
    _textAnimationLabel.numberOfLines = 0;
    _textAnimationLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _textAnimationLabel.textAlignment = NSTextAlignmentLeft;
    [imageView addSubview:_textAnimationLabel];
    

    UIButton *btn =[[UIButton alloc] init];
    btn.frame = CGRectMake(100, self.view.frame.size.height - 50, 100, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"点我更换文字" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changeWord:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:btn];
}

- (void)changeWord:(UIButton *)sender
{
    NSInteger index = arc4random_uniform(20);
    if (index < _textArray.count) {
        NSString *text = _textArray[index];
        self.textAnimationLabel.text = text;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
