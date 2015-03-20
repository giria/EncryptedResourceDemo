//
//  NSURL+EncryptedFileProtocol.h
//
//  Created by Robin Summerhill on 15/07/2010.
//  Copyright 2010 Aptogo Ltd. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <Foundation/Foundation.h>


@interface NSURL (EncryptedFileURLProtocol) 

+ (id)encryptedFileURLWithPath:(NSString *)path;

@end
