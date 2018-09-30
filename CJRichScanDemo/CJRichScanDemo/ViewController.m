//
//  ViewController.m
//  CJRichScanDemo
//
//  Created by ciyouzen on 2017/3/16.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "ViewController.h"

#import <CJMedia/CJValidateAuthorizationUtil.h>

#import "EasyReaderViewController.h"
#import "SampleQRCodeReaderViewController.h"
#import "OtherScanViewController.h"


#import "QRCodeReaderViewController2.h"

@interface ViewController () <CJCodeReaderViewControllerDelegate>

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"主页";
}

- (IBAction)testQRCodeReaderView1:(id)sender {
    EasyReaderViewController *listViewController = [[EasyReaderViewController alloc] initWithNibName:@"EasyReaderViewController" bundle:nil];
    [self.navigationController pushViewController:listViewController animated:YES];
}

- (IBAction)testQRCodeReaderView2:(id)sender {
    SampleQRCodeReaderViewController *listViewController = [[SampleQRCodeReaderViewController alloc] initWithNibName:@"SampleQRCodeReaderViewController" bundle:nil];
    [self.navigationController pushViewController:listViewController animated:YES];
}

- (IBAction)testQRCodeReaderView3:(id)sender
{
    OtherScanViewController *listViewController = [[OtherScanViewController alloc] initWithNibName:@"OtherScanViewController" bundle:nil];
    [self.navigationController pushViewController:listViewController animated:YES];
}

- (IBAction)scanReader2Action:(id)sender {
    BOOL enable = [CJValidateAuthorizationUtil checkEnableForDeviceComponentType:CJDeviceComponentTypeAlbum inViewController:self];
    if (!enable) {
        return;
    }
    
    QRCodeReaderViewController2 *reader = [QRCodeReaderViewController2 new];
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
