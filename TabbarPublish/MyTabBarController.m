//
//  MyTabBarController.m
//  TabbarPublish
//
//  Created by muxue on 2019/2/15.
//  Copyright © 2019 暮雪. All rights reserved.
//

#import "MyTabBarController.h"
#import "ViewController.h"

CG_INLINE UIImage *myImage(NSString *imageName) {
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@interface MyTabBarController ()
@property (nonatomic, weak) UIButton *publishBtn;
@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllers = [self createSubviewController];
    self.tabBar.translucent = NO;
    self.tabBar.shadowImage = [[UIImage alloc] init];
    [self addpublishBtn];
}

// 创建子视图
- (NSArray<UIViewController *>*)createSubviewController {
    NSMutableArray <UIViewController *>* subviewController = [NSMutableArray array];
    NSArray *selectimage = @[myImage(@"tabbar_card_select"), myImage(@"tabbar_mission_select"), myImage(@"tabbar_my_select"), myImage(@"tabbar_shop_select")];
    NSArray *normalimage = @[myImage(@"tabbar_card_normal"), myImage(@"tabbar_mission_normal"), myImage(@"tabbar_my_normal"), myImage(@"tabbar_shop_normal")];
    for (NSInteger i = 0; i < 4; i++) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc]init]];
        nav.tabBarItem.title = [NSString stringWithFormat:@"item %ld", i];
        nav.tabBarItem.image = normalimage[i];
        nav.tabBarItem.selectedImage = selectimage[i];
        [subviewController addObject:nav];
    }
    return subviewController;
}

// 添加发布按钮
- (void)addpublishBtn {
    CGFloat totalW = self.tabBar.frame.size.width;
    CGFloat itemW = totalW/self.tabBar.items.count;
    CGFloat newItemW = totalW/(self.tabBar.items.count + 1);
    //向下取整
    NSInteger halfcount = floor(self.tabBar.items.count/2.0);
    
    for (NSInteger i = 0; i < self.tabBar.items.count; i++) {
        UITabBarItem *item = self.tabBar.items[i];
        CGFloat offsetX = 0;
        if (i < halfcount) {
            offsetX = (i*newItemW) + (newItemW/2) - ((i*itemW) + (itemW/2.0));
        } else {
            offsetX = ((i+1)*newItemW) + (newItemW/2) - ((i*itemW) + (itemW/2.0));
        }
        item.titlePositionAdjustment = UIOffsetMake(offsetX, 0);
    }

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    button.backgroundColor = UIColor.orangeColor;
    button.layer.cornerRadius = 25;
    button.center = CGPointMake(self.tabBar.center.x, 15);
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(publishing) forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds = YES;

    self.publishBtn = button;
    [self.tabBar addSubview:button];
}

//重写touchesbegan 方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //获得点击的位置
    UITouch *touch = touches.allObjects.firstObject;
    CGPoint touchPoint = [touch locationInView:self.view];

    //获得发布按钮相对当前视图的位置和大小
    CGRect rect =  [self.publishBtn convertRect:self.publishBtn.bounds toView:self.view];
    //如果点击位置在发布按钮上，则触发发布事件
    if (CGRectContainsPoint(rect, touchPoint)) {
        [self.publishBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)publishing {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发布" message:@"发布内容" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {}];
    [alertController addAction:action];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

@end
