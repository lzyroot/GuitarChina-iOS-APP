//
//  GCForumDisplayViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCForumDisplayViewController.h"
#import "GCForumDisplayCell.h"
#import "GCPostThreadViewController.h"
#import "GCThreadDetailViewController.h"
#import "GCNavigationController.h"
#import "GCLoginViewController.h"
#import "MJRefresh.h"
#import <CoreText/CoreText.h>

@interface GCForumDisplayViewController ()

@property (nonatomic, assign) BOOL loaded;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GCTableViewKit *tableViewKit;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *rowHeightArray;

@end

@implementation GCForumDisplayViewController

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loaded = false;
    self.uid = 0;
    self.pageIndex = 1;
    self.pageSize = 20;

    self.navigationItem.rightBarButtonItem = [UIView createCustomBarButtonItem:@"icon_edit"
                                                                   normalColor:[UIColor whiteColor]
                                                              highlightedColor:[GCColor grayColor4]
                                                                        target:self
                                                                        action:@selector(newThreadAction)];

    [self configureView];
    [self configureNotification];
    
    [self.tableView.header beginRefreshing];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGCNotificationLoginSuccess object:nil];
}

#pragma mark - Notification

- (void)configureNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction) name:kGCNotificationLoginSuccess object:nil];
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.tableView];
}

#pragma mark - Event Response

- (void)refreshAction {
    self.loaded = false;
    APP.tabBarController.selectedIndex = 1;
    [self.tableView.header beginRefreshing];
}

- (void)newThreadAction {
    if (self.loaded == YES) {
        if ([self.uid isEqualToString:@"0"]) {
            GCLoginViewController *loginViewController = [[GCLoginViewController alloc] initWithNibName:@"GCLoginViewController" bundle:nil];
            GCNavigationController *navigationController = [[GCNavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:nil];
        }
        else if (!self.threadTypes || self.threadTypes.count == 0) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"GuitarChina Interface Error", nil)];
        }
        else {
            GCPostThreadViewController *controller = [[GCPostThreadViewController alloc] initWithNibName:@"GCPostThreadViewController" bundle:[NSBundle mainBundle]];
            controller.fid = self.fid;
            controller.formhash = self.formhash;
            controller.threadTypes = self.threadTypes;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark - HTTP

- (void)getForumDisplay {
    @weakify(self);
    [GCNetworkManager getForumDisplayWithForumID:self.fid pageIndex:self.pageIndex pageSize:self.pageSize success:^(GCForumDisplayArray *array) {
        @strongify(self);
        self.loaded = true;
        self.uid = array.member_uid;
        self.formhash = array.formhash;
        self.threadTypes = array.threadTypes;
        
        if (!self.threadTypes || self.threadTypes.count == 0) {
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        if (self.pageIndex == 1) {
            self.data = array.data;
            self.rowHeightArray = [NSMutableArray array];
            for (GCForumThreadModel *model in self.data) {
                [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCForumDisplayCell getCellHeightWithModel:model]]];
            }
            [self.tableView.header endRefreshing];
        } else {
            for (GCForumThreadModel *model in array.data) {
                [self.data addObject:model];
                [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCForumDisplayCell getCellHeightWithModel:model]]];
            }
            [self.tableView.footer endRefreshing];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        @strongify(self);
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
    }];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, ScreenWidth, 44)];
//        label.font = [UIFont systemFontOfSize:15];
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
//        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"XXX"
//                                                                       attributes:
//                                         @{NSFontAttributeName:[UIFont systemFontOfSize:12.f],
//                                           (id)kCTForegroundColorAttributeName:(id)[UIColor redColor].CGColor,
//                                           NSBackgroundColorAttributeName:[UIColor blueColor]}]];
//        [string appendAttributedString:[[NSAttributedString alloc] initWithString:self.threads attributes:@{}]];
//        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@" | 回复:" attributes:@{}]];
//        [string appendAttributedString:[[NSAttributedString alloc] initWithString:self.posts attributes:@{}]];
//        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@" | 今日:" attributes:@{}]];
//        [string appendAttributedString:[[NSAttributedString alloc] initWithString:self.todayposts attributes:@{}]];
//        label.attributedText = string;
//        [headerView addSubview:label];
//        _tableView.tableHeaderView = headerView;

        _tableView.tableFooterView = [[UIView alloc] init];
        
        self.tableViewKit = [[GCTableViewKit alloc] initWithCellType:ConfigureCellTypeClass cellIdentifier:@"GCForumDisplayCell"];
        @weakify(self);
        self.tableViewKit.getItemsBlock = ^{
            @strongify(self);
            return self.data;
        };
        self.tableViewKit.cellForRowBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell) {
            GCForumDisplayCell *forumDisplayCell = (GCForumDisplayCell *)cell;
            GCForumThreadModel *forumThreadModel = (GCForumThreadModel *)item;
            forumDisplayCell.model = forumThreadModel;
        };
        self.tableViewKit.heightForRowBlock = ^(NSIndexPath *indexPath, id item) {
            @strongify(self);
            NSNumber *height = [self.rowHeightArray objectAtIndex:indexPath.row];
            return (CGFloat)[height floatValue];
        };
        self.tableViewKit.didSelectCellBlock = ^(NSIndexPath *indexPath, id item) {
            @strongify(self);
            GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
            GCForumThreadModel *model = [self.data objectAtIndex:indexPath.row];
            controller.tid = model.tid;
            [self.navigationController pushViewController:controller animated:YES];
        };
        [self.tableViewKit configureTableView:_tableView];
        
        _tableView.header = ({
            @weakify(self);
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                @strongify(self);
                self.pageIndex = 1;
                [self getForumDisplay];
            }];
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;
            header;
        });
        _tableView.footer = ({
            @weakify(self);
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                @strongify(self);
                self.pageIndex++;
                [self getForumDisplay];
            }];
            footer.automaticallyRefresh = YES;
            footer.refreshingTitleHidden = YES;
            [footer setTitle:NSLocalizedString(@"Load More", nil) forState:MJRefreshStateIdle];
            footer;
        });
    }
    return _tableView;
}

@end
