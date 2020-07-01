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

    CATransform3D transform = CATransform3DTranslate(
        CATransform3DMakeScale(1.2, 1.2, 1),
        0, 5, 0
    );

    LPM_replaykit.sublayerTransform = transform;

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
			self.percentLabel.textColor = [UIColor blackColor];
	  } else {
			self.percentLabel.textColor = [UIColor whiteColor];
	  }

    [self.percentLabel setFont:[UIFont boldSystemFontOfSize:13]];
	  [self.view addSubview:self.percentLabel];

  }

}

-(void)touchesEnded:(id)arg1 forEvent:(id)arg2 {
  %orig;
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=BATTERY_USAGE"]];
}

-(void)viewWillAppear:(BOOL)arg1 {
  %orig(arg1);

  int battery = [[UIDevice currentDevice] batteryLevel] * 100;
  self.percentLabel.text = [NSString stringWithFormat:@"%i%%", battery];

  [self.percentLabel sizeToFit];
  self.percentLabel.frame = CGRectMake(self.view.frame.size.width/2 - self.percentLabel.frame.size.width/2, self.view.frame.size.height * 0.65, self.percentLabel.frame.size.width, self.percentLabel.frame.size.height);

  [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
  [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceBatteryStateDidChangeNotification object:nil queue:
    [NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

      [self refreshIcon];

  }];

  [self refreshIcon];

}

-(void)refreshState {

  %orig;

  [self refreshIcon];

}

%new
-(void)refreshIcon {

  [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];

  // [[UIDevice currentDevice] batteryState] != UIDeviceBatteryStateUnplugged
  // [[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging

  if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging) {

    self.longBatteryBar.backgroundColor  = [[UIColor batteryGreen] CGColor];
    self.shortBatteryBar.backgroundColor = [[UIColor batteryGreen] CGColor];
    self.tipBatteryBar.backgroundColor   = [[UIColor batteryGreen] CGColor];

  } else if ([self.module isSelected]) {

    self.longBatteryBar.backgroundColor  = [[UIColor batteryYellow] CGColor];
    self.shortBatteryBar.backgroundColor = [[UIColor batteryYellow] CGColor];
    self.tipBatteryBar.backgroundColor   = [[UIColor batteryYellow] CGColor];

  } else {

    self.longBatteryBar.backgroundColor  = [[UIColor batteryRed]    CGColor];
    self.shortBatteryBar.backgroundColor = [[UIColor batteryRed]    CGColor];
    self.tipBatteryBar.backgroundColor   = [[UIColor batteryRed]    CGColor];

  }

  if ([self.module isSelected]) {
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
