//
//  Loader.m
//

#import "Loader.h"

@implementation Loader{
    
    UIView *loaderContentView;
}

#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Set default values for properties
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    }
    return self;
}

- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    return [self initWithFrame:view.bounds];
}

- (id)initWithWindow:(UIWindow *)window {
    return [self initWithView:window];
}

+ (instancetype)LoaderForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (Loader *)subview;
        }
    }
    return nil;
}

#pragma mark - set Loader Content View Property
-(void)setLoaderContentViewProperty{
    //Loader View
    loaderContentView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 80, 80)];
    loaderContentView.backgroundColor = [UIColor whiteColor];
    [loaderContentView.layer setCornerRadius:5.0f];
    // drop shadow
    [loaderContentView.layer setShadowColor:[UIColor colorWithRed:131.0/255.0 green:131.0/255.0 blue:131.0/255.0 alpha:1.0].CGColor];
    [loaderContentView.layer setShadowOpacity:0.5];
    [loaderContentView.layer setShadowRadius:5.0];
    [loaderContentView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    //added gif imageView
    UIImageView *loaderImageView = [[UIImageView alloc] init];
    loaderImageView.frame = CGRectMake(0,0, 72, 72);
    NSURL *imageURL = [[NSBundle mainBundle] URLForResource:@"loader" withExtension:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    loaderImageView.image = [UIImage animatedImageWithAnimatedGIFData:imageData];
    
    [loaderContentView addSubview:loaderImageView];
    loaderImageView.center = loaderContentView.center;
    [self addSubview:loaderContentView];
    loaderContentView.center = self.center;
}

#pragma mark - Show Loader View method
+ (void)showLoaderAddedTo:(UIView *)view {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        Loader *loader = [[self alloc] initWithView:view];
        [view addSubview:loader];
        [loader setLoaderContentViewProperty];
        loader = nil;
    });
}

#pragma mark - Hide Loader View method
+ (void)hideLoaderForView:(UIView *)view{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        Loader *loader = [self LoaderForView:view];
        if (loader != nil) {
            [loader removeFromSuperview];
        }
    });
}

@end
