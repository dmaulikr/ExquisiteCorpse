

#import "UIImage+Helpers.h"
#import <AssetsLibrary/AssetsLibrary.h>


// TODO: vytk: for tips on resize performance, EXIF handling and CGInterpolationQuality, check out:  
//  http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/
/// http://eran.sandler.co.il/2011/11/07/uiimage-in-ios-5-orientation-and-resize/


@implementation UIImage (EXQHelpers)

+ (UIImage*)concatenateImagesWithVerticalFlow:(NSArray*)images
{
    CGFloat h = 0., w=0.;
    for (UIImage *img in images) {
        h += img.size.height;
        w = MAX(w, img.size.width);
    }
    
    CGSize sz = CGSizeMake(w, h);
    
    UIGraphicsBeginImageContext(sz);

    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor whiteColor].CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), (CGRect){CGPointZero, sz});
    
    CGPoint cur = CGPointZero;
    for (UIImage *img in images) {
        [img drawAtPoint:cur];
        cur = CGPointMake(0, cur.y + img.size.height);
    }
    
    id img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;

    
}

+ (UIImage*)transparentImageWithSize:(CGSize)s
{
    UIGraphicsBeginImageContext(s);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor clearColor].CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), (CGRect){CGPointZero, s});
    id img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage*)crop:(UIEdgeInsets)insets
{
    // temporary muckery
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectMake(0, 40, 640, 2*self.size.height-40));
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return img;
    
    /*UIGraphicsBeginImageContext(CGSizeMake(self.size.width*2, self.size.height*2));
    [self drawAtPoint:CGPointMake(0, -40)];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;*/
    
    
    /*// Create rectangle that represents a cropped image
    CGRect rect = CGRectMake(0, 0, 2*self.size.width, 2*self.size.height);
    insets = ZGHEdgeInsetsScalarMultiply(insets, 2);
    rect = UIEdgeInsetsInsetRect(rect, insets);
    
    // Create bitmap image from original image data,
    // using rectangle to specify desired crop area
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return img;*/
}

- (UIImage *)scaleToSize:(CGSize)targetSize {
    CGFloat xscale = targetSize.width / self.size.width;
    CGFloat yscale = targetSize.height / self.size.height;
    
    CGFloat scaleFactor = fminf(fminf(xscale, yscale), 1.0f);
    
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width*scaleFactor, self.size.height*scaleFactor)); 
    
    //Creating the rect where the scaled image is drawn in
    // CGRect rect = CGRectMake((targetSize.width - self.size.width * scaleFactor) / 2,
    //                          (targetSize.height -  self.size.height * scaleFactor) / 2,
    //                          self.size.width * scaleFactor, self.size.height * scaleFactor);
    
    CGRect rect = CGRectMake(0, 0, self.size.width*scaleFactor, self.size.height*scaleFactor);
    
    //Draw the image into the rect
    [self drawInRect:rect];
    
    //Saving the image, ending image context
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //DLog(@"scale: %g  image: %@", scaleFactor, scaledImage);
    
    return scaledImage;
}

- (UIImage*)scaleToFillSize:(CGSize)targetSize {
    CGFloat xscale = targetSize.width / self.size.width;
    CGFloat yscale = targetSize.height / self.size.height;
    
    CGFloat scaleFactor = fminf(fmaxf(xscale, yscale), 1.0f);
    
    UIGraphicsBeginImageContext(targetSize); 
    
    //Creating the rect where the scaled image is drawn in
    CGRect rect = CGRectMake((targetSize.width - self.size.width * scaleFactor) / 2,
                             (targetSize.height -  self.size.height * scaleFactor) / 2,
                             self.size.width * scaleFactor, self.size.height * scaleFactor);
    
    //Draw the image into the rect
    [self drawInRect:rect];
    
    //Saving the image, ending image context
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //DLog(@"scale: %g  image: %@", scaleFactor, scaledImage);
    
    return scaledImage;
    
}

- (NSData*)pixelData {
    NSData *pixelData = (__bridge_transfer NSData*)CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage));
    return pixelData;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)sz
{
    CGRect rect = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
