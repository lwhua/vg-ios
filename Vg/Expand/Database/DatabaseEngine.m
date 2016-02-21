//
//  DatabaseEngine.m
//  FMDB
//
//  Created by lulucas on 9/18/14.
//  Copyright (c) 2014 lulucas. All rights reserved.
//

#import "DatabaseEngine.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

@interface DatabaseEngine ()
{
    FMDatabaseQueue *_userDbQueue;
}

@end

@implementation DatabaseEngine

+ (id)shareInstanceWithDir:(NSString *)databaseDir name:(NSString *)databaseName
{
    static DatabaseEngine *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DatabaseEngine alloc] initWithDir:databaseDir name:databaseName];
    });
    
    return _instance;
}

- (id)initWithDir:(NSString *)databaseDir name:(NSString *)databaseName
{
    if (self = [super init])
    {
        // 预加载离线数据库
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *directoryString = [pathArray objectAtIndex:0];
        NSString *filePathString = [directoryString stringByAppendingPathComponent:databaseDir];
        NSError *error=nil;
        
        if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:filePathString])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:filePathString
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
        }
        //初始化离线数据库连接
        NSString *fileNameString = [filePathString stringByAppendingPathComponent:databaseName];
        // 如果第一次安装，离线数据库不存在,拷贝离线数据库
//        if (NO == [[NSFileManager defaultManager] fileExistsAtPath:fileNameString]) {
//            NSString * docPath = [[NSBundle mainBundle] pathForResource:@"db" ofType:@"sqlite3"];
//            [[NSFileManager defaultManager] copyItemAtPath:docPath toPath:fileNameString error:NULL];
//        }
        //初始化用户数据库连接
        fileNameString = [filePathString stringByAppendingPathComponent:databaseName];
        
        _userDbQueue = [FMDatabaseQueue databaseQueueWithPath:fileNameString];
        
    }
    
    
    return self;
}

- (NSDictionary *)addDbWorker:(DatabaseWorker *)worker
{
    if (!worker) {
        return nil;
    }
    @autoreleasepool {
        [_userDbQueue inDatabase:^(FMDatabase *db) {
            
            if (![db open]) {
                return ;
            }
            
            BOOL bRollBack = NO;
            
            @try {
                [db beginTransaction];
                [worker onStart:db];
                [worker onRun:db];
            } @catch (NSException *exception) {
                bRollBack = YES;
            } @finally {
                if (bRollBack) {
                    [db rollback];
                    [worker onFault:db];
                } else {
                    [db commit];
                    [worker onFinished:db];
                }
            }
            
            [db close];
        }];
        
        return [worker onResult];
    }
    
}

@end
