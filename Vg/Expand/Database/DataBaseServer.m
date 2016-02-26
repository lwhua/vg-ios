//
//  DataBaseServer.m
//  KKBusiness
//
//  Created by lulucas on 9/19/14.
//  Copyright (c) 2014 lulucas. All rights reserved.
//

#import "DataBaseServer.h"
#import "DatabaseEngine.h"

/**
 *  数据库上级目录
 */
static NSString *databaseDir = @"ysb";
/**
 *  数据库名称
 */
static NSString *databaseName = @"db.sqlite3";


@implementation DataBaseServer

+ (NSDictionary *)addToEngine:(DatabaseWorker *)worker
{
	return [[DatabaseEngine shareInstanceWithDir:databaseDir name:databaseName] addDbWorker:worker];
}

@end
