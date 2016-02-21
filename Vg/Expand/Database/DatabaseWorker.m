//
//  DatabaseWorker.m
//  KKBusiness
//
//  Created by lulucas on 9/19/14.
//  Copyright (c) 2014 lulucas. All rights reserved.
//

#import "DatabaseWorker.h"

@implementation DatabaseWorker

@synthesize execute = _execute;

- (void)dealloc
{
    if (_execute) {
        _execute = nil;
    }
    
}

- (void)onStart:(FMDatabase *)dbHelper
{
    
}

- (void)onRun:(FMDatabase *)dbHelper
{
    if (_execute) {
        _execute(dbHelper);
    }
    
}

- (void)onFinished:(FMDatabase *)dbHelper
{
    
}

- (void)onFault:(FMDatabase *)dbHelper
{
    
}

- (NSDictionary *)onResult
{
    return _result;
}

@end
