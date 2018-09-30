//
//  CJCodeReaderViewController.h
//  CJRichScanDemo
//
//  Created by ciyouzen on 2017/3/16.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>

@class CJCodeReaderViewController;
@protocol CJCodeReaderViewControllerDelegate <NSObject>

@optional
- (void)cj_codeReaderViewController:(CJCodeReaderViewController *)codeReaderViewController didScanResult:(NSString *)result;

@end



@interface CJCodeReaderViewController : UIViewController {
    
}
@property (nonatomic, weak) id<CJCodeReaderViewControllerDelegate> delegate;

@property (nonatomic, strong) UIView *readerView;


+ (BOOL)isAvailable;

- (void)addReaderView:(UIView *)readerView;

- (void)chooseAlbum;
- (void)switchDeviceInput;

- (void)startScanning;

- (void)stopScanning;

@end
