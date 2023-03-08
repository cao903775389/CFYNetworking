//
//  CFYNetworkServiceFactory.m
//  CFYNetworking
//
//  Created by caofengyang on 2023/3/8.
//

#import "CFYNetworkServiceFactory.h"

@interface CFYNetworkServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, CFYNetworkAPIBaseService *> *serviceStorage;

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
- (CFYNetworkAPIBaseService *)serviceWithIdentifier:(NSString *)identifier {
    if (self.serviceStorage[identifier] == nil) {
        CFYNetworkAPIBaseService *service = [self newServiceWithIdentifier:identifier];
        if (service) {
            self.serviceStorage[identifier] = service;
        } else {
            return nil;
        }
    }
    return self.serviceStorage[identifier];
}

#pragma mark - private methods
- (CFYNetworkAPIBaseService *)newServiceWithIdentifier:(NSString *)identifier {
    Class serviceClass = NSClassFromString(identifier);
    CFYNetworkAPIBaseService *instance = [[serviceClass alloc] init];
    if (instance) {
        return instance;
    } else {
        NSCAssert(NO, @"service未找到对应类");
        return nil;
    }
}

#pragma mark - getters and setters
- (NSMutableDictionary<NSString *, CFYNetworkAPIBaseService *> *)serviceStorage {
    if (!_serviceStorage) {
        _serviceStorage = [NSMutableDictionary dictionary];
    }
    return _serviceStorage;
}

@end
