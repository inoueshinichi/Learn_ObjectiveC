/* Objective-C++ */
#import <wrap_objcxx_mixed.h>
#import "mixed_cpp.h"

@implementation ObjCppMix
{
    MixCpp mixCpp; // C++クラス
}

-(void)wrap_mixed_test
{
    mixCpp.mixed_test_cpp();
}

@end