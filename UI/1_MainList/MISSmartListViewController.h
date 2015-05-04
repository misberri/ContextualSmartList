//
//  MISSmartListViewController.h
//  GeoSmart
//
//  Created by Agathe Battestini on 5/1/15.
//  Copyright (c) 2015 Misberri. All rights reserved.
//


#import <UIKit/UIKit.h>

@class MISSmartListViewModel;


@interface MISSmartListViewController : UIViewController


- (instancetype)initWithViewModel:(MISSmartListViewModel *)viewModel;
@end
