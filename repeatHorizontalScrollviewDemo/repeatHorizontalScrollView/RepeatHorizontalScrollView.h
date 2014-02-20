//
//  RepeatHorizontalScrollView.h
//  repeatHorizontalScrollviewDemo
//
//  Created by kewei on 2/20/14.
//  Copyright (c) 2014 kewei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RepeatHorizontalScrollViewDelegate;


@interface RepeatHorizontalScrollView : UIView<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    NSTimer *_timer;
    NSInteger _currentIndex;
    NSInteger _total;
    NSMutableDictionary *_dictionaryCells;
    UIPageControl *_pageControl;
}
@property (nonatomic, weak) id<RepeatHorizontalScrollViewDelegate> delegate;


-(void)run;
@end



@protocol RepeatHorizontalScrollViewDelegate <NSObject>

@required
-(NSInteger )numberOfCellInRepeatHorizontalScrollView:(RepeatHorizontalScrollView *)view;
-(UIView *)repeatHorizontalScrollView:(RepeatHorizontalScrollView *)view cellForIndex:(NSInteger)index;

@end