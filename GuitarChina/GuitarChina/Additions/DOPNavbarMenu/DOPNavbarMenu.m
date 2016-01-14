//
//  DOPNavbarMenu.m
//  DOPNavbarMenu
//
//  Created by weizhou on 5/14/15.
//  Copyright (c) 2015 weizhou. All rights reserved.
//

#import "DOPNavbarMenu.h"

@implementation UITouchGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.state = UIGestureRecognizerStateRecognized;
}

@end

@implementation DOPNavbarMenuItem

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon row:(NSInteger)row actionBlock:(Action)actionBlock{
    self = [super init];
    if (self == nil) return nil;
    _title = title;
    _icon = icon;
    _row = row;
    _action = actionBlock;
    return self;
}

+ (DOPNavbarMenuItem *)ItemWithTitle:(NSString *)title icon:(UIImage *)icon row:(NSInteger)row actionBlock:(Action)actionBlock {
    return [[self alloc] initWithTitle:title icon:icon row:(NSInteger)row actionBlock:actionBlock];
}

@end

@interface DOPNavbarMenu ()

//灰色半透明背景
@property (strong, nonatomic) UIView *background;
@property (assign, nonatomic) CGRect beforeAnimationFrame;
@property (assign, nonatomic) CGRect afterAnimationFrame;

@property (assign, nonatomic) CGFloat menuViewHeight;


@end

@implementation DOPNavbarMenu

- (instancetype)initWithRowItems:(NSArray *)rowItems {
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    if (self) {
        if (iPhone) {
            _menuViewHeight = 240;
        } else {
            _menuViewHeight = 400 + 64;
        }
        _rowItems = rowItems;
        
        _open = NO;
        self.dop_height = _menuViewHeight;
        self.dop_y = -self.dop_height;
        _beforeAnimationFrame = self.frame;
        _afterAnimationFrame = self.frame;
        
        _background = [[UIView alloc] initWithFrame:CGRectZero];
        _background.backgroundColor = [UIColor blackColor];
        _background.alpha = 0.3f;
        UITouchGestureRecognizer *gr = [[UITouchGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
        [_background addGestureRecognizer:gr];
        
        _textColor = [UIColor grayColor];
        _separatarColor = [UIColor lightGrayColor];
        _iconColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithRed:0.922f green:0.922f blue:0.922f alpha:1.00f];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height, width, interval, fontSize;
    if (iPhone) {
        height = 120;
        interval = 20;
        if (ScreenWidth == 320) {
            //3.5inch、4inch
            width = (ScreenWidth - interval) / 4;
        } else {
            width = (ScreenWidth - interval) / 5;
        }
        fontSize = 12;
    } else {
        //ipad
        height = 200;
        interval = 40;
        width = (ScreenWidth - interval) / 5;
        fontSize = 15;
    }
    
    UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, height)];
    topScrollView.backgroundColor = [UIColor clearColor];
    topScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:topScrollView];
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + topScrollView.frame.size.height + 1, ScreenWidth, 0.5)];
    seperator.backgroundColor = self.separatarColor;
    [self addSubview:seperator];
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, seperator.frame.origin.y + seperator.frame.size.height + 1, ScreenWidth, height)];
    bottomScrollView.backgroundColor = [UIColor clearColor];
    bottomScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:bottomScrollView];
    
    NSInteger count = 0;
    
    for (int i = 0; i < self.rowItems.count; i++) {
        DOPNavbarMenuItem *obj = self.rowItems[i];
        
        if (obj.row == 0) {
            count++;
        }
        
        UIView *itemView = [[UIView alloc] init];
        if (obj.row == 0) {
            itemView.frame = CGRectMake(interval / 2 + (count - 1) * width, 0, width, height);
        } else {
            itemView.frame = CGRectMake(interval / 2 + (i - count) * width, 0, width, height);
        }
        itemView.backgroundColor = [UIColor clearColor];
        
        UIButton *iconButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width - interval, width - interval)];
        iconButton.tag = i;
        iconButton.backgroundColor = self.iconColor;
        iconButton.center = CGPointMake(itemView.frame.size.width / 2, itemView.frame.size.height / 2 - 15);
        iconButton.layer.cornerRadius = 10;
        [iconButton setImage:obj.icon forState:UIControlStateNormal];
        [iconButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:iconButton];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(interval / 4, iconButton.frame.origin.y + iconButton.frame.size.height + interval / 2, width - interval / 2, 20)];
        label.text = obj.title;
        label.numberOfLines = 0;
        label.preferredMaxLayoutWidth = width - interval / 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.textColor;
        label.font = [UIFont systemFontOfSize:fontSize];
        [itemView addSubview:label];
        if ([label sizeThatFits:label.frame.size].height > 20) {
            [label sizeToFit];
            label.frame = CGRectMake(interval / 4, iconButton.frame.origin.y + iconButton.frame.size.height + 10, width - interval / 2, [label sizeThatFits:label.frame.size].height);
            label.center = CGPointMake(itemView.frame.size.width / 2, label.center.y);
        }
        
        if (obj.row == 0) {
            [topScrollView addSubview:itemView];
        } else {
            [bottomScrollView addSubview:itemView];
        }
    }
    topScrollView.contentSize = CGSizeMake(count * width + interval <= ScreenWidth ? ScreenWidth + 1 : count * width + interval, height);
    bottomScrollView.contentSize = CGSizeMake((self.rowItems.count - count) * width + interval <= ScreenWidth ? ScreenWidth + 1 : (self.rowItems.count - count) * width + interval, height);
}

- (void)showInNavigationController:(UINavigationController *)nvc {
    [nvc.view insertSubview:self.background belowSubview:nvc.navigationBar];
    [nvc.view insertSubview:self belowSubview:nvc.navigationBar];
    if (CGRectEqualToRect(self.beforeAnimationFrame, self.afterAnimationFrame)) {
        CGRect tmp = self.afterAnimationFrame;
        //        tmp.origin.y += ([UIApplication sharedApplication].statusBarFrame.size.height+nvc.navigationBar.dop_height+rowHeight*self.numberOfRow);
        tmp.origin.y += self.menuViewHeight;
        self.afterAnimationFrame = tmp;
    }
    self.background.frame = nvc.view.frame;
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.dop_y = self.afterAnimationFrame.origin.y;
                     } completion:^(BOOL finished) {
                         if (self.delegate != nil) {
                             [self.delegate didShowMenu:self];
                         }
                         self.open = YES;
                     }];
}

- (void)dismissWithAnimation:(BOOL)animation {
    void (^completion)(void) = ^void(void) {
        [self removeFromSuperview];
        [self.background removeFromSuperview];
        if (self.delegate != nil) {
            [self.delegate didDismissMenu:self];
        }
        self.open = NO;
    };
    if (animation) {
        //        [UIView animateWithDuration:0.3 animations:^{
        //            self.dop_y += 20;
        //        } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.dop_y = self.beforeAnimationFrame.origin.y;
        } completion:^(BOOL finished) {
            completion();
        }];
        //        }];
    } else {
        self.dop_y = self.beforeAnimationFrame.origin.y;
        completion();
    }
}

- (void)dismissMenu {
    [self dismissWithAnimation:YES];
}

- (void)buttonTapped:(UIButton *)button {
    if (self.delegate) {
        [self.delegate didSelectedMenu:self atIndex:button.tag];
    }
    DOPNavbarMenuItem *obj = self.rowItems[button.tag];
    if (obj.action) {
        obj.action();
    }
    
    [self dismissMenu];
}
@end
