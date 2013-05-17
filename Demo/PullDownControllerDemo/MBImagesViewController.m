//
//  MBImagesViewController.m
//  PullDownControllerDemo
//
//  Created by Matej Bukovinski on 24. 02. 13.
//  Copyright (c) 2013 Matej Bukovinski. All rights reserved.
//

#import "MBImagesViewController.h"
#import "MBImageCell.h"


static NSUInteger const kNumbeOfItems = 42;
static NSString * const kMBImageCellId = @"MBImageCell";
static NSString * const kURLFormat = @"http://lorempixel.com/166/166/%@/%d/";


@implementation MBImagesViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.collectionView registerClass:[MBImageCell class] forCellWithReuseIdentifier:kMBImageCellId];
	
	self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
    self.mediaFocusManager.delegate = self;

	
}

#pragma mark - Cache

+ (NSCache *)cache {
	static NSCache *cache = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		cache = [[NSCache alloc] init];
	});
	return cache;
}

#pragma mark - Category

- (void)setImageCategory:(NSString *)imageCategory {
	if (_imageCategory != imageCategory) {
		_imageCategory = imageCategory;
		[self load];
	}
}

#pragma mark - Loading

- (void)load {
	if (self.imageCategory) {
		[self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
	}
}

- (void)reload {
	[[[self class] cache] removeAllObjects];
	[self load];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return kNumbeOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	MBImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMBImageCellId forIndexPath:indexPath];
	cell.URL = [NSURL URLWithString:[NSString stringWithFormat:kURLFormat, self.imageCategory, (indexPath.row % 10) + 1]];
	cell.imageView.tag = indexPath.row;
	[self.mediaFocusManager installOnView:cell.imageView];
	return cell;
}

#pragma mark - ASMediaFocusDelegate
- (UIImage *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager imageForView:(UIView *)view
{
	self.collectionView.scrollEnabled = NO;
    return ((UIImageView *)view).image;
}

- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameforView:(UIView *)view
{
//	return view.bounds;
//	CGRect retRect = CGRectMake(([UIScreen mainScreen].bounds.size.width - view.bounds.size.width) / 2,
//								 ([UIScreen mainScreen].bounds.size.height - view.bounds.size.height) / 2, view.bounds.size.width, view.bounds.size.height);
	
	return [UIScreen mainScreen].bounds;
//    return self.view.bounds;
//	return retRect;
}

- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
{
    return self;
}

- (NSURL *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager mediaURLForView:(UIView *)view
{
	NSURL *url;
	
	NSInteger row = ((UIImageView *)view).tag;
	NSIndexPath *selectRow = [NSIndexPath indexPathForRow:row inSection:0];
	MBImageCell *cell =(MBImageCell*)[self.collectionView cellForItemAtIndexPath:selectRow];
	selectImageURL = cell.URL;
//    url = [NSURL URLWithString:@"https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQsbFlAIplQ7dmCxM322U2YjMOFJhIGuzaodTymGKQisLeSBUwkyQ"];
	url = selectImageURL;
    
    return url;
}

-(void)dismissFocusMedia {
	self.collectionView.scrollEnabled = YES;
	NSLog(@"%s", __FUNCTION__);
}

@end
