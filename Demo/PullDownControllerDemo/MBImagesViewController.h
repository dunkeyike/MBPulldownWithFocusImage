//
//  MBImagesViewController.h
//  PullDownControllerDemo
//
//  Created by Matej Bukovinski on 24. 02. 13.
//  Copyright (c) 2013 Matej Bukovinski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASMediaFocusManager.h"

@interface MBImagesViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, ASMediasFocusDelegate>{
	NSURL *selectImageURL;
}

@property (copy, nonatomic) NSString *imageCategory;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) ASMediaFocusManager *mediaFocusManager;
+ (NSCache *)cache;
- (void)reload;

@end
