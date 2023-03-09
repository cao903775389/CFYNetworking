//
//  CFYNetworkAPIBaseManager.h
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import <Foundation/Foundation.h>
#import <CFYNetworking/CFYNetworkDefines.h>

NS_ASSUME_NONNULL_BEGIN
@class CFYNetworkBaseResponse;
@protocol CFYNetworkAPIManagerDelegate;
@protocol CFYNetworkAPIManagerValidator;
@protocol CFYNetworkAPIManagerParamSource;

@interface CFYNetworkAPIBaseManager : NSObject

@property (nonatomic, weak) id <CFYNetworkAPIManagerValidator> _Nullable validator;
@property (nonatomic, weak) id <CFYNetworkAPIManagerParamSource> _Nullable paramSource;
@property (nonatomic, assign, readonly) BOOL isLoading;
@property (nonatomic, strong, readonly) CFYNetworkBaseResponse * _Nonnull response;
@property (nonatomic, assign, readonly) CFYNetworkAPIManagerErrorType errorType;
@property (nonatomic, copy, readonly) NSString * _Nullable errorMsg;

//delegate
- (void)addDelegate:(id<CFYNetworkAPIManagerDelegate>)delegate;
- (void)removeDelegate:(id<CFYNetworkAPIManagerDelegate>)delegate;

// start
- (void)loadData;
- (void)loadDataWithParams:(NSDictionary *_Nullable)params;

// cancel
- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSNumber *)requestID;

@end

NS_ASSUME_NONNULL_END
