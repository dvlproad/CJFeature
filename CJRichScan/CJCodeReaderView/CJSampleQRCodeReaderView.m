//
//  CJSampleQRCodeReaderView.m
//  CJRichScanDemo
//
//  Created by ciyouzen on 2017/3/16.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJSampleQRCodeReaderView.h"

@implementation CJSampleQRCodeReaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self improveInterface];
        
        __weak typeof(self)weakSelf = self;
        self.drawRectCompleteBlock = ^(CJBaseCodeReaderView *qrCodeReaderView) {
            [weakSelf setupConstains];
            
            [weakSelf setNeedsLayout];
            [weakSelf layoutIfNeeded];
            
            [weakSelf startScanning];
        };
    }
    return self;
}

- (void)improveInterface {
    UIImageView *cornerImageView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
    cornerImageView1.image = [UIImage imageNamed:@"cjScannerCornerTopLeft"];
    [self addSubview:cornerImageView1];
    _cornerImageView1 = cornerImageView1;
    
    UIImageView *cornerImageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
    cornerImageView2.image = [UIImage imageNamed:@"cjScannerCornerTopRight"];
    [self addSubview:cornerImageView2];
    _cornerImageView2 = cornerImageView2;
    
    UIImageView *cornerImageView3 = [[UIImageView alloc] initWithFrame:CGRectZero];
    cornerImageView3.image = [UIImage imageNamed:@"cjScannerCornerBottomLeft"];
    [self addSubview:cornerImageView3];
    _cornerImageView3 = cornerImageView3;
    
    UIImageView *cornerImageView4 = [[UIImageView alloc] initWithFrame:CGRectZero];
    cornerImageView4.image = [UIImage imageNamed:@"cjScannerCornerBottomRight"];
    [self addSubview:cornerImageView4];
    _cornerImageView4 = cornerImageView4;
    
    _scanLineImageView = [[UIImageView alloc] init];
    _scanLineImageView.image = [UIImage imageNamed:@"cjScannerScanLine"];
    [self addSubview:_scanLineImageView];
    
    
    UILabel *scanResultLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    scanResultLabel.backgroundColor = [UIColor clearColor];
    scanResultLabel.text = @"扫描结果:scanResult";
    scanResultLabel.textColor = [UIColor whiteColor];
    scanResultLabel.font = [UIFont systemFontOfSize:13];
    scanResultLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:scanResultLabel];
    _scanResultLabel = scanResultLabel;
    
    UILabel *scanStatusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    scanStatusLabel.backgroundColor = [UIColor lightGrayColor];
    scanStatusLabel.numberOfLines = 0;
    scanStatusLabel.text = @"当前网络不可用\n请检查网络设置";
    scanStatusLabel.textColor = [UIColor whiteColor];
    scanStatusLabel.font = [UIFont systemFontOfSize:20];
    scanStatusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:scanStatusLabel];
    _scanStatusLabel = scanStatusLabel;
    
    UILabel *scanPromptLabel = [[UILabel alloc] init];
    scanPromptLabel.backgroundColor = [UIColor clearColor];
    scanPromptLabel.text = @"将二维码放入框内 即可自动扫描";
    scanPromptLabel.textColor = [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];  //#bfbfbf;
    scanPromptLabel.font = [UIFont systemFontOfSize:15];
    scanPromptLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:scanPromptLabel];
    _scanPromptLabel = scanPromptLabel;
}


- (void)setupConstains {
    CGFloat scanWindowWidth = CGRectGetWidth(self.innerViewRect);
    CGFloat scanWindowHeight = CGRectGetHeight(self.innerViewRect);
    CGFloat scanWindowMinX = CGRectGetMinX(self.innerViewRect);
    CGFloat scanWindowMinY = CGRectGetMinY(self.innerViewRect);
    
    //cornerImageView
    CGFloat cornerWidth = 16;
    CGFloat cornerOffset = 3;
    CGFloat cornerImageMinX = scanWindowMinX - cornerOffset;
    CGFloat cornerImageMinY = scanWindowMinY - cornerOffset;
    CGFloat cornerImageMaxX = scanWindowMinX + scanWindowWidth - (cornerWidth-cornerOffset);
    CGFloat cornerImageMaxY = scanWindowMinY + scanWindowHeight - (cornerWidth-cornerOffset);
    
    CGRect cornerImageViewRect1 = CGRectMake(cornerImageMinX, cornerImageMinY, cornerWidth, cornerWidth);
    CGRect cornerImageViewRect2 = CGRectMake(cornerImageMaxX, cornerImageMinY, cornerWidth, cornerWidth);
    CGRect cornerImageViewRect3 = CGRectMake(cornerImageMinX, cornerImageMaxY, cornerWidth, cornerWidth);
    CGRect cornerImageViewRect4 = CGRectMake(cornerImageMaxX, cornerImageMaxY, cornerWidth, cornerWidth);
    
    [_cornerImageView1 setFrame:cornerImageViewRect1];
    [_cornerImageView2 setFrame:cornerImageViewRect2];
    [_cornerImageView3 setFrame:cornerImageViewRect3];
    [_cornerImageView4 setFrame:cornerImageViewRect4];
    
    //scanLineImageView
    CGFloat imageViewLineMinX = 0;
    CGFloat imageViewLineMinY = CGRectGetMinY(self.innerViewRect);
    CGFloat imageViewLineWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat imageViewLineHeight = 12;
    _scanLineImageView.frame = CGRectMake(imageViewLineMinX, imageViewLineMinY, imageViewLineWidth, imageViewLineHeight);
    
    //scanResultLabel
    CGFloat scanResultLabelWidth = [[UIScreen mainScreen] bounds].size.width;
    CGRect scanResultLabelRect = CGRectMake(0, CGRectGetMinY(self.innerViewRect) - 50, scanResultLabelWidth, 30);
    [_scanResultLabel setFrame:scanResultLabelRect];
    
    //scanStatusLabel
    CGRect scanStatusLabelRect = CGRectMake(CGRectGetMinX(self.innerViewRect),
                                            CGRectGetMinY(self.innerViewRect),
                                            CGRectGetWidth(self.innerViewRect),
                                            CGRectGetHeight(self.innerViewRect));
    [_scanStatusLabel setFrame:scanStatusLabelRect];
    
    //scanPromptLabel
    CGFloat scanPromptLabelWidth = [[UIScreen mainScreen] bounds].size.width;
    CGRect scanPromptLabelRect = CGRectMake(0, CGRectGetMaxY(self.innerViewRect) + 19, scanPromptLabelWidth, 15);
    [_scanPromptLabel setFrame:scanPromptLabelRect];
}


- (void)startScanning {
    if(_scanTimer) {
        [_scanTimer invalidate];
        _scanTimer = nil;
    }
    
    [self scanLineAnimate];
    _scanTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scanLineAnimate) userInfo:nil repeats:YES];
//    [_scanTimer fire];
//    NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(scanLineAnimate) userInfo:nil repeats:YES];
//    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0] interval:1 target:self selector:@selector(scanLineAnimate) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//    [timer fire];
//    _scanTimer = timer;
}

- (void)stopScanning {
    if(_scanTimer) {
        [_scanTimer invalidate];
        _scanTimer = nil;
    }
}

- (void)pauseScanning {
    if(_scanTimer) {
        [_scanTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)continueScanning {
    if(_scanTimer) {
        [_scanTimer setFireDate:[NSDate date]];
    } else {
        [self scanLineAnimate];
        _scanTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scanLineAnimate) userInfo:nil repeats:YES];
    }
}

- (void)scanLineAnimate {
    CGFloat imageViewLineMinX = 0;
    CGFloat imageViewLineMinY = CGRectGetMinY(self.innerViewRect);
    CGFloat imageViewLineMaxY = CGRectGetMaxY(self.innerViewRect) - 6;
    CGFloat imageViewLineWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat imageViewLineHeight = 12;
    
    _scanLineImageView.frame = CGRectMake(imageViewLineMinX, imageViewLineMinY, imageViewLineWidth, imageViewLineHeight);
    __weak typeof(self.scanLineImageView)weak_scanLineImageView = self.scanLineImageView;
    [UIView animateWithDuration:2 animations:^{
        weak_scanLineImageView.frame = CGRectMake(imageViewLineMinX, imageViewLineMaxY, imageViewLineWidth, imageViewLineHeight);
    }];
}

/*
//更新 scanResultString 的例子
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
//*/

@end
