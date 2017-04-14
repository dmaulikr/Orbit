//
//  ObjectEntity.m
//  Orbit
//
//  Created by Ken Hung on 2/20/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "ObjectEntity.h"
#import "WeaponEntity.h"
#import "TextureUtils.h"
#import "AppUtils.h"

@implementation ObjectEntity
@synthesize gameAreaSize, numberOfScreens, vertices = vertices_, wallType = wallType_;

- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side withNode: (SKNode *) node physicsWorld: (SKPhysicsWorld *) world withStreak: (BOOL) enableStreak {
    if (self = [super initAtPosition: position onSide: side withNode: node physicsWorld: world withStreak: enableStreak]) {

    }
    
    return self;
}

- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side wallType: (WallType) wallType  withNode: (SKNode *) node physicsWorld: (SKPhysicsWorld *) world withVertexList: (NSArray*) vertexList withStreak: (BOOL) enableStreak {
    if (self = [self initAtPosition: position onSide: side withNode: node physicsWorld: world withStreak: enableStreak]) {
        [self setKVO];
        
        self.isValid = NO;
        self.entitySide = side;
        self.entityType = ENTITY_TYPE_WALL;
        self.wallType = wallType;
        self.vertices = [NSMutableArray arrayWithArray: vertexList];
        
        // [self createAnimator];
        [self createSpriteAndBody];
        [self createPrimaryWeapon];
        
        // self.animator.anchorNode = self.sprite;
        
        if (self.enableStreak) {
            [self createMotionStreak];
        }
    }
    
    return self;
}

- (void) showEntityWithAnimation {
    // [self.animator createWarningAnimationAtPosition: self.initialPosition completion: ^{
        [self show];
        
        if (self.primaryWeapon) {
            [self.primaryWeapon showEntityWithAnimation];
        }
    // }];
}

- (void) createSpriteAndBody {
    if (!self.vertices || ![self.vertices count]) {
        return;
    }
    
    // Create and add unit sprite
	// Form a Convex polygon with provided vertices.
    self.vertices = [TextureUtils convexHull: self.vertices];
    
    CGSize textureSize = [TextureUtils findTextureSizeFromVertexList: self.vertices];
    
    self.sprite = [EntitySKSpriteNode spriteNodeWithTexture: [TextureUtils createPolygonTextureWithVertexPoints: self.vertices textureSize: textureSize]];
    // self.sprite.scale = 1.0f;
    self.sprite.position = self.initialPosition;
    self.sprite.entityContainer = self;
    [self.rootNode addChild: self.sprite];
    
    // Create the physics body for this Entity
    self.sprite.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath: [TextureUtils createPhysicsPathWithVertexPoints: self.vertices sprite: self.sprite]];
    self.sprite.physicsBody.dynamic = YES;
    self.sprite.physicsBody.affectedByGravity = NO;
    
    [self setCollidable: NO];
    
    self.sprite.hidden = YES;
    
    // TO DO: Implement Wall Types
    /*
    // Create and add health sprite
    // The healthSprite's position will be managed by the circle sprite.
    self.healthSprite = [SKSpriteNode spriteNodeWithImageNamed: @"ph_line_hp_bar.png"];
    self.healthSprite.size = CGSizeMake(ENTITY_DEFAULT_HEALTH_SPRITE_WIDTH, ENTITY_DEFAULT_HEALTH_SPRITE_HEIGHT);
    self.healthSprite.hidden = YES;
    [self.sprite addChild: self.healthSprite];
    */
    
    self.speed = 0.0;
    
    self.isValid = YES;
    
    [self updateMetaData];
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

- (void) update: (float)dt {
    if (self.speed > 0) {
        CGSize screenSize = [AppUtils getScreenSize];
        
        if (self.sprite.position.x + (self.sprite.size.width / 2) < 0) {
            // Sprite is offscreen, move it to other side of the screen
            self.sprite.position = CGPointMake(screenSize.width + self.sprite.size.width / 2, self.sprite.position.y);
        } else {
            self.sprite.position = CGPointMake(self.sprite.position.x - self.speed, self.sprite.position.y);
        }
    }
    
    // [self.animator update: dt];
    [self.primaryWeapon update: dt];
    
    [super update: dt];
}

- (void) updateMetaData {

}

#pragma mark - Overrides
#pragma mark - Key Value Observer
/**
 * This is how we keep health and the health sprite variables in sync.
 */
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // NOTE: The use of xScale. This assumes all sprites are equilateral.
    // Override health response for ObjectEntities
    if ([keyPath isEqualToString: @"health"]) {
        if (self.wallType != WALL_TYPE_INDESTRUCTABLE) {
            if (self.health <= 0) {
                self.isValid = NO;
                [self setCollidable: NO];
                [self clearObject];
                return;
            }
            
            self.healthSprite.xScale = self.health;
            self.healthSprite.yScale = self.health;
        }
        
        return;
    }
    
    [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
}
@end
