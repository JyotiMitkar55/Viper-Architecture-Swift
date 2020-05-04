//
//  Loader.h
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIImage+animatedGIF.h"

@interface Loader : UIView

+ (void)hideLoaderForView:(UIView *)view;
+ (void)showLoaderAddedTo:(UIView *)view;

@end
