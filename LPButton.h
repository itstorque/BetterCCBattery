#import <UIKit/UIKit.h>

@interface CCUIButtonModuleView : UIControl

-(BOOL)isSelected;

@property (retain, nonatomic) NSString* glyphState;
@property (retain, nonatomic) CALayer* layer;

@end

@interface CCUIToggleViewController : UIViewController

@property (retain, nonatomic) CCUIButtonModuleView* module;
@property (retain, nonatomic) NSString* glyphState;
-(void)touchesEnded:(id)arg1 forEvent:(id)arg2;

// Created Properties

-(void)refreshIcon;

@property (retain, nonatomic) UILabel* percentLabel;

// internally <CALayer name="yellow long guy that gets short" .../>
@property (retain, nonatomic) CALayer* longBatteryBar;

// internally <CALayer name="white short guy that gets long" .../>
@property (retain, nonatomic) CALayer* shortBatteryBar;

// internally <CALayer name="tip" .../>
@property (retain, nonatomic) CALayer* tipBatteryBar;

// additional CALayers inside the battery are: "well"

@end
