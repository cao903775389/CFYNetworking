//
//  CFYNetworkServiceFactory.m
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import "CFYNetworkServiceFactory.h"

@interface CFYNetworkServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id<CFYNetworkServiceProtocol>> *serviceStorage;

@end

@implementation CFYNetworkServiceFactory

#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static CFYNetworkServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CFYNetworkServiceFactory alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (id <CFYNetworkServiceProtocol>)serviceWithIdentifier:(NSString *)identifier {
    if (self.serviceStorage[identifier] == nil) {
        id<CFYNetworkServiceProtocol> service = [self newServiceWithIdentifier:identifier];
        if (service) {
            self.serviceStorage[identifier] = service;
        } else {
            return nil;
        }
    }
    return self.serviceStorage[identifier];
}

#pragma mark - private methods
- (id <CFYNetworkServiceProtocol>)newServiceWithIdentifier:(NSString *)identifier {
    Class serviceClass = NSClassFromString(identifier);
    id<CFYNetworkServiceProtocol> instance = [[serviceClass alloc] init];
    if ([instance conformsToProtocol:@protocol(CFYNetworkServiceProtocol)]) {
        return instance;
    } else {
        NSCAssert(NO, @"service未实现CFYNetworkServiceProtocol协议");
        return nil;
    }
}

#pragma mark - getters and setters
- (NSMutableDictionary<NSString *, id<CFYNetworkServiceProtocol>> *)serviceStorage {
    if (!_serviceStorage) {
        _serviceStorage = [NSMutableDictionary dictionary];
    }
    return _serviceStorage;
}

@end
