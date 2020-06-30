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

%property (retain, nonatomic) UILabel* percentLabel;
%property (retain, nonatomic) CALayer* longBatteryBar;
%property (retain, nonatomic) CALayer* shortBatteryBar;
%property (retain, nonatomic) CALayer* tipBatteryBar;

-(void)viewDidLoad {

  %orig;

  if ([self.module isKindOfClass:NSClassFromString(@"CCUILowPowerModule")]) {

		CALayer* LPM_replaykit = self.view.layer.sublayers[0].sublayers[1].sublayers[0].sublayers[0];

		for (CALayer* layerItem in LPM_replaykit.sublayers) {

			if ([layerItem.name isEqual: @"yellow long guy that gets short"]) {

				self.longBatteryBar = layerItem;

			} else if ([layerItem.name isEqual: @"white short guy that gets long"]) {

				self.shortBatteryBar = layerItem;

			} else if ([layerItem.name isEqual: @"tip"]) {

				self.tipBatteryBar = layerItem;

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

  }

}

-(void)viewWillAppear:(BOOL)arg1 {
  %orig(arg1);

  int battery = [[UIDevice currentDevice] batteryLevel] * 100;
  self.percentLabel.text = [NSString stringWithFormat:@"%i%%", battery];

  [self.percentLabel sizeToFit];
  self.percentLabel.frame = CGRectMake(self.view.frame.size.width/2 - self.percentLabel.frame.size.width/2, self.view.frame.size.height * 0.70, self.percentLabel.frame.size.width, self.percentLabel.frame.size.height);


	self.longBatteryBar.backgroundColor  = [[UIColor redColor]    CGColor];
	self.shortBatteryBar.backgroundColor = [[UIColor greenColor]  CGColor];
	self.tipBatteryBar.backgroundColor   = [[UIColor blueColor]   CGColor];

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
