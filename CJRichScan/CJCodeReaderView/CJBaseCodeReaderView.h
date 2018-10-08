//
//  CJBaseCodeReaderView.h
//  CJRichScanDemo
//
//  Created by ciyouzen on 2017/3/16.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJBaseCodeReaderView : UIView {
    
}
@property (nonatomic, copy) void (^drawRectCompleteBlock)(CJBaseCodeReaderView *qrCodeReaderView);
@property (nonatomic, assign) CGRect innerViewRect;

- (instancetype)initWithOtherLayerColor:(UIColor *)otherLayerColor;

@end
