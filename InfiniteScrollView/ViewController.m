//
//  ViewController.m
//  InfiniteScrollView
//
//  Created by 王文娟 on 16/8/3.
//  Copyright © 2016年 EJU. All rights reserved.
//


#import "ViewController.h"
#import "WJInfiniteScrollView.h"

@interface ViewController ()<WJInfiniteScrollViewDataSource,WJInfiniteScrollViewDelegate>

@property (nonatomic, strong) NSArray *imageUrls;
@end

@implementation ViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    WJInfiniteScrollView *scrollView = [[WJInfiniteScrollView alloc] init];
    scrollView.dataSource = self;
    scrollView.delegate = self;
    scrollView.frame = CGRectMake(0, 50, self.view.frame.size.width, 200);
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    scrollView.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    self.imageUrls = @[
                       @"http://pic.58pic.com/58pic/13/72/07/55Z58PICKka_1024.jpg",
                       @"http://pic27.nipic.com/20130310/4499633_163759170000_2.jpg",
                       @"http://pic24.nipic.com/20120928/6062547_081856296000_2.jpg",
                       @"http://pic15.nipic.com/20110731/8022110_162804602317_2.jpg",
                       @"http://pic29.nipic.com/20130515/1391526_115902145000_2.jpg"
                       
                       ];
}

- (NSInteger)numberOfImagesInScrollView:(WJInfiniteScrollView *)infiniteScrollView{
    
    return 5;
}

- (void)infiniteScrollView:(WJInfiniteScrollView *)infiniteScrollView didScrollToIndex:(NSInteger )index{
    
    NSLog(@"%zd",index);
    
}
- (NSURL *)imageUrlInInfiniteScrollView:(WJInfiniteScrollView *)infiniteScrollView atIndex:(NSInteger )index{
    
    NSString *urlStr = self.imageUrls[index];
    
    return [NSURL URLWithString:urlStr];

}
//- (NSString *)placeholderImageNameInInfiniteScrollView:(WJInfiniteScrollView *)infiniteScrollView{
//    return nil;
//}
@end
