//
//  CJCodeReaderManager.m
//  CJRichScanDemo
//
//  Created by ciyouzen on 2018/10/8.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJCodeReaderManager.h"
#import "CJCodeReader.h"

@interface CJCodeReaderManager () <CJCodeReaderDelegate> {
    
}

@end



@implementation CJCodeReaderManager

+ (CJCodeReaderManager *)sharedInstance {
    static CJCodeReaderManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _codeReader = [CJCodeReader sharedInstance];
        _codeReader.delegate = self;
    }
    return self;
}

- (void)switchDeviceInput {
    [self.codeReader switchDeviceInput];
}

- (void)startScanning {
    [self.codeReader startScanning];
}

- (void)stopScanning {
    [self.codeReader stopScanning];
}

#pragma mark - CJCodeReaderDelegate
- (void)cj_codeReader:(CJCodeReader *)codeReader didScanResult:(NSString *)scannedResult {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cj_codeReaderManager:didScanResult:)]) {
        [self.delegate cj_codeReaderManager:self didScanResult:scannedResult];
    }
}

@end
