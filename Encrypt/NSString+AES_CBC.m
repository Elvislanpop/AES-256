//
//  NSString+AES_CBC.m
//  AES-Encrypt
//
//  Created by 黄尧栋 on 25/01/2018.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

#import "NSString+AES_CBC.h"

@implementation NSString (AES_CBC)
- (NSString *)AES256EncryptWithKey:(NSString *)key iv:(NSString *)iv
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //对数据进行加密
    NSData *result = [data AES256EncryptWithKey:key iv:iv];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }
    return nil;
    
    
}
- (NSString *)AES256DecryptWithKey:(NSString *)key iv:(NSString *)iv
{
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData* result = [data AES256DecryptWithKey:key iv:iv];
    if (result && result.length > 0) {
        
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}



@end
