//
//  EncryptedFileURLProtocol.m
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

#import "EncryptedFileURLProtocol.h"

// Custom URL scheme name
NSString * const ENCRYPTED_FILE_SCHEME_NAME = @"encrypted-file";

// Default 256bit key - change this!
static NSString *sharedKey = @"abcdefghijklmnopqrstuvwxyz123456";

// Buffer length - must be multiple of 16 for AES256
static const int BUFFER_LENGTH = 512;

static NSString * const ERROR_DOMAIN = @"EncryptedFileURLProtocol";

enum ERROR_CODES {
    DECRYPTION_ERROR_CODE = 1
};

@implementation EncryptedFileURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return ([[[request URL] scheme] isEqualToString:ENCRYPTED_FILE_SCHEME_NAME]);
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (void)setKey:(NSString *)key
{
    if (key != sharedKey)
    {
        [sharedKey release];
        sharedKey = [key copy];
    }
}

+ (NSString*)key
{
    return sharedKey;
}

// Called when URL loading system initiates a request using this protocol. Initialise input stream, buffers and decryption engine.
- (void)startLoading
{
    inBuffer = malloc(BUFFER_LENGTH);
    outBuffer = malloc(BUFFER_LENGTH);
    CCCryptorCreate(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, [sharedKey cStringUsingEncoding:NSISOLatin1StringEncoding], kCCKeySizeAES256, NULL, &cryptoRef);
    
    inStream = [[NSInputStream alloc] initWithFileAtPath:[[self.request URL] path]];
    [inStream setDelegate:self];
    [inStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inStream open];
}

// Called by URL loading system in response to normal finish, error or abort. Cleans up in each case.
- (void)stopLoading
{
    [inStream close];
    [inStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inStream release];
    inStream = nil;
    CCCryptorRelease(cryptoRef);
    free(inBuffer);
    free(outBuffer);
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)streamEvent
{
    switch(streamEvent) {
        case NSStreamEventHasBytesAvailable:
        {
            size_t len = 0;
            len = [(NSInputStream *)inStream read:inBuffer maxLength:BUFFER_LENGTH];
            if (len)
            {
                // Decrypt read bytes
                if (kCCSuccess != CCCryptorUpdate(cryptoRef, inBuffer, len, outBuffer, BUFFER_LENGTH, &len))
                {
                    [self.client URLProtocol:self didFailWithError:[NSError errorWithDomain:ERROR_DOMAIN code:DECRYPTION_ERROR_CODE userInfo:nil]];
                    return;
                }
                
                // Pass decrypted bytes on to URL loading system
                NSData *data = [NSData dataWithBytes:outBuffer length:len];
                [self.client URLProtocol:self didReceiveResponse:[[NSURLResponse alloc] init] cacheStoragePolicy:NSURLCacheStorageAllowed];
                [self.client URLProtocol:self didLoadData:data];
            }
            break;
        }
            
        case NSStreamEventEndEncountered:
        {
            // Flush any remaining decrypted bytes
            size_t len = 0;
            CCCryptorFinal(cryptoRef, outBuffer, kCCBlockSizeAES128, &len);
            if (len)
            {
                NSData *data = [NSData dataWithBytesNoCopy:outBuffer length:len freeWhenDone:NO];
                [self.client URLProtocol:self didReceiveResponse:[[NSURLResponse alloc] init] cacheStoragePolicy:NSURLCacheStorageAllowed];
                [self.client URLProtocol:self didLoadData:data];  
            }
            
            [self.client URLProtocolDidFinishLoading:self];
            break;
        }
        case NSStreamEventErrorOccurred:
        {
            [self.client URLProtocol:self didFailWithError:[inStream streamError]];
            break;
        }
    }
}

@end
