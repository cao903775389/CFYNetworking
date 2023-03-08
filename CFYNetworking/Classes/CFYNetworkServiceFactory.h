//
//  CFYNetworkServiceFactory.h
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import <Foundation/Foundation.h>
#import <CFYNetworking/CFYNetworkAPIBaseService.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFYNetworkServiceFactory : NSObject

+ (instancetype)sharedInstance;

- (CFYNetworkAPIBaseService *)serviceWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
