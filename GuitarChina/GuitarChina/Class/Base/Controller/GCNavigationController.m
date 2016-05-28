//
//  GCNavigationController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/30.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCNavigationController.h"
#import "DKNightVersion.h"

@interface GCNavigationController ()

@end

@implementation GCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.tintColor = [UIColor GCDarkGrayFontColor];
    self.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor GCDarkGrayFontColor], NSFontAttributeName : [UIFont systemFontOfSize:18]};
    //    self.navigationBar.nightBarTintColor = [UIColor GCDarkGrayFontColor];
//    self.navigationBar.nightTintColor = [UIColor whiteColor];
//    UIImage *image = [[[UIImage alloc] init] imageWithTintColor:[UIColor GCRedColor]];
//
//        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//        [self.navigationBar setShadowImage:[[UIImage alloc] init]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
