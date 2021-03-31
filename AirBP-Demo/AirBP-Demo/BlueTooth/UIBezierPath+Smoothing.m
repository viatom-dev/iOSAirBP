//
//  UIBezierPath+Smoothing.m
//  BP
//
//  Created by yangweichao on 2018/6/29.
//  Copyright © 2018 Viatom. All rights reserved.
//

#import "UIBezierPath+Smoothing.h"

#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]

#define VALUE(_INDEX_) [NSValue valueWithCGPoint:points[_INDEX_]]

@implementation UIBezierPath (Smoothing)

- (UIBezierPath *)smoothedPathWithGranularity:(int)granularity
{
    NSMutableArray *points = [pointsFromBezierPath(self) mutableCopy];
    // Add control points to make the math make sense
    UIBezierPath *smoothedPath = [self copy];

    [points insertObject:[points objectAtIndex:0] atIndex:0];
    [points addObject:[points lastObject]];

    [smoothedPath removeAllPoints];
    [smoothedPath moveToPoint:POINT(0)];

    for (int index = 3; index < points.count; index ++) {

        CGPoint p0 = POINT(index - 3);
        CGPoint p1 = POINT(index - 2);
        CGPoint p2 = POINT(index - 1);
        CGPoint p3 = POINT(index);

        if (p0.x > p1.x ) {
            [smoothedPath moveToPoint:p1];
        }else{
            if (p1.x > p2.x) {
                [smoothedPath moveToPoint:p2];
            }else{
                if (p2.x > p3.x) {
                    [smoothedPath moveToPoint:p3];
                }else{
                    for (int i = 1; i < granularity; i++) {
                        float t = (float)i * (1.0 / granularity);
                        float tt = t * t;
                        float ttt = tt * t;

                        CGPoint pi;
                        pi.x = 0.5 * (2 * p1.x +(p2.x - p0.x) * t +(2 * p0.x - 5 * p1.x + 4 *p2.x - p3.x) * tt + (3 * p1.x - p0.x - 3 *p2.x + p3.x) *ttt );
                        pi.y = 0.5 * (2 * p1.y +(p2.y - p0.y) * t +(2 * p0.y - 5 * p1.y + 4 *p2.y - p3.y) * tt + (3 * p1.y - p0.y - 3 *p2.y + p3.y) *ttt );
                        [smoothedPath addLineToPoint:pi];
                    }
                    // Now add p2
                    [smoothedPath addLineToPoint:p2];
                }
            }
        }
    }
    if (POINT(points.count - 1).x < POINT(points.count -2).x) {
        [smoothedPath moveToPoint:POINT(points.count - 1)];
    }else{
        [smoothedPath addLineToPoint:POINT(points.count - 1)];
    }
    return smoothedPath;
}

// Get points from Bezier Curve
void getPointsFromBezier(void *info,const CGPathElement *element){
    
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    
    // Retrieve the path element type and its points
    CGPathElementType type = element->type;
    CGPoint *points = element->points;
    
    // Add the points if they're available (per type)
    if (type != kCGPathElementCloseSubpath) {
        
        [bezierPoints addObject:VALUE(0)];
        if ((type != kCGPathElementAddLineToPoint) && (type != kCGPathElementMoveToPoint)) {
            [bezierPoints addObject:VALUE(1)];
        }
    }
    
    if (type == kCGPathElementAddCurveToPoint) {
        [bezierPoints addObject:VALUE(2)];
    }
}

NSArray *pointsFromBezierPath(UIBezierPath *bpath)
{
    NSMutableArray *points = [NSMutableArray array];
    CGPathApply(bpath.CGPath, (__bridge void *)points, getPointsFromBezier);
    return points;
}

@end

