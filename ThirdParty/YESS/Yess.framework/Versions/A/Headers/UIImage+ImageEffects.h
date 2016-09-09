
//#import "UIKit/UIKit.h"
//#import <UIKit>
@import UIKit;

@interface UIImage (ImageEffects)


- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

- (UIImage *)wantCurrentScreenshotFromView:(UIView *)views withBluring:(BOOL)bluring tintColor:(UIColor*)tintcolor blurRadius:(float)hardBlur;

@end
