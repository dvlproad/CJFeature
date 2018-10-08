//
//  CJCodeReader.m
//  CJRichScanDemo
//
//  Created by ciyouzen on 2018/10/8.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJCodeReader.h"

@interface CJCodeReader () <AVCaptureMetadataOutputObjectsDelegate> {
    
}
@property (nonatomic, strong) AVCaptureDevice            *defaultDevice;
@property (nonatomic, strong) AVCaptureDeviceInput       *defaultDeviceInput;
@property (nonatomic, strong) AVCaptureDevice            *frontDevice;
@property (nonatomic, strong) AVCaptureDeviceInput       *frontDeviceInput;
@property (nonatomic, strong) AVCaptureMetadataOutput    *metadataOutput;
@property (nonatomic, strong) AVCaptureSession           *session;

@end


@implementation CJCodeReader

+ (CJCodeReader *)sharedInstance {
    static CJCodeReader *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupAVComponents];
        [self configureDefaultComponents];
    }
    return self;
}

#pragma mark - Initializing the AV Components
- (void)setupAVComponents
{
    self.defaultDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (_defaultDevice) {
        self.defaultDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_defaultDevice error:nil];
        self.metadataOutput     = [[AVCaptureMetadataOutput alloc] init];
        self.session            = [[AVCaptureSession alloc] init];
        self.previewLayer       = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        
        for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
            if (device.position == AVCaptureDevicePositionFront) {
                self.frontDevice = device;
            }
        }
        
        if (_frontDevice) {
            self.frontDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_frontDevice error:nil];
        }
    }
}

- (void)configureDefaultComponents
{
    [_session addOutput:_metadataOutput];
    
    if (_defaultDeviceInput) {
        [_session addInput:_defaultDeviceInput];
    }
    
    [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if ([[_metadataOutput availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeQRCode]) {
        [_metadataOutput setMetadataObjectTypes:@[ AVMetadataObjectTypeQRCode ]];
    }
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}



+ (BOOL)isAvailable
{
    @autoreleasepool {
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if (!captureDevice) {
            return NO;
        }
        
        NSError *error;
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        
        if (!deviceInput || error) {
            return NO;
        }
        
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        
        if (![output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            return NO;
        }
        
        return YES;
    }
}

- (void)switchDeviceInput
{
    if (_frontDeviceInput) {
        [_session beginConfiguration];
        
        AVCaptureDeviceInput *currentInput = [_session.inputs firstObject];
        [_session removeInput:currentInput];
        
        AVCaptureDeviceInput *newDeviceInput = (currentInput.device.position == AVCaptureDevicePositionFront) ? _defaultDeviceInput : _frontDeviceInput;
        [_session addInput:newDeviceInput];
        
        [_session commitConfiguration];
    }
}

- (void)startScanning {
    if (![self.session isRunning]) {
        [self.session startRunning];
    }
}

- (void)stopScanning {
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
}


#pragma mark - AVCaptureMetadataOutputObjects Delegate Methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for(AVMetadataObject *current in metadataObjects) {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]
            && [current.type isEqualToString:AVMetadataObjectTypeQRCode])
        {
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *) current stringValue];
            
            [self stopScanning];
            
            if (_delegate && [_delegate respondsToSelector:@selector(cj_codeReader:didScanResult:)]) {
                [_delegate cj_codeReader:self didScanResult:scannedResult];
            }
            
            break;
        }
    }
}


@end
