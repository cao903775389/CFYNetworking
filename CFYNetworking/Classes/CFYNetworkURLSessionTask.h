//
//  CFYNetworkURLSessionTask.h
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFYNetworkURLSessionTask : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithDataTask:(NSURLSessionDataTask *)task;
- (instancetype)initWithDownLoadTask:(NSURLSessionDownloadTask *)downLoadTask;

- (void)cancel;
- (void)resume;
- (NSNumber *)taskIdentifier;

@end

NS_ASSUME_NONNULL_END
