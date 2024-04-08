//
//  SafeExpressionWrapper.h
//
//
//  Created by Other on 4/7/24.
//

#ifndef SafeExpressionWrapper_h
#define SafeExpressionWrapper_h

#import <Foundation/Foundation.h>

@interface SafeExpressionWrapper : NSObject

+ (BOOL)performBlock:(void(NS_NOESCAPE ^)(void))block error:(NSError * _Nullable * _Nullable)error;
//+ (BOOL)performBlock:(void(NS_NOESCAPE ^)(void))block error:(NSError * _Nullable * _Nullable)error;

@end
#endif /* SafeExpressionWrapper_h */
