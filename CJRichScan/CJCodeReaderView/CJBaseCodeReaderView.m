//
//  CJBaseCodeReaderView.m
//  CJRichScanDemo
//
//  Created by ciyouzen on 2017/3/16.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJBaseCodeReaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface CJBaseCodeReaderView () {
    CAShapeLayer *_layerTop;
    CAShapeLayer *_layerLeft;
    CAShapeLayer *_layerRight;
    CAShapeLayer *_layerBottom;
}
@property (nonatomic, strong) CAShapeLayer *overlay;

@end



@implementation CJBaseCodeReaderView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self addOverlay];
    
        [self addOtherLayerWithColor:[UIColor blackColor]];
  }
  
  return self;
}

- (instancetype)initWithOtherLayerColor:(UIColor *)otherLayerColor {
    self = [super init];
    if (self) {
        [self addOverlay];
        
        [self addOtherLayerWithColor:otherLayerColor ? otherLayerColor : [UIColor blackColor]];
    }
    return self;
}

#pragma mark - Private Methods
- (void)addOverlay {
    _overlay = [[CAShapeLayer alloc] init];
    _overlay.backgroundColor = [UIColor redColor].CGColor;
    _overlay.fillColor       = [UIColor clearColor].CGColor;
    _overlay.strokeColor     = [UIColor lightGrayColor].CGColor;
    _overlay.lineWidth       = 1;
    _overlay.lineDashPattern = @[@50,@0];
    _overlay.lineDashPhase   = 1;
    _overlay.opacity         = 0.5;
    [self.layer addSublayer:_overlay];
}

- (void)addOtherLayerWithColor:(UIColor *)color {
    CAShapeLayer *layerTop   = [[CAShapeLayer alloc] init];
    layerTop.fillColor       = color.CGColor;
    layerTop.opacity         = 0.5;
    [self.layer addSublayer:layerTop];
    _layerTop = layerTop;
    
    CAShapeLayer *layerLeft   = [[CAShapeLayer alloc] init];
    layerLeft.fillColor       = color.CGColor;
    layerLeft.opacity         = 0.5;
    [self.layer addSublayer:layerLeft];
    _layerLeft = layerLeft;
    
    CAShapeLayer *layerRight   = [[CAShapeLayer alloc] init];
    layerRight.fillColor       = color.CGColor;
    layerRight.opacity         = 0.5;
    [self.layer addSublayer:layerRight];
    _layerRight = layerRight;
    
    CAShapeLayer *layerBottom   = [[CAShapeLayer alloc] init];
    layerBottom.fillColor       = color.CGColor;
    layerBottom.opacity         = 0.5;
    [self.layer addSublayer:layerBottom];
    _layerBottom = layerBottom;
}

- (void)drawRect:(CGRect)rect
{
    CGRect innerRect = CGRectInset(rect, 50, 50);
    
    CGFloat minSize = MIN(innerRect.size.width, innerRect.size.height);
    if (innerRect.size.width != minSize) {
        innerRect.origin.x   += (innerRect.size.width - minSize) / 2;
        innerRect.size.width = minSize;
    }
    else if (innerRect.size.height != minSize) {
        innerRect.origin.y    += (innerRect.size.height - minSize) / 2;
        innerRect.size.height = minSize;
    }
    
    CGRect offsetRect = CGRectOffset(innerRect, 0, 15);
    
    _innerViewRect = offsetRect;
    
    _overlay.path = [UIBezierPath bezierPathWithRect:offsetRect].CGPath;
    
    [self setupConstainsForOtherLayerByInnerViewRect:offsetRect];
    
    if (self.drawRectCompleteBlock) {
        self.drawRectCompleteBlock(self);
    }
}


- (void)setupConstainsForOtherLayerByInnerViewRect:(CGRect)innerViewRect {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGRect topRect = CGRectMake(0, 0, width, innerViewRect.origin.y);
    CGRect leftRect = CGRectMake(0, innerViewRect.origin.y, 50, height);
    CGRect rightRect = CGRectMake(width - 50, innerViewRect.origin.y, 50, height);
    CGRect bottomRect = CGRectMake(50, innerViewRect.origin.y + innerViewRect.size.height, width - 100, height - innerViewRect.origin.y - innerViewRect.size.height);
    
    _layerTop.path  = [UIBezierPath bezierPathWithRect:topRect].CGPath;
    _layerLeft.path = [UIBezierPath bezierPathWithRect:leftRect].CGPath;
    _layerRight.path = [UIBezierPath bezierPathWithRect:rightRect].CGPath;
    _layerBottom.path = [UIBezierPath bezierPathWithRect:bottomRect].CGPath;
}


@end
