//
//  Macro.h
//  Vg
//
//  Created by lwhua on 16/2/17.
//  Copyright © 2016年 lwhua. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define NavigationBar_HEIGHT 44
#define kViewHeight (kScreenHeight - 64)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define bIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define DEVICE_IS_IPHONE4 ([[UIScreen mainScreen] bounds].size.height == 480)


#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define CLEARCOLOR [UIColor clearColor]
#define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]


//重写NSLog,Debug模式下打印日志和当前行数
#if defined(DEBUG)||defined(_DEBUG)
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif


#define kMainColor [UIColor colorWithRed:253 / 255.0f green:92 / 255.0f blue:2 / 255.0f alpha:1.0f]
#define kBackgroundColor [UIColor whiteColor]
#define kAlertViewRedColor [UIColor colorWithRed:230 / 255.0f green:0 / 255.0f blue:18 / 255.0f alpha:1.0f]
#define COLOR_CLEAR [UIColor clearColor]
#define COLOR_646464 [UIColor colorWithRed:0x64 / 255.0f green:0x64 / 255.0f blue:0x64 / 255.0f alpha:1.0f]

#endif /* Macro_h */
