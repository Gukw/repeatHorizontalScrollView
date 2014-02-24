//
//  RepeatHorizontalScrollView.m
//  repeatHorizontalScrollviewDemo
//
//  Created by kewei on 2/20/14.
//  Copyright (c) 2014 kewei. All rights reserved.
//

#import "RepeatHorizontalScrollView.h"
#define RATEMODEL 5

@implementation RepeatHorizontalScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)run{
    _cellBounds = self.bounds;
    _cellWidth = _cellBounds.size.width;
    _cellHeight = _cellBounds.size.height;
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:_cellBounds];
    [self addSubview:_scrollView];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    

    
    _dictionaryCells = [NSMutableDictionary dictionary];
    _total= [_delegate numberOfCellInRepeatHorizontalScrollView:self];


    
    _scrollView.contentSize = CGSizeMake(_cellWidth * (_total * RATEMODEL), _cellHeight);
    float pageControlWidth=(_total)*10.0f+40.f;
    float pagecontrolHeight=20.0f;
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.bounds.size.width-pageControlWidth)/2,self.bounds.size.height-pagecontrolHeight - 10, pageControlWidth, pagecontrolHeight)];
    _pageControl.currentPage=0;
    _pageControl.numberOfPages=_total;
    [self addSubview:_pageControl];
    
    
    NSInteger beiginIndex = RATEMODEL/2 * _total;
    _scrollView.contentOffset = CGPointMake(beiginIndex * _cellWidth, 0);
    [self moveTo:beiginIndex];
    
    [self startTimer];
}

-(void)resetCells{
//    NSLog(@"scollviewdidscroll:%@", NSStringFromCGPoint(_scrollView.contentOffset));
    CGFloat x = _scrollView.contentOffset.x;
    NSInteger index = floor(x/_cellWidth);
    [self moveTo:index];
}
-(void)resetPage{
    NSInteger index = floor(_scrollView.contentOffset.x / _cellWidth);
    NSInteger page = index % _total;
    _pageControl.currentPage = page;
}
-(void)moveTo:(NSInteger)index{
    if(index != _centerIndex){
        _centerIndex = index;
        [self showCell:index];
    }
    if(index - 1>=0 && _leftIndex != index - 1){
        _leftIndex = index - 1;
        _leftView = [self showCell:index - 1];
    }
    if(index + 1<= _total*RATEMODEL - 1 && _rightIndex != index+1){
        _rightIndex = index + 1;
        _rightView = [self showCell:index + 1];
    }
}
-(UIView *)showCell:(NSInteger)index{
    NSInteger indexData = index % _total;
    NSString *sIndexData = [NSString stringWithFormat:@"%ld", indexData];
    UIView *view = _dictionaryCells[sIndexData];
    if(view == nil){
        view = [_delegate repeatHorizontalScrollView:self cellForIndex:indexData];
        _dictionaryCells[sIndexData] = view;
    }
    [_scrollView addSubview:view];
    view.frame = CGRectMake(index * _cellWidth, 0, _cellWidth, _cellHeight);
    return view;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //    NSLog(@"did end decelerating");
    NSInteger index = floor(scrollView.contentOffset.x / _cellWidth);
    if(index == RATEMODEL * _total - 1){
        [self moveTo:RATEMODEL/2*_total -1];
        _scrollView.contentOffset = CGPointMake((RATEMODEL/2*_total -1) * _cellWidth, 0);
    }
    if(index == 0){
        [self moveTo:RATEMODEL/2*_total];
        _scrollView.contentOffset = CGPointMake(RATEMODEL/2*_total * _cellWidth, 0);
    }
    [self resetPage];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(_scrollView.dragging){
        [self resetCells];
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self resetCells];
    [self scrollViewDidEndDecelerating:scrollView];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}
-(void)scrollToNext{
    NSInteger x =  _scrollView.contentOffset.x;
    x += _cellWidth;
    [self resetCells];
    //    [_scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [_scrollView setContentOffset:CGPointMake(x, 0) animated:NO];
                     }
                     completion:^(BOOL finished){
                         //                         NSLog(@"completion");
                         [self scrollViewDidEndScrollingAnimation:_scrollView];
                     }
     ];
}
-(void)startTimer{
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                              target:self
                                            selector:@selector(scrollToNext)
                                            userInfo:nil
                                             repeats:YES];
}
-(void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}
-(void)dealloc{
    [self stopTimer];
}
@end
