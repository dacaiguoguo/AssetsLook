//
//  main.m
//  AssetsLook
//
//  Created by yanguo sun on 2023/6/20.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//    AssetsLook`double_num2:
//    0x102b13514 <+0>:  sub    sp, sp, #0x10
//    0x102b13518 <+4>:  str    x0, [sp, #0x8]
//    0x102b1351c <+8>:  ldr    x8, [sp, #0x8]
//    0x102b13520 <+12>: lsl    x0, x8, #1
//    0x102b13524 <+16>: add    sp, sp, #0x10
//    0x102b13528 <+20>: ret
long double_num2(long num) {
    __asm__ __volatile__(
                         "lsl x0, x0, 1\n"
                         "str x0, [sp, #0x8]\n"
                         );
    return num;
}

int double_num(int num) {
    __asm__ __volatile__(
                         "lsl x0, x0, 1\n"
                         "str x0, [sp, #12]\n"
                         );
    return num;
}

int mainAdd(int a, int b) {
    return a + b;
}
#import "asmtest.h"

int main(int argc, char * argv[]) {
    mainAdd(argc, 0xff);
    testaaa();
    long ret = double_num2(0x68449035);
    printf("%0ld\n", ret);

    int ret1 = double_num(0x6844);
    printf("%0d\n", ret1);
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
