//
//  CFYNetworkRequest.h
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import <Foundation/Foundation.h>
#import <CFYNetworking/CFYNetworkHTTPRequest.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFYNetworkHTTPRequest : NSObject <CFYNetworkHTTPRequest>

@end

@interface CFYNetworkGetRequest : CFYNetworkHTTPRequest

@end

@interface CFYNetworkPostRequest : CFYNetworkHTTPRequest

@end

@interface CFYNetworkPutRequest : CFYNetworkHTTPRequest

@end

@interface CFYNetworkDeleteRequest : CFYNetworkHTTPRequest

@end

@interface CFYNetworkHTTPRequest (Convenient)

+ (CFYNetworkHTTPRequest *)requestWithType:(CFYNetworkRequestType)requestType;

@end

NS_ASSUME_NONNULL_END
