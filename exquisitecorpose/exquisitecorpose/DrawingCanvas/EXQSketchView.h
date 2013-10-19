
#import <UIKit/UIKit.h>

typedef enum {
    kDrawingRoutineTypeNone = -1,
    kDrawingRoutineTypeFreehand = 0,
    kDrawingRoutineTypeLine,
    kDrawingRoutineTypeRectangle,
    kDrawingRoutineTypeRound,
} DrawingRoutingType;

@interface EXQSketchView : UIImageView

@property (nonatomic, assign) int drawingRoutineType;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSMutableArray *drawingStack;
@property (nonatomic, strong) UIImage *backgroundImage;

- (void)addViewToStack:(UIView*)view;

- (UIImage*)renderImage;
- (void)clear;

@end
