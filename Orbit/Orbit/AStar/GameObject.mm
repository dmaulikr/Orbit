#import "GameObject.h"

@implementation GameObject

@synthesize type, typeTag, markedForDestruction;

-(id) init {
    if( (self=[super init]) ) {
		[self initBox2D];
		markedForDestruction = NO;
    }
    return self;
}

-(void) initBox2D {
    // TO DO: Setup phybics
/*
	bodyDef = new b2BodyDef();
	fixtureDef = new b2FixtureDef();

	//Initial fixture settings
	fixtureDef->density = 1.0f;
	fixtureDef->friction = 0.5f;
	fixtureDef->restitution = 0.3f;

	bodyDef->userData = self;
 */
}
/*
-(int) type {
	return GO_TYPE_NONE;
}
*/
- (BOOL) isValid {
    return YES;
}
@end
