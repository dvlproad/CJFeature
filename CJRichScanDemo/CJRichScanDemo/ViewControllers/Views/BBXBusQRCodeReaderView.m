//
//  BBXBusQRCodeReaderView.m
//  CJRichScanDemo
//
//  Created by lichq on 2018/4/23.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "BBXBusQRCodeReaderView.h"

@implementation BBXBusQRCodeReaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        CJSampleQRCodeReaderView *qrCodeReaderView = self;
        
        UIImage *image = [UIImage imageNamed:@"scan_icon_frame"];
        qrCodeReaderView.cornerImageView1.image = image;
        qrCodeReaderView.cornerImageView1.transform = CGAffineTransformMakeRotation(M_PI);
        qrCodeReaderView.cornerImageView2.image = image;
        qrCodeReaderView.cornerImageView2.transform = CGAffineTransformMakeRotation(-M_PI/2);
        qrCodeReaderView.cornerImageView3.image = image;
        qrCodeReaderView.cornerImageView3.transform = CGAffineTransformMakeRotation(M_PI/2);
        qrCodeReaderView.cornerImageView4.image = image;
        
        qrCodeReaderView.scanPromptLabel.text = NSLocalizedString(@"将电子车票放入框内，即可自动扫描", nil);
        
        qrCodeReaderView.scanStatusLabel.hidden = YES;
    }
    return self;
}

///更新 scanResultString
- (void)updateScanResultString:(NSString *)scanResultString {
    NSRange stringRange = NSMakeRange(0, scanResultString.length);
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSFontAttributeName:           [UIFont systemFontOfSize:18],
                                 };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:scanResultString attributes:attributes];
    
    NSError *error;
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:@"\\d+" options:0 error:&error];
    if (!error && regexps != nil) {
        [regexps enumerateMatchesInString:scanResultString options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            NSRange redRange = result.range;
            
            UIColor *redColor = [UIColor colorWithRed:255/255.0 green:96/255.0 blue:57/255.0 alpha:1];  //#FF6039
            NSDictionary *redAttributes = @{NSForegroundColorAttributeName: redColor,
                                            NSFontAttributeName:           [UIFont systemFontOfSize:32],
                                            };
            [attributedString addAttributes:redAttributes range:redRange];
        }];
    }
    self.scanResultLabel.attributedText = attributedString;
}


@end
