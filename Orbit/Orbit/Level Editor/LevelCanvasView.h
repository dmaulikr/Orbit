//
//  LevelCanvasView.h
//  Orbit
//
//  Created by Ken Hung on 4/7/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelData.h"
#import "LevelObject.h"

@interface LevelCanvasView : UIView

@property (nonatomic, assign) LevelObjectType currentType;
@property (nonatomic, assign) CGRect currentRect;

@property (nonatomic, assign) CGPoint lastTouchPoint;
@property (nonatomic, assign) CGFloat currentScale;

@property (nonatomic, retain) UIPinchGestureRecognizer * pinchGesture;
@property (nonatomic, retain) UITapGestureRecognizer * tapGesture;

// List comes from a LevelEditor. Yes not MVC ... but ok for now.
@property (nonatomic, assign) NSMutableArray * drawList;

@property (nonatomic, assign) LevelObject * currentEditObject;

@property (nonatomic, assign) UIBarButtonItem * coordinateLabel;

- (void) refreshDisplay;
@end
