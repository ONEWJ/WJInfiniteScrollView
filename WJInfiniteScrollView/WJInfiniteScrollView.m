//
//  WJInfiniteScrollView.m
//  InfiniteScrollView
//
//  Created by 王文娟 on 16/8/3.
//  Copyright © 2016年 EJU. All rights reserved.
//

#import "WJInfiniteScrollView.h"
#import "UIImageView+WebCache.h"
static int const ImageViewCount = 3;

@interface WJPageControl()
@property (nonatomic, copy) NSString *currentImageName;
@property (nonatomic, copy) NSString *normalImageName;
@property (nonatomic, assign) CGFloat pointMargin;
@property (nonatomic, assign) CGSize normalPagePointSize;
@property (nonatomic, assign) CGSize currentPagePointSize;
@end

@implementation WJPageControl

-(void)setCurrentPage:(NSInteger)currentPage{
    
    [super setCurrentPage:currentPage];
    
    [self updatePoint];
    
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self updatePoint];
    
    
}
-(void)updatePoint{
    
    CGFloat centerX = 0;

    CGFloat centerY = self.frame.size.height/2.0;

    for (NSUInteger i=0; i<self.subviews.count; i++) {

        UIView *point = self.subviews[i];

        CGSize size = CGSizeZero;

        if (i==self.currentPage) {

            size = self.currentPagePointSize;

        }else{

            size = self.normalPagePointSize;
        }

        centerX+=size.width/2.0;


        point.frame = (CGRect){0,0,size};
        point.center = CGPointMake(centerX, centerY);

        centerX = CGRectGetMaxX(point.frame)+self.pointMargin;
    }
}
@end

@interface WJInfiniteScrollView() <UIScrollViewDelegate>
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) NSTimer *timer;
@property (nonatomic, weak) WJPageControl *pageControl;
@end

@implementation WJInfiniteScrollView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupContentView];
    }
    return self;
}

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupContentView];
    
}

-(void)setupContentView{
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    for (int i = 0; i<ImageViewCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [scrollView addSubview:imageView];
    }
    self.pageControl.currentPage = 0;
    self.scrollDuration = 3;
    self.pointMargin = 5;
    self.normalPagePointSize = CGSizeMake(7, 7);
    self.currentPagePointSize = CGSizeMake(34, 7);
}

#pragma mark - lazy
-(WJPageControl *)pageControl{
    
    if(_pageControl==nil){
        
        WJPageControl *pageControl = [[WJPageControl alloc]init];
        [self addSubview:pageControl];
        self.pageControl =  pageControl;
    }
    return _pageControl;
    
}
    
#pragma mark - get
-(WJPageControl *)scrollFlag{
    return self.pageControl;
}
#pragma mark - set

-(void)setPointMargin:(CGFloat)pointMargin{

    _pointMargin = pointMargin;
    
    self.pageControl.pointMargin = pointMargin;
    
}
-(void)setNormalPagePointSize:(CGSize)normalPagePointSize{

    _normalPagePointSize = normalPagePointSize;
    
    self.pageControl.normalPagePointSize = normalPagePointSize;

}

-(void)setCurrentPagePointSize:(CGSize)currentPagePointSize{
    
    _currentPagePointSize = currentPagePointSize;
    
    self.pageControl.currentPagePointSize = currentPagePointSize;

}

-(void)setPageControlAlignment:(WJPageControlAlignment)pageControlAlignment{
    
    _pageControlAlignment = pageControlAlignment;
    
    [self setupPageControlFrame];
}

-(void)setScrollDuration:(CGFloat)scrollDuration{

    _scrollDuration = scrollDuration;
    
    if (self.allowAutomaticScroll && [self.dataSource numberOfImagesInScrollView:self]>1) {
    
        [self stopTimer];
        
        [self startTimer];
    }
}


-(void)setAllowAutomaticScroll:(BOOL)allowAutomaticScroll{

    _allowAutomaticScroll = allowAutomaticScroll;
    
    BOOL allowScroll = [self.dataSource numberOfImagesInScrollView:self]>1;
    
    if (allowAutomaticScroll && !self.timer && allowScroll) {
        
        [self startTimer];
        
    }else{
        
        [self stopTimer];
    }

}

#pragma mark - 布局

-(void)setupPageControlFrame{
    
    NSInteger count  = [self.dataSource numberOfImagesInScrollView:self];
    
    if (!count) {
        return;
    }
    
    self.pageControl.numberOfPages = count;
    
    CGFloat pageW = ((count - 1)*(self.pointMargin +self.normalPagePointSize.width))+self.currentPagePointSize.width;
    CGFloat pageH = 20;
    
    CGFloat pageY = self.scrollView.frame.size.height - pageH;
    CGFloat pageX = 0;
    
    switch (_pageControlAlignment) {
            
        case WJPageControlAlignmentCenter:
            
            pageX = (self.frame.size.width - pageW)/2.0;
            
            break;
        case WJPageControlAlignmentLeft:
            
            pageX = self.pointMargin;
            
            break;
        case WJPageControlAlignmentRight:
            
            pageX = self.scrollView.frame.size.width - pageW - self.pointMargin;
            
            break;
            
        default:
            break;
    }
    
    self.pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(ImageViewCount * self.bounds.size.width, 0);
    
    for (int i = 0; i<ImageViewCount; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        
        imageView.frame = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    }
    
    [self setupPageControlFrame];
    
    if (self.pageControl.numberOfPages ==1) {
        self.scrollView.scrollEnabled = NO;
    }
    
    [self updateContent];
}

#pragma mark - 定时器处理
- (void)startTimer{
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.scrollDuration target:self selector:@selector(next) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.timer = timer;
}

- (void)stopTimer{
    
    [self.timer invalidate];
    
    self.timer = nil;
}

- (void)next{
    
    [self.scrollView setContentOffset:CGPointMake(2 * self.scrollView.frame.size.width, 0) animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT;
    for (int i = 0; i<self.scrollView.subviews.count; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        CGFloat distance = 0;
        distance = ABS(imageView.frame.origin.x - scrollView.contentOffset.x);
        if (distance < minDistance) {
            minDistance = distance;
            page = imageView.tag;
        }
    }
    if (self.pageControl.currentPage!=page) {
        self.pageControl.currentPage = page;
        
        if ([self.delegate respondsToSelector:@selector(infiniteScrollView:didScrollToIndex:)]) {
            [self.delegate infiniteScrollView:self didScrollToIndex:page];
        }
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self.allowAutomaticScroll && [self.dataSource numberOfImagesInScrollView:self]>1) {
        
        [self startTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateContent];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateContent];
}

#pragma mark - 内容更新
- (void)updateContent{
    
    if (![self.dataSource numberOfImagesInScrollView:self]) {
        return;
    }
    // 设置图片
    for (int i = 0; i<self.scrollView.subviews.count; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        NSInteger index = self.pageControl.currentPage;
        if (i == 0) {
            index--;
        } else if (i == 2) {
            index++;
        }
        if (index < 0) {
            index = self.pageControl.numberOfPages - 1;
        } else if (index >= self.pageControl.numberOfPages) {
            index = 0;
        }
        imageView.tag = index;
        
        UIImage *image = nil;
        
        if ([self.dataSource respondsToSelector:@selector(placeholderImageNameInInfiniteScrollView:)]) {
            
            image = [UIImage imageNamed:[self.dataSource placeholderImageNameInInfiniteScrollView:self]];
            
        }
        
        [imageView sd_setImageWithURL:[self.dataSource imageUrlInInfiniteScrollView:self atIndex:index] placeholderImage:image];
    }
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
}
@end
