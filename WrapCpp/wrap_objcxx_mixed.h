/**
 * @file wrap_objcxx_mixed.h
 * @author Shinichi Inoue (inoue.shinichi.1800@gmail.com)
 * @brief Objective-Cに適用するC++用のObjective-C++ラッパー
 * @version 0.1
 * @date 2023-08-22
 * 
 * @copyright Copyright (c) 2023
 * 
 */

/* Objective-C++ */
#ifndef __H_WRAP_MIXED__
#define __H_WRAP_MIXED__

/* Objective-Cとの相互運用のためヘッダー側にはC++識別子は使わない. */

#import <Foundation/Foundation.h>

@interface ObjCppMix : NSObject
- (void)wrap_mixed_test;
@end

#endif