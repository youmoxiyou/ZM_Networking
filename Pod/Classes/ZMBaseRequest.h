//
//  ZMBaseRequest.h
//  Pods
//
//  Created by Abe on 16/4/18.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZMHttpMethod) {
    ZMHttpMethodGet,
    ZMHttpMethodPost,
    ZMHttpMethodHead,
    ZMHttpMethodPut,
    ZMHttpMethodDelete,
    ZMHttpMethodPatch,
};

typedef NS_ENUM(NSInteger , ZMRequestSerializerType) {
    ZMRequestSerializerTypeHTTP = 0,
    ZMRequestSerializerTypeJSON,
};

typedef NS_ENUM(NSInteger , ZMResponseSerializerType) {
    ZMResponseSerializerTypeHTTP = 0,
    ZMResponseSerializerTypeJSON,
};

typedef void(^AFConstructingBlock)(id<AFMultipartFormData> formData);

typedef void(^AFURLSessionDataTaskDidReceiveDataBlock)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data);
typedef NSURLSessionResponseDisposition (^AFURLSessionDataTaskDidReceiveResponseBlock)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLResponse *response);
typedef void (^AFURLSessionTaskProgressBlock)(NSProgress *);

@protocol ZMRequestDelegate;

@interface ZMBaseRequest : NSObject

/// Tag
@property (nonatomic) NSInteger tag;

/// User info
@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, strong) NSURLSessionTask *sessionTask;

/// request delegate object
@property (nonatomic, weak) id<ZMRequestDelegate> delegate;


@property (nonatomic, strong, readonly) NSDictionary *responseHeaders;

@property (nonatomic, strong, readonly) NSString *responseString;

@property (nonatomic, strong, readonly) id responseJSONObject;

//@property (nonatomic, readonly) NSInteger responseStatusCode;
//
//@property (nonatomic, copy) void (^successCompletionBlock)(ZMBaseRequest *);
//
//@property (nonatomic, copy) void (^failureCompletionBlock)(ZMBaseRequest *);
//
//@property (nonatomic, strong) NSMutableArray *requestAccessories;

/// append self to request queue
- (void)start;

/// remove self from request queue
- (void)stop;

/// pause self
- (void)pause;

//TODO: block 回调 start

//TODO: block 回调 stop

/// 把block置nil来打破循环引用
- (void)clearCompletionBlock;

/// 以下方法由子类继承来覆盖默认值

/// 请求的URL
- (NSString *)requestUrl;

/// 请求的CdnURL
- (NSString *)cdnUrl;

/// 请求的BaseURL
- (NSString *)baseUrl;

/// 请求的连接超时时间，默认为60秒
- (NSTimeInterval)requestTimeoutInterval;

/// 请求的参数列表
- (id)requestArgument;

- (ZMHttpMethod)requestMethod;

/// 请求的SerializerType
- (ZMRequestSerializerType)requestSerializerType;

/// 响应的SerializerType
- (ZMResponseSerializerType)responseSerializerType;

/// 请求的Server用户名和密码
- (NSArray *)requestAuthorizationHeaderFieldArray;

/// 在HTTP报头添加的自定义参数
- (NSDictionary *)requestHeaderFieldValueDictionary;

/// 构建自定义的UrlRequest，
/// 若这个方法返回非nil对象，会忽略requestUrl, requestArgument, requestMethod, requestSerializerType
- (NSURLRequest *)buildCustomUrlRequest;

/// 是否使用CDN的host地址
- (BOOL)useCDN;

- (AFConstructingBlock)constructingBodyBlock;

/// 下载路径
- (NSString *)resumableDownloadPath;

- (AFURLSessionDataTaskDidReceiveDataBlock)dataTaskDidReceiveDataBlock;

- (AFURLSessionDataTaskDidReceiveResponseBlock)dataTaskReceiveResponseBlock;

- (AFURLSessionTaskProgressBlock)uploadProgressBlock;

- (AFURLSessionTaskProgressBlock)downloadProgressBlock;

@end

@protocol ZMRequestDelegate <NSObject>

- (void)requestFinished:(ZMBaseRequest *)request;
- (void)requestFailed:(ZMBaseRequest *)request;

@optional
- (void)clearRequest;

@end

