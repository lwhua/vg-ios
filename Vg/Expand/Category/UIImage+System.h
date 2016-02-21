//
//  UIImage+System.h
//  YSBBusiness
//
//  Created by jackyshan on 11/20/14.
//  Copyright (c) 2014 lu lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (System)

/**
 *  利用系统方法对图片进行压缩 按尺寸进行压缩
 *
 *  @param length 和image的width做比较，进行比例缩放，建议image.width/2
 *  @param image  源image
 *
 *  @return 压缩过的图片
 */
+ (UIImage *)imageWithMaxSide:(CGFloat)length sourceImage:(UIImage *)image;

/**
 *  按比例压缩，有损画质
 *
 *  @param quality 压缩比率 0-1
 *  @param image   源image
 *
 *  @return data
 */
+ (NSData *)imageWithQuality:(CGFloat)quality sourceImage:(UIImage *)image;

/**
 *  彩色图转灰白图
 *
 *  @param anImage
 *  @param type 1黑白 2老照片 3底片
 *
 *  @return 转完后的灰白图
 */

+ (UIImage*)grayscale:(UIImage*)anImage type:(int)type;

@end
