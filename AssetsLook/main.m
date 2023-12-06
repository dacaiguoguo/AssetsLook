//
//  main.m
//  AssetsLook
//
//  Created by yanguo sun on 2023/6/20.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

long double_num(long num) {
    __asm__ __volatile__(
                         "lsl x0, x0, 1\n"
                         "str x0, [sp, #8]\n"
                         );
    return num;
}


int main(int argc, char * argv[]) {
    long ret = double_num(0x68449035);
    printf("%0ld", ret);
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
