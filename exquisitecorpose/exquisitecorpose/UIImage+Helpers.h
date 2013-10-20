

#import <UIKit/UIKit.h>

@interface UIImage (EXQHelpers)
+ (UIImage*)transparentImageWithSize:(CGSize)s;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)sz;

- (UIImage *)scaleToSize:(CGSize)targetSize;
- (UIImage *)scaleToFillSize:(CGSize)targetSize;

- (NSData*)pixelData;
- (UIImage*)crop:(UIEdgeInsets)insets;

+ (UIImage*)concatenateImagesWithVerticalFlow:(NSArray*)images;

@end
