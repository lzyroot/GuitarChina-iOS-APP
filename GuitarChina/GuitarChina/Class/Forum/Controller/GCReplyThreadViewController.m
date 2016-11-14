//
//  GCReplyThreadViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCReplyThreadViewController.h"
#import "GCReplyThreadView.h"

@interface GCReplyThreadViewController ()

@property (nonatomic, strong) GCReplyThreadView *replyThreadView;

@end

@implementation GCReplyThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Event Responses

- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendAction {
    if ([self.replyThreadView.textView.text trim].length == 0) {
        return;
    }
    [self.replyThreadView.textView resignFirstResponder];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    @weakify(self);
    void (^postWebReplyBlock)(NSArray *) = ^(NSArray *attachArray){
        @strongify(self);
        [GCNetworkManager postWebReplyWithTid:self.tid fid:self.fid message:[self.replyThreadView.textView.text stringByAppendingString:@"\n[url=https://itunes.apple.com/cn/app/ji-ta-zhong-guo-hua-yu-di/id1089161305][color=Gray]发自吉他中国iOS客户端[/color][/url]"] attachArray:attachArray formhash:self.formhash success:^{
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Reply Success", nil)];
            [self closeAction];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
        }];
    };
    
    NSArray *imageArray = self.replyThreadView.imageArray;
    NSUInteger imageCount = self.replyThreadView.imageArray.count;
    
    if (imageCount > 0) {
        [GCNetworkManager getWebReplyWithFid:self.fid tid:self.tid success:^(NSData *htmlData) {
            //获取web页面formhash
            NSString *formhash = [GCHTMLParse parseWebReply:htmlData];
            @strongify(self);
            __block int tempCount = 0;
            NSMutableArray *attachArray = [NSMutableArray array];
            for (int i = 0; i < imageCount; i++) {
                [GCNetworkManager postWebReplyImageWithFid:self.fid image:imageArray[i] formhash:formhash success:^(NSString *imageID) {
                    
                    tempCount++;
                    [attachArray addObject:imageID];
                    if (tempCount == imageCount) {
                        postWebReplyBlock(attachArray);
                    }
                    
                } failure:^(NSError *error) {
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Other Error", nil)];
                }];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
        }];
    } else {
        postWebReplyBlock(nil);
    }
    
    /*
     ** old
     [GCNetworkManager postReplyWithTid:self.tid message:[self.replyThreadView.textView.text stringByAppendingString:@"\n"] formhash:self.formhash success:^(GCSendReplyModel *model) {
     self.navigationItem.rightBarButtonItem.enabled = YES;
     if ([model.message.messageval isEqualToString:@"post_reply_succeed"]) {
     [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Reply Success", nil)];
     [self closeAction];
     } else {
     [SVProgressHUD showSuccessWithStatus:model.message.messagestr];
     }
     } failure:^(NSError *error) {
     [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
     self.navigationItem.rightBarButtonItem.enabled = YES;
     }];
     */
}

#pragma mark - Private Methods

- (void)configureView {
    self.title = NSLocalizedString(@"Write reply", nil);
    
    self.navigationItem.leftBarButtonItem = [UIView createCustomBarButtonItem:@"icon_delete"
                                                                  normalColor:[UIColor whiteColor]
                                                             highlightedColor:[GCColor grayColor4]
                                                                       target:self
                                                                       action:@selector(closeAction)];
    
    self.navigationItem.rightBarButtonItem = [UIView createCustomBarButtonItem:@"icon_checkmark"
                                                                   normalColor:[UIColor whiteColor]
                                                              highlightedColor:[GCColor grayColor4]
                                                                        target:self
                                                                        action:@selector(sendAction)];
    
    [self.view addSubview:self.replyThreadView];
}

#pragma mark - Getters

- (GCReplyThreadView *)replyThreadView {
    if (!_replyThreadView) {
        _replyThreadView = [[GCReplyThreadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _replyThreadView.viewController = self;
    }
    return _replyThreadView;
}

@end
