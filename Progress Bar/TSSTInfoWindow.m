//
//  TSSTInfoWindow.m
//  SimpleComic
//
//  Created by Alexander Rauchfuss on 7/15/07.
//  Copyright 2007 Dancing Tortoise Software. All rights reserved.
//

#import "TSSTInfoWindow.h"
#import "TSSTImageUtilities.h"


@implementation TSSTInfoWindow


- (id)initWithContentRect:(NSRect)contentRect styleMask:(unsigned int)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect: contentRect styleMask: NSBorderlessWindowMask backing: bufferingType defer: flag];
    if(self)
    {
        [self setOpaque: NO];
        [self setIgnoresMouseEvents: YES];
    }
    return self;
}


- (void)caretAtPoint:(NSPoint)point size:(NSSize)size withLimitLeft:(float)left right:(float)right
{
	left -= 30;
	right += 30;
    float limitWidth = right - left;
    float relativePosition = (point.x - left) / limitWidth;
    float offset = size.width * relativePosition;
	[[self contentView] setCaretPosition: offset];
    [self setFrame: NSMakeRect( point.x - offset, point.y, size.width, size.height) display: YES];
}


- (void)centerAtPoint:(NSPoint)center
{
    NSRect frame = [self frame];
    [self setFrameOrigin: NSMakePoint(center.x - NSWidth(frame) / 2, center.y - NSHeight(frame) / 2)];
	[self invalidateShadow];
}


- (void)resizeToDiameter:(float)diameter
{
    NSRect frame = [self frame];
	NSPoint center = NSMakePoint(NSMinX( frame ) + NSWidth(frame) / 2, NSMinY( frame ) + NSHeight(frame) / 2);
	
	[self setFrame: NSMakeRect(center.x - diameter / 2,  center.y - diameter / 2, diameter, diameter) 
		   display: YES 
		   animate: NO];
}


@end



@implementation TSSTInfoView

@synthesize bordered, caretPosition;


- (void)setCaretPosition:(float)position
{
    caretPosition = position;
	[self setNeedsDisplay: YES];
}


- (void)drawRect:(NSRect)aRect
{
    NSRect bounds = [self bounds];
    [[NSColor clearColor] set];
    NSRectFill(bounds);
    
    NSBezierPath * outline = [NSBezierPath bezierPath];
    [outline moveToPoint: NSMakePoint(caretPosition + 5, 5)];
    [outline lineToPoint: NSMakePoint(caretPosition, 0)];
    [outline lineToPoint: NSMakePoint(caretPosition - 5, 5)];
    [outline appendBezierPathWithArcFromPoint: NSMakePoint(0 , 5) 
                                      toPoint: NSMakePoint(0 , NSMidY(bounds)) 
                                       radius: 5];
    [outline appendBezierPathWithArcFromPoint: NSMakePoint(0 , NSMaxY(bounds)) 
                                      toPoint: NSMakePoint(NSMidX(bounds), NSMaxY(bounds)) 
                                       radius: 5];
    [outline appendBezierPathWithArcFromPoint: NSMakePoint(NSMaxX(bounds), NSMaxY(bounds)) 
                                      toPoint: NSMakePoint(NSMaxX(bounds), NSMidY(bounds)) 
                                       radius: 5];
    [outline appendBezierPathWithArcFromPoint: NSMakePoint(NSMaxX(bounds), 5) 
                                      toPoint: NSMakePoint(caretPosition + 5, 5)
                                       radius: 5];
    [outline closePath];
    [[NSColor colorWithCalibratedWhite: 0 alpha: 0.8] set];
    [outline fill];
	
//	int borderWidth = bordered ? 4 : 2;
	int borderWidth = 4;

	[outline addClip];
	[[NSColor colorWithCalibratedWhite: 1 alpha: 0.8] set];
	[outline setLineWidth: borderWidth];
	[outline setLineJoinStyle: NSRoundLineJoinStyle];
	[outline stroke];
}


@end


@implementation TSSTTransparentContent

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

//- (void)drawRect:(NSRect)rect
//{
//    [[NSColor clearColor] set];
//    NSRectFill( rect);
//}

@end



@implementation TSSTCircularImageView



- (void)drawRect:(NSRect)rect
{
	NSRect bounds = [self bounds];
	[[NSColor clearColor] set];
    NSRectFill(bounds);
    if([self image])
    {
        NSGradient * loupeGradient = [[NSGradient alloc] initWithStartingColor: [NSColor colorWithCalibratedWhite: 0.3 alpha: 1] 
                                                                   endingColor: [NSColor colorWithCalibratedWhite: 0.6 alpha: 1]];
        
        NSPoint centerPoint = centerPointOfRect( rect );
        [loupeGradient drawFromCenter: centerPoint radius: NSWidth(rect) / 2 - 10 toCenter: centerPoint radius: NSWidth(rect) / 2 - 1 options: 0];
        
		NSBezierPath * circle = [NSBezierPath bezierPathWithOvalInRect: NSInsetRect(bounds,1,1)];
        [[NSColor colorWithCalibratedWhite: 0.2 alpha: 2] set];
        [circle setLineWidth: 2.0];
        [circle stroke];
        circle = [NSBezierPath bezierPathWithOvalInRect: NSInsetRect(bounds,10,10)];
        [[NSColor whiteColor] set];
        [circle fill];
        [circle addClip];
        [loupeGradient release];
		[super drawRect: rect];
		[[NSColor colorWithCalibratedWhite: 0.6 alpha: 1] set];
        [circle setLineWidth: 3.0];
        [circle stroke];
    }
}



@end
