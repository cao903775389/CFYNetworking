//
//  CFYNetworkURLSessionTask.m
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import "CFYNetworkURLSessionTask.h"

@interface CFYNetworkURLSessionTask ()

@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, strong, nullable) NSURLSessionDownloadTask *downLoadTask;

@end

@implementation CFYNetworkURLSessionTask

- (instancetype)initWithTask:(NSURLSessionTask *)task {
    if (self = [super init]) {
        _task = task;
    }
    return self;
}

- (instancetype)initWithDataTask:(NSURLSessionDataTask *)task {
    return [self initWithTask:task];
}

- (instancetype)initWithDownLoadTask:(NSURLSessionDownloadTask *)downLoadTask {
    if (![downLoadTask isKindOfClass:NSURLSessionDownloadTask.class]) {
        NSCParameterAssert(NO);
        return nil;
    }
    if (self = [self initWithTask:downLoadTask]) {
        _downLoadTask = downLoadTask;
    }
    return self;
}

- (void)cancel {
    [self.task cancel];
}

- (void)resume {
    [self.task resume];
}

- (NSNumber *)taskIdentifier {
    if (!self.task) {
        return nil;
    }
    return @(self.task.taskIdentifier);
}

@end
