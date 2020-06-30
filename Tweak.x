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

%hook CALayer

-(void)layoutSublayers {

  %orig;

	if ([self.superlayer.superlayer.superlayer.superlayer.delegate isKindOfClass:NSClassFromString(@"CCUILowPowerModule")]) {

		UIAlertController* alert = [UIAlertController alertControllerWithTitle: @"CCUILPM Found"
															 message: @"happy"
															 preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
			 handler:^(UIAlertAction * action) {}];

		[alert addAction:defaultAction];
		[[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];

	}

	if ([self.name isEqual: @"yellow long guy that gets short"]) {

		UIAlertController* alert = [UIAlertController alertControllerWithTitle: [NSString stringWithFormat:@"%@",self.superlayer.superlayer.superlayer.superlayer.superlayer.name]
															 message: [NSString stringWithFormat:@"%@",[self.superlayer.superlayer.superlayer.superlayer delegate]]
															 //[self.module.glyphPackageView.packageDescription.packageURL absoluteString]
															 preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
			 handler:^(UIAlertAction * action) {}];

		[alert addAction:defaultAction];
		[[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];

		self.backgroundColor = [[UIColor batteryRed]  CGColor];

	}

	else if ([self.name isEqual: @"white short guy that gets long"]) {

		self.backgroundColor = [[UIColor greenColor]  CGColor];

	}

	// Those two will be unused for now

	// else if ([self.name isEqual: @"well"]) {
	//
	// 	self.backgroundColor = [[UIColor greenColor]  CGColor];
	//
	// }

	// else if ([self.name isEqual: @"tip"]) {
	//
	// 	self.backgroundColor = [[UIColor blueColor]  CGColor];
	//
	// }

}

%end

%hook CCUIToggleViewController

// static NSString* colorToString(UIColor* color) {
//     CGFloat red, green, blue, alpha;
//     [color getRed:&red green:&green blue:&blue alpha:&alpha];
//     return [NSString stringWithFormat:@"%02x%02x%02x", (int)(red * 255), (int)(green * 255) , (int)(blue * 255)];
// }

%property (retain, nonatomic) UILabel* percentLabel;
%property (retain, nonatomic) CALayer* longBatteryBar;
%property (retain, nonatomic) CALayer* shortBatteryBar;

-(void)viewDidLoad {

  %orig;

  if ([self.module isKindOfClass:NSClassFromString(@"CCUILowPowerModule")]) {
		// self.glyphImageView.backgroundColor = [UIColor purpleColor];

		// self.selectedGlyphColor = [UIColor purpleColor];

		CALayer* LPM_replaykit = self.view.layer.sublayers[0].sublayers[1].sublayers[0].sublayers[0];

		for (CALayer* layerItem in LPM_replaykit.sublayers) {

			if ([layerItem.name isEqual: @"yellow long guy that gets short"]) {

				self.longBatteryBar = layerItem;

				UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"happy"
																	 message: @"boi"
																	 preferredStyle:UIAlertControllerStyleAlert];

				UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
					 handler:^(UIAlertAction * action) {}];

				[alert addAction:defaultAction];
				[[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];

			} else if ([layerItem.name isEqual: @"white short guy that gets long"]) {

				self.shortBatteryBar = layerItem;

			}

		}

		self.percentLabel = [[UILabel alloc] init];

		if([self.module isSelected]){
			self.percentLabel.textColor = [UIColor batteryYellow];
	  } else {
			self.percentLabel.textColor = [UIColor whiteColor];
	  }

	  self.percentLabel.font = [self.percentLabel.font fontWithSize:10];
	  [self.view addSubview:self.percentLabel];

		// [self.module setGlyphPackageDescription: [CCUICAPackageDescription descriptionForPackageNamed:@"Mute" inBundle:[NSBundle bundleWithURL: [NSURL URLWithString: @"/System/Library/ControlCenter/Bundles/MuteModule.bundle"]]]];

		// UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"self.module.glyphPackageView.packageLayer.contentsFormat"
		// 													 message: [NSString stringWithFormat:@"%@",self.module.glyphPackageDescription.packageURL]
		// 													 //[self.module.glyphPackageView.packageDescription.packageURL absoluteString]
		// 													 preferredStyle:UIAlertControllerStyleAlert];
		//
		// UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
		// 	 handler:^(UIAlertAction * action) {}];
		//
		// [alert addAction:defaultAction];
		// [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];

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
		self.percentLabel.textColor = [UIColor batteryYellow];
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
