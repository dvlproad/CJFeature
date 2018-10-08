//
//  CJCodeReaderViewController.m
//  CJRichScanDemo
//
//  Created by ciyouzen on 2017/3/16.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJCodeReaderViewController.h"

//CGFloat mainScreenWidth = [[UIScreen mainScreen] bounds].size.width;
//CGFloat mainScreenHeight = [[UIScreen mainScreen] bounds].size.height;
//CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;

@interface CJCodeReaderViewController () {
    
}

@end



@interface CJCodeReaderViewController () <CJCodeReaderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
}
@property (nonatomic, strong) CIDetector *detector;

@end

@implementation CJCodeReaderViewController

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startScanning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopScanning];
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.codeReader.previewLayer.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _codeReader = [CJCodeReader sharedInstance];
    _codeReader.delegate = self;
    
    [self.codeReader.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.codeReader.previewLayer setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    AVCaptureConnection *captureConnection = self.codeReader.previewLayer.connection;
    if ([captureConnection isVideoOrientationSupported]) {
        captureConnection.videoOrientation = [[self class] videoOrientationFromInterfaceOrientation:self.interfaceOrientation];
    }
}

/*
//播放beef语音 (放在子类中实现)
- (void)playBeepVoice {
    NSString *wavPath = [[NSBundle mainBundle] pathForResource:@"cjBeep" ofType:@"wav"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:wavPath];
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    
    [audioPlayer play];
}
*/


#pragma mark - Controlling Reader
- (void)switchDeviceInput {
    [self.codeReader switchDeviceInput];
}

- (void)startScanning {
    [self.codeReader startScanning];
}

- (void)stopScanning {
    [self.codeReader stopScanning];
}

#pragma mark - Checking the Metadata Items Types

+ (BOOL)isAvailable
{
    return [CJCodeReader isAvailable];
}

- (void)chooseAlbum {
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Managing the Orientation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.codeReaderView setNeedsDisplay];
    
    
    AVCaptureConnection *captureConnection = self.codeReader.previewLayer.connection;
    if (captureConnection.isVideoOrientationSupported) {
        captureConnection.videoOrientation = [[self class] videoOrientationFromInterfaceOrientation:toInterfaceOrientation];
    }
}

+ (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        default:
            return AVCaptureVideoOrientationPortraitUpsideDown;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
//    NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]
//                                               options:@{CIDetectorImageOrientation:[NSNumber numberWithInt:1]}];
    NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >=1) {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scannedResult = feature.messageString;
        
        if (_delegate && [_delegate respondsToSelector:@selector(cj_codeReaderViewController:didScanResult:)]) {
            [_delegate cj_codeReaderViewController:self didScanResult:scannedResult];
        }
    }
}

@end
