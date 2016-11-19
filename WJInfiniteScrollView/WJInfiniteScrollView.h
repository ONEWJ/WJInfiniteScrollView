//
//  WJInfiniteScrollView.h
//  InfiniteScrollView
//
//  Created by 王文娟 on 16/8/3.
//  Copyright © 2016年 EJU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WJPageControlAlignment) {
    WJPageControlAlignmentCenter  = 0,
    WJPageControlAlignmentLeft    = 1,
    WJPageControlAlignmentRight   = 2
};

@class WJInfiniteScrollView;

@protocol WJInfiniteScrollViewDataSource <NSObject>

- (NSURL *)imageUrlInInfiniteScrollView:(WJInfiniteScrollView *)infiniteScrollView atIndex:(NSInteger )index;

- (NSInteger)numberOfImagesInScrollView:(WJInfiniteScrollView *)infiniteScrollView;

@optional

- (NSString *)placeholderImageNameInInfiniteScrollView:(WJInfiniteScrollView *)infiniteScrollView;
@end

@protocol WJInfiniteScrollViewDelegate <NSObject>

@optional

- (void)infiniteScrollView:(WJInfiniteScrollView *)infiniteScrollView didScrollToIndex:(NSInteger )index;

@end
@interface WJPageControl : UIPageControl
@end
@interface WJInfiniteScrollView : UIView


@property (nonatomic, assign) BOOL allowAutomaticScroll;

@property (nonatomic, assign) CGFloat scrollDuration;

//可以自定义图片(后期补充)
@property (nonatomic, copy) NSString *currentImageName;
@property (nonatomic, copy) NSString *normalImageName;

@property (nonatomic, assign) CGFloat pointMargin;
@property (nonatomic, assign) CGSize normalPagePointSize;
@property (nonatomic, assign) CGSize currentPagePointSize;


@property (weak, nonatomic, readonly) WJPageControl *pageControl;

@property (nonatomic, weak) id<WJInfiniteScrollViewDataSource> dataSource;

@property (nonatomic, weak) id<WJInfiniteScrollViewDelegate> delegate;

@property (nonatomic, assign) WJPageControlAlignment pageControlAlignment;


@end
