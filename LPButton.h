#import <UIKit/UIKit.h>

// UIViewController* ancestor;

// @interface CCUIToggleModule : NSObject
//
// @property (retain, nonatomic) NSString* glyphState;
//
// @end
//

@interface CAPackage : NSObject

@property (readonly) CALayer *rootLayer;
@property (readonly) BOOL geometryFlipped;

+ (id)packageWithContentsOfURL:(id)arg1 type:(id)arg2 options:(id)arg3 error:(id)arg4;
- (id)_initWithContentsOfURL:(id)arg1 type:(id)arg2 options:(id)arg3 error:(id)arg4;

@end

extern NSString const *kCAPackageTypeCAMLBundle;

@interface CCUICAPackageDescription : NSObject
@property (nonatomic, copy, readonly) NSURL *packageURL;
@property (assign, nonatomic) BOOL flipsForRightToLeftLayoutDirection;
+ (instancetype)descriptionForPackageNamed:(NSString *)name inBundle:(NSBundle *)bundle;
- (BOOL)flipsForRightToLeftLayoutDirection;
- (CCUICAPackageDescription *)initWithPackageName:(NSString *)name inBundle:(NSBundle *)bundle;
- (void)setFlipsForRightToLeftLayoutDirection:(BOOL)flips;
- (NSURL *)packageURL;
@end

@interface CCUICAPackageView : UIView

@property (nonatomic, retain) CAPackage* package;
// @property(nonatomic, retain) CALayer* packageLayer;
// @property(nonatomic) double* scale;
@property (nonatomic, retain) CCUICAPackageDescription* packageDescription;

@end

@interface CCUIButtonModuleView : UIControl

-(BOOL)isSelected;
@property(nonatomic, retain) CCUICAPackageDescription* glyphPackageDescription;
@property (retain, nonatomic) NSString* glyphState;
-(void)setGlyphPackageDescription;

@end

// @interface NSObject (Private)
// -(BOOL)isSelected;
// @end

@interface CCUIToggleViewController : UIViewController

// @property(nonatomic, retain)UIView* highlightedBackgroundView;

@property (retain, nonatomic) UILabel *percentLabel;

// @property (retain, nonatomic) UIColor* selectedGlyphColor;
@property (retain, nonatomic) NSString* glyphState;
// @property (retain, nonatomic) CCUIButtonModuleView*
// selectedColor
@property (retain, nonatomic) CCUIButtonModuleView* module;

// - (id)_viewControllerForAncestor;

@end
