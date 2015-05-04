//
// Created by Agathe Battestini on 5/1/15.
// Copyright (c) 2015 Misberri. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MISSmartListViewModel : RVMViewModel {
    NSArray *_results;
}

/// 2 dimension array: sections x rows
@property (atomic, strong) NSArray *results;

@property (nonatomic, assign) CGFloat tableViewWidth;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (void)registerTableViewCellClasses:(UICollectionView *)collectionView;

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath;


@end