//
//  GCLoginModel.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/23.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCLoginModel.h"

@implementation GCLoginMessageModel

@end

@implementation GCLoginModel

- (instancetype)initWithDictionary:(id)dictionary {
    if (self = [super initWithDictionary:[dictionary objectForKey:@"Variables"]]) {
        NSDictionary *messageDictionary = [dictionary objectForKey:@"Message"];
        GCLoginMessageModel *message = [[GCLoginMessageModel alloc] init];
        message.messageval = [messageDictionary objectForKey:@"messageval"];
        message.messagestr = [messageDictionary objectForKey:@"messagestr"];
        self.message = message;
    }
    
    return self;
}

@end