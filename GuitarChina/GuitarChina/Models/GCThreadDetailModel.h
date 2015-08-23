//
//  GCThreadDetailModel.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/23.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCBaseModel.h"

@interface GCThreadDetailModel : GCBaseModel

@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *ppp;
@property (nonatomic, copy) NSString *forum_threadpay;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end