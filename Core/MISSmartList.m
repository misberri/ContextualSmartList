//
// Created by Agathe Battestini on 5/1/15.
// Copyright (c) 2015 Misberri. All rights reserved.
//

#import "MISSmartList.h"
#import "MISSmartManager.h"
#import "MISAPIManager+Context.h"
#import "MISSmartListItem.h"

@interface MISSmartList()

@property (nonatomic, strong, readwrite) NSArray *smartList;

@end

@implementation MISSmartList {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        _smartList = @[
                [MISSmartListItem newWithName:@"go home"],
                [MISSmartListItem newWithName:@"call friend"],
                [MISSmartListItem newWithName:@"buy something"],
                [MISSmartListItem newWithName:@"listen to music"],
                [MISSmartListItem newWithName:@"alarm clock to 7am"]
                ];

        self.listChangedSignal = RACObserve(self, smartList);
    }
    return self;
}


- (NSArray*)orderedListForContext:(NSNumber*)context {
    // create first a list of (weight, index)
    NSArray *items = [[[self.smartList rac_sequence]
            scanWithStart:nil reduceWithIndex:^id(id running, MISSmartListItem *item, NSUInteger index) {
                NSNumber *weight = [item weightForContext:context];
                return RACTuplePack(weight, item);
            }]
            array];
    // TODO maybe just get the weight in the comparator method
    // sort and return the list of ordered
    NSArray *sortedItems = [[[[items
            sortedArrayUsingComparator:^NSComparisonResult(RACTuple *first, RACTuple *second) {
                return [first.first compare:second.first];
            }]
            rac_sequence]
            map:^id(RACTuple *tuple) {
                return tuple.second;
            }] array];
    return sortedItems;
}

@end