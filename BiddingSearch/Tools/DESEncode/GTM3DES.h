//
//  GTM3DES.h
//  Sand Life Preview
//
//  Created by lin peng on 25/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@interface GTM3DES : NSObject

+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key ;
+ (NSData*)en3DESData:(NSData*)plainData withKeyData:(NSData*)keyData;
@end
