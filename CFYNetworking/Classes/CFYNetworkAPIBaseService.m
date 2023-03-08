//
//  CFYNetworkAPIBaseService.m
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import "CFYNetworkAPIBaseService.h"
#import <CFYNetworking/CFYNetworkRequest.h>
#import <CFYNetworking/CFYNetworkDefines.h>
#import <CFYNetworking/CFYNetworkBaseResponse.h>
#import <CFYNetworking/CFYNetworkServiceProtocol.h>

@interface CFYNetworkAPIBaseService ()

@property (nonatomic, weak) NSObject<CFYNetworkServiceProtocol> *child;

@end

@implementation CFYNetworkAPIBaseService

- (instancetype)init {
    if (self = [super init]) {
        if ([self conformsToProtocol:@protocol(CFYNetworkServiceProtocol)]) {
            self.child = (id<CFYNetworkServiceProtocol>)self;
        } else {
            NSException *exception = [[NSException alloc] initWithName:@"类型异常" reason:@"子类必须实现CFYNetworkServiceProtocol协议" userInfo:nil];
            @throw exception;
        }
    }
    return self;
}

#pragma mark - method for child
- (id<CFYNetworkHTTPRequest>)requestWithParams:(NSDictionary *)params apiPath:(NSString *)apiPath requestType:(CFYNetworkRequestType)requestType {
    IMP childIMP = [self.child methodForSelector:@selector(requestWithParams:apiPath:requestType:)];
    IMP selfIMP = [self methodForSelector:@selector(requestWithParams:apiPath:requestType:)];
    if (selfIMP != childIMP) {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        CFYNetworkHTTPRequest *request = [self.child requestWithParams:params apiPath:apiPath requestType:requestType];
        return request;
    } else {
        //说明子类没有重写或者返回了一个空
        CFYNetworkHTTPRequest *request = [CFYNetworkHTTPRequest requestWithType:requestType];
        request.apiPath = apiPath;
        request.baseURL = [self.child baseURL];
        request.params = params;
        return request;
    }
}

- (NSDictionary *)handleResponse:(NSURLResponse *)response responseObject:(id)responseObject request:(NSURLRequest *)request error:(NSError *__autoreleasing  _Nullable *)error {
    IMP childIMP = [self.child methodForSelector:@selector(handleResponse:responseObject:request:error:)];
    IMP selfIMP = [self methodForSelector:@selector(handleResponse:responseObject:request:error:)];
    if (selfIMP != childIMP) {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        return [self.child handleResponse:response responseObject:responseObject request:request error:error];
    } else {
        //说明子类没有重写或者返回了一个空
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        if (*error || ![responseObject isKindOfClass:NSDictionary.class]) {
            return result;
        }
        return (NSDictionary *)responseObject;
    }
}

- (BOOL)handleCommonErrorWithResponse:(CFYNetworkBaseResponse *)response manager:(CFYNetworkAPIBaseManager *)manager errorType:(CFYNetworkAPIManagerErrorType)errorType {
    return YES;
}

- (AFHTTPSessionManager *)sessionManager {
    IMP childIMP = [self.child methodForSelector:@selector(sessionManager)];
    IMP selfIMP = [self methodForSelector:@selector(sessionManager)];
    if (selfIMP != childIMP) {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        return [self.child sessionManager];
    } else {
        //说明子类没有重写或者返回了一个空
        AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
        return sessionManager;
    }
}

@end
