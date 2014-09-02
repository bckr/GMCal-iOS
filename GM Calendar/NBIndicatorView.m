//
//  NBClassIndicatorView.m
//  GM Calendar
//
//  Created by Nils Becker on 2/19/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBIndicatorView.h"

@implementation NBIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        [self setupLayer];
    }
    return self;
}

- (void)setupLayer
{
    self.textLayer = [CATextLayer layer];
    self.textLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.textLayer.foregroundColor = [UIColor whiteColor].CGColor;
    
    self.textLayer.font = (__bridge CFTypeRef)([UIFont fontWithName:@"HelveticaNeue" size:12.0].fontName);
    self.textLayer.fontSize = 12.0;
    self.textLayer.alignmentMode = kCAAlignmentCenter;
    self.textLayer.contentsScale = [[UIScreen mainScreen] scale];
    
    [self.layer addSublayer:self.textLayer];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self.color set];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [path fill];

    self.textLayer.frame = self.frame;
    self.textLayer.position = CGPointMake(10, 13);
    self.textLayer.string = self.text;
}

@end
