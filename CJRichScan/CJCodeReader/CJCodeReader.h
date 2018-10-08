//
//  CJCodeReader.h
//  CJRichScanDemo
//
//  Created by ciyouzen on 2018/10/8.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@class CJCodeReader;
@protocol CJCodeReaderDelegate <NSObject>

@optional
- (void)cj_codeReader:(CJCodeReader *)codeReader didScanResult:(NSString *)scannedResult;

@end



@interface CJCodeReader : NSObject {
    
}
@property (nonatomic, weak) id<CJCodeReaderDelegate> delegate;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

+ (CJCodeReader *)sharedInstance;

+ (BOOL)isAvailable;

- (void)switchDeviceInput;

- (void)startScanning;
- (void)stopScanning;

@end
