#import "GameWaypoint.h"

@implementation GameWaypoint

@synthesize position, speedMod, lastDistance, preCallback, postCallback;

-(id)init {
    self = [super init];
    if (self != nil) {

    }
    return self;
}

-(void)dealloc {
    preCallback = nil;
    postCallback = nil;
}

+(id) createWithPosition:(CGPoint)p withSpeedMod:(float)s{
    return [[self alloc] initWithPosition:p withSpeedMod:s];
}

-(id) initWithPosition:(CGPoint)p withSpeedMod:(float)s{
	if( (self = [self init]) ) {
		self.position = p;
		self.speedMod = s;
		self.lastDistance = 1000000.0f;
		self.preCallback = nil;
		self.postCallback = nil;
	}
	return self;
}

-(void) processPreCallback {
	[preCallback.obj performSelector:NSSelectorFromString(preCallback.callback)];
	preCallback = nil;
}

-(void) processPostCallback {
	[postCallback.obj performSelector:NSSelectorFromString(postCallback.callback)];
	postCallback = nil;
}

@end