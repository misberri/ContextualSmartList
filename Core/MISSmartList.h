//
// Created by Agathe Battestini on 5/1/15.
// Copyright (c) 2015 Misberri. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MISSmartList : NSObject

/// contains MISSmartListItem objects
@property (nonatomic, strong, readonly) NSArray *smartList;

@property (nonatomic, strong) RACSignal *listChangedSignal;

/**
* Returns the list of items based on the given context
*/
- (NSArray *)orderedListForContext:(NSNumber *)context;

@end