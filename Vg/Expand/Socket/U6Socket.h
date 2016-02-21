//
//  U6Socket.h
//  Hello320
//
//  Created by wwb on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AsyncSocket.h"

@class U6Socket;

/**
	Socket异常
 */
typedef enum{
	U6SocketErrorUncompressDataError,	/**< 解压数据异常 */
	U6SocketErrorNotConnected			/**< 尚未链接 */
}U6SocketError;


@protocol U6SocketDelegate <NSObject>

//安全连接事件
- (void) onSocketSecureConnected:(U6Socket*)socket;

//连接事件
- (void) onSocketConnected:(U6Socket*)socket;

/**
	重连事件
	@param socket Socket对象
 */
- (void)onSocketReconnected:(U6Socket *)socket;


//数据接收事件
- (void) onSocketDataReceived:(U6Socket*)socket;
//链接关闭事件
- (void) onSocketDisconnected:(U6Socket *)socket;
//数据发送事件
- (void) onSocketDataSent:(U6Socket *)socket tag:(NSNumber *)tag;
//异常事件
- (void) onSocketError:(U6Socket *)socket error:(NSError *)error;

@end


@interface U6Socket : NSObject {	
    id <U6SocketDelegate> _delegate;
	
	AsyncSocket *asynSocket;   //异步套接口
	
	NSString  *strServer;      //服务器地址
	NSInteger iPort;                 //服务器端口
	
	NSTimer *_hbTimer;	       //心跳定时器
	int     counterRC;         //重连计数器
	int     counterHB;         //心跳计数器   
	int     iStatus;           //状态  0:未连接   1:正在连接   2:已连接  
	NSData  *dataHB;           //心跳协议包	
	
	int nMsgId;                //最近接收到的服务器推送过来的MessageId
	NSString* strMsgContent;   //最近接收到的服务器推送过来的Message内容
	
	/**
	 错误标识，表示在连接过程中是否存在异常，
	 主要用于判断Socket是正常断开还是异常断开,如果异常断开则立即重连，否则由心跳负责重连
	 **/
	BOOL	hasError;
	
	/**
	 重连标识，标识当前连接是否与服务器进行重新连接。
	 **/
	BOOL	isReconnect;
	
	/**
	 压缩数据标识,如果接收的数据标识为压缩数据则此标识值为YES，否则为NO。
	 **/
	BOOL    isCompressData;


    NSMutableData *serverErrorData;
}

@property(nonatomic, assign) int nMsgId;
@property(nonatomic, retain) NSString *strMsgContent;
@property(nonatomic) BOOL isReconnect;
@property (nonatomic, assign) id<U6SocketDelegate> delegate;

@property (nonatomic, assign) BOOL shouldReconnect;

/**
	初始化Socket对象
	@param dele 委托对象，用于委托Socket对象的相应事件
	@param ta Socket标识
	@param onServerConnected 服务器连接事件处理器
	@param onServerReconnected 服务器重连事件处理器
	@param onDataReceived 数据接收事件处理器
	@param onDataSent 数据发送事件处理器
	@param onServerDisconnected 服务器断开链接事件处理器
	@param onServerError 服务器异常事件处理器
	@returns Socket对象
 */
- (id) initWithDelegate:(id<U6SocketDelegate>)dele;


/**
	连接服务器
	@param server 服务器地址
	@param port 服务器端口
 */
-(void) connectServer:(NSString*)server
				 Port:(NSInteger)port;


-(void) startHB:(NSData*)data;   //开始心跳
-(void) sendData:(NSData*)data tag:(NSInteger)tag;  //发送数据
-(void) disconnectServer;        //断开服务器
-(void) reconnectServer;		 //重连服务器

@end
