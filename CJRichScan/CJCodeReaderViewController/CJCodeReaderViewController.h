//
//  CJCodeReaderViewController.h
//  CJRichScanDemo
//
//  Created by ciyouzen on 2017/3/16.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "CJCodeReader.h"

@class CJCodeReaderViewController;
@protocol CJCodeReaderViewControllerDelegate <NSObject>

@optional
- (void)cj_codeReaderViewController:(CJCodeReaderViewController *)codeReaderViewController didScanResult:(NSString *)result;

@end



@interface CJCodeReaderViewController : UIViewController {
    
}
@property (nonatomic, weak) id<CJCodeReaderViewControllerDelegate> delegate;
@property (nonatomic, strong) CJCodeReader *codeReader;
@property (nonatomic, strong) UIView *codeReaderView;
/* //子类必须做的事：在viewDidLoad中定义生成readerView
- (void)viewDidLoad {
    [super viewDidLoad];
    
    DemoQRCodeReaderView *codeReaderView = [[DemoQRCodeReaderView alloc] init];
    codeReaderView.scanStatusLabel.hidden = YES;
    [self.view addSubview:rcodeReaderView];
    [codeReaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.readerView = codeReaderView;
    
    [self.codeReaderView.layer insertSublayer:self.codeReader.previewLayer atIndex:0];
}
*/

+ (BOOL)isAvailable;

- (void)chooseAlbum;
- (void)switchDeviceInput;

- (void)startScanning;

- (void)stopScanning;

@end
