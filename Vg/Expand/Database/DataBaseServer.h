//
//  DataBaseServer.h
//  KKBusiness
//
//  Created by lulucas on 9/19/14.
//  Copyright (c) 2014 lulucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseWorker.h"

@interface DataBaseServer : NSObject

+ (NSDictionary *)addToEngine:(DatabaseWorker *)worker;

@end

