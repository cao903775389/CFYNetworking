//
//  CFYNetworkHTTPRequest.h
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import <Foundation/Foundation.h>
#import <CFYNetworking/CFYNetworkDefines.h>
#import <CFYNetworking/CFYNetworkServiceProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CFYNetworkHTTPRequest <NSObject>

- (CFYNetworkRequestType)requestType;
- (NSURLRequest *)urlRequest;
- (id<CFYNetworkServiceProtocol>)service;

@end

NS_ASSUME_NONNULL_END
