//
//  UIView+Toast.m
//  Toast
////

#include "UIView+Toast.h"
#include <QuartzCore/QuartzCore.h>
#include <objc/runtime.h>

/*
 *  CONFIGURE THESE VALUES TO ADJUST LOOK & FEEL,
 *  DISPLAY DURATION, ETC.
 */

// general appearance
static const CGFloat CSToastMaxWidth                = 0.8;      // 80% of parent view width
static const CGFloat CSToastMaxHeight               = 0.8;      // 80% of parent view height
static CGFloat CSToastHorizontalPadding             = 16.0;
static CGFloat CSToastVerticalPadding               = 24.0;
static const CGFloat CSToastCornerRadius            = 10.0;
static const CGFloat CSToastOpacity                 = 1;
static const CGFloat CSToastMaxMessageLines         = 0;
static const NSTimeInterval CSToastFadeDuration     = 0.2;

#define LIBRARY_IS_IPHONE                           ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define CSToastTringleHeight                        LIBRARY_IS_IPHONE ? 14 : 24
#define CSToastTringleBase                          LIBRARY_IS_IPHONE ? 25 : 35

// display duration and position
static const NSString * CSToastDefaultPosition      = @"bottom";
static const NSTimeInterval CSToastDefaultDuration  = 2.0;

// interaction
static const BOOL CSToastHidesOnTap                 = YES;     // excludes activity views

// associative reference keys
static const NSString * CSToastTimerKey             = @"CSToastTimerKey";

@interface UIView (ToastPrivate)

- (void)hideToast:(UIView *)toast;
- (void)toastTimerDidFinish:(NSTimer *)timer;
- (void)handleToastTapped:(UITapGestureRecognizer *)recognizer;
- (CGPoint)centerPointForPosition:(id)point withToast:(UIView *)toast frame:(CGRect)frame;
- (UIView *)viewForMessage:(NSString *)message image:(UIImage *)image position:(id)position backgroundColor:(UIColor *)backgroundColor frame:(CGRect)frame tintColor:(UIColor *)tintColor;
- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end


@implementation UIView (Toast)

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Toast Methods

- (void)makeToast:(NSString *)message backgroundColor:(UIColor *)backgroundColor tintColor:(UIColor *)tintColor{
    [self makeToast:message duration:CSToastDefaultDuration position:CSToastDefaultPosition frame:CGRectNull backgroundColor:[UIColor blackColor] tintColor:tintColor];
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position frame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor tintColor:(UIColor *)tintColor{
    UIView *toast = [self viewForMessage:message image:nil position:position backgroundColor:backgroundColor frame:frame tintColor:tintColor];
    [self showToast:toast duration:duration position:position frame:frame] ;
}

- (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position image:(UIImage *)image frame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor tintColor:(UIColor *)tintColor{
    
    CSToastVerticalPadding = 25.0;
    UIView *toast = [self viewForMessage:message image:image position:position backgroundColor:backgroundColor frame:frame tintColor:tintColor];
    [self showToast:toast duration:duration position:position frame:frame];
}

- (void)showToast:(UIView *)toast{
    [self showToast:toast duration:CSToastDefaultDuration position:CSToastDefaultPosition frame:CGRectNull];
}

- (void)showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)point frame:(CGRect)frame{
    
    toast.center = [self centerPointForPosition:point withToast:toast frame:frame];
    
    toast.alpha = 0.0;
    
    if (CSToastHidesOnTap) {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:toast action:@selector(handleToastTapped:)];
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    
    [self addSubview:toast];
    
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(toastTimerDidFinish:) userInfo:toast repeats:NO];
                         // associate the timer with the toast view
                         objc_setAssociatedObject (toast, &CSToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
    
}

- (void)hideToast:(UIView *)toast {
    [UIView animateWithDuration:CSToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         toast.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [toast removeFromSuperview];
                     }];
}

#pragma mark - Events

- (void)toastTimerDidFinish:(NSTimer *)timer {
    [self hideToast:(UIView *)timer.userInfo];
}

- (void)handleToastTapped:(UITapGestureRecognizer *)recognizer {
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(self, &CSToastTimerKey);
    [timer invalidate];
    
    [self hideToast:recognizer.view];
}

#pragma mark - Helpers
- (CGPoint)centerPointForPosition:(id)point withToast:(UIView *)toast frame:(CGRect)frame {
    
    BOOL isFrameNull = CGRectIsNull(frame);

    if([point isKindOfClass:[NSString class]]) {
        
        if ([point caseInsensitiveCompare:@"bottom"] == NSOrderedSame && isFrameNull){
            
            return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - CSToastVerticalPadding);
        }
        else if ([point caseInsensitiveCompare:@"aboveView"] == NSOrderedSame){
            
            return CGPointMake(self.bounds.size.width/2, frame.origin.y - (toast.frame.size.height /2) - (CSToastTringleHeight));
        }
        else if ([point caseInsensitiveCompare:@"belowView"] == NSOrderedSame){
            
            return CGPointMake(self.bounds.size.width/2, ((frame.origin.y + frame.size.height) + (toast.frame.size.height /2)) + (CSToastTringleHeight) );
        }
        else if([point caseInsensitiveCompare:@"bottom"] == NSOrderedSame && !isFrameNull) {
            
            return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)));
            
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    return [self centerPointForPosition:CSToastDefaultPosition withToast:toast frame:frame];
}

- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    /* If boundingRectWithSize doesn't respond then user sizeWithFont. But the later method is deprecated from iOS7.1 */
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
}

- (UIView *)viewForMessage:(NSString *)message image:(UIImage *)image position:(id)position backgroundColor:(UIColor *)backgroundColor frame:(CGRect)frame tintColor:(UIColor *)tintColor{
    
    BOOL tringluarWrapper = NO;
    
    if ([position isKindOfClass:[NSString class]] && ([position isEqualToString:@"aboveView"] || [position isEqualToString:@"belowView"])) {
        tringluarWrapper = YES;
    }
    
    // sanity
    if((message == nil) && (image == nil)) return nil;
    
    // dynamically build a toast view with any combination of message, title, & image.
    UILabel *messageLabel = nil;
    UIImageView *imageView = nil;
    CGFloat imageWidth;
    CGFloat imageHeight;
    CGFloat imageLeft;
    
    // create the parent view
    UIView *wrapperView = [[UIView alloc] init];
    
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    
    wrapperView.layer.cornerRadius = CSToastCornerRadius;
    wrapperView.backgroundColor = [backgroundColor colorWithAlphaComponent:CSToastOpacity];
    
    if(image != nil) {
        
        CGFloat image_Width = LIBRARY_IS_IPHONE ? 25 : 40;
        CGFloat image_Height = LIBRARY_IS_IPHONE ? 25 : 40;
        
        imageView = [[UIImageView alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(CSToastHorizontalPadding, CSToastVerticalPadding, image_Width, image_Height);
        [imageView setTintColor:tintColor];
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = CSToastHorizontalPadding;
        
    }
    else{
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    // messageLabel frame values
    CGFloat messageWidth;
    CGFloat messageHeight;
    CGFloat messageLeft;
    CGFloat messageTop;
    
    if (message != nil) {
        
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = CSToastMaxMessageLines;
        messageLabel.font = [UIFont systemFontOfSize:LIBRARY_IS_IPHONE ? 16 : 21];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = tintColor;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * CSToastMaxWidth), self.bounds.size.height * CSToastMaxHeight);
        
        if (tringluarWrapper == YES){
            
            maxSizeMessage = CGSizeMake((self.bounds.size.width - CSToastHorizontalPadding * 4) - imageLeft - imageWidth, self.bounds.size.height * CSToastMaxHeight);
        }
        else if(image != nil){
            
            maxSizeMessage = CGSizeMake(self.bounds.size.width - imageLeft - imageWidth - CSToastHorizontalPadding - CSToastHorizontalPadding, self.bounds.size.height * CSToastMaxHeight);
            
        }
        CGSize expectedSizeMessage = [self sizeForString:message font:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
        
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + CSToastHorizontalPadding;
        messageTop =  CSToastVerticalPadding;
        
    }
    else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }
    
    
    CGFloat wrapperWidth = MAX((imageWidth + (CSToastHorizontalPadding * 2)), (messageLeft + messageWidth + CSToastHorizontalPadding));
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + CSToastVerticalPadding), (imageHeight + (CSToastVerticalPadding * 2)));
    
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    
    if(messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        [wrapperView addSubview:imageView];
    }
    
    if ([position isKindOfClass:[NSString class]]) {
        
        if ([position isEqualToString:@"aboveView"]) {
            
            [wrapperView.layer addSublayer:[self addTringleAtBottomRight:wrapperView backgroundColor:backgroundColor frame:frame]];
            wrapperView.frame = CGRectMake(CSToastHorizontalPadding, 0.0, (self.bounds.size.width - (CSToastHorizontalPadding * 2)), wrapperHeight);
        }
        else if ([position isEqualToString:@"belowView"]){
            
            [wrapperView.layer addSublayer:[self addTringleAtTopLeft:wrapperView backgroundColor:backgroundColor frame:frame]];
            wrapperView.frame = CGRectMake(CSToastHorizontalPadding, 0.0, (self.bounds.size.width - (CSToastHorizontalPadding * 2)), wrapperHeight);
        }
        else if ([position isEqualToString:@"bottom"]){
            
            wrapperView.frame = CGRectMake(0.0, 0.0, (self.bounds.size.width), wrapperHeight);
            wrapperView.layer.cornerRadius = 0;
            imageView.center = CGPointMake(CSToastHorizontalPadding + (imageView.frame.size.width / 2), wrapperView.center.y);
        }
        
    }
    
    return wrapperView;
}

-(CAShapeLayer *)addTringleAtTopLeft:(UIView *)wrapperView backgroundColor:(UIColor *)backgroundColor frame:(CGRect)frame{
    
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint:CGPointMake(frame.origin.x + (frame.size.width / 2) - (((float)CSToastTringleBase)/2) - CSToastHorizontalPadding, 0)];
    [bezierPath addLineToPoint:CGPointMake(frame.origin.x + (frame.size.width / 2) - CSToastHorizontalPadding, -(CSToastTringleHeight))];
    [bezierPath addLineToPoint:CGPointMake(frame.origin.x + (frame.size.width / 2) - CSToastHorizontalPadding + (((float)CSToastTringleBase)/2), 0)];
    [bezierPath closePath];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = wrapperView.bounds;
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = [backgroundColor colorWithAlphaComponent:CSToastOpacity].CGColor;
    
    return shapeLayer;
}

-(CAShapeLayer *)addTringleAtBottomRight:(UIView *)wrapperView backgroundColor:(UIColor *)backgroundColor frame:(CGRect)frame{
    
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint:CGPointMake(frame.origin.x + (frame.size.width / 2) - (((float)CSToastTringleBase)/2) - CSToastHorizontalPadding, wrapperView.bounds.size.height)];
    [bezierPath addLineToPoint:CGPointMake(frame.origin.x + (frame.size.width / 2) - CSToastHorizontalPadding,wrapperView.bounds.size.height + (CSToastTringleHeight))];
    [bezierPath addLineToPoint:CGPointMake(frame.origin.x + (frame.size.width / 2) - CSToastHorizontalPadding + (((float)CSToastTringleBase)/2), wrapperView.bounds.size.height)];
    [bezierPath closePath];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = wrapperView.bounds;
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = [backgroundColor colorWithAlphaComponent:CSToastOpacity].CGColor;
    
    return shapeLayer;
}


@end
