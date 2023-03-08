//
//  CFYNetworkAPIBaseManager.m
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import "CFYNetworkAPIBaseManager.h"
#import <CFYNetworking/CFYNetworkAPIManager.h>
#import <CFYNetworking/CFYNetworkTaskManager.h>
#import <CFYNetworking/CFYNetworkServiceFactory.h>
#import <CFYNetworking/CFYNetworkHTTPRequest.h>
#import <CFYNetworking/CFYNetworkBaseResponse.h>

//没有token，需要登录
 NSString * const kCTUserNeedTokenNotification = @"kCTUserNeedTokenNotification";
//token过期，需要重新登录
 NSString * const kCTUserTokenInvalidNotification = @"kCTUserTokenInvalidNotification";
//userInfo传递的Manager
 NSString * const kCTUserTokenNotificationUserInfoKeyManagerToContinue = @"kCTUserTokenNotificationUserInfoKeyManagerToContinue";

@interface CFYNetworkWeakObjectPlaceHolder : NSObject

@property (nonatomic, weak) id realObject;

@end

@implementation CFYNetworkWeakObjectPlaceHolder

@end

@interface CFYNetworkWeakObjectSet : NSObject

@property (nonatomic, strong) NSMutableArray<CFYNetworkWeakObjectPlaceHolder *> *placeHolderObjectList;

@end

@implementation CFYNetworkWeakObjectSet

- (NSUInteger)count {
    return _placeHolderObjectList.count;
}

- (void)addObject:(id)object {
    if (object) {
        CFYNetworkWeakObjectPlaceHolder *oldObject = nil;
        for (CFYNetworkWeakObjectPlaceHolder *placeHolder in self.placeHolderObjectList) {
            if (placeHolder.realObject == object) {
                oldObject = placeHolder;
                break;
            }
        }
        if (!oldObject) {
            CFYNetworkWeakObjectPlaceHolder *placeHolder = [[CFYNetworkWeakObjectPlaceHolder alloc] init];
            placeHolder.realObject = object;
            [self.placeHolderObjectList addObject:placeHolder];
        }
    }
}

- (void)removeObject:(id)object {
    NSMutableArray *holdersToBeRemoved = [NSMutableArray array];
    for (CFYNetworkWeakObjectPlaceHolder *holder in _placeHolderObjectList) {
        if (!holder.realObject || object == holder.realObject) {
            [holdersToBeRemoved addObject:holder];
        }
    }
    [_placeHolderObjectList removeObjectsInArray:holdersToBeRemoved];
}

- (void)removeAllObjects {
    [self.placeHolderObjectList removeAllObjects];
}

- (NSArray *)objectsArray {
    NSMutableArray *holdersToBeRemoved = [NSMutableArray array];
    NSMutableArray *result = [NSMutableArray array];
    for (CFYNetworkWeakObjectPlaceHolder *holder in _placeHolderObjectList) {
        id realObject = holder.realObject;
        if (!realObject) {
            [holdersToBeRemoved addObject:holder];
        }
        else {
            [result addObject:realObject];
        }
    }
    [_placeHolderObjectList removeObjectsInArray:holdersToBeRemoved];
    return [NSArray arrayWithArray:result];
}

- (BOOL)containsObject:(id)object {
    if (object) {
        CFYNetworkWeakObjectPlaceHolder *oldHolder;
        for (CFYNetworkWeakObjectPlaceHolder *holder in _placeHolderObjectList) {
            if (holder.realObject == object) {
                oldHolder = holder;
                break;
            }
        }
        return oldHolder != nil;
    }
    return NO;
}

- (NSMutableArray<CFYNetworkWeakObjectPlaceHolder *> *)placeHolderObjectList {
    if (!_placeHolderObjectList) {
        _placeHolderObjectList = [NSMutableArray array];
    }
    return _placeHolderObjectList;
}

@end

@interface CFYNetworkAPIBaseManager ()

@property (nonatomic, weak) NSObject<CFYNetworkAPIManager> *child;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, strong) CFYNetworkWeakObjectSet *delegateArray;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *requestIdList;
@property (nonatomic, strong, readwrite) CFYNetworkBaseResponse * _Nonnull response;
@property (nonatomic, assign, readwrite) CFYNetworkAPIManagerErrorType errorType;
@property (nonatomic, copy, readwrite, nullable) NSString * _Nullable errorMsg;

@end

@implementation CFYNetworkAPIBaseManager

- (void)dealloc {
    [self cancelAllRequests];
    self.requestIdList = nil;
}

- (instancetype)init {
    if (self = [super init]) {
        if ([self conformsToProtocol:@protocol(CFYNetworkAPIManager)]) {
            self.child = (id<CFYNetworkAPIManager>)self;
        } else {
            NSException *exception = [[NSException alloc] initWithName:@"类型异常" reason:@"子类必须实现CFYNetworkAPIManager协议" userInfo:nil];
            @throw exception;
        }
        _delegateArray = [[CFYNetworkWeakObjectSet alloc] init];
    }
    return self;
}

//delegate
- (void)addDelegate:(id<CFYNetworkAPIManagerDelegate>)delegate {
    [self.delegateArray addObject:delegate];
}

- (void)removeDelegate:(id<CFYNetworkAPIManagerDelegate>)delegate {
    [self.delegateArray removeObject:delegate];
}

#pragma mark - Public Method
// start
- (void)loadData {
    [self loadDataWithParams:nil];
}

- (void)loadDataWithParams:(NSDictionary *)params {
    //初始化参数
    NSDictionary *reformParams = [self reformParams:params] ?: @{};
    
    CFYNetworkAPIManagerErrorType errorType = [self.validator manager:self isCorrectWithParamsData:reformParams];
    if (errorType != CFYNetworkAPIManagerErrorTypeNoError) {
        //请求参数校验失败
        [self failedOnCallingAPI:nil withErrorType:errorType];
        return;
    }
    
    //初始化service
    id<CFYNetworkServiceProtocol> service = [[CFYNetworkServiceFactory sharedInstance] serviceWithIdentifier:self.child.serviceIdentifier];
    //创建request
    id<CFYNetworkHTTPRequest> request = [service requestWithParams:reformParams apiPath:self.child.apiPath requestType:self.child.requestType];
    
    self.isLoading = YES;
    CFYNetworkURLSessionTask *task = [[CFYNetworkTaskManager sharedInstance] dataTaskWithRequest:request success:^(CFYNetworkBaseResponse * _Nonnull response) {
        [self successedOnCallingAPI:response];
    } fail:^(CFYNetworkBaseResponse * _Nonnull response) {
        [self failedOnCallingAPI:response];
    }];
    [task resume];
    [self.requestIdList addObject:task.taskIdentifier];
}

// cancel
- (void)cancelAllRequests {
    [[CFYNetworkTaskManager sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSNumber *)requestID {
    [self removeRequestIdWithRequestID:requestID];
    [[CFYNetworkTaskManager sharedInstance] cancelRequestWithRequestID:requestID];
}

- (BOOL)isLoading {
  if (self.requestIdList.count == 0) {
      _isLoading = NO;
  }
  return _isLoading;
}
                                      
#pragma mark - method for child
//如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
//子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
- (NSDictionary *_Nullable)reformParams:(NSDictionary *_Nullable)params {
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    if (selfIMP == childIMP) {
        //说明子类没有重写
        return params;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

#pragma mark - api callbacks
- (void)successedOnCallingAPI:(CFYNetworkBaseResponse *)response {
    self.isLoading = NO;
    self.response = response;
    [self removeRequestIdWithRequestID:response.requestID];
    CFYNetworkAPIManagerErrorType errorType = [self.validator manager:self isCorrectWithCallBackData:response.responseObject];
    if (errorType == CFYNetworkAPIManagerErrorTypeNoError) {
        self.errorType = CFYNetworkAPIManagerErrorTypeSuccess;
        dispatch_async(dispatch_get_main_queue(), ^{
            //外部回调处理
            [self.delegateArray performSelector:@selector(managerCallAPIDidSuccess:) withObject:self];
        });
    } else {
        [self failedOnCallingAPI:response withErrorType:errorType];
    }
}

- (void)failedOnCallingAPI:(CFYNetworkBaseResponse *)response {
    CFYNetworkAPIManagerErrorType errorType = CFYNetworkAPIManagerErrorTypeDefault;
    if (response.status == CFYNetworkURLResponseStatusErrorCancel) {
        errorType = CFYNetworkAPIManagerErrorTypeCanceled;
    }
    if (response.status == CFYNetworkURLResponseStatusErrorTimeout) {
        errorType = CFYNetworkAPIManagerErrorTypeTimeout;
    }
    if (response.status == CFYNetworkURLResponseStatusErrorNoNetwork) {
        errorType = CFYNetworkAPIManagerErrorTypeNoNetWork;
    }
    [self failedOnCallingAPI:response withErrorType:errorType];
}

- (void)failedOnCallingAPI:(CFYNetworkBaseResponse *)response withErrorType:(CFYNetworkAPIManagerErrorType)errorType {
    self.isLoading = NO;
    if (response) {
        self.response = response;
    }
    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestID];
    
    if (errorType == CFYNetworkAPIManagerErrorTypeNeedLogin) {
        //发通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kCTUserNeedTokenNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kCTUserTokenNotificationUserInfoKeyManagerToContinue:self
                                                                     }];
        return;
    }
    if (errorType == CFYNetworkAPIManagerErrorTypeAccessTokenInvalid) {
        //发通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kCTUserTokenInvalidNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     kCTUserTokenNotificationUserInfoKeyManagerToContinue:self
                                                                     }];
        return;
    }
    
    id<CFYNetworkServiceProtocol> service = [[CFYNetworkServiceFactory sharedInstance] serviceWithIdentifier:self.child.serviceIdentifier];
    BOOL shouldContinue = [service handleCommonErrorWithResponse:response manager:self errorType:errorType];
    if (shouldContinue == NO) {
        return;
    }
    // 常规错误
    if (errorType == CFYNetworkAPIManagerErrorTypeNoNetWork) {
        self.errorMsg = @"无网络连接，请检查网络";
    }
    if (errorType == CFYNetworkAPIManagerErrorTypeTimeout) {
        self.errorMsg = @"请求超时";
    }
    if (errorType == CFYNetworkAPIManagerErrorTypeCanceled) {
        self.errorMsg = @"已取消";
    }

    // 其他错误
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegateArray performSelector:@selector(managerCallAPIDidFailed:) withObject:self];
    });
}
                                      
#pragma mark - Private Method
- (void)removeRequestIdWithRequestID:(NSNumber *)requestId {
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId unsignedIntegerValue] == requestId.unsignedIntegerValue) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

@end
