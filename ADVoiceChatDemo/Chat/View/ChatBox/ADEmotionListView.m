//
//  ADEmotionListView.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADEmotionListView.h"
#import "ADEmotionPageView.h"

#define topLineH  0.5

@interface ADEmotionListView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *topLine;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation ADEmotionListView

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA_COLOR(237, 237, 246, 1);
        [self topLine];
        [self scrollView];
        [self pageControl];
    }
    return self;
}


#pragma mark - Priate
- (void)pageControlClicked:(UIPageControl *)pageControl {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.pageControl.width          = self.width;
    self.pageControl.height         = 20;
    self.pageControl.x              = 0;
    self.pageControl.y              = self.height - self.pageControl.height;
    self.scrollView.width           = self.width;
    self.scrollView.height          = self.pageControl.y;
    self.scrollView.x               =self.scrollView.y
    = 0;
    NSUInteger count                = self.scrollView.subviews.count;
    for (int i = 0; i < count; i ++) {
        ADEmotionPageView *pageView = self.scrollView.subviews[i];
        pageView.width              = self.scrollView.width;
        pageView.height             = self.scrollView.height;
        pageView.y                  = 0;
        pageView.x                  = i * pageView.width;
    }
    self.scrollView.contentSize     = CGSizeMake(count*self.scrollView.width, 0);
}

- (void)setEmotions:(NSArray *)emotions {
    _emotions = emotions;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger count = (emotions.count + ADEmotionPageSize - 1)/ ADEmotionPageSize;
    self.pageControl.numberOfPages  = count;
    for (int i = 0; i < count; i ++) {
        ADEmotionPageView *pageView = [[ADEmotionPageView alloc] init];
        NSRange range;
        range.location              = i * ADEmotionPageSize;
        NSUInteger left             = emotions.count - range.location;//剩余
        if (left >= ADEmotionPageSize) {
            range.length            = ADEmotionPageSize;
        } else {
            range.length            = left;
        }
        pageView.emotions           = [emotions subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
    }
    [self setNeedsLayout];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    double pageNum                = scrollView.contentOffset.x/scrollView.width;
    self.pageControl.currentPage  = (int)(pageNum+0.5);
}

#pragma mark - Getter and Setter
- (UIScrollView *)scrollView {
    if (nil == _scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setPagingEnabled:YES];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (nil == _pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [self addSubview:pageControl];
        _pageControl = pageControl;
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (UIView *)topLine {
    if (nil == _topLine) {
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,topLineH)];
        [self addSubview:topLine];
        topLine.backgroundColor = RGBA_COLOR(188, 188, 188, 1);
        _topLine = topLine;
    }
    return _topLine;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

