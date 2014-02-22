//
//  ViewController.m
//  repeatHorizontalScrollviewDemo
//
//  Created by kewei on 2/20/14.
//  Copyright (c) 2014 kewei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    RepeatHorizontalScrollView *view = [[RepeatHorizontalScrollView alloc] initWithFrame:CGRectMake(0, 200, 320, 140)];
    view.delegate = self;
    [self.view addSubview:view];
    [view run];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfCellInRepeatHorizontalScrollView:(RepeatHorizontalScrollView *)view{
    return 6;
}
-(UIView *)repeatHorizontalScrollView:(RepeatHorizontalScrollView *)view cellForIndex:(NSInteger)index{
    UIView *cell = [[UIView alloc] initWithFrame:view.bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"png_%d", index+1]];
    [cell addSubview:imageView];
    return cell;
}

@end
