//
//  RORuntime.h
//  RetroObjective
//
//  Created by Amine Bensalah on 21/01/2020.
//

#import <Foundation/Foundation.h>

BOOL RO_isMethodReturnTypeVoid(struct objc_method_description method);

BOOL RO_isMethodSignatureVoid(NSMethodSignature * _Nonnull methodSignature);

NSArray * _Nonnull RO_argumentsFromInvocation(NSInvocation * _Nonnull invocation);

id _Nonnull RO_argumentsFromInvocationWithIndex(NSInvocation * _Nonnull invocation, NSUInteger index);
