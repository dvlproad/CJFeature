//
//  CodeReaderToolViewController.m
//  CJRichScanDemo
//
//  Created by ciyouzen on 2017/3/16.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CodeReaderToolViewController.h"

#import "BBXBusQRCodeReaderView.h"

#import <CJBaseUIKit/CJAlertView.h>

#import <CJBaseUtil/CJSectionDataModel.h>   //在CJDataUtil中
#import <CJBaseUtil/CJModuleModel.h>        //在CJDataUtil中

#import <CJBaseUIKit/UIButton+CJMoreProperty.h>
#import <CJBaseUIKit/CJToast.h>

@interface CodeReaderToolViewController () {

}
@property (nonatomic, strong) AVAudioPlayer        *beepPlayer;

@property (nonatomic, strong) NSMutableArray<CJSectionDataModel *> *sectionDataModels;

@end

@implementation CodeReaderToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"扫码", nil);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(chooseAlbum)];
    
    BBXBusQRCodeReaderView *readerView = [[BBXBusQRCodeReaderView alloc] init];
    readerView.scanStatusLabel.hidden = YES;
    [self.view addSubview:readerView];
    [readerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.codeReaderView = readerView;
    [self.codeReaderView.layer insertSublayer:self.codeReader.previewLayer atIndex:0];
    
    
    
    [(BBXBusQRCodeReaderView *)self.codeReaderView updateScanResultString:@""];
    
    self.delegate = self;
    
    
    NSString *wavPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:wavPath];
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    _beepPlayer = audioPlayer;
}

#pragma mark - CJCodeReaderViewControllerDelegate
- (void)cj_codeReaderViewController:(CJCodeReaderViewController *)codeReaderViewController didScanResult:(NSString *)result
{
    [self.beepPlayer play];
    
    CJSampleQRCodeReaderView *qrCodeReaderView = (CJSampleQRCodeReaderView *)codeReaderViewController.codeReaderView;
    qrCodeReaderView.scanResultLabel.text = result;
    
    [self showDebugViewWithTitle:@"扫描结果" message:result];
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf stopScanning];
        [(BBXBusQRCodeReaderView *)weakSelf.codeReaderView pauseScanning];
    });
}

- (void)continueScanning {
    ((CJSampleQRCodeReaderView *)self.codeReaderView).scanResultLabel.text = @"";
    
    [self startScanning];
    [(CJSampleQRCodeReaderView *)self.codeReaderView startScanning];
}

- (void)qrCodeReaderViewController_DidCancel:(CJCodeReaderViewController *)reader {
    [self.navigationController popViewControllerAnimated:YES];
}


/* 完整的描述请参见文件头部 */
- (void)showDebugViewWithTitle:(NSString *)title message:(NSString *)message
{
    CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGSize popupViewSize = CGSizeMake(screenWidth * 0.9, 200);
    CJAlertView *alertView = [[CJAlertView alloc] initWithSize:popupViewSize firstVerticalInterval:10 secondVerticalInterval:10 thirdVerticalInterval:0 bottomMinVerticalInterval:10];
    
    //UIImage *flagImage = [UIImage imageNamed:@"scan_icon_notice"];
    //[alertView addFlagImage:flagImage size:CGSizeMake(38, 38)];
    
    if (title.length > 0) {
        [alertView addTitleWithText:title font:[UIFont systemFontOfSize:15.0] textAlignment:NSTextAlignmentCenter margin:10 paragraphStyle:nil];
    }
    
    if (message.length > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.lineSpacing = 3;
        paragraphStyle.firstLineHeadIndent = 10;
        [alertView addMessageWithText:message font:[UIFont systemFontOfSize:15.0] textAlignment:NSTextAlignmentLeft margin:10 paragraphStyle:paragraphStyle];
        [alertView addMessageLayerWithBorderWidth:0.5 borderColor:nil cornerRadius:3];
    }
    
    

    CJSectionDataModel *sectionDataModel = [[CJSectionDataModel alloc] init];
    sectionDataModel.theme = @"扫一扫结果处理选项";
    
    {
        CJModuleModel *helperModule = [[CJModuleModel alloc] init];
        helperModule.title = NSLocalizedString(@"重新扫码", nil);
        helperModule.actionBlock = ^{
            [CJToast shortShowMessage:@"重新扫码"];
            [self continueScanning];
        };
        [sectionDataModel.values addObject:helperModule];
    }
    {
        CJModuleModel *helperModule = [[CJModuleModel alloc] init];
        helperModule.title = NSLocalizedString(@"复制到粘贴板", nil);
        helperModule.actionBlock = ^{
            //NSLog(@"调试面板:调试信息已复制到粘贴板");
            [CJToast shortShowMessage:@"已复制到粘贴板"];
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = message;
            
            [self.navigationController popViewControllerAnimated:YES];
            
        };
        [sectionDataModel.values addObject:helperModule];
    }
    
    {
        CJModuleModel *helperModule = [[CJModuleModel alloc] init];
        helperModule.title = NSLocalizedString(@"在Safari中打开", nil);
        helperModule.actionBlock = ^{
            [CJToast shortShowMessage:@"在Safari中打开"];
            
            NSURL *URL = [NSURL URLWithString:message];
            if ([[UIApplication sharedApplication] canOpenURL:URL]) {
                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
                    [[UIApplication sharedApplication] openURL:URL];
                } else {
                    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
                }
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        };
        [sectionDataModel.values addObject:helperModule];
    }
    
    {
        CJModuleModel *helperModule = [[CJModuleModel alloc] init];
        helperModule.title = NSLocalizedString(@"退出", nil);
        helperModule.actionBlock = ^{
            [CJToast shortShowMessage:@"点击了退出按钮"];
            [self.navigationController popViewControllerAnimated:YES];
        };
        [sectionDataModel.values addObject:helperModule];
    }
    
    UIColor *lineColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1]; //#e5e5e5
    UIColor *cancelTitleColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1]; //#888888
    UIColor *okTitleColor = [UIColor colorWithRed:66/255.0 green:135/255.0 blue:255/255.0 alpha:1]; //#4287ff
    
    NSMutableArray *choiceButtons = [[NSMutableArray alloc] init];
    for (CJModuleModel *choiceModel in sectionDataModel.values) {
        UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [okButton setBackgroundColor:[UIColor clearColor]];
        [okButton setTitle:choiceModel.title forState:UIControlStateNormal];
        [okButton setTitleColor:okTitleColor forState:UIControlStateNormal];
        [okButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [okButton setCjTouchUpInsideBlock:^(UIButton *button) {
            [alertView dismissWithDelay:0];
            [self execModuleModel:choiceModel];
        }];
        [choiceButtons addObject:okButton];
    }
    
    [alertView addBottomButtons:choiceButtons withActionButtonHeight:44 bottomInterval:10 leftOffset:10 rightOffset:10 buttonHandle:^(NSInteger index) {
//        CJModuleModel *choiceModel = sectionDataModel.values[index];
//        [self execModuleModel:choiceModel];
    }];
    
    UIColor *blankBGColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.6];
    [alertView showWithShouldFitHeight:YES blankBGColor:blankBGColor];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"didSelectRowAtIndexPath = %zd %zd", indexPath.section, indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CJSectionDataModel *sectionDataModel = [self.sectionDataModels objectAtIndex:indexPath.section];
    NSArray *dataModels = sectionDataModel.values;
    CJModuleModel *moduleModel = [dataModels objectAtIndex:indexPath.row];
    
    [self execModuleModel:moduleModel];
}


- (void)execModuleModel:(CJModuleModel *)moduleModel {
    if (moduleModel.actionBlock) {
        moduleModel.actionBlock();
        
    } else if (moduleModel.selector) {
        [self performSelectorOnMainThread:moduleModel.selector withObject:nil waitUntilDone:NO];
        
    } else {
        UIViewController *viewController = nil;
        Class classEntry = moduleModel.classEntry;
        NSString *clsString = NSStringFromClass(moduleModel.classEntry);
        if ([clsString isEqualToString:NSStringFromClass([UIViewController class])]) {
            viewController = [[classEntry alloc] init];
            viewController.view.backgroundColor = [UIColor whiteColor];
            
        } else {
            if (moduleModel.isCreateByXib) {
                viewController = [[classEntry alloc] initWithNibName:clsString bundle:nil];
            } else {
                viewController = [[classEntry alloc] init];
            }
        }
        
        viewController.title = NSLocalizedString(moduleModel.title, nil);
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


@end
