#import <Foundation/Foundation.h>
#import "LPButton.h"
#import "Utils.h"

@interface NSUserDefaults (Tweak_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

static NSString * nsDomainString = @"com.tareq.betterccbattery";
static NSString * nsNotificationString = @"com.tareq.betterccbattery/preferences.changed";
static BOOL enabled;

%hook CCUIToggleViewController

// static NSString* colorToString(UIColor* color) {
//     CGFloat red, green, blue, alpha;
//     [color getRed:&red green:&green blue:&blue alpha:&alpha];
//     return [NSString stringWithFormat:@"%02x%02x%02x", (int)(red * 255), (int)(green * 255) , (int)(blue * 255)];
// }

%property (retain, nonatomic) UILabel *percentLabel;

%property (nonatomic, retain) CCUICAPackageView *packageView;
- (void)layoutSubviews {
  %orig;
  if (!self.module.packageView) {
    // self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    // self.backgroundView.userInteractionEnabled = NO;
    // self.backgroundView.layer.cornerRadius = self.bounds.size.width/2;
    // self.backgroundView.layer.masksToBounds = YES;
    // self.backgroundView.backgroundColor = [UIColor whiteColor];
    // self.backgroundView.alpha = 0;
    // [self addSubview:self.backgroundView];

    self.module.packageView = [[%c(CCUICAPackageView) alloc] initWithFrame:self.bounds];
    self.module.packageView.package = [CAPackage packageWithContentsOfURL:[NSURL fileURLWithPath:@"/System/Library/ControlCenter/Bundles/MuteModule.bundle/Mute.ca"] type:kCAPackageTypeCAMLBundle options:nil error:nil];
    // [self.module.packageView setStateName:@"dark"];
    [self addSubview:self.module.packageView];

    // [self setHighlighted:NO];
    // [self updateStateAnimated:NO];
  }
}

// -(void)viewDidLoad {
//
//   %orig;
//
//   if([self.module isKindOfClass:NSClassFromString(@"CCUILowPowerModule")]){
// 		// self.glyphImageView.backgroundColor = [UIColor purpleColor];
//
// 		// self.selectedGlyphColor = [UIColor purpleColor];
//
// 		self.percentLabel = [[UILabel alloc] init];
//
// 		if([self.module isSelected]){
// 			self.percentLabel.textColor = [UIColor battery_yellow];
// 	  } else {
// 			self.percentLabel.textColor = [UIColor whiteColor];
// 	  }
//
// 	  self.percentLabel.font = [self.percentLabel.font fontWithSize:10];
// 	  [self.view addSubview:self.percentLabel];
//
// 		// UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"self.module.glyphPackageView.packageLayer.contentsFormat"
// 		// 													 message: [NSString stringWithFormat:@"%.20lf", *self.module.glyphPackageView.scale]//.packageLayer.contentsFormat
// 		// 													 preferredStyle:UIAlertControllerStyleAlert];
// 		//
// 		// UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
// 		// 	 handler:^(UIAlertAction * action) {}];
// 		//
// 		// [alert addAction:defaultAction];
// 		// [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];
//
// 		self.module.packageView.package = [CAPackage packageWithContentsOfURL:[NSURL fileURLWithPath:@"/System/Library/ControlCenter/Bundles/MuteModule.bundle/Mute.ca"] type:kCAPackageTypeCAMLBundle options:nil error:nil];
//
//   } else {
//
// 		// self.selectedGlyphColor = [UIColor greenColor];
//
// 	}
//
//
//
// }

-(void)viewWillAppear:(BOOL)arg1 {
  %orig(arg1);

  int battery = [[UIDevice currentDevice] batteryLevel] * 100;
  self.percentLabel.text = [NSString stringWithFormat:@"%i%%", battery];

  [self.percentLabel sizeToFit];
  self.percentLabel.frame = CGRectMake(self.view.frame.size.width/2 - self.percentLabel.frame.size.width/2, self.view.frame.size.height * 0.70, self.percentLabel.frame.size.width, self.percentLabel.frame.size.height);
}
-(void)refreshState {
  %orig;
  if([self.module isSelected]){
		self.percentLabel.textColor = [UIColor battery_yellow];
  } else {
		self.percentLabel.textColor = [UIColor whiteColor];
  }
}

%end

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber * enabledValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled" inDomain:nsDomainString];
	enabled = (enabledValue)? [enabledValue boolValue] : YES;
}

%ctor {
	// Set variables on start up
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	// Register for 'PostNotification' notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);

	// Add any personal initializations

}
