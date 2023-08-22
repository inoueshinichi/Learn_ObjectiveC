/* Objective-C++ */
#import <wrap_objcxx_mixed.h>
#import "mixed_cpp.hpp"

@implementation ObjCppMix
{
    MixCpp *mixCpp; // C++クラス
}

-(id)init
{
    self = [super init];
    mixCpp = new MixCpp();
    return self;
}

-(void)dealloc 
{
    delete mixCpp;
    [super dealloc];
}

-(void)wrap_mixed_test
{
    mixCpp->mixed_test_cpp();
}

@end