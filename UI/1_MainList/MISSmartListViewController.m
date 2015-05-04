//
//  ViewController.m
//  GeoSmart
//
//  Created by Agathe Battestini on 5/1/15.
//  Copyright (c) 2015 Misberri. All rights reserved.
//


#import "MISSmartListViewController.h"
#import "MISSmartListViewModel.h"


@interface MISSmartListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MISSmartListViewModel *viewModel;

@end

@implementation MISSmartListViewController


- (instancetype)initWithViewModel:(MISSmartListViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }

    return self;
}


- (void)loadView {
    [super loadView];
    [self.view addSubview:self.tableView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = NSLocalizedString(@"Smart Menu", nil);
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor
            colorWithHexString:@"494949"]};
    [self.navigationItem setHidesBackButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];


    [self setupLayout];
    [self setupViewModelConnections];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // set the model active, which in turns activate stuff
    self.viewModel.active = YES;

}


#pragma mark - Setting up view and model

- (void)setupLayout
{
    @weakify(self);

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(0.0f);
        make.bottom.equalTo(self.view.mas_bottom);

    }];
}

- (void)setupViewModelConnections
{
    @weakify(self);

    [[[RACObserve(self.viewModel, results)
            ignore:nil]
            distinctUntilChanged]
            subscribeNext:^(NSArray *results) {
                [self.tableView reloadData];
            }];


    // keep that at the end
    self.tableView.delegate = self;
}


#pragma mark - Views

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.bounces = YES;
        _tableView.alwaysBounceVertical = YES;
        _tableView.scrollEnabled = YES;
        _tableView.delaysContentTouches = YES;
        [self.viewModel registerTableViewCellClasses:_tableView];
    }
    return _tableView;
}

#pragma mark - Table view source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self.viewModel cellIdentifierAtIndexPath:indexPath];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    id object = [self.viewModel objectAtIndexPath:indexPath];

    if ([cell respondsToSelector:@selector(setDataObject:)]){
        [cell performSelector:@selector(setDataObject:) withObject:object];
    } else {
        cell.textLabel.text = object;
    }

    return cell;
}

@end