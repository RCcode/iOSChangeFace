/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>

@interface UIBezierPath (Points)
@property (nonatomic, readonly) NSMutableArray *points;
@property (nonatomic, readonly) NSArray *bezierElements;
@property (nonatomic, readonly) CGFloat length;

- (NSMutableArray *)points;
- (CGPoint) pointAtPercent: (CGFloat) percent withSlope: (CGPoint *) slope;
+ (UIBezierPath *) pathWithPoints: (NSArray *) points;
+ (UIBezierPath *) pathWithElements: (NSArray *) elements;
@end
