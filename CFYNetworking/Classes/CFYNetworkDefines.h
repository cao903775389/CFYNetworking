//
//  CFYNetworkDefines.h
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 参数拦截/校验
 Request组装
 task生成，网络请求发送
 Response处理，error处理
 数据解析
 */


typedef NS_ENUM (NSUInteger, CFYNetworkRequestType){
    CFYNetworkRequestTypeGet,
    CFYNetworkRequestTypePost,
    CFYNetworkRequestTypePut,
    CFYNetworkRequestTypeDelete,
};

// 业务层错误码
typedef NS_ENUM (NSUInteger, CFYNetworkAPIManagerErrorType){
    CFYNetworkAPIManagerErrorTypeDefault = 0,               // 没有产生过API请求，这个是manager的默认状态。
    CFYNetworkAPIManagerErrorTypeAccessTokenInvalid = 1,    // 需要重新刷新accessToken
    CFYNetworkAPIManagerErrorTypeNeedLogin = 2,             // 需要登陆
    CFYNetworkAPIManagerErrorTypeLoginCanceled = 3,         // 调用API需要登陆态，弹出登陆页面之后用户取消登陆了
    CFYNetworkAPIManagerErrorTypeSuccess = 4,               // API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    CFYNetworkAPIManagerErrorTypeNoContent = 5,             // API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    CFYNetworkAPIManagerErrorTypeParamsError = 6,           // 参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    CFYNetworkAPIManagerErrorTypeTimeout = 7,               // 请求超时。CTAPIProxy设置的是20秒超时，具体超时时间的设置请自己去看CTAPIProxy的相关代码。
    CFYNetworkAPIManagerErrorTypeNoNetWork = 8,             // 网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
    CFYNetworkAPIManagerErrorTypeCanceled = 9,              // 取消请求
    CFYNetworkAPIManagerErrorTypeNoError = 10,              // 请求校验无错误
};

#pragma mark - 通知
//没有token，需要登录
extern NSString * _Nonnull const kCTUserNeedTokenNotification;
//token过期，需要重新登录
extern NSString * _Nonnull const kCTUserTokenInvalidNotification;
//userInfo传递的Manager
extern NSString * _Nonnull const kCTUserTokenNotificationUserInfoKeyManagerToContinue;


NS_ASSUME_NONNULL_END
