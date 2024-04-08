#include "SafeExpressionWrapper.h"
#import <Foundation/Foundation.h>

@implementation SafeExpressionWrapper

+ (BOOL)performBlock:(void(NS_NOESCAPE ^)(void))block error:(NSError * _Nullable * _Nullable)error {
    @try {
        block();
        return YES;
    }
    @catch (NSException *exception) {
        if (error) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: exception.reason};
            *error = [NSError errorWithDomain:@"SafeExpressionWrapperErrorDomain"
                                         code:-1
                                     userInfo:userInfo];
        }
        return NO;
    }
}

@end
