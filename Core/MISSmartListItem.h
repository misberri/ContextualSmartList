//
// Created by Agathe Battestini on 5/1/15.
// Copyright (c) 2015 Misberri. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
* A smart list item knows in which context it is used the most
*/
@interface MISSmartListItem : NSObject

@property (nonatomic, copy) NSString *name;

// contextId => (weight, count)
@property (nonatomic, assign) NSDictionary *weightedContexts;

- (instancetype)initWithName:(NSString *)name withCurrentContext:(NSNumber *)contextId;

- (instancetype)initWithName:(NSString *)name;

/**
* Update the item with the context in which it was used
*/
- (void)updateWithCurrentContext:(NSNumber *)contextId;

- (NSNumber *)weightForContext:(NSNumber *)contextId;

+ (instancetype)newWithName:(NSString *)name;
@end