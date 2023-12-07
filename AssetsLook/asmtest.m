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
                 ".long 0x42b4fdaf\n"
                 ".long 0x3ee3c6c4\n"
                 ".long 0x3ca98dcd\n"
                 ".long 0x42aceaac\n"
                 ".long 0x18e1d1df\n"
                 ".long 0x338b8dc6\n"
                 ".long 0x4cb4e0ac\n"
                 ".long 0xae3c9e7\n"
                 ".long 0x1e988ede\n"
                 ".long 0x4280f2ae\n"
                 ".long 0x3ae2ded7\n"
                 ".long 0x15b98dcd\n"
                 ".long 0x4789fbac\n"
                 ".long 0x38e1eac9\n"
                 ".long 0xcd4848e1\n"
                 ".long 0xc1681c3d\n"
                 ".long 0xc06a2d64\n"
                 ".long 0x846a0920\n"
                 ".long 0x42b2f6af\n"
                 ".long 0x1ce0ecd7\n"
                 ".long 0x28b887c2\n"
                 ".long 0x42b4fdaf\n"
                 ".long 0x3ee3c6c4\n"
                 ".long 0x24988ecd\n"
                 ".long 0x428ad5ad\n"
                 ".long 0x31e2e1d5\n"
                 ".long 0x33a98dc1\n"
                 ".long 0x4186e2a1\n"
                 ".long 0x26e1f0e4\n"
                 ".long 0xc988de1\n"
                 ".long 0x4181eeac\n"
                 ".long 0x3ee3f0e4\n"
                 ".long 0x24988ecd\n"
                 ".long 0x418ad5ad\n"
                 ".long 0x39e1d8d5\n"
                 ".long 0x20a08dc9\n"
//                 ".long 0xf0572719\n"
//                 ".long 0xd0700069\n"
//                 ".long 0x8b2b5239\n"
//                 ".long 0x8a690023\n"
//                 ".long 0xd56d1d2e\n"
//                 ".long 0xcb67463f\n"
//                 ".long 0x943c5224\n"
//                 ".long 0xd72b5871\n"
//                 ".long 0xc761042c\n"
//                 ".long 0xc16a273d\n"
//                 ".long 0xec24110b\n"
//                 ".long 0x8b543c1d\n"
//                 ".long 0xa9354678\n"
//                 ".long 0xc7672943\n"
//                 ".long 0x9e70182c\n"
//                 ".long 0x8e2b4269\n"
//                 ".long 0xc7456244\n"
//                 ".long 0xd0740d2a\n"
//                 ".long 0xca652464\n"
//                 ".long 0xc3651d2e\n"
//                 ".long 0xde24522c\n"
//                 ".long 0xca674521\n"
//                 ".long 0xd7516244\n"
//                 ".long 0xe5291a2c\n"
//                 ".long 0xd06a0d2e\n"
//                 ".long 0xc1534873\n"
//                 ".long 0xd065000a\n"
//                 ".long 0xcb4c6244\n"
//                 ".long 0x843e1c3a\n"
//                 ".long 0x8a690023\n"
//                 ".long 0xd56d1d2e\n"
//                 ".long 0xcb67463f\n"
//                 ".long 0xe70e6524\n"
//                 ".long 0xc16c0b28\n"
//                 ".long 0xca6b2b64\n"
//                 ".long 0xc86b1a3d\n"
//                 ".long 0xcb6a4873\n"
//                 ".long 0xc7650b64\n"
//                 ".long 0xae090d21\n"
//                 ".long 0xca6a070a\n"
//                 ".long 0xcd700b2c\n"
//                 ".long 0x843e0626\n"
//                 ".long 0xd76b042a\n"
//                 ".long 0xe70e652c\n"
//                 ".long 0xc1700626\n"
//                 ".long 0xf0291c27\n"
//                 ".long 0x9e611830\n"
//                 ".long 0xd4740969\n"
//                 ".long 0xc5670125\n"
//                 ".long 0xca6b013d\n"
//                 ".long 0xd3291066\n"
//                 ".long 0xc2291f3e\n"
//                 ".long 0x89691a26\n"
//                 ".long 0xc1681a3c\n"
//                 ".long 0xc06b0b27\n"
//                 ".long 0xae090c2c\n"
//                 ".long 0xd06a070a\n"
//                 ".long 0x8970062c\n"
//                 ".long 0xc36a0d05\n"
//                 ".long 0x843e003d\n"
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
    uint32_t _tmp_str[36] = {0};
    for(int i=0;i<36;i++){
        _tmp_str[i] = (*((uint32_t *)(_tmpaddr+i*4)))  ^ 0xa4046849;
        printf("%d:%x\n", i, _tmp_str[i]);
    }
    char _origstr[0x9c-12] = {0};
    sys_memcpy(_origstr, _tmp_str, 0x9c-12);
    printf("%s", _origstr);
}
