//
//  QRCodeReaderViewController2.m
//  CJRichScanDemo
//
//  Created by ciyouzen on 2017/3/16.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "QRCodeReaderViewController2.h"

#import "BBXBusQRCodeReaderView.h"

@interface QRCodeReaderViewController2 () {

}
@property (nonatomic, strong) AVAudioPlayer        *beepPlayer;

@end

@implementation QRCodeReaderViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(chooseAlbum)];
    
    [self addReaderView];
    
    [(BBXBusQRCodeReaderView *)self.readerView updateScanResultString:@"待上车5人"];
    
    self.delegate = self;
    
    
    NSString *wavPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:wavPath];
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    _beepPlayer = audioPlayer;
}

- (void)addReaderView {
    BBXBusQRCodeReaderView *qrCodeReaderView = [[BBXBusQRCodeReaderView alloc] init];
    
    qrCodeReaderView.scanStatusLabel.hidden = YES;
    
    [self addReaderView:qrCodeReaderView];
}

#pragma mark - CJCodeReaderViewControllerDelegate
- (void)cj_codeReaderViewController:(CJCodeReaderViewController *)codeReaderViewController didScanResult:(NSString *)result
{
    [self.beepPlayer play];
    
    CJSampleQRCodeReaderView *qrCodeReaderView = (CJSampleQRCodeReaderView *)codeReaderViewController.readerView;
    qrCodeReaderView.scanResultLabel.text = result;
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf stopScanning];
        [(BBXBusQRCodeReaderView *)weakSelf.readerView pauseScanning];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self continueScanning];
    });
}

- (void)continueScanning {
    ((CJSampleQRCodeReaderView *)self.readerView).scanResultLabel.text = @"";
    
    [self startScanning];
    [(CJSampleQRCodeReaderView *)self.readerView startScanning];
}

- (void)qrCodeReaderViewController_DidCancel:(CJCodeReaderViewController *)reader {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
