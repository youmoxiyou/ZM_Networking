//
//  ZMNetworkAgent.m
//  Pods
//
//  Created by Abe on 16/4/18.
//
//

#import "ZMNetworkAgent.h"
#import "AFNetworking.h"

#import "ZMNetworkConfig.h"
#import "ZMBaseRequest.h"

void ZMLog(NSString *format, ...) {
#ifdef DEBUG
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}

typedef void(^ZMSuccessBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
typedef void(^ZMFailureBlock)(NSURLSessionDataTask * _Nonnull task, NSError * _Nullable error);

@interface ZMNetworkAgent ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) ZMNetworkConfig *config;
@property (nonatomic, strong) NSMutableDictionary *requestsRecord;

@end

@implementation ZMNetworkAgent

#pragma mark - Life Cycle
+ (instancetype)sharedInstance {
    static ZMNetworkAgent *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _manager = [AFHTTPSessionManager manager];
        _config = [ZMNetworkConfig sharedInstance];
        _requestsRecord = [NSMutableDictionary dictionary];
    }
    return self;
}



- (void)addRequest:(ZMBaseRequest *)request {
    ZMHttpMethod method = [request requestMethod];
    id param = [request requestArgument];
    NSString *url = [self buildRequestUrl:request];
    
    AFConstructingBlock constructingBlock = [request constructingBodyBlock];
    AFURLSessionTaskProgressBlock uploadProgressBlock = [request uploadProgressBlock];
    AFURLSessionTaskProgressBlock downloadProgressBlock = [request downloadProgressBlock];
    
    if (request.requestSerializerType == ZMRequestSerializerTypeHTTP) {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    if (request.responseSerializerType == ZMResponseSerializerTypeHTTP) {
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    } else {
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    
    _manager.requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    
    NSArray *authorizationHeaderFieldArray = [request requestAuthorizationHeaderFieldArray];
    if (authorizationHeaderFieldArray != nil) {
        [_manager.requestSerializer
         setAuthorizationHeaderFieldWithUsername:authorizationHeaderFieldArray.firstObject
         password:authorizationHeaderFieldArray.lastObject];
    }
    
    NSDictionary *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    if (headerFieldValueDictionary != nil) {
        for (id httpHeaderField in headerFieldValueDictionary.allKeys) {
            id value = headerFieldValueDictionary[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [_manager.requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
            } else {
                ZMLog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
            }
        }
    }
    
    
    if ([request buildCustomUrlRequest]) {
        ZMSuccessBlock successBlock = [self successBlock];
        ZMFailureBlock failureBlock = [self failureBlock];
        NSURLRequest *customUrlRequest = [request buildCustomUrlRequest];
        __block NSURLSessionDataTask *dataTask = nil;
        dataTask = [_manager dataTaskWithRequest:customUrlRequest
                                  uploadProgress:uploadProgressBlock
                                downloadProgress:downloadProgressBlock
                               completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                   if (error) {
                                       failureBlock(dataTask, error);
                                   }
                                   else {
                                       successBlock(dataTask, responseObject);
                                   }
                               }];
        request.sessionTask = dataTask;
        [dataTask resume];
    } else {
        if (method == ZMHttpMethodGet) {
            if ([request resumableDownloadPath]) {
                [_manager setDataTaskDidReceiveDataBlock:[request dataTaskDidReceiveDataBlock]];
                [_manager setDataTaskDidReceiveResponseBlock:[request dataTaskReceiveResponseBlock]];
                request.sessionTask = [_manager GET:url parameters:param
                                           progress:downloadProgressBlock
                                            success:[self successBlock]
                                            failure:[self failureBlock]
                                       ];
            } else {
                request.sessionTask = [_manager GET:url parameters:param
                                           progress:downloadProgressBlock
                                            success:[self successBlock]
                                            failure:[self failureBlock]
                                       ];
            }
        } else if (method == ZMHttpMethodPost) {
            if (constructingBlock != nil) {
                request.sessionTask = [_manager POST:url parameters:param
                           constructingBodyWithBlock:constructingBlock
                                            progress:uploadProgressBlock
                                             success:[self successBlock]
                                             failure:[self failureBlock]
                                       ];
            } else {
                request.sessionTask = [_manager POST:url parameters:param
                                            progress:uploadProgressBlock
                                             success:[self successBlock]
                                             failure:[self failureBlock]
                                       ];
            }
        } else if (method == ZMHttpMethodHead) {
            
        } else if (method == ZMHttpMethodPut) {
            
        } else if (method == ZMHttpMethodDelete) {
            
        } else if (method == ZMHttpMethodPatch) {
            
        }
    }
    ZMLog(@"Add request: %@", NSStringFromClass([request class]));
    [self addSessionTask:request];
}

- (void)suspendsRequest:(ZMBaseRequest *)request {
    [request.sessionTask suspend];
}

- (void)suspendsAllRequest {
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        ZMBaseRequest *request = copyRecord[key];
        [request pause];
    }
}

- (void)cancleRequest:(ZMBaseRequest *)request {
    [request.sessionTask cancel];
    [self removeSessionTask:request.sessionTask];
    [request clearCompletionBlock];
}

- (void)cancleAllRequest {
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        ZMBaseRequest *request = copyRecord[key];
        [request stop];
    }
}

- (ZMSuccessBlock)successBlock {
    return ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *key = @(task.taskIdentifier).stringValue;
        ZMBaseRequest *request = _requestsRecord[key];
        request.responseObject = responseObject;
        if (request.delegate != nil) {
            [request.delegate requestFinished:request];
        }
        //TODO: Block Callback
        //TODO: Clear Block
        [self removeSessionTask:task];
    };
}

- (ZMFailureBlock)failureBlock {
    return ^(NSURLSessionDataTask * _Nonnull task, NSError * _Nullable error) {
        NSString *key = @(task.taskIdentifier).stringValue;
        ZMBaseRequest *request = _requestsRecord[key];
        request.error = error;
        if (request.delegate != nil) {
            [request.delegate requestFailed:request];
        }
        //TODO: Block Callback
        //TODO: Clear Block
        
        [self removeSessionTask:task];
    };
}

- (void)addSessionTask:(ZMBaseRequest *)request {
    if (request.sessionTask != nil) {
        NSString *key = @(request.sessionTask.taskIdentifier).stringValue;
        @synchronized (self) {
            _requestsRecord[key] = request;
        }
    }
}

- (void)removeSessionTask:(NSURLSessionTask *)sessionTask {
    NSString *key = @(sessionTask.taskIdentifier).stringValue;
    @synchronized (self) {
        [_requestsRecord removeObjectForKey:key];
    }
    ZMLog(@"Request queue size = %lu", (unsigned long)[_requestsRecord count]);
}

- (NSString *)buildRequestUrl:(ZMBaseRequest *)request {
    NSString *detailUrl = [request requestUrl];
    if ([detailUrl hasPrefix:@"http"]) {
        return detailUrl;
    }
    
    //TODO: filter url
    
    NSString *baseUrl;
    if ([request useCDN]) {
        if ([request cdnUrl].length > 0) {
            baseUrl = [request cdnUrl];
        } else {
            baseUrl = [_config cdnUrl];
        }
    } else {
        if ([request baseUrl].length > 0) {
            baseUrl = [request baseUrl];
        } else {
            baseUrl = [_config baseUrl];
        }
    }
    return [NSString stringWithFormat:@"%@%@", baseUrl, detailUrl];
}
@end
