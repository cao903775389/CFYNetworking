//
//  CFYNetworkTaskManager.h
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import <Foundation/Foundation.h>
#import <CFYNetworking/CFYNetworkURLSessionTask.h>
#import <CFYNetworking/CFYNetworkBaseResponse.h>
#import <CFYNetworking/CFYNetworkHTTPRequest.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CFYNetworkCallback)(CFYNetworkBaseResponse *response);

@interface CFYNetworkTaskManager : NSObject

+ (instancetype)sharedInstance;

///创建请求task
- (CFYNetworkURLSessionTask *)dataTaskWithRequest:(id<CFYNetworkHTTPRequest>)request
                                          success:(CFYNetworkCallback)success
                                             fail:(CFYNetworkCallback)fail;

///取消请求
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDList;

@end

NS_ASSUME_NONNULL_END
