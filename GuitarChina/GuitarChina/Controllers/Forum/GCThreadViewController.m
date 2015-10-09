//
//  GCThreadViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadViewController.h"
#import "RESideMenu.h"
#import "GCThreadReplyCell.h"
#import "GCThreadHeaderView.h"
#import "GCThreadRightMenuViewController.h"
#import "GCLeftMenuViewController.h"
#import "KxMenu.h"

@interface GCThreadViewController ()

@property (nonatomic, strong) GCThreadHeaderView *threadHeaderView;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) RESideMenu *sideMenuViewController;

@end

@implementation GCThreadViewController

#pragma mark - life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pageIndex = 1;
        self.pageSize = 20;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.title = @"帖子详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureView];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setAdjustsImageWhenHighlighted:YES];
    UIImage *image = [UIImage imageNamed:@"icon_ellipsis"];
    [leftButton setImage:[image imageWithTintColor:[UIColor FontColor]] forState:UIControlStateNormal];
    [leftButton setImage:[image imageWithTintColor:[UIColor LightFontColor]] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(rightBarButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBlock];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.sideMenuViewController = ApplicationDelegate.sideMenuViewController;
//    self.sideMenuViewController.rightMenuViewController = ApplicationDelegate.rightMenuViewController;
//    self.sideMenuViewController.leftMenuViewController = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

//    RESideMenu *sideMenuViewController = ApplicationDelegate.sideMenuViewController;
//    sideMenuViewController.rightMenuViewController = nil;
//    self.sideMenuViewController.leftMenuViewController = ApplicationDelegate.leftMenuViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GCThreadReplyCell";
    GCThreadReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GCThreadReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    GCThreadDetailPostModel *model = [self.data objectAtIndex:indexPath.row];
//    cell.textLabel.text = model.message;
   
    // HTML是网页的设计语言
    // <>表示标记</>
    // 应用场景:截取网页中的某一部分显示
    // 例如:网页的完整内容中包含广告!加载完成页面之后,把广告部分的HTML删除,然后再加载
    // 被很多新闻类的应用程序使用
    [cell.webView loadHTMLString:model.message baseURL:nil];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Event Response

- (void)rightBarButtonClickAction:(id)sender {
    NSArray *menuItems = @[
      [KxMenuItem menuItem:NSLocalizedString(@"Reply", nil)
                     image:nil
                    target:nil
                    action:@selector(replyAction:)],
      
      [KxMenuItem menuItem:NSLocalizedString(@"Collect", nil)
                     image:[UIImage imageNamed:@"action_icon"]
                    target:self
                    action:@selector(collectAction:)],
      
      [KxMenuItem menuItem:NSLocalizedString(@"Share", nil)
                     image:nil
                    target:self
                    action:@selector(shareAction:)],
      
      [KxMenuItem menuItem:NSLocalizedString(@"Report", nil)
                     image:[UIImage imageNamed:@"reload"]
                    target:self
                    action:@selector(reportAction:)],
      
      [KxMenuItem menuItem:NSLocalizedString(@"Open in Safari", nil)
                     image:[UIImage imageNamed:@"search_icon"]
                    target:self
                    action:@selector(safariAction:)],
      
      [KxMenuItem menuItem:NSLocalizedString(@"Copy url", nil)
                     image:[UIImage imageNamed:@"home_icon"]
                    target:self
                    action:@selector(copyUrlAction:)],
      ];

    for (KxMenuItem *item in menuItems) {
        item.alignment = NSTextAlignmentCenter;
    }
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(ScreenWidth - 50, 20, 44, 44)
                 menuItems:menuItems];
}

- (void)replyAction:(id)sender {
}

- (void)collectAction:(id)sender {
}

- (void)shareAction:(id)sender {
}

- (void)reportAction:(id)sender {
}

- (void)safariAction:(id)sender {
}

- (void)copyUrlAction:(id)sender {
}

#pragma mark - Private Methods

- (void)configureView {
    if (self.forumThreadModel) {
        [self.threadHeaderView setForumThreadModel:self.forumThreadModel];
    } else {
        [self.threadHeaderView setHotThreadModel:self.hotThreadModel];
    }
    self.tableView.tableHeaderView = self.threadHeaderView;
}

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^{
        @strongify(self);
        [[GCNetworkManager manager] getViewThreadWithThreadID:@"1961535" pageIndex:self.pageIndex pageSize:self.pageSize Success:^(GCThreadDetailModel *model) {
            if (self.pageIndex == 1) {
                self.data = model.postlist;
                //                [self.rowHeightArray removeAllObjects];
                
                [self.tableView reloadData];
                [self endRefresh];
            } else {
                for (GCThreadDetailPostModel *item in model.postlist) {
                    [self.data addObject:item];
                }
                
                [self.tableView reloadData];
                [self endFetchMore];
            }
            
        } failure:^(NSError *error) {
            
        }];
    };
}

#pragma mark - Getters

- (GCThreadHeaderView *)threadHeaderView {
    if (!_threadHeaderView) {
        _threadHeaderView = [[GCThreadHeaderView alloc] initWithFrame:CGRectZero];
    }
    return _threadHeaderView;
}

@end
