//
//  CFYNetworkBaseResponse.m
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import "CFYNetworkBaseResponse.h"

@interface CFYNetworkBaseResponse ()

@property (nonatomic, assign, readwrite) CFYNetworkURLResponseStatus status;
@property (nonatomic, strong, readwrite) NSString *errorMsg;
@property (nonatomic, copy, readwrite) NSDictionary *responseObject;
@property (nonatomic, copy, readwrite) NSURLRequest *request;
@property (nonatomic, strong, readwrite) NSNumber *requestID;

@end

@implementation CFYNetworkBaseResponse

- (instancetype)initWithResponseObject:(NSDictionary *)responseObject
                             requestId:(NSNumber *)requestId
                               request:(NSURLRequest *)request
                                 error:(NSError *)error {
    if (self = [super init]) {
        self.requestID = requestId;
        self.request = request;
        self.status = [self responseStatusWithError:error];
        self.responseObject = responseObject ? responseObject : @{};
        self.errorMsg = error.localizedDescription;
    }
    return self;
}

#pragma mark - private methods
- (CFYNetworkURLResponseStatus)responseStatusWithError:(NSError *)error {
    if (error) {
        CFYNetworkURLResponseStatus result = CFYNetworkURLResponseStatusErrorNoNetwork;
        // 除了超时以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            result = CFYNetworkURLResponseStatusErrorTimeout;
        }
        if (error.code == NSURLErrorCancelled) {
            result = CFYNetworkURLResponseStatusErrorCancel;
        }
        if (error.code == NSURLErrorNotConnectedToInternet) {
            result = CFYNetworkURLResponseStatusErrorNoNetwork;
        }
        return result;
    } else {
        return CFYNetworkURLResponseStatusSuccess;
    }
}

@end
