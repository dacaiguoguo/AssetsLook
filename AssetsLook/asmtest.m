//
//  asmtest.c
//  AssetsLook
//
//  Created by yanguo sun on 2023/12/7.
//

#include "asmtest.h"

#define __SYMBOL_VISIBILITY__(type) __attribute__((visibility("hidden"))) type


__SYMBOL_VISIBILITY__(void) *sys_memcpy(void *dst,const void *src,size_t num){

    if (dst == NULL || src == NULL) {
        return dst;
    }

    //assert（des>=src+num||src>dst+num）;
    Byte * psrc = (Byte *)src;//byte 既为unsigned char类型
    Byte * pdst = (Byte *)dst;

    while(num-- > 0)
        *pdst++ = *psrc++;

    return dst;
}


__attribute__((naked)) void getpc(void){
    //    getpc的作用就是x30 也就是连接寄存器，也就是函数执行完后的下一条指令的地址，
    //    存储到了x16寄存器中
    //    这里的指令意思就是修改了x30，让其跳过了一部分指令也就是下面插入的 .long
#ifdef __arm64__
    asm volatile ("sub sp,sp,0x10\n"
                  "stp x29,x30,[sp]\n"
                  "mov x0,%0\n"
                  "add x0,x0,40\n"
                  "br x0\n"
                  ".long 0x1234dfae\n"
                  ".long 0x1234dfae\n"
                  ".long 0x1234dfae\n"
                  "ldp x29,x30,[sp]\n"
                  "mov x16,x30\n"
                  "add sp,sp,0x10\n"
                  "ret\n"
                  :
                  :"r"(&getpc)
                  :"x0");
#endif
}

void testaaa(void) {
#ifdef __arm64__
    getpc();
    //    这里的指令意思就是修改了x30，让其跳过了一部分指令也就是下面插入的 .long
    asm volatile(
                 "add x16,x16,0x9c\n"
                 "mov x30,x16\n"
                 "ret\n"
                 );
#else

#endif

    asm volatile(
                 ".long 0xf0572719\n"
                 ".long 0xd0700069\n"
                 ".long 0x8b2b5239\n"
                 ".long 0xdd2a1023\n"
                 ".long 0xcd741d26\n"
                 ".long 0xd02a5f27\n"
                 ".long 0x933e1826\n"
                 ".long 0x8b315e7e\n"
                 ".long 0xc5650928\n"
                 ".long 0xd42a0524\n"
                 ".long 0xa4046849\n"
                 );
    //用来亦或加密的字符串的数值为：0xa4046849
    unsigned long _tmpaddr = 0;
    asm volatile(
#ifdef __arm64__
                 "mov %0,x16\n"
#else
                 "mov %0,lr\n"
#endif
                 :"=r"(_tmpaddr)
                 );
    _tmpaddr = _tmpaddr - 0x9c + 12;
    uint32_t _tmp_str[0x28] = {0};
    for(int i=0;i<0x28;i++){
        _tmp_str[i] = (*((uint32_t *)(_tmpaddr+i*4)))  ^ 0xa4046849;
        printf("%d:%x\n", i, _tmp_str[i]);
    }
    char _origstr[0x9c-12] = {0};
    sys_memcpy(_origstr, _tmp_str, 0x9c-12);
    printf("%s\n", _origstr);
}
