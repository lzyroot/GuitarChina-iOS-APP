//
//  GCForumDisplayViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCForumDisplayViewController.h"
#import "GCThreadViewController.h"
#import "GCForumDisplayCell.h"

@interface GCForumDisplayViewController ()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation GCForumDisplayViewController

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureBlock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^{
        @strongify(self);
        [[GCNetworkManager manager] getForumDisplayWithForumID:self.fid pageIndex:self.pageIndex pageSize:self.pageSize Success:^(GCForumDisplayArray *array) {
            if (self.pageIndex == 1) {
                self.data = array.data;
//                [self.rowHeightArray removeAllObjects];
                
                [self.tableView reloadData];
                [self endRefresh];
            } else {
                for (GCForumThreadModel *model in array.data) {
                    [self.data addObject:model];
                }
                
                [self.tableView reloadData];
                [self endFetchMore];
            }
        } failure:^(NSError *error) {
            
        }];
    };
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GCForumDisplayCell";
    GCForumDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GCForumDisplayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    GCForumThreadModel *model = [self.data objectAtIndex:indexPath.row];
    cell.textLabel.text = model.subject;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GCThreadViewController *controller = [[GCThreadViewController alloc] init];
    GCForumThreadModel *model = [self.data objectAtIndex:indexPath.row];
    controller.threadID = model.tid;
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end