//
//  CFYNetworkServiceFactory.h
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import <Foundation/Foundation.h>
#import <CFYNetworking/CFYNetworkServiceProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFYNetworkServiceFactory : NSObject

+ (instancetype)sharedInstance;

- (id <CFYNetworkServiceProtocol>)serviceWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
