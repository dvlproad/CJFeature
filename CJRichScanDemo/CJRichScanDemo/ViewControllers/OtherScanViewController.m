//
//  OtherScanViewController.m
//  CJRichScanDemo
//
//  Created by ciyouzen on 2017/3/16.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "OtherScanViewController.h"

#import <LBXScan/LBXScanView.h>
//#import <LBXScan/LBXScanViewStyle.h>
#import "StyleDIY.h"

@interface OtherScanViewController () {
    
}
@property (nonatomic, strong) LBXScanView *qrCodeReaderView;

@end

@implementation OtherScanViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.qrCodeReaderView startScanAnimation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    LBXScanViewStyle *style = [StyleDIY qqStyle];
    LBXScanView *qrCodeReaderView = [[LBXScanView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:style];
    [self.view addSubview:qrCodeReaderView];
    [qrCodeReaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.qrCodeReaderView = qrCodeReaderView;
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
