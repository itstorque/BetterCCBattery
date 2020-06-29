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

-(void)viewDidLoad {

  %orig;

  if([self.module isKindOfClass:NSClassFromString(@"CCUILowPowerModule")]){
		// self.glyphImageView.backgroundColor = [UIColor purpleColor];

		// self.selectedGlyphColor = [UIColor purpleColor];

		self.percentLabel = [[UILabel alloc] init];

		if([self.module isSelected]){
			self.percentLabel.textColor = [UIColor battery_yellow];
	  } else {
			self.percentLabel.textColor = [UIColor whiteColor];
	  }

	  self.percentLabel.font = [self.percentLabel.font fontWithSize:10];
	  [self.view addSubview:self.percentLabel];

		[self.module setGlyphPackageDescription: [CCUICAPackageDescription descriptionForPackageNamed:@"Mute" inBundle:[NSBundle bundleWithURL: [NSURL URLWithString: @"/System/Library/ControlCenter/Bundles/MuteModule.bundle"]]]];

		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"self.module.glyphPackageView.packageLayer.contentsFormat"
															 message: [NSString stringWithFormat:@"%@",self.module.glyphPackageDescription.packageURL]
															 //[self.module.glyphPackageView.packageDescription.packageURL absoluteString]
															 preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
			 handler:^(UIAlertAction * action) {}];

		[alert addAction:defaultAction];
		[[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];

		// self.module.glyphPackageView.package = [CAPackage packageWithContentsOfURL:[NSURL fileURLWithPath:@"/System/Library/ControlCenter/Bundles/MuteModule.bundle/Mute.ca"] type:kCAPackageTypeCAMLBundle options:nil error:nil];

  } else {

		// self.selectedGlyphColor = [UIColor greenColor];

	}



}

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
