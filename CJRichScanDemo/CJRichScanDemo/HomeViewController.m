//
//  HomeViewController.m
//  CJRichScanDemo
//
//  Created by ciyouzen on 2017/3/16.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "HomeViewController.h"

#import <CJMedia/CJValidateAuthorizationUtil.h>

#import "EasyReaderViewController.h"
#import "SampleQRCodeReaderViewController.h"
#import "OtherScanViewController.h"


#import "QRCodeReaderViewController2.h"

#import "CodeReaderToolViewController.h"

@interface HomeViewController () <CJCodeReaderViewControllerDelegate>

@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"主页";
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    //Helper
    {
        CJSectionDataModel *sectionDataModel = [[CJSectionDataModel alloc] init];
//        sectionDataModel.theme = @"CJHelper";
//        {
//            CJModuleModel *helperModule = [[CJModuleModel alloc] init];
//            helperModule.title = @"测试QRCodeReaderView1";
//            helperModule.classEntry = [EasyReaderViewController class];
//            [sectionDataModel.values addObject:helperModule];
//        }
//        {
//            CJModuleModel *helperModule = [[CJModuleModel alloc] init];
//            helperModule.title = @"QRCodeReaderView2";
//            helperModule.classEntry = [SampleQRCodeReaderViewController class];
//            [sectionDataModel.values addObject:helperModule];
//        }
//        {
//            CJModuleModel *helperModule = [[CJModuleModel alloc] init];
//            helperModule.title = @"QRCodeReaderView3";
//            helperModule.classEntry = [OtherScanViewController class];
//            [sectionDataModel.values addObject:helperModule];
//        }
//        {
//            CJModuleModel *helperModule = [[CJModuleModel alloc] init];
//            helperModule.title = @"RichScan(扫一扫)";
//            helperModule.content = @"扫一扫";
//            helperModule.selector = @selector(scanReader2Action);
//            [sectionDataModel.values addObject:helperModule];
//        }
//
        {
            CJModuleModel *helperModule = [[CJModuleModel alloc] init];
            helperModule.title = @"CodeReaderTool(扫一扫工具)";
            helperModule.content = @"扫一扫工具";
            helperModule.selector = @selector(goCodeReaderToolViewController);
            [sectionDataModel.values addObject:helperModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    
    self.sectionDataModels = sectionDataModels;
}


- (void)scanReader2Action {
    BOOL enable = [CJValidateAuthorizationUtil checkEnableForDeviceComponentType:CJDeviceComponentTypeCamera inViewController:self];
    if (!enable) {
        return;
    }
    
    QRCodeReaderViewController2 *reader = [QRCodeReaderViewController2 new];
    reader.modalPresentationStyle = UIModalPresentationFormSheet;

    [self.navigationController pushViewController:reader animated:YES];
}

- (void)goCodeReaderToolViewController {
    BOOL enable = [CJValidateAuthorizationUtil checkEnableForDeviceComponentType:CJDeviceComponentTypeCamera inViewController:self];
    if (!enable) {
        return;
    }
    
    CodeReaderToolViewController *reader = [CodeReaderToolViewController new];
    reader.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self.navigationController pushViewController:reader animated:YES];
}


#pragma mark - CJCodeReaderViewControllerDelegate
- (void)cj_codeReaderViewController:(CJCodeReaderViewController *)codeReaderViewController didScanResult:(NSString *)result
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
