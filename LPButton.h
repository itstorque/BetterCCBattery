#import <UIKit/UIKit.h>

// UIViewController* ancestor;

// @interface CCUIToggleModule : NSObject
//
// @property (retain, nonatomic) NSString* glyphState;
//
// @end
//

// @interface CALayer : NSObject

// @property(nonatomic, retain) NSString * name;

// @end

@interface CALayerDelegate : NSObject
@end

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
@property (retain, nonatomic) CALayer* layer;
-(void)setGlyphPackageDescription;

@end

// @interface NSObject (Private)
// -(BOOL)isSelected;
// @end

@interface CCUIToggleViewController : UIViewController

@property (retain, nonatomic) CCUIButtonModuleView* module;

@property (retain, nonatomic) NSString* glyphState;

@property (retain, nonatomic) UILabel* percentLabel;

// internally <CALayer name="yellow long guy that gets short" .../>
@property (retain, nonatomic) CALayer* longBatteryBar;

// internally <CALayer name="white short guy that gets long" .../>
@property (retain, nonatomic) CALayer* shortBatteryBar;

// additional CALayers inside the battery are: "well", "tip"

@end
