//
//  U6Socket.m
//  Hello320
//
//  Created by wwb on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "U6Socket.h"

#define U6SocketErrorDomain @"U6SocketErrorDomain"

@interface U6Socket ()


{
    BOOL _bHasSecure;
}

@end

@implementation U6Socket

@synthesize nMsgId;
@synthesize strMsgContent;
@synthesize isReconnect;
@synthesize delegate = _delegate;


- (id) initWithDelegate:(id)dele
{
	if (self = [super init]) {
		_delegate = dele;
		
		asynSocket = [[AsyncSocket alloc] initWithDelegate:self];

		strServer=nil;
		iPort = 0;
		_hbTimer = NULL;
		counterRC = 0;
		counterHB = 0;
		iStatus = 0;
		
		isReconnect=NO;
        _shouldReconnect = YES;
		
	}
	return self;
}

- (void)dealloc
{
    [_hbTimer invalidate];_hbTimer = nil;
    [dataHB release];dataHB = nil;
    [strServer release];strServer = nil;
	[asynSocket release];asynSocket = nil;
    [strMsgContent release];strMsgContent = nil;
    [super dealloc];
}

-(void) startHB:(NSData*)data {
	//保存心跳协议包
    [data retain];
    [dataHB release];dataHB = nil;
	dataHB = data;
	
	//启动心跳定时器
	if (_hbTimer)
    {
		[_hbTimer invalidate];
		_hbTimer = nil;
	}
	counterHB = 0;
	_hbTimer = [NSTimer scheduledTimerWithTimeInterval:8
											  target:self 
											selector:@selector(onTimer1) 
											userInfo:nil 
											 repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:_hbTimer forMode:NSRunLoopCommonModes];
}

- (void) onTimer1 {
	counterHB++;
	
    if (_bHasSecure) {
        //发送服务器心跳协议包
        [self sendData:dataHB tag:0];
    }
	
	if (counterHB > 3 || iStatus == 0) {  //已断线
		[self reconnectServer];

	}
}

- (void)connectServer:(NSString*)server Port:(NSInteger)port
{
    [server retain];
    [strServer release];strServer = nil;
	strServer = server;

	iPort = port;
	
	if ([asynSocket isConnected]) {
		hasError=NO;
		asynSocket.delegate=nil;
		[asynSocket disconnect];
		[asynSocket release];
		asynSocket = [[AsyncSocket alloc] initWithDelegate:self];
	}
		
	@try {
		NSError *err = nil;
        // 2.2.0 提升速度做了这个更改
		if ([asynSocket connectToHost:[[NSUserDefaults standardUserDefaults] objectForKey:@"host"] onPort:[[[NSUserDefaults standardUserDefaults] objectForKey:@"port"] integerValue] error:&err]) {
            _bHasSecure = NO;
			iStatus = 1;  //正在连接		
		}
        // ssl加密连接
//        NSString *validatesCertificateChain = (__bridge NSString *)kCFStreamSSLValidatesCertificateChain;
//        NSDictionary *options = @{
//                                  validatesCertificateChain:@0
//                                  };
//        [asynSocket startTLS:options];
//         NSMutableDictionary *SSLOptions = [[NSMutableDictionary alloc] init];
//         [SSLOptions setValue:[NSNumber numberWithBool:NO] forKey:(__bridge id)kCFStreamSSLValidatesCertificateChain];
//        [SSLOptions setValue:(__bridge id)kCFStreamSocketSecurityLevelNone forKey:(__bridge id)kCFStreamSSLLevel];
//        [asynSocket startTLS:SSLOptions];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  (id)kCFStreamSocketSecurityLevelNegotiatedSSL, kCFStreamPropertySocketSecurityLevel,
                                  [NSNumber numberWithBool:YES], kCFStreamSSLAllowsExpiredCertificates,
                                  [NSNumber numberWithBool:YES], kCFStreamSSLAllowsExpiredRoots,
                                  [NSNumber numberWithBool:NO], kCFStreamSSLValidatesCertificateChain,nil];
#pragma clang diagnostic pop
        [asynSocket startTLS:settings];
	}
	@catch (NSException * e) {
		//派发委托
		if ([_delegate conformsToProtocol:@protocol(U6SocketDelegate)] && [_delegate respondsToSelector:@selector(onSocketError:error:)]) {
			[_delegate onSocketError:self
                              error:[NSError errorWithDomain:AsyncSocketErrorDomain code:AsyncSocketIsConnectedError userInfo:[e userInfo]]];
		}
	}
	@finally {
	}

}

-(void) reconnectServer {
	if (iStatus == 1) {  //正在连接
		return;
	}
    NSLog(@"socket准备重连");
	if ([asynSocket isConnected]) {
		hasError=YES;
		asynSocket.delegate=nil;
		[asynSocket disconnect];
        NSLog(@"socket断开就连接");
		[asynSocket release];
		asynSocket = [[AsyncSocket alloc] initWithDelegate:self];
	}
	
	//重连
	isReconnect=YES;
	
	@try {
		NSError *err = nil;
		if ([asynSocket connectToHost:[[NSUserDefaults standardUserDefaults] objectForKey:@"host"] onPort:[[[NSUserDefaults standardUserDefaults] objectForKey:@"port"] integerValue] error:&err]) {
            _bHasSecure = NO;
			iStatus = 1;  //正在连接
            NSLog(@"socket开始重连");
		}
        // ssl加密
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  (id)kCFStreamSocketSecurityLevelNegotiatedSSL, kCFStreamPropertySocketSecurityLevel,
                                  [NSNumber numberWithBool:YES], kCFStreamSSLAllowsExpiredCertificates,
                                  [NSNumber numberWithBool:YES], kCFStreamSSLAllowsExpiredRoots,
                                  [NSNumber numberWithBool:NO], kCFStreamSSLValidatesCertificateChain,nil];
#pragma clang diagnostic pop
        [asynSocket startTLS:settings];
	}
	@catch (NSException * e) {
		//派发委托
		if ([_delegate conformsToProtocol:@protocol(U6SocketDelegate)] && [_delegate respondsToSelector:@selector(onSocketError:error:)]) {
			[_delegate onSocketError:self error:[NSError errorWithDomain:AsyncSocketErrorDomain code:AsyncSocketIsConnectedError userInfo:[e userInfo]]];
		}
	}
	@finally {
	}
	
	counterRC++; //重连次数加1
}

-(void) sendData:(NSData*)data tag:(NSInteger)tag
{
	if ([asynSocket isConnected])
	{
        NSData *comData = data;
//        NSLog(@" fasong  %@", [[NSString alloc] initWithData:[NSData dataUncompressGZipData:comData] encoding:NSUTF8StringEncoding]);
		//发送数据至服务器
		[asynSocket writeData:comData withTimeout:-1 tag:tag];
	} else {
		//报告尚未连接服务器
		if ([_delegate conformsToProtocol:@protocol(U6SocketDelegate)]
			&& [_delegate respondsToSelector:@selector(onSocketError:error:)])
		{
			[_delegate onSocketError:self
							  error:[NSError errorWithDomain:AsyncSocketErrorDomain 
														code:U6SocketErrorNotConnected 
													userInfo:nil]];
		}
	}
}

-(void) disconnectServer {
	//主动断开连接
	if ([asynSocket isConnected]) {
		[asynSocket disconnect];
		asynSocket.delegate=nil;
		[asynSocket release];
		asynSocket = [[AsyncSocket alloc] initWithDelegate:self];
	}
	
	iStatus = 0; //已断开
	isReconnect=NO;
	
	if (_hbTimer) {
		[_hbTimer invalidate];
		_hbTimer = nil;
	}
}

#pragma mark -  asyn delegate

- (BOOL)onSocketWillConnect:(AsyncSocket *)sock {
	return YES;
}

- (void)onSocketDidSecure:(AsyncSocket *)sock{
    
    iStatus = 2;   //当前状态为已连接
    counterRC = 0; //重连计数器清0
    counterHB = 0; // 心跳计数器清零 by lucas
    _bHasSecure = YES;
    
    if (isReconnect)
    {
        if ([_delegate conformsToProtocol:@protocol(U6SocketDelegate)] &&
            [_delegate respondsToSelector:@selector(onSocketReconnected:)])
        {
            [_delegate onSocketReconnected:self];
        }
    }
    
    if ([_delegate conformsToProtocol:@protocol(U6SocketDelegate)] &&
        [_delegate respondsToSelector:@selector(onSocketSecureConnected:)])
    {
        [_delegate onSocketSecureConnected:self];
    }
    
    
    //准备接收消息
    [asynSocket readDataWithTimeout:-1 tag:1];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
//	iStatus = 2;   //当前状态为已连接
//	counterRC = 0; //重连计数器清0	
//	
//	if (isReconnect)
//	{
//		if ([delegate conformsToProtocol:@protocol(U6SocketDelegate)] &&
//			[delegate respondsToSelector:@selector(onSocketReconnected:)])
//		{
//			[delegate onSocketReconnected:self];
//		}
//	}
//	else
//	{
//		if ([delegate conformsToProtocol:@protocol(U6SocketDelegate)] && 
//			[delegate respondsToSelector:@selector(onSocketConnected:)]) 
//		{
//			[delegate onSocketConnected:self];
//		}
//	}
//    
//	//准备接收消息
//	[asynSocket readDataWithTimeout:-1 tag:1];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {	
	counterHB = 0; //心跳计数器清0(只要服务器有响应，说明连接还存活着)
    
    NSData *unComData = data;
    NSString *msg = [[NSString alloc] initWithData:unComData encoding:NSUTF8StringEncoding];
    self.strMsgContent = msg;
    [msg release];
    //向上层报告
    if ([_delegate conformsToProtocol:@protocol(U6SocketDelegate)] && [_delegate respondsToSelector:@selector(onSocketDataReceived:)]) {
        [_delegate onSocketDataReceived:self];
    }
    // 继续读后面的
	[asynSocket readDataWithTimeout:-1 tag:1];

}


- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
	if ([_delegate conformsToProtocol:@protocol(U6SocketDelegate)] && [_delegate respondsToSelector:@selector(onSocketDataSent:tag:)]) {
		[_delegate onSocketDataSent:self tag:[NSNumber numberWithInteger:tag]];
	}
}

- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(CFIndex)partialLength tag:(long)tag {
	
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
	hasError = YES;
	if ([_delegate conformsToProtocol:@protocol(U6SocketDelegate)] && [_delegate respondsToSelector:@selector(onSocketError:error:)]) {
		[_delegate onSocketError:self error:err];
	}
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
	if (iStatus == 0) {
		return;
	}
	
	iStatus = 0; //已断开(未连接)
	
	//报告状态
	if ([_delegate conformsToProtocol:@protocol(U6SocketDelegate)] && [_delegate respondsToSelector:@selector(onSocketDisconnected:)]) {
		[_delegate onSocketDisconnected:self];
	}
	
	if (hasError && counterRC == 0
        && _shouldReconnect) {
		/**
		 异常并且首次断开则延迟一秒立即进行连接
		 **/
		hasError=NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reconnectServer];
        });
		
	}
}

@end
