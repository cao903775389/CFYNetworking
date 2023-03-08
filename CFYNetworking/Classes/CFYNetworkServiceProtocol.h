//
//  CFYNetworkServiceProtocol.h
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <CFYNetworking/CFYNetworkDefines.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CFYNetworkHTTPRequest;
@class CFYNetworkBaseResponse;
@class CFYNetworkAPIBaseManager;

@protocol CFYNetworkServiceProtocol <NSObject>

//构造请求
- (id<CFYNetworkHTTPRequest>)requestWithParams:(NSDictionary *)params
                                       apiPath:(NSString *)apiPath
                                   requestType:(CFYNetworkRequestType)requestType;

//处理返回数据
- (NSDictionary *)handleResponse:(NSURLResponse *)response
                  responseObject:(id)responseObject
                         request:(NSURLRequest *)request
                           error:(NSError **)error;

/*
 return true means should continue the error handling process in CTAPIBaseManager
 return false means stop the error handling process
 
 如果检查错误之后，需要继续走fail路径上报到业务层的，return YES。（例如网络错误等，需要业务层弹框）
 如果检查错误之后，不需要继续走fail路径上报到业务层的，return NO。（例如用户token失效，此时挂起API，调用刷新token的API，成功之后再重新调用原来的API。那么这种情况就不需要继续走fail路径上报到业务。）
 */
- (BOOL)handleCommonErrorWithResponse:(CFYNetworkBaseResponse *)response
                              manager:(CFYNetworkAPIBaseManager *)manager
                            errorType:(CFYNetworkAPIManagerErrorType)errorType;

@optional
- (AFHTTPSessionManager *)sessionManager;

@end

NS_ASSUME_NONNULL_END
