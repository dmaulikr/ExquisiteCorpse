

#import "UIView+Utilities.h"

@implementation UIView (EXQUtilities)

- (void)setborderWidth:(CGFloat)width
{
    self.layer.borderWidth = width;
}

- (void)setborderColor:(UIColor *)color
{
    self.layer.borderColor = color.CGColor;
}

- (void)setcornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

#pragma mark - Rendering a UIImage

- (UIImage *)renderAsUIImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (CGFloat)width
{
    return self.bounds.size.width;
}
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)height
{
    return self.bounds.size.height;
}
- (CGFloat)right
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)left
{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)top
{
    return CGRectGetMinY(self.frame);
}

- (CGFloat)bottom
{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)centerX
{
    return CGRectGetMidX(self.bounds);
}

- (CGFloat)centerY
{
    return CGRectGetMinY(self.bounds);
}

- (void)setRight:(CGFloat)right
{
    self.frame = CGRectMake(right - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setLeft:(CGFloat)left
{
    self.frame = CGRectMake(left, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setTop:(CGFloat)top
{
    self.frame = CGRectMake(self.frame.origin.x, top, self.frame.size.width, self.frame.size.height);
}

- (void)setBottom:(CGFloat)bottom
{
    self.frame = CGRectMake(self.frame.origin.x, bottom - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}




@end
