//
// Created by Agathe Battestini on 5/1/15.
// Copyright (c) 2015 Misberri. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "MISSmartListViewModel.h"
#import "MISSmartManager.h"
#import "MISSmartList.h"
#import "MISSmartListItem.h"


@interface MISSmartListViewModel()

- (void)prepareData:(id)sender;

@end




@implementation MISSmartListViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableViewWidth = 320.0f;
        [self setupSignals];
    }

    return self;
}


#pragma mark - Signals

- (void)setupSignals {

    @weakify(self);

    [[[self.didBecomeActiveSignal
            take:1]
            doNext:^(id x) {
                [[MISSmartManager sharedInstance] setActive:YES];
            }]
            subscribeCompleted:^{

            }];

    MISSmartManager *smartManager = [MISSmartManager sharedInstance];

    [self rac_liftSelector:@selector(prepareData:) withSignals:[smartManager.smartListChangedSignal
                                                                       mapReplace:[smartManager itemListForCurrentContext] ],
                    nil];


    // when the VC appears, we turn on the detection
//    [[[self.didBecomeActiveSignal
//            take:1]
//            flattenMap:^RACStream *(id value) {
//                BooTimelineModel *model = [[[BooCommManager sharedInstance] feedManager] timelineModel];
//                [[model reloadCommand] execute:nil];
//                return RACObserve(model, initialized);
//            }]
//            subscribeNext:^(id x) {
//                DDLogVerbose(@"Starting scanning beacons");
//                [[[BooCommManager sharedInstance] beaconManager] startScanning];
//            }];
//
//    RACSignal *didTimelineChange = [[[BooCommManager sharedInstance] rac_didUpdateTimeline] startWith:nil];
//
//    RACSignal *widthChanged = [RACObserve(self, collectionViewWidth)
//            mapReplace:[[BooCommManager sharedInstance] feedManager].timelineModel];
//
//    [self rac_liftSelector:@selector(prepareData:)
//               withSignals:[RACSignal merge: @[didTimelineChange, widthChanged]], nil];

}


#pragma mark - Data

- (void)prepareData:(id)sender {
    NSMutableArray *data = [NSMutableArray array]; // data is as [section][row]

    NSArray *listItems = sender;

    CGSize defaultSize = {.width = self.tableViewWidth, .height = UIViewNoIntrinsicMetric};
    __block CGSize size = {.width = defaultSize.width, .height = 44.0f};
    __block ABCellInfoDataObject *infoDataObject;

    NSMutableArray *sectionData = [NSMutableArray arrayWithCapacity:4];

    [listItems enumerateObjectsUsingBlock:^(MISSmartListItem *item, NSUInteger idx, BOOL *stop) {
//        size = [BooTimelineCardCell sizeForObject:eventModel withSize:cardSize];
        infoDataObject = [ABCellInfoDataObject newWithSize:size cellIdentifier:@"cell"];
        infoDataObject.object = item.name;
        [sectionData addObject:infoDataObject];
    }];
    [data addObject:sectionData];


    self.results = data;
}


#pragma mark - Table view

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    ABCellInfoDataObject *object = [self cellInfoDataObjectAtIndexPath:indexPath];
    return object.object;
}

- (void)registerTableViewCellClasses:(UITableView *)tableView {
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize result;
    return result;
}

- (NSInteger)numberOfSections {
    return self.results.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    if(section < [self numberOfSections])
        return [((NSArray*)self.results[section]) count];
    return 0;
}

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    ABCellInfoDataObject *cellInfoDataObject = [self cellInfoDataObjectAtIndexPath:indexPath];
    NSAssert(cellInfoDataObject, @"object is nil");
    return cellInfoDataObject.cellIdentifier;
}

- (ABCellInfoDataObject *)cellInfoDataObjectAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(indexPath, @"cannot be nil");
    return self.results[indexPath.section][indexPath.row];

}

@end