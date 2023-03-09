//
//  CFYNetworkRequest.m
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import "CFYNetworkRequest.h"
#import <AFNetworking/AFNetworking.h>

@interface CFYNetworkHTTPRequest ()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation CFYNetworkHTTPRequest

@synthesize apiPath = _apiPath, params = _params, baseURL = _baseURL, service = _service;

- (CFYNetworkRequestType)requestType {
    return CFYNetworkRequestTypePost;
}

- (NSMutableURLRequest *)urlRequest {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.baseURL, self.apiPath];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET"
                                                                       URLString:urlString
                                                                      parameters:self.params
                                                                           error:nil];
    return request;
}

- (AFHTTPRequestSerializer *)httpRequestSerializer {
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        [_httpRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return _httpRequestSerializer;
}

@end


@implementation CFYNetworkGetRequest

- (CFYNetworkRequestType)requestType {
    return CFYNetworkRequestTypeGet;
}

@end

@implementation CFYNetworkPostRequest

- (CFYNetworkRequestType)requestType {
    return CFYNetworkRequestTypePost;
}

@end

@implementation CFYNetworkPutRequest

- (CFYNetworkRequestType)requestType {
    return CFYNetworkRequestTypePut;
}

@end

@implementation CFYNetworkDeleteRequest

- (CFYNetworkRequestType)requestType {
    return CFYNetworkRequestTypeDelete;
}

@end

@implementation CFYNetworkHTTPRequest (Convenient)

+ (CFYNetworkHTTPRequest *)requestWithType:(CFYNetworkRequestType)requestType {
    CFYNetworkHTTPRequest *request = nil;
    switch (requestType) {
        case CFYNetworkRequestTypePost:
            request = [CFYNetworkPostRequest new];
            break;
        case CFYNetworkRequestTypeGet:
            request = [CFYNetworkGetRequest new];
            break;
        case CFYNetworkRequestTypePut:
            request = [CFYNetworkPutRequest new];
            break;
        case CFYNetworkRequestTypeDelete:
            request = [CFYNetworkDeleteRequest new];
            break;
        default:
            break;
    }
    return request;
}

@end
