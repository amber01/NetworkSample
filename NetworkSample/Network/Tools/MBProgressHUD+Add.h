//
//  MBProgressHUD+Add.h
//  MumMum
//
//  Created by shlity on 16/6/16.
//  Copyright © 2016年 Moresing Inc. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;

+ (void)hideHUDForView:(UIView *)view;

+ (MBProgressHUD *)showProgress:(NSString *)title toView:(UIView *)view afterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *)showProgress:(UIView *)view;

@end
