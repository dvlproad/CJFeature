//
//  CJCodeReaderManager.h
//  CJRichScanDemo
//
//  Created by ciyouzen on 2018/10/8.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJCodeReader.h"

@class CJCodeReaderManager;
@protocol CJCodeReaderManagerDelegate <NSObject>

@optional
- (void)cj_codeReaderManager:(CJCodeReaderManager *)codeReaderManager didScanResult:(NSString *)scannedResult;

@end



@interface CJCodeReaderManager : NSObject {
    
}
@property(nonatomic, weak, readonly) id<CJCodeReaderManagerDelegate> delegate;
@property (nonatomic, strong) CJCodeReader *codeReader;

+ (CJCodeReaderManager *)sharedInstance;

- (void)switchDeviceInput;

- (void)startScanning;
- (void)stopScanning;

@end
