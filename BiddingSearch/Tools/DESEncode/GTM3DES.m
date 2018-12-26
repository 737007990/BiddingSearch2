//
//  GTM3DES.m
//  Sand Life Preview
//
//  Created by lin peng on 25/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GTM3DES.h"
#import "NSData-Hex.h"
#import "NSString.h"
//#import "Utility.h"
@implementation GTM3DES


+ (NSData*)en3DESData:(NSData*)plainData withKeyData:(NSData*)keyData

{
    
    CCCryptorStatus ccStatus;
    
    uint8_t *bufferPtr = NULL;
    
    size_t bufferPtrSize = 0;
    
    size_t movedBytes = 0;
    
//    uint8_t iv[kCCBlockSize3DES];
    
    bufferPtrSize = ([plainData length] + kCCBlockSize3DES) & ~(kCCBlockSize3DES -1);
    
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    
    memset((void *)bufferPtr, 0x00, bufferPtrSize);
    
    
    ccStatus = CCCrypt(kCCEncrypt,
    
                       kCCAlgorithm3DES,
                       
                       kCCOptionPKCS7Padding,
                       
                       [keyData bytes],
                       
                       [keyData length],
                       
                       nil,
                       
                       [plainData bytes],
                       
                       [plainData length],
                       
                       (void *)bufferPtr,
                       
                       bufferPtrSize,
                       
                       &movedBytes);
    return [NSData dataWithBytes:bufferPtr length:movedBytes];
    
    
    
}



+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key {
    
    const void *vplainText;
    size_t plainTextBufferSize;
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    uint8_t iv [kCCBlockSize3DES];
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    memset((void *) iv, 0x0, (size_t) sizeof(iv));
//    const void *vkey = (const void *) [key UTF8String];
     NSData* keydata = [key dataUsingEncoding:NSUTF8StringEncoding];
    const void *vkey  = (const void *)[keydata bytes];
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       (kCCOptionPKCS7Padding|kCCOptionECBMode),
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       iv, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding]
        ;
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
    
}




@end
