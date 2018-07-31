//
//  ADChatBoxMoreView.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADChatBoxMoreView.h"
#import "ADChatBoxMoreViewItem.h"

#define topLineH  0.5
#define bottomH  18

@interface ADChatBoxMoreView() <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *topLine;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation ADChatBoxMoreView

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA_COLOR(237, 237, 246, 1);
        [self topLine];
        [self scrollView];
        [self pageControl];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.scrollView setFrame:CGRectMake(0, topLineH, frame.size.width,frame.size.height-bottomH)];
    [self.pageControl setFrame:CGRectMake(0, frame.size.height-bottomH, frame.size.width, 8)];
}

#pragma mark - Public Methods
- (void)setItems:(NSMutableArray *)items {
    _items = items;
    self.pageControl.numberOfPages = items.count / 8 + 1;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * (items.count / 8 + 1), _scrollView.height);
    
    float w = self.width * 20 / 21 / 4 * 0.8;
    float space = w / 4;
    float h = (self.height - 20 - space * 2) / 2;
    float x = space, y = space;
    int i = 0, page = 0;
    for (ADChatBoxMoreViewItem * item in _items) {
        [self.scrollView addSubview:item];
        [item setFrame:CGRectMake(x, y, w, h)];
        [item setTag:i];
        [item addTarget:self action:@selector(didSelectedItem:) forControlEvents:UIControlEventTouchUpInside];
        i ++;
        page = i % 8 == 0 ? page + 1 : page;
        x = (i % 4 ? x + w : page * self.width) + space;
        y = (i % 8 < 4 ? space : h + space * 1.5);
    }
    
}

// 点击了某个Item
- (void) didSelectedItem:(ADChatBoxMoreViewItem *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxMoreView:didSelectItem:)]) {
        [_delegate chatBoxMoreView:self didSelectItem:(int)sender.tag];
    }
}

#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / self.width;
    [_pageControl setCurrentPage:page];
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
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        [_pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (UIView *)topLine {
    if (nil == _topLine) {
        UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,topLineH)];
        [self addSubview:topLine];
        topLine.backgroundColor = RGBA_COLOR(188, 188, 188, 1);
        _topLine = topLine;
    }
    return _topLine;
}

#pragma mark - Privite Method
- (void)pageControlClicked:(UIPageControl *)pageControl {
    [self.scrollView scrollRectToVisible:CGRectMake(pageControl.currentPage * ScreenWidth, 0, ScreenWidth, self.scrollView.height) animated:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
