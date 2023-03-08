//
//  CFYNetworkTaskManager.m
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import <CFYNetworking/CFYNetworkTaskManager.h>
#import <AFNetworking/AFNetworking.h>
#import <CFYNetworking/CFYNetworkServiceProtocol.h>

@interface CFYNetworkTaskManager ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, CFYNetworkURLSessionTask *> *taskMap;

@end

@implementation CFYNetworkTaskManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static  CFYNetworkTaskManager*instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

#pragma mark - Public Method
///创建请求task
- (CFYNetworkURLSessionTask *)dataTaskWithRequest:(id<CFYNetworkHTTPRequest>)request
                                          success:(CFYNetworkCallback)success
                                             fail:(CFYNetworkCallback)fail {
    
    __block NSURLSessionDataTask *dataTask = nil;
    __block NSURLRequest *urlRequest = request.urlRequest;
    AFURLSessionManager *sessionManager = [self sessionManagerWithService:request.service];
    dataTask = [sessionManager dataTaskWithRequest:request.urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //移除task
        NSNumber *requestID = @([dataTask taskIdentifier]);
        if (requestID) {
            [self.taskMap removeObjectForKey:requestID];
        }
        //处理数据
        NSDictionary *result = [request.service handleResponse:response responseObject:responseObject request:urlRequest error:&error];
        CFYNetworkBaseResponse *handleResponse = [[CFYNetworkBaseResponse alloc] initWithResponseObject:result requestId:requestID request:urlRequest error:error];
        if (error) {
            if (fail) {
                fail(handleResponse);
            }
        } else {
            if (success) {
                success(handleResponse);
            }
        }
    }];
    if (!dataTask) {
        NSCAssert(NO, @"dataTask创建失败");
        return nil;
    }
    CFYNetworkURLSessionTask *sessionTask = [[CFYNetworkURLSessionTask alloc] initWithDataTask:dataTask];
    [self.taskMap setObject:sessionTask forKey:sessionTask.taskIdentifier];
    return sessionTask;
}

///取消请求
- (void)cancelRequestWithRequestID:(NSNumber *)requestID {
    if (!requestID) {
        NSCParameterAssert(NO);
        return;
    }
    CFYNetworkURLSessionTask *task = [self.taskMap objectForKey:requestID];
    [task cancel];
    [self.taskMap removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDList {
    for (NSNumber *requestID in requestIDList) {
        [self cancelRequestWithRequestID:requestID];
    }
}

#pragma mark - Private Method
- (AFURLSessionManager *)sessionManagerWithService:(id<CFYNetworkServiceProtocol>)service {
    AFURLSessionManager *sessionManager = nil;
    if ([service respondsToSelector:@selector(sessionManager)]) {
        sessionManager = service.sessionManager;
    }
    if (sessionManager == nil) {
        sessionManager = [AFHTTPSessionManager manager];
    }
    return sessionManager;
}

#pragma mark - Getter
- (NSMutableDictionary<NSNumber *,CFYNetworkURLSessionTask *> *)taskMap {
    if (!_taskMap) {
        _taskMap = [NSMutableDictionary dictionary];
    }
    return _taskMap;
}

@end
