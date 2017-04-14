//
//  ProceduralGenerator.h
//  Orbit
//
//  Created by Ken Hung on 5/11/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProceduralGenerator : NSObject {

}

@property (nonatomic, assign) NSInteger minimumWidth, minimumHeight;

@property (nonatomic, assign) CGSize wallSize;

- (NSMutableArray *) generateWall;
@end
