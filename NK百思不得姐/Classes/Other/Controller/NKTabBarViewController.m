//
//  NKTabBarViewController.m
//  NK百思不得姐
//
//  Created by 陆金龙 on 16/1/22.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKTabBarViewController.h"
#import "NKEssenceViewController.h"
#import "NKFriendTrendsViewController.h"
#import "NKNewViewController.h"
#import "NKTabBar.h"
#import "NKNavigationController.h"
#import "NKMainTabBarViewController.h"

@interface NKTabBarViewController ()

@end

@implementation NKTabBarViewController
+ (void)initialize {
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];

    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];

    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    // 添加子控制器
    [self setupChildVc:[[NKEssenceViewController alloc] init] title:@"热门" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];

    [self setupChildVc:[[NKNewViewController alloc] init] title:@"微博" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];

    [self setupChildVc:[[NKMainTabBarViewController alloc] init] title:@"精品" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
    [self setupChildVc:[[NKFriendTrendsViewController alloc] init] title:@"盆友" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];

    [self setValue:[[NKTabBar alloc]init] forKey: @"tabBar"];
}

/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    // 设置文字和图片
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    // 添加为子控制器
    if ([vc isKindOfClass:[NKMainTabBarViewController class]]) {
        [self addChildViewController:vc];
    } else {
        NKNavigationController *nav = [[NKNavigationController alloc] initWithRootViewController:vc];
        [self addChildViewController:nav];
    }
}

@end
