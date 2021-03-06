//
//  DelegateProxy.m
//  RetroObjective
//
//  Created by Amine Bensalah on 21/01/2020.
//

#import "DelegateProxy.h"
#import "RORuntime.h"
#import <objc/runtime.h>

@implementation DelegateProxy

- (void)interceptedSelector:(SEL)selector arguments:(NSArray *)arguments
{
    NSAssert(NO, @"Abstract method");
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if (RO_isMethodSignatureVoid(anInvocation.methodSignature)) {
        NSArray *arguments = RO_argumentsFromInvocation(anInvocation);
        [self interceptedSelector:anInvocation.selector arguments:arguments];
    }
}

@end
