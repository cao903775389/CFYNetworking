//
//  CFYDemoAPIManager.m
//  CFYNetworking_Example
//
//  Created by caofengyang on 2023/3/9.
//  Copyright © 2023 caofengyang. All rights reserved.
//

#import "CFYDemoAPIManager.h"
#import "CFYNetworkAPIService.h"

@interface CFYDemoAPIManager ()  <CFYNetworkAPIManagerValidator, CFYNetworkAPIManagerParamSource>

@end

@implementation CFYDemoAPIManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.paramSource = self;
        self.validator = self;
    }
    return self;
}


- (nonnull NSString *)apiPath {
    return @"/rest/test";
}

- (CFYNetworkRequestType)requestType {
    return CFYNetworkRequestTypeGet;
}

- (NSString * _Nonnull)serviceIdentifier {
    return NSStringFromClass(CFYNetworkAPIService.class);
}

- (CFYNetworkAPIManagerErrorType)manager:(CFYNetworkAPIBaseManager * _Nonnull)manager isCorrectWithCallBackData:(NSDictionary * _Nullable)data {
    return CFYNetworkAPIManagerErrorTypeNoError;
}

- (CFYNetworkAPIManagerErrorType)manager:(CFYNetworkAPIBaseManager * _Nonnull)manager isCorrectWithParamsData:(NSDictionary * _Nullable)data {
    return CFYNetworkAPIManagerErrorTypeNoError;
}

- (NSDictionary * _Nullable)paramsForApi:(CFYNetworkAPIBaseManager * _Nonnull)manager {
    return nil;
}

@end
