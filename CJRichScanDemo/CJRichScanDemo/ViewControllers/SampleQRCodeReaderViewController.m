//
//  SampleQRCodeReaderViewController.m
//  CJRichScanDemo
//
//  Created by ciyouzen on 2017/3/16.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "SampleQRCodeReaderViewController.h"
#import "CJSampleQRCodeReaderView.h"

@interface SampleQRCodeReaderViewController () {
    
}
@property (nonatomic, strong) CJSampleQRCodeReaderView *qrCodeReaderView;

@end

@implementation SampleQRCodeReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor greenColor];
    
    CJSampleQRCodeReaderView *qrCodeReaderView = [[CJSampleQRCodeReaderView alloc] init];
    [self.view addSubview:qrCodeReaderView];
    [qrCodeReaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.qrCodeReaderView = qrCodeReaderView;
    
//    [self.qrCodeReaderView startScanning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self.qrCodeReaderView startScanning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
//    [self.qrCodeReaderView startScanning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
