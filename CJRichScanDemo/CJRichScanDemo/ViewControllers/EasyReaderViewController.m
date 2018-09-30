//
//  EasyReaderViewController.m
//  CJRichScanDemo
//
//  Created by ciyouzen on 2017/3/16.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "EasyReaderViewController.h"
#import "CJBaseCodeReaderView.h"

@interface EasyReaderViewController () {
    
}
@property (nonatomic, strong) CJBaseCodeReaderView *qrCodeReaderView;

@end

@implementation EasyReaderViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    
    CJBaseCodeReaderView *qrCodeReaderView = [[CJBaseCodeReaderView alloc] initWithOtherLayerColor:[UIColor greenColor]];
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
