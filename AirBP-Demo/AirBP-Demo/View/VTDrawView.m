//
//  DrawView.m
//  BP
//
//  Created by yangweichao on 2018/6/8.
//  Copyright © 2018 Viatom. All rights reserved.
//

#import "VTDrawView.h"
#import "UIBezierPath+Smoothing.h"

#define POINT(_INDEX_) [(NSValue *)[self.pointArray objectAtIndex:_INDEX_] CGPointValue]
@interface VTDrawView ()
{
    CGFloat _pointSpace;         //X distance between two waveform points
    CGFloat _totalWidth;         //Total width drawn
    CGFloat _totalHeight;        //Total height drawn
    NSInteger _pointCount;       //Total number of points drawn
    CGFloat _currentLocationX;   //X position of current waveform point
}
@property (nonatomic, retain) UIBezierPath *path; //path
@property (nonatomic, retain) CAShapeLayer *shape; //shape
@property (nonatomic, strong) NSMutableArray *midArray; //mid array
@property (nonatomic, strong) NSMutableArray *pointArray; //Coordinate data pool

@end

@implementation VTDrawView


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        //Approximately 3~4 pulse waves (wave crests) are displayed on each screen
        if (IS_IPHONE_MIN) {
            _pointSpace = 4;
        }else if (IS_IPHONE_PLUS){
            _pointSpace = 5.5;
        }else if(IS_IPAD){
            
            if (IS_IPAD_PRO_9) {
                _pointSpace = 11;
            }else if(IS_IPAD_PRO_10){
                _pointSpace = 11.5;
            }else if(IS_IPAD_PRO_12){
                _pointSpace = 12.5;
            }else{
                _pointSpace = 9.5;
            }
            
        }else{//iphone 6、7、8、X
            _pointSpace = 5;
        }
        
        _currentLocationX = 0;
        _totalHeight = self.frame.size.height;
        _totalWidth = self.frame.size.width;
        _pointCount = (NSInteger)_totalWidth / _pointSpace;
        
        _pointArray = [NSMutableArray array];
        _realTimeDataArr = [NSMutableArray array];

        self.path = [UIBezierPath bezierPath];
    }
    
    return self;
}

#pragma mark - Ready to refresh the pulse wave
- (void)prepareToRefreshPW{
    if (self.realTimeDataArr.count >= 1) {//The constant indicates how many points are drawn together
        self.midArray = [NSMutableArray arrayWithArray:self.realTimeDataArr];
        [self.realTimeDataArr removeAllObjects];
        
        [self shape];
        [self startToRefreshPW];
    }
}

#pragma mark -  init CAShapeLayer
- (CAShapeLayer *)shape{
    if (!_shape) {
        _shape = [[CAShapeLayer alloc] init];        
        _shape.frame = self.bounds;
        _shape.masksToBounds = true;//Do not display out of range
        _shape.lineCap = kCALineCapRound;//End style
        _shape.lineJoin = kCALineJoinRound;//Inflection point style
        
        _shape.strokeColor = RGBA(125, 191, 59, 1).CGColor;
        _shape.fillColor = [UIColor clearColor].CGColor;//filling
        _shape.fillMode = kCAFillModeBoth;
        _shape.fillRule = kCAFillRuleEvenOdd;
        _shape.lineWidth = 3.0f;
        [self.layer addSublayer:_shape];
    }

    return _shape;
}

#pragma mark - Start refreshing the pulse wave
- (void)startToRefreshPW
{
    if (self.midArray.count == 0) {
        return;
    }

    //Convert newly added data to points to be newly drawn
    for (int i = 0; i < self.midArray.count; i++) {
        // If the current position is greater than the width to be drawn, continue drawing from the starting position
        
        if (_currentLocationX > _totalWidth) {
            _currentLocationX = 0;
        }
        
        CGFloat tempY = [self.midArray[i] floatValue];
        // tempY  MAX  <4100
        CGFloat y;
        //Convert the data to the y value of the waveform
        int yinshe = 0;
        if (IS_IPHONE_MIN) {
            yinshe = 500;

        }else{
            yinshe = 550;
            
        }
        int  k = tempY-yinshe;
        if (k >= 3500) {
            k = 3500;
        }else if (k >=3400){
            
        }
        y = _totalHeight/2 + _totalHeight *k/7000 - _shape.lineWidth;//Waveform display height adjustment; Decrease the overall waveform graph moves down;
            
        //Wave point, added to the array
        CGPoint startPoint = CGPointMake(_currentLocationX,y);
        NSValue *value = [NSValue valueWithCGPoint:startPoint];
        [self.pointArray addObject:value];

        //Increase the current X position by unit distance
        _currentLocationX += _pointSpace;
    }
    
    //Leave a few dots in the gap to show the blank moving point
    if (self.pointArray.count > _pointCount - 1) {
        [self.pointArray removeObjectsInRange:NSMakeRange(0, self.pointArray.count - _pointCount + 1)];
    }
    
    //Remove all points
    [self.path removeAllPoints];
    CGPoint point = [self.pointArray[0] CGPointValue];
    [self.path moveToPoint:point];
    for (NSInteger i = 1; i < [self.pointArray count];i++) {
        if (self.pointArray[i] == nil) {
            break;
        }
        CGPoint previousPoint = [self.pointArray[i - 1] CGPointValue];  // Point in front
        CGPoint nextPoint = [self.pointArray[i] CGPointValue]; // Point behind
        //If the next point is less than the x value of the previous point, it indicates that it has returned to the starting value, do not add the line, and move the point to the origin;
        if (nextPoint.x  < previousPoint.x) {
            //Move to the starting point
            [self.path moveToPoint:nextPoint];
        } else {
            //Continue to increase the line
            [self.path addLineToPoint:nextPoint];
        }
    }
    
    //Set the path of shapeLayer
    _shape.path = [_path smoothedPathWithGranularity:20].CGPath;//The parameter indicates the roundness
}

- (void)drawRect:(CGRect)rect {
#if 0
    
    if (self.realTimeDataArr.count >= 1) {//The constant indicates how many points are drawn together
        // Assign the received data to another array
        self.midArray = [NSMutableArray arrayWithArray:self.realTimeDataArr];
        // Empty array
        [self.realTimeDataArr removeAllObjects];
    }
    
    
    CGFloat height = self.frame.size.height;
    
    // self.midArray  Each new data array added
    if (self.midArray.count == 0) {
        return;
    }
    
   
    // Convert newly added data to points to be newly drawn
    for (int i = 0; i < self.midArray.count; i++) {
        // If the current position is greater than the width to be drawn, continue drawing from the starting position
        
        if (_currentLocationX > _totalWidth) {
            _currentLocationX = 0;
        }
        
        // Get the data in the array
        CGFloat tempY = [self.midArray[i] floatValue];
        
        // Convert the data to the y value of the waveform, you don’t need to care about how to turn it, fill in the value at will, just look at it
        CGFloat y = (height/2 + height *(tempY - 1500)/2000)/1.5;
        
        // Wave point, added to the array
        CGPoint startPoint = CGPointMake(_currentLocationX,y);
        NSValue *value = [NSValue valueWithCGPoint:startPoint];
        [self.pointArray addObject:value];
        
        // Increase the current X position by unit distance
        _currentLocationX = _currentLocationX + _pointSpace;
        
    }
    
    // Leave a gap of X dots to show that blank moving point
    if (self.pointArray.count > _pointCount - 3) {
        [self.pointArray removeObjectsInRange:NSMakeRange(0, self.pointArray.count - _pointCount + 3)];
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();  // Get context
    CGPoint point = [self.pointArray[0] CGPointValue];
    CGContextMoveToPoint(ctx, point.x, point.y);  // Move to the first point
    CGContextSetLineWidth(ctx, 1);  // Set width
    for (NSInteger i = 1; i < [self.pointArray count];i++) {
        if (self.pointArray[i] == nil) {
            break;
        }
        
        CGPoint previousPoint = [self.pointArray[i - 1] CGPointValue];  // Point in front
        CGPoint nextPoint = [self.pointArray[i] CGPointValue]; // Point behind
        // If the next point is less than the x value of the previous point, it indicates that it has returned to the starting value, do not add the line, and move the point to the origin;
        if (nextPoint.x  < previousPoint.x) {
            // Move to the starting point
            CGContextMoveToPoint(ctx, nextPoint.x, nextPoint.y);
        } else {
            // Continue to increase the line
            CGContextAddLineToPoint(ctx, nextPoint.x, nextPoint.y);
        }
    }
    [[UIColor blackColor] setStroke]; // Set color
    CGContextStrokePath(ctx);  // Draw waveform
#endif
    
}

@end
