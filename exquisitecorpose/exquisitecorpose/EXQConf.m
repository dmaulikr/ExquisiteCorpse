
#import "EXQConf.h"

#define kZGHFontFamily @"Avenir Next Condensed"
#define ZGHUIColorFromRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ZGHUIColorFromRGBA(r,g,b,a) [UIColor colorWithRed:((float)r/255.0) green:((float)g/255.0) blue:((float)b/255.0) alpha:a]


@implementation EXQConf

+ (UIColor*)colorNavBarOrange
{
    return [UIColor colorWithRed:176./255. green:65./255. blue:25./255. alpha:1.0];
}
+ (UIColor*)colorViewBackgroundOrange
{
    return [UIColor colorWithRed:233./255. green:112./255. blue:35./255. alpha:1.0];
}
+ (UIColor*)colorTextWhite
{
    return [UIColor whiteColor];
}
+ (UIColor*)colorBorderOrange
{
    return ZGHUIColorFromRGBA(255, 153, 102, 1.0);
}


+ (UIFont*)ultraLightFontOfSize:(NSInteger)pt
{
    return [UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:pt];
}

@end
