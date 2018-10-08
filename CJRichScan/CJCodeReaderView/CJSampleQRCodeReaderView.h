//
//  CJSampleQRCodeReaderView.h
//  CJRichScanDemo
//
//  Created by ciyouzen on 2017/3/16.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJBaseCodeReaderView.h"

@interface CJSampleQRCodeReaderView : CJBaseCodeReaderView {
    
}
@property (nonatomic, strong) UIImageView *cornerImageView1;
@property (nonatomic, strong) UIImageView *cornerImageView2;
@property (nonatomic, strong) UIImageView *cornerImageView3;
@property (nonatomic, strong) UIImageView *cornerImageView4;

@property (nonatomic, strong) UIImageView *scanLineImageView;
@property (nonatomic, strong) UILabel *scanStatusLabel;

@property (nonatomic, strong) UILabel *scanResultLabel;
@property (nonatomic, strong) UILabel *scanPromptLabel;

@property (nonatomic, weak) NSTimer *scanTimer;

- (void)startScanning;

- (void)stopScanning;

- (void)pauseScanning;

- (void)continueScanning;

@end
