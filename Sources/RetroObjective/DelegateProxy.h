//
//  DelegateProxy.h
//  RetroObjective
//
//  Created by Amine Bensalah on 21/01/2020.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DelegateProxy : NSObject

- (void)interceptedSelector:(SEL _Nonnull)selector arguments:(NSArray * _Nonnull)arguments;

@end

NS_ASSUME_NONNULL_END
