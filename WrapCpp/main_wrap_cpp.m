#import <Foundation/Foundation.h>

// FOUNDATION_EXTERN void mixed_test_cpp();
// OBJC_EXTERN void mixed_test_cpp();
#import "wrap_objcxx_mixed.h"

/* Objective-CからC++をラップしたObjective-C++を呼び出す */

int main() {
    @autoreleasepool {
        NSLog(@"Hello world!");  

        // mixed_test_cpp();
        ObjCppMix *obj = [ObjCppMix new];
        [obj wrap_mixed_test]; 
    }
    return 0;
}