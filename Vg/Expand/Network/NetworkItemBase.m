//
//  NetworkItemBase.m
//  YSBBusiness
//
//  Created by lu lucas on 4/11/14.
//  Copyright (c) 2014 lu lucas. All rights reserved.
//

#import "NetworkItemBase.h"
#import "MKNetworkKit.h"
#import "Macro.h"
#import "CommonHelper.h"
#import "DataBaseServer.h"
#import "MBProgressHUD.h"
#import "UserInfoPro.h"
#import "NotificationMacro.h"
#import "YSBProMacro.h"
#import <mach/mach_time.h>


#define kHttpRetryCount 1

static MKNetworkEngine *_businessEngine = nil;
static MKNetworkEngine *_testEngine = nil;

@interface NetworkItemBase ()
{
	HttpMethodType _methodType;
	NSUInteger _retryCount;
    
    NSTimeInterval _startTime;

}

/**
 *  请求路径
 */
@property (nonatomic, strong) NSString *path;
/**
 *  请求的参数
 */
@property (nonatomic, strong) NSDictionary *params;
/**
 *  是否需要带token
 */
@property (nonatomic, assign) NWFlag flag;
/**
 *   是否强刷
 */
@property (nonatomic, assign) CacheType cacheType;
/**
 *  post请求的data文件
 */
@property (nonatomic, strong) NSArray *files;

/**
 *是否是纯JSON数据POST 没有对应的Key
 */
@property (nonatomic, assign) BOOL pureJSONData;

/**
 *  是否是文件下载
 */
@property (nonatomic, assign) BOOL fileDownload;
/**
 *  是否支持断点续传
 */
@property (nonatomic, assign) BOOL breakResume;
/**
 *  文件保存路径
 */
@property (nonatomic, strong) NSString *fileSavePath;

@end

@implementation NetworkItemBase

+ (void)initialize {
    // TODO:子类实例化也调用了这个方法，导致引擎不断被实例化，之前的变量自动消失后，通知没有移除，导致崩溃
    if (!_businessEngine) {
        
        NSString *domain = [[NSUserDefaults standardUserDefaults] objectForKey:YSBDomain];
        if (!domain
            || [domain isEqualToString:@""]) {
            domain = PackageDomain;
        }
        
        _businessEngine = [[MKNetworkEngine alloc] initWithHostName:domain];
            //@"192.168.0.218:8080"
        _testEngine = [[MKNetworkEngine alloc] initWithHostName:@"192.168.0.218:8080"];
    }
}

- (void)dealloc {
	
#ifdef DEBUG
    NSDate *tmpStartData = [NSDate date];
    NSTimeInterval end = [tmpStartData timeIntervalSince1970];
    NSTimeInterval duration = end - _startTime;
    
    NSLog(@"请求销毁->%@ dealloc 耗时:%@", [self class], @(duration));
#endif
}

- (id)init {
	self = [super init];
	if (self) {
		_flag = NWFlagNone;
		_retryCount = 0;
		_pureJSONData = YES;
		_cacheType = CacheTypeUseServer;
		_serverType = ServerTypeNormal;
	}
	return self;
}

#pragma mark GET Method

- (void)startGet {
	// 需要token
	if (_flag != NWFlagNone
	    && [UserInfoPro shareInstance].userInfo) {
		if (_params) {
			NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:_params];
			[tmpDic setObject:[UserInfoPro shareInstance].userInfo.usertoken forKey:@"usertoken"];
			_params = tmpDic;
		}
		else {
			if ([_path rangeOfString:@"?"].location == NSNotFound) {
				_path = [NSString stringWithFormat:@"%@?usertoken=%@", _path, [UserInfoPro shareInstance].userInfo.usertoken];
			}
			else {
				_path = [NSString stringWithFormat:@"%@&usertoken=%@", _path, [UserInfoPro shareInstance].userInfo.usertoken];
			}
		}
	}

	[self sendRequest:HttpMethodGet];
}

#pragma mark POST Method

- (void)startPost {
#ifdef DEBUG
    NSDate *tmpStartData = [NSDate date];
    _startTime = [tmpStartData timeIntervalSince1970];
#endif
    NSLog(@"开始请求->%@", [self class]);
    
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_params];
	[dic setObject:@"123456" forKey:@"authcode"];
	[dic setObject:@"iOS" forKey:@"platform"];
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	[dic setObject:version forKey:@"version"];
	if (_flag != NWFlagNone) {
		[dic setObject:[UserInfoPro shareInstance].userInfo.usertoken ? : @"" forKey:@"usertoken"];
	}
	_params = dic;

	// 保存image
	NSMutableArray *fileArray = nil;
	if (_files && _files.count > 0) {
		fileArray = [[NSMutableArray alloc] init];
		for (int i = 0; i < _files.count; i++) {
			NSDictionary *dic = [_files objectAtIndex:i];

			if ([[dic objectForKey:@"image"] isKindOfClass:[NSString class]]) {
				NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
				[newDic setObject:@"" forKey:@"path"];
				[newDic setObject:@"file" forKey:@"name"];
				[fileArray addObject:newDic];
				continue;
			}

			UIImage *image = [dic objectForKey:@"image"];

			NSData *data = nil;
			if (UIImagePNGRepresentation(image) == nil) {
				data = UIImageJPEGRepresentation(image, 0.6);
			}
			else {
				data = UIImagePNGRepresentation(image);
			}

			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
			NSString *cachePath = [paths objectAtIndex:0];
			NSString *filePath = [cachePath stringByAppendingFormat:@"/upload-file-%d.jpg", i];

			NSFileManager *fileManager = [NSFileManager defaultManager];
			[fileManager createFileAtPath:filePath contents:data attributes:nil];

			NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
			[newDic setObject:filePath forKey:@"path"];
			[newDic setObject:@"file" forKey:@"name"];
			[fileArray addObject:newDic];
		}
	}
	_files = fileArray;

	[self sendRequest:HttpMethodPost];
}

#pragma mark Request Method

- (void)sendRequest:(HttpMethodType)type {
	_retryCount++;
	_methodType = type;

	MKNetworkEngine *engine = nil;
	switch (_serverType) {
		case ServerTypeNormal:
			engine = _businessEngine;
			break;
        case ServerTypeTest:
            engine = _testEngine;
            break;
		default:
			break;
	}

	MKNetworkOperation *operation = [engine operationWithPath:[_path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
	                                                   params:_params
	                                               httpMethod:(type == HttpMethodGet) ? @"GET" : @"POST"];
	if (_pureJSONData) {
		[operation setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
	}

	// ======
	// 如果有缓存
	switch (_cacheType) {
		case CacheTypeUseCahe:
		{
			NSString *key = [[NSString stringWithFormat:@"%@:%@", operation.url, [InputHelper convertToJsonString:operation.readonlyPostDictionary options:YES]] md5];
			id result = [DataBaseServer getCache:key];
			if (result) {
                _isCache = YES;
				[self dealComplete:[InputHelper jsonConvertToObject:result] succ:YES];
				NSLog(@"\n数据来自：%@\n请求地址：%@\n提交数据：%@\n返回数据:%@", @"缓存", operation.url, operation.readonlyPostDictionary, [InputHelper jsonConvertToObject:result]);
				return;
			}
		}
		break;

		case CacheTypeCacheAndServer:
		{
			NSString *key = [[NSString stringWithFormat:@"%@:%@", operation.url, [InputHelper convertToJsonString:operation.readonlyPostDictionary options:YES]] md5];
			id result = [DataBaseServer getCache:key];
			if (result) {
                _isCache = YES;
				[self dealComplete:[InputHelper jsonConvertToObject:result] succ:YES];
				NSLog(@"\n数据来自：%@\n请求地址：%@\n提交数据：%@\n返回数据:%@", @"缓存", operation.url, operation.readonlyPostDictionary, [InputHelper jsonConvertToObject:result]);
			}
		}
		break;

		case CacheTypeUseServer:

			break;

		default:
			break;
	}

	// ======


	// 上传文件
	if (self.files && self.files.count > 0) {
		for (NSDictionary *fileDic in self.files) {
			[operation addFile:[fileDic objectForKey:@"path"] forKey:[fileDic objectForKey:@"name"]];
		}
	}

	[operation addCompletionHandler: ^(MKNetworkOperation *completedOperation) {
	    [self requestComplete:completedOperation];
	} errorHandler: ^(MKNetworkOperation *completedOperation, NSError *error) {
	    [self requestComplete:completedOperation];
	}];

	//下载文件
	if (_fileDownload) {
		NSString *savePath = [CommonHelper getDownloadSavePath:_fileSavePath];

		if (_breakResume) {
			NSString *headRange = [NSString stringWithFormat:@"bytes=%llu-", [CommonHelper getCacheFileSize:savePath]];
			[operation addHeader:@"Range" withValue:headRange];
		}
		[operation addDownloadStream:[NSOutputStream outputStreamToFileAtPath:savePath append:_breakResume]];
		[operation onDownloadProgressChanged: ^(double progress) {
		    [self requestComplete:[NSNumber numberWithDouble:progress] succ:progress == 1 operation:nil];
		}];
	}

	[engine enqueueOperation:operation];
}

- (void)requestComplete:(MKNetworkOperation *)completedOperation {
    
    // 下载完成code==200,result=nil,下载不需要走下面的判断
    if (_fileDownload) {
        return;
    }
    
    id result = completedOperation.responseJSON;
    BOOL flag = NO;
	if (completedOperation.HTTPStatusCode == 200 && result) {// 请求成功，有返回数据，判断返回码
        
		if ([[result objectForKey:@"code"] integerValue] == 40001) {
			flag = YES;
		} else {
			
			if ([[result objectForKey:@"code"] integerValue] == 40020) {
				[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_TOKEN_OUTTIME object:@"tokenError"];
			} else {
                
                NSString *msg = [result objectForKey:@"message"];
#ifdef DEBUG
                NSString *error = [NSString stringWithFormat:@"%@/%@", [completedOperation.url componentsSeparatedByString:@"/"].lastObject, msg.length > 0 ? msg : @"请求成功，有错误信息"];
                if ([[result objectForKey:@"code"] integerValue] == 40030) {
                    [CommonHelper showLongMessage:nil message:error];
                } else {
                    [CommonHelper showMessage:nil message:error];
                }
#else
                if ([[result objectForKey:@"code"] integerValue] == 40030) {
                    [CommonHelper showLongMessage:nil message:msg?:@"请检查您的网络~"];
                } else {
                    [CommonHelper showMessage:nil message:msg?:@"请检查您的网络~"];
                }

#endif
                
			}
		}
	} else if (completedOperation.HTTPStatusCode == 0) {// 没有网络
		NSString *errorDescription = [completedOperation.error.userInfo objectForKey:@"NSLocalizedDescription"];
		errorDescription = [errorDescription substringToIndex:errorDescription.length - 1];
        [CommonHelper showMessage:nil message:@"请检查您的网络~"];
	} else {// 其他情况
#ifdef DEBUG
        [CommonHelper showMessage:nil message:@"服务器休息中~"];
#endif
	}
#ifdef DEBUG
    // 打印信息
    @try {
        
        id paramsJson = [InputHelper convertToJsonString:completedOperation.readonlyPostDictionary options:NO];
        if (!paramsJson) {
            paramsJson = completedOperation.readonlyPostDictionary;
        }
        
        NSString *resultJson = [InputHelper convertToJsonString:result options:NO];
        if (!resultJson) {
            resultJson = [self _replaceUnicode:completedOperation.responseString];
        }
        
        // 打印结果
        NSLog(@"\n数据来自：服务器\n请求地址：%@\n提交数据：%@\n返回数据:%@", completedOperation.url, paramsJson, resultJson);
    }
    @catch (NSException *exception) {
        NSLog(@"exception %@", exception);
    }
    @finally {
        
    }
#endif
	[self requestComplete:result succ:flag operation:completedOperation];
}

- (NSString *)_replaceUnicode:(NSString *)aUnicodeString {
    
    NSString *tempStr1 = [aUnicodeString stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

// 失败后再次请求
- (void)requestComplete:(id)result succ:(BOOL)succ operation:(MKNetworkOperation *)completedOperation {
	if (!succ) {
		if (_retryCount < kHttpRetryCount) {
			[self sendRequest:_methodType];
			return;
		}
	}

	// 如果成功，存缓存
	if (succ
	    && completedOperation
        && _flag == NWFlagNone) {
        NSString *string = [InputHelper convertToJsonString:completedOperation.readonlyPostDictionary options:YES];
		NSString *key = [[NSString stringWithFormat:@"%@:%@", completedOperation.url, string] md5];
        NSString *resultJson = [InputHelper convertToJsonString:result options:YES];
        if (resultJson) {
            [DataBaseServer insertCache:key value:resultJson];
        }
        
		
	}

    _isCache = NO;
	[self dealComplete:result succ:succ];
}

- (void)dealComplete:(id)result succ:(BOOL)succ {
	[self doesNotRecognizeSelector:_cmd];
}

- (void)startRequest {
	[self doesNotRecognizeSelector:_cmd];
}

- (void)startRequestWithCache:(CacheType)type {
	[self doesNotRecognizeSelector:_cmd];
}

- (void)startRequestWithParams:(NSDictionary *)params {
	[self doesNotRecognizeSelector:_cmd];
}


- (void)cancel {
    [MKNetworkEngine cancelOperationsContainingURLString:self.path];
}


+ (void)cancelAllOperations {
	[_businessEngine cancelAllOperations];
    [_testEngine cancelAllOperations];
}

+ (void)cancelLogin
{
    [MKNetworkEngine cancelOperationsContainingURLString:@"auth/login"];
}

@end
