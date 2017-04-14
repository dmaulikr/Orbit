// #import "cocos2d.h"
//#import "Box2D.h"
//#import "b2Body.h"
//#import "GameObjectTypes.h"

// TO DO; DELETE - comments


@interface GameObject : NSObject {
    
}

// TO DO: Add Physics object
// TO DO: Add Sprite object

@property (readwrite, assign) int typeTag;
@property (readwrite, assign) bool markedForDestruction;
@property (readonly) int type;

-(id) init;
-(void) initBox2D;
-(int) type;
-(BOOL) isValid;
@end