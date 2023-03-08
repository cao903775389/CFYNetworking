//
//  CFYNetworkBaseResponse.h
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CFYNetworkURLResponseStatus) {
    CFYNetworkURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的CTAPIBaseManager来决定。
    CFYNetworkURLResponseStatusErrorTimeout,
    CFYNetworkURLResponseStatusErrorCancel,
    CFYNetworkURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

@interface CFYNetworkBaseResponse : NSObject

@property (nonatomic, assign, readonly) CFYNetworkURLResponseStatus status;
@property (nonatomic, strong, readonly) NSString *errorMsg;
@property (nonatomic, copy, readonly) NSDictionary *responseObject;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, strong, readonly) NSNumber *requestID;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithResponseObject:(NSDictionary *)responseObject
                             requestId:(NSNumber *)requestId
                               request:(NSURLRequest *)request
                                 error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
