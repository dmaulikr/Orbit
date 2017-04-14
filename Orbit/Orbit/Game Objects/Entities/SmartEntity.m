//
//  SmartEntity.m
//  Orbit
//
//  Created by Ken Hung on 6/13/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import "SmartEntity.h"
#import "WeaponEntity.h"
#import "AppUtils.h"
#import "Vector2DUtility.h"

@interface SmartEntity (Private)

@end

@implementation SmartEntity
@synthesize targetPoint = targetPoint_, lastNode = lastNode_, moveIncrement = moveIncrement_, currentNode = currentNode_, moveDistance = moveDistance_;

- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side withNode: (SKNode *) node physicsWorld: (SKPhysicsWorld *) world withStreak: (BOOL) enableStreak {
    if (self = [super initAtPosition: position onSide: side withNode: node physicsWorld: world withStreak: enableStreak]) {
        [self setKVO];
        
        self.isValid = NO;
        self.entitySide = side;
        self.entityType = ENTITY_TYPE_SMART;
        
        [self createAnimator];
        [self createSpriteAndBody];
        [self createPrimaryWeapon];
        
        self.animator.anchorNode = self.sprite;
        
        if (self.enableStreak) {
            [self createMotionStreak];
        }
    }
    
    return self;
}

- (void) clearObject {
    [self.debugNode removeFromParent];
    [super clearObject];
}

- (void) showEntityWithAnimation {
    [self.animator createWarningAnimationAtPosition: self.initialPosition completion: ^{
        [self show];
        
        if (self.primaryWeapon) {
            [self.primaryWeapon showEntityWithAnimation];
        }
    }];
}

- (void) createSpriteAndBody {
    // self.animator.warningAnimationDuration = 2.0;
    
    // Create and add unit sprite
    self.sprite = [EntitySKSpriteNode spriteNodeWithImageNamed: @"ph_circle.png"];
    self.sprite.size = CGSizeMake(ENTITY_DEFAULT_SPRITE_WIDTH, ENTITY_DEFAULT_SPRITE_HEIGHT);
    self.sprite.position = self.initialPosition;
    self.sprite.entityContainer = self;
    [self.rootNode addChild: self.sprite];
    
    // Create the physics body for this Entity
    self.sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: (self.sprite.size.width - 10) / 2];
    self.sprite.physicsBody.dynamic = YES;
    self.sprite.physicsBody.affectedByGravity = NO;
    
    [self setCollidable: NO];
    
    self.sprite.hidden = YES;
    
    // Create and add health sprite
    // The healthSprite's position will be managed by the circle sprite.
    self.healthSprite = [SKSpriteNode spriteNodeWithImageNamed: @"ph_circle_hp_bar.png"];
    self.healthSprite.size = CGSizeMake(ENTITY_DEFAULT_HEALTH_SPRITE_WIDTH, ENTITY_DEFAULT_HEALTH_SPRITE_HEIGHT);
    self.healthSprite.hidden = YES;
    [self.sprite addChild: self.healthSprite];
    
#ifdef DEBUG
    self.debugNode = [SKShapeNode node];
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    self.debugNode.path = pathToDraw;
    CGPathRelease(pathToDraw);
    [self.debugNode setStrokeColor:[UIColor redColor]];
    [self.rootNode addChild: self.debugNode];
    
    self.d1 = [SKShapeNode node];
    pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    self.d1.path = pathToDraw;
    CGPathRelease(pathToDraw);
    [self.d1 setStrokeColor:[UIColor redColor]];
    [self.rootNode addChild: self.d1];
    
    self.d2 = [SKShapeNode node];
    pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    self.d2.path = pathToDraw;
    CGPathRelease(pathToDraw);
    [self.d2 setStrokeColor:[UIColor redColor]];
    [self.rootNode addChild: self.d2];
    
    self.d3 = [SKShapeNode node];
    pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    self.d3.path = pathToDraw;
    CGPathRelease(pathToDraw);
    [self.d3 setStrokeColor:[UIColor redColor]];
    [self.rootNode addChild: self.d3];
    
    self.d4 = [SKShapeNode node];
    pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    self.d4.path = pathToDraw;
    CGPathRelease(pathToDraw);
    [self.d4 setStrokeColor:[UIColor redColor]];
    [self.rootNode addChild: self.d4];
    
    self.d5 = [SKShapeNode node];
    pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    self.d5.path = pathToDraw;
    CGPathRelease(pathToDraw);
    [self.d5 setStrokeColor:[UIColor redColor]];
    [self.rootNode addChild: self.d5];
#endif
    
    self.speed = 1.0;
    self.isValid = YES;
    
    [self updateMetaData];
}

- (void) createPrimaryWeapon {
    // Init WeaponEntity
    CGPoint weaponPosition = CGPointMake(self.initialPosition.x, self.initialPosition.y);
    self.primaryWeapon = [[WeaponEntity alloc] initAtPosition: weaponPosition onSide: self.entitySide withNode: self.rootNode physicsWorld: self.physicsWorld withStreak: self.enableStreak];
    self.primaryWeapon.speed = 3.0f;
    self.primaryWeapon.orbitDistance = 28;
    // self.primaryWeapon.animator.warningAnimationDuration = 3.0;
}

- (void) createMotionStreak {
    /*
     self.streak = [CCMotionStreak streakWithFade:0.75 minSeg:1 image:@"ph_circle.png" width:64 length:64 color:ccc4(255, 255, 255, 255)];
     self.streak.scale = 0.5f;
     self.streak.position = position;
     
     [node addChild: self.streak];
     */
}

- (void) show {
    [super show];
    [self setCollidable: YES];
}

- (void) hide {
    [super hide];
    [self setCollidable: NO];
}

#pragma mark - Overriden Methods
- (void) update: (float) dt {
    [self.animator update: dt];
    [self.primaryWeapon update: dt];
    
    [super update: dt];
    
    if (self.currentNode) {
        // Entity has reached target point.
        if (abs(self.sprite.position.x - self.targetPoint.x) <= 0.1 && abs(self.sprite.position.y - self.targetPoint.y) <= 0.1) {
            NSLog(@"Destination Hit");
            
          //  self.targetPoint = CGPointMake(arc4random() % (int)screenSize.width, arc4random() % (int)screenSize.height);
            // Track the Player.
            self.targetPoint = self.playerEntity.sprite.position;
            [self updateMetaData];
            
            [Animation createScoreTextAnimationInNode: self.rootNode atPosition: self.targetPoint withText: @"WARNING" completion: nil];
            return;
        }
        
        if (!self->lastUpdateTime) {
            self->lastUpdateTime = dt;
        }
        
        // Spawn Timer
        if (self->lastUpdateTime)
        {
            if (dt - self->lastUpdateTime > 0.25) {
                BOOL res = [self ping: self.currentNode.vectorNormalized];
                self->lastUpdateTime = 0.0;
                
                if (res) {
                    self.targetPoint = self.playerEntity.sprite.position;
                    [self updateMetaData];
                    
                    [Animation createScoreTextAnimationInNode: self.rootNode atPosition: self.targetPoint withText: @"WARNING" completion: nil];
                    return;
                }
            }
        }
        
        // Move Entity towards end point.
        self.sprite.position = CGPointMake(self.sprite.position.x + self.currentNode.vectorNormalized.dx * self.speed, self.sprite.position.y + self.currentNode.vectorNormalized.dy * self.speed);
        self->moved += self.currentNode.vectorNormalized.dx ? self.currentNode.vectorNormalized.dx : self.currentNode.vectorNormalized.dy;
        
        // Entity has reached end point (intermediate point to target point)
        if ((abs(self.sprite.position.x - self.currentNode.endPoint.x) <= 0.01 && abs(self.sprite.position.y - self.currentNode.endPoint.y) <= 0.01) || abs(self->moved) >= self.moveDistance) {
            // Track the Player.
            self.targetPoint = self.playerEntity.sprite.position;
            [self updateMetaData];

            [Animation createScoreTextAnimationInNode: self.rootNode atPosition: self.targetPoint withText: @"WARNING" completion: nil];
        }
    } else {
        [self updateMetaData];
    }
}

- (void) updateMetaData {
    // Setup meta data
    self.moveDistance = 48.0;
    CGPoint currentPosition = self.sprite.position;
    CGFloat componentDistance = sqrtf((self.moveDistance * self.moveDistance) / 2);
    
    CGPoint north = CGPointMake(currentPosition.x, currentPosition.y + self.moveDistance),
    northEast = CGPointMake(currentPosition.x + componentDistance, currentPosition.y + componentDistance),
    east = CGPointMake(currentPosition.x + self.moveDistance, currentPosition.y),
    southEast = CGPointMake(currentPosition.x + componentDistance, currentPosition.y - componentDistance),
    south = CGPointMake(currentPosition.x, currentPosition.y - self.moveDistance),
    southWest = CGPointMake(currentPosition.x - componentDistance, currentPosition.y - componentDistance),
    west = CGPointMake(currentPosition.x - self.moveDistance, currentPosition.y),
    northWest = CGPointMake(currentPosition.x - componentDistance, currentPosition.y + componentDistance);
    
    NSArray * directions = [[NSArray alloc] initWithObjects: [NSValue valueWithCGPoint: north],
                            [NSValue valueWithCGPoint: northEast],
                            [NSValue valueWithCGPoint: east],
                            [NSValue valueWithCGPoint: southEast],
                            [NSValue valueWithCGPoint: south],
                            [NSValue valueWithCGPoint: southWest],
                            [NSValue valueWithCGPoint: west],
                            [NSValue valueWithCGPoint: northWest], nil];
    
    if (!self.nodeList || ![self.nodeList count]) {
        self.nodeList = [[NSArray alloc] initWithObjects:
                         [[MPNode alloc] initWithStartPoint: self.sprite.position endPoint: north targetPoint: self.targetPoint physicsWorld: self.physicsWorld],
                         [[MPNode alloc] initWithStartPoint: self.sprite.position endPoint: northEast targetPoint: self.targetPoint physicsWorld: self.physicsWorld],
                         [[MPNode alloc] initWithStartPoint: self.sprite.position endPoint: east targetPoint: self.targetPoint physicsWorld: self.physicsWorld],
                         [[MPNode alloc] initWithStartPoint: self.sprite.position endPoint: southEast targetPoint: self.targetPoint physicsWorld: self.physicsWorld],
                         [[MPNode alloc] initWithStartPoint: self.sprite.position endPoint: south targetPoint: self.targetPoint physicsWorld: self.physicsWorld],
                         [[MPNode alloc] initWithStartPoint: self.sprite.position endPoint: southWest targetPoint: self.targetPoint physicsWorld: self.physicsWorld],
                         [[MPNode alloc] initWithStartPoint: self.sprite.position endPoint: west targetPoint: self.targetPoint physicsWorld: self.physicsWorld],
                         [[MPNode alloc] initWithStartPoint: self.sprite.position endPoint: northWest targetPoint: self.targetPoint physicsWorld: self.physicsWorld],
                         nil];
    } else {
        for (int i = 0; i < [self.nodeList count]; i++) {
            [((MPNode *)[self.nodeList objectAtIndex: i]) setStartPoint: self.sprite.position endPoint: [[directions objectAtIndex: i] CGPointValue] targetPoint: self.targetPoint physicsWorld: self.physicsWorld];
        }
    }
    
    // Sort according to closest angle to target point
    self.nodeList = [self.nodeList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if (((MPNode*)obj1).angle > ((MPNode*)obj2).angle ) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (((MPNode*)obj1).angle < ((MPNode*)obj2).angle) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    // TO DO: It is possible for Entity to get stuck in a loop if prvious node/point is the only choice
    // Pick the first Node that is closes to angle and not previous.
    for (MPNode * node in self.nodeList) {
        if (!node.doesCollide && !self.lastNode) {
            self.lastNode = self.currentNode;
            self.currentNode = [node copy];
            break;
        } else if (!node.doesCollide && (fabs(node.startPoint.x - self.lastNode.startPoint.x) > 0.1 || fabs(node.startPoint.y - self.lastNode.startPoint.y) > 0.1)
                   && ![self ping: node.vectorNormalized]) {
            self.lastNode = self.currentNode;
            self.currentNode = [node copy];
            break;
        }
    }
    
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, self.currentNode.endPoint.x, self.currentNode.endPoint.y);
    self.debugNode.path = pathToDraw;
    CGPathRelease(pathToDraw);
    
    // Reset Entity total move progress amount
    self->moved = 0.0f;
}

- (BOOL) ping: (CGVector) moveDirection {
  //  NSLog(@"ping");
    CGFloat widthMag = (self.sprite.size.width / 2),
    heightMag = (self.sprite.size.height / 2);

    CGVector r = [Vector2DUtility RotateVector: moveDirection angle: 45];
    SKPhysicsBody * b1 = [self.physicsWorld bodyAlongRayStart: self.sprite.position end: CGPointMake(self.sprite.position.x + (widthMag * r.dx), self.sprite.position.y + (heightMag * r.dy))];

    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, self.sprite.position.x + (widthMag * r.dx), self.sprite.position.y + (heightMag * r.dy));
    self.d1.path = pathToDraw;
    CGPathRelease(pathToDraw);
    
    r = [Vector2DUtility RotateVector: moveDirection angle: 90];
    SKPhysicsBody * b2 = [self.physicsWorld bodyAlongRayStart: self.sprite.position end: CGPointMake(self.sprite.position.x + (widthMag * r.dx), self.sprite.position.y + (heightMag * r.dy))];

    pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, self.sprite.position.x + (widthMag * r.dx), self.sprite.position.y + (heightMag * r.dy));
    self.d2.path = pathToDraw;
    CGPathRelease(pathToDraw);
    
    r = [Vector2DUtility RotateVector: moveDirection angle: -45];
    SKPhysicsBody * b3 = [self.physicsWorld bodyAlongRayStart: self.sprite.position end: CGPointMake(self.sprite.position.x + (widthMag * r.dx), self.sprite.position.y + (heightMag * r.dy))];

    pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, self.sprite.position.x + (widthMag * r.dx), self.sprite.position.y + (heightMag * r.dy));
    self.d3.path = pathToDraw;
    CGPathRelease(pathToDraw);
    
    r = [Vector2DUtility RotateVector: moveDirection angle: -90];
    SKPhysicsBody * b4 = [self.physicsWorld bodyAlongRayStart: self.sprite.position end: CGPointMake(self.sprite.position.x + (widthMag * r.dx), self.sprite.position.y + (heightMag * r.dy))];

    pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, self.sprite.position.x + (widthMag * r.dx), self.sprite.position.y + (heightMag * r.dy));
    self.d4.path = pathToDraw;
    CGPathRelease(pathToDraw);
    
    r = [Vector2DUtility RotateVector: moveDirection angle: 0];
    SKPhysicsBody * b5 = [self.physicsWorld bodyAlongRayStart: self.sprite.position end: CGPointMake(self.sprite.position.x + (widthMag * r.dx), self.sprite.position.y + (heightMag * r.dy))];
    
    pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, self.sprite.position.x, self.sprite.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, self.sprite.position.x + (widthMag * r.dx), self.sprite.position.y + (heightMag * r.dy));
    self.d5.path = pathToDraw;
    CGPathRelease(pathToDraw);
    
    // TO DO: PASS THROUGH BUG: Smart objects will pass through geometry if it gets stuck. It seems that raycast checks fail if
    // the ray cast starts within the object itself. Perhaps we have to implement our own ray cast function.
    return b1 || b2 || b3 || b4 || b5;
}
@end
