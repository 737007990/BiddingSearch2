//
//  ImageBanner.m
//  zaibopian
//
//  Created by luxiqiang on 15/11/1.
//  Copyright © 2015年 luxq. All rights reserved.
//

#import "ImageBanner.h"

@interface ImageBanner()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;
@end

@implementation ImageBanner

-(instancetype)initWithFrame:(CGRect)frame AndWithImageArray:(NSArray *)imageArray
{
    self=[super initWithFrame:frame];
    if(self)
    {
        self.autoScrollTimeInterval=5.0f;//默认间隔时间
        self.imageArray=imageArray;
        self.frame=frame;
        [self createMainView];
        [self createPageControll:imageArray];
    }
    return self;
}

+(instancetype)imageBannerWithFrame:(CGRect)frame AndWithImageArray:(NSArray *)imageArray
{
    ImageBanner * imageBannerView=[[ImageBanner alloc]initWithFrame:frame AndWithImageArray:imageArray];
    return imageBannerView;
    
}
-(void)createPageControll:(NSArray *)array
{
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height-20, AS_SCREEN_WIDTH, 20)];
    _pageControl.pageIndicatorTintColor=[UIColor hex:@"#FFFFFF"];
    _pageControl.currentPageIndicatorTintColor= [UIColor hex:@"#009EFD"];
    _pageControl.numberOfPages=array.count;
    [self addSubview:_pageControl];
}
-(void)createMainView
{
    UICollectionViewFlowLayout * flowLayout=[[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize=self.frame.size;
    flowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing=0;
    _flowLayout=flowLayout;
    
    UICollectionView * collectView=[[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:flowLayout];
    if(_imageArray.count<2)
    {
        collectView.scrollEnabled=NO;
    }
    else if(_imageArray.count>1)
    {
        collectView.scrollEnabled=YES;
    }
    collectView.delegate=self;
    collectView.dataSource=self;
    collectView.pagingEnabled=YES;
    collectView.showsHorizontalScrollIndicator=NO;
    collectView.showsVerticalScrollIndicator=NO;
    collectView.backgroundColor=[UIColor clearColor];
    [collectView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:@"collectionCell"];
    [self addSubview:collectView];
    _mainView=collectView;
    
}
- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    _totalItemsCount = imageArray.count * 1000;
    [_timer invalidate];
    _timer = nil;
    [self setupTimer];
    [_mainView reloadData];
//    [self setupPageControl];
}


-(void)setupTimer
{
    if(_imageArray.count>1)
    {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
        _timer = timer;
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

-(void)automaticScroll
{
    NSInteger currentIndex = _mainView.contentOffset.x / _flowLayout.itemSize.width;
    NSInteger targetIndex = currentIndex + 1;
    if (targetIndex == _totalItemsCount)
    {
        targetIndex = _totalItemsCount * 0.5;
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _mainView.frame = self.bounds;
    if (_mainView.contentOffset.x == 0&&_imageArray.count>=1) {
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_totalItemsCount * 0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [_timer invalidate];
    _timer = nil;
    [self setupTimer];
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _flowLayout.itemSize = self.frame.size;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger itemIndex = (scrollView.contentOffset.x + self.mainView.frame.size.width * 0.5) / self.mainView.frame.size.width;
    NSInteger indexOnPageControl = itemIndex % self.imageArray.count;
    _pageControl.currentPage = indexOnPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setupTimer];
}

#pragma -mark collectionViewDatasource,collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    long itemIndex = indexPath.item % self.imageArray.count;
    HJCBannerModel *model = self.imageArray[itemIndex];
    UIImageView *image = [[UIImageView alloc] init];
    [image sd_setImageWithURL:[NSURL URLWithString:model.path] placeholderImage:[UIImage imageNamed:@"banner"]];
    cell.backgroundView = image;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectImage:AndSelectIndex:)]) {
        [self.delegate didSelectImage:self AndSelectIndex:indexPath.item%self.imageArray.count];
    }
}

- (void)reloadData:(NSMutableArray *)imageArray {
    self.imageArray = imageArray;
    _pageControl.numberOfPages = imageArray.count;
    if(_imageArray.count<2)
    {
        _mainView.scrollEnabled=NO;
    }
    else if(_imageArray.count>1)
    {
        _mainView.scrollEnabled=YES;
    }
    [self.mainView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
