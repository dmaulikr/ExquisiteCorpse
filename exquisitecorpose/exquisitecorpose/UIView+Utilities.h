#import <UIKit/UIKit.h>

@interface UIView (EXQUtilities)

- (void)setborderWidth:(CGFloat)width;
- (void)setborderColor:(UIColor *)color;
- (void)setcornerRadius:(CGFloat)cornerRadius;


// Rendering a UIImage
- (UIImage *)renderAsUIImage;

@property (assign, readwrite) CGFloat right;
@property (assign, readwrite) CGFloat left;
@property (assign, readwrite) CGFloat top;
@property (assign, readwrite) CGFloat bottom;
@property (readonly)          CGFloat height;
@property (assign, readwrite)          CGFloat width;
@property (readonly)          CGFloat centerX;
@property (readonly)          CGFloat centerY;

@end
