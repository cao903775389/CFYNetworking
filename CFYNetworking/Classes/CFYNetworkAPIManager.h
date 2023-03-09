//
//  CFYNetworkAPIManager.h
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import <Foundation/Foundation.h>
#import <CFYNetworking/CFYNetworkDefines.h>

NS_ASSUME_NONNULL_BEGIN
@class CFYNetworkAPIBaseManager;

@protocol CFYNetworkAPIManager <NSObject>

- (NSString *)apiPath;
- (CFYNetworkRequestType)requestType;
- (NSString *_Nonnull)serviceIdentifier;

@optional
//公参处理
- (NSDictionary *_Nullable)reformParams:(NSDictionary *_Nullable)params;

@end

//请求代理回调
@protocol CFYNetworkAPIManagerDelegate <NSObject>

- (void)managerCallAPIDidSuccess:(CFYNetworkAPIBaseManager * _Nonnull)manager;
- (void)managerCallAPIDidFailed:(CFYNetworkAPIBaseManager * _Nonnull)manager;

@end

//请求合法性校验
@protocol CFYNetworkAPIManagerValidator <NSObject>
@required
- (CFYNetworkAPIManagerErrorType)manager:(CFYNetworkAPIBaseManager *_Nonnull)manager isCorrectWithCallBackData:(NSDictionary *_Nullable)data;
- (CFYNetworkAPIManagerErrorType)manager:(CFYNetworkAPIBaseManager *_Nonnull)manager isCorrectWithParamsData:(NSDictionary *_Nullable)data;
@end

//参数组装
@protocol CFYNetworkAPIManagerParamSource <NSObject>
@required
- (NSDictionary *_Nullable)paramsForApi:(CFYNetworkAPIBaseManager *_Nonnull)manager;
@end


NS_ASSUME_NONNULL_END
