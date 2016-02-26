//
//  YSBProMacro.h
//  YSBPro
//
//  Created by lu lucas on 6/1/15.
//  Copyright (c) 2015 lu lucas. All rights reserved.
//

#ifndef YSBPro_YSBProMacro_h
#define YSBPro_YSBProMacro_h

#pragma mark - 域名设置

#define YSBDomain @"YSBDomain"

#define DevelopmentDomain @"192.168.0.11"
#define TestDomain @"test.ysbang.cn"
#define RCDomain @"58.67.200.249:18080"
#define ProductionDomain @"api.ysbang.cn"

#define PackageDomain ProductionDomain


#pragma mark - 密码加密的密码, 取第一版人员的姓名首字母以作纪念
#define kAesKey @"LsLwHz"

#pragma mark - 离店最大距离
#define kMaxInStore 2000.0f

// 友盟的key
#define sUMAppKey @"545c9107fd98c5efa2005160"
#define sChannelId @"appStore"

#pragma mark - 支付宝相关
//支付宝支付标识符urltypes identifier
#define ALIPAY_IDENTIFIER @"com.yaoshibang.pay"


#endif
