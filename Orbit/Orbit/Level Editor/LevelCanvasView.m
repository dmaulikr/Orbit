//
//  LevelCanvasView.m
//  Orbit
//
//  Created by Ken Hung on 4/7/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "LevelCanvasView.h"
#import "LevelEditor.h"

@interface LevelCanvasView () 
    - (void) drawObjectInContext: (CGContextRef) context objectType: (LevelObjectType) type rect: (CGRect) dimension;
@end

@implementation LevelCanvasView
@synthesize currentType, lastTouchPoint, currentScale, currentRect, drawList, pinchGesture, tapGesture, currentEditObject, coordinateLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        self.clearsContextBeforeDrawing = YES;
        self.opaque = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        // Set by LevelEditorViewController
        self.currentType = LEVEL_OBJECT_NONE;
        
        self.currentScale = 1.0;
        
        self.coordinateLabel = nil;
        
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget: self action: @selector(handleGesture:)];
        self.pinchGesture.cancelsTouchesInView = YES;
        [self addGestureRecognizer: self.pinchGesture];
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleGesture:)];
        self.tapGesture.numberOfTapsRequired = 2;
        self.tapGesture.cancelsTouchesInView = YES;
        [self addGestureRecognizer: self.tapGesture];
    }
    return self;
}

- (void) handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        UIPinchGestureRecognizer * pinch = (UIPinchGestureRecognizer*)gestureRecognizer;
        
        if (pinch.state == UIGestureRecognizerStateChanged) {
            NSLog(@"zooming scale: %f", pinch.scale);
            self.currentScale = pinch.scale;
            [self refreshDisplay];
        }
    } else if ([gestureRecognizer isKindOfClass: [UITapGestureRecognizer class]]) {
        UITapGestureRecognizer * tap = (UITapGestureRecognizer *)gestureRecognizer;
        
        if (tap.state == UIGestureRecognizerStateEnded) {
            CGPoint pt = [tap locationInView: self];
            NSLog(@"Tapped at: (%f, %f)", pt.x, pt.y);

            NSArray * list =  [LevelEditor collisionWithObjects:self.drawList againstPoint:pt];
            //    NSLog(@"%@", [obj description]);
                if (list && [list count] > 0)
                    self.currentEditObject = [list objectAtIndex: 0];
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // get the initial context
    CGContextRef context = UIGraphicsGetCurrentContext();
    // save the current state, as we'll overwrite this
    CGContextSaveGState(context);
#if 0
    /*
     draw a line across the top of the view
     */
    // move the pen to the starting point
    CGContextMoveToPoint(context, 10, 10);
    // draw a line to another point
    CGContextAddLineToPoint(context, 290, 10);
    
    /*
     draw a rectangle just below, with a stroke on the outside.
     */
    CGContextAddRect(context, CGRectMake(10, 20, 280, 30));
    
    /*
     write the previous to the context then
     change the colour to blue and the stroke to 2px.
     */
    CGContextStrokePath(context);
    CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);
    CGContextSetLineWidth(context, 2);
    
    /*
     draw a circle filling most of the rest of the box.
     */
    CGContextAddEllipseInRect(context, CGRectMake(50, 70, 200, 200));
#endif
    // Set black background
    CGContextSetRGBFillColor(context, 0.0,0.0,0.0,1);
    CGContextFillRect(context, rect);
    
    // TEMP: edit mode checking
    if (self.tapGesture.isEnabled) {
        CGRect rect = self.currentEditObject.objectDimension;
        NSInteger radius = rect.size.width / 2;
        
        if (self.currentEditObject)
            self.currentEditObject.objectDimension = CGRectMake(self.lastTouchPoint.x - radius, self.lastTouchPoint.y - radius, radius * 2, radius * 2);
    }
    
    // Draw existing (saved) objects
    for (LevelObject * obj in self.drawList) {
        [self drawObjectInContext: context objectType: obj.objectType rect: obj.objectDimension];
    }
    
    // TEMP: edit mode checking
    if (!self.tapGesture.isEnabled) {
        // Draw currently selected object
        NSInteger radius = 100;
        radius *= self.currentScale;
        CGRect newRect = CGRectMake(self.lastTouchPoint.x - radius, self.lastTouchPoint.y - radius, radius * 2, radius * 2);    
        [self drawObjectInContext: context objectType: self.currentType rect: newRect];
        
        self.currentRect = newRect;
    }

    // do the actual drawing
    CGContextStrokePath(context);
    // restore the state back after drawing on it.
    CGContextRestoreGState(context);
}

- (void) drawObjectInContext: (CGContextRef) context objectType: (LevelObjectType) type rect: (CGRect) dimension {
    switch (type) {
        case LEVEL_OBJECT_CIRCLE:
            CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);
            CGContextAddEllipseInRect(context, dimension);
            CGContextStrokePath(context);
            break;
        case LEVEL_OBJECT_RECT:
            CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
            CGContextAddRect(context, dimension);
            CGContextStrokePath(context);
            break;
        case LEVEL_OBJECT_POLY:
            
            break;
        default:
            break;
    }
}

- (void) refreshDisplay {
    [self setNeedsDisplay];
}
                         
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView: self];
    
    NSLog(@"touch began %f %f num touch %d", touchPoint.x, touchPoint.y, [touches count]);
    
    if ([touches count] == 1) {
        self.lastTouchPoint = touchPoint;
        if (self.coordinateLabel) self.coordinateLabel.title = [NSString stringWithFormat:@"%.2f,%.2f", touchPoint.x, touchPoint.y];
        [self refreshDisplay];
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView: self];
    
 //   NSLog(@"touch moved");
    
    if ([touches count] == 1) {
        self.lastTouchPoint = touchPoint;
        if (self.coordinateLabel) self.coordinateLabel.title = [NSString stringWithFormat:@"%.2f,%.2f", touchPoint.x, touchPoint.y];
        [self refreshDisplay];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView: self];
    
    NSLog(@"touch ended");
    if (self.coordinateLabel) self.coordinateLabel.title = [NSString stringWithFormat:@"%.2f,%.2f", touchPoint.x, touchPoint.y];
}

- (void) dealloc {
    [self removeGestureRecognizer: self.pinchGesture];
    [self removeGestureRecognizer: self.tapGesture];
    // TODO Release tap gesture recognizers
}
@end
