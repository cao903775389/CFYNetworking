//
//  CFYNetworkHTTPRequest.h
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import <Foundation/Foundation.h>
#import <CFYNetworking/CFYNetworkDefines.h>
#import <CFYNetworking/CFYNetworkAPIBaseService.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CFYNetworkHTTPRequest <NSObject>

//请求path
@property (nonatomic, copy) NSString *apiPath;
//请求参数
@property (nonatomic, copy, nullable) NSDictionary *params;
//域名路径
@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, weak) CFYNetworkAPIBaseService *service;

- (NSMutableURLRequest *)urlRequest;

@end

NS_ASSUME_NONNULL_END
