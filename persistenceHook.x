#include "sharedHeader.h"

%group AVAudioSessionHookGroup
%hook AVAudioSession

- (BOOL)setCategory:(AVAudioSessionCategory)category 
               mode:(AVAudioSessionMode)mode 
 routeSharingPolicy:(AVAudioSessionRouteSharingPolicy)policy 
            options:(AVAudioSessionCategoryOptions)options 
              error:(NSError * _Nullable *)outError{

               return YES;
              }


- (BOOL)setCategory:(AVAudioSessionCategory)category 
               mode:(AVAudioSessionMode)mode 
            options:(AVAudioSessionCategoryOptions)options 
              error:(NSError * _Nullable *)outError{

                return YES;

              }

- (BOOL)setCategory:(AVAudioSessionCategory)category 
        withOptions:(AVAudioSessionCategoryOptions)options 
              error:(NSError * _Nullable *)outError{

                return YES;
              }

- (BOOL)setCategory:(AVAudioSessionCategory)category 
              error:(NSError * _Nullable *)outError{

                return YES;

              }
%end
%end

static void initHookGroup(void){
    %init(AVAudioSessionHookGroup);
}

__attribute__ ((constructor(999)))
void applyPersistance(){
    NSLog(@"[dora] consPersistence");
    resumer = [musicResumer new];
    [[NSNotificationCenter defaultCenter] addObserver:resumer selector:@selector(resumeMusic) name:(__bridge NSString *)kMRMediaRemoteNowPlayingApplicationIsPlayingDidChangeNotification object:nil];
    
    if(CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMPersistenceEnabled", kCFPreferencesCurrentApplication) == kCFBooleanTrue){
        initHookGroup();
    }else{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (dispatch_time_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        initHookGroup();}); //giving 3 seconds for app to set its categories

    }

dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (dispatch_time_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
__block NSError* err = nil;
    if(CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMPersistenceEnabled", kCFPreferencesCurrentApplication) == kCFBooleanTrue)
{
    ringerAudioSwitch = [UISwitch new];
    allowMixingSwitch = [UISwitch new];
    duckSwitch = [UISwitch new];
    resumeButton = [UIButton systemButtonWithImage:[UIImage systemImageNamed:@"play.fill"] target:menuViewController action:@selector(nowPlayingSongShouldResume:)];
    nextButton = [UIButton systemButtonWithImage:[UIImage systemImageNamed:@"forward.fill"] target:menuViewController action:@selector(nowPlayingSongShouldSkipNext:)];
    previousButton = [UIButton systemButtonWithImage:[UIImage systemImageNamed:@"backward.fill"] target:menuViewController action:@selector(nowPlayingSongShouldSkipPrev:)];

NSLog(@"[dora] inside persistenceEnabled ");
if(CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMPressDuration", kCFPreferencesCurrentApplication) != NULL){
    float getValuePressDuration;
    CFNumberGetValue(CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMPressDuration", kCFPreferencesCurrentApplication), kCFNumberFloatType, &getValuePressDuration);
    if(getValuePressDuration <= 30.0f){
        menuViewController.pressDuration = getValuePressDuration;
    }else{
        float numberCreatePressDuration = 30.0f;
        CFPreferencesSetAppValue((__bridge CFStringRef)@"AMPressDuration", CFNumberCreate(NULL, kCFNumberFloatType, &numberCreatePressDuration), kCFPreferencesCurrentApplication);
        CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
        menuViewController.pressDuration = 30.0f;
    }
    gestureRecognizer.minimumPressDuration = menuViewController.pressDuration;
    NSLog(@"[dora] getValuePressDuration:%f pressDuration:%f minimumPressDuration:%f", getValuePressDuration, menuViewController.pressDuration, gestureRecognizer.minimumPressDuration);

}

if (CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMRingerAudioSwitchEnabled", kCFPreferencesCurrentApplication) == kCFBooleanTrue && CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMAllowMixingSwitchEnabled", kCFPreferencesCurrentApplication) == kCFBooleanTrue && CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMDuckSwitchEnabled", kCFPreferencesCurrentApplication) == kCFBooleanTrue)
{    
    setCategoryOriginal([AVAudioSession sharedInstance], @selector(setCategory:mode:options:error:), AVAudioSessionCategoryPlayback, AVAudioSessionModeDefault, AVAudioSessionCategoryOptionDuckOthers, &err);
    NSLog(@"[dora]1 error: %@", err);

    [ringerAudioSwitch setOn:YES];
    [allowMixingSwitch setOn:YES];
    [duckSwitch setOn:YES];

    [ringerAudioSwitch setEnabled:NO];
    [allowMixingSwitch setEnabled:NO];
}
else if (CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMRingerAudioSwitchEnabled", kCFPreferencesCurrentApplication) == kCFBooleanTrue && CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMAllowMixingSwitchEnabled", kCFPreferencesCurrentApplication) == kCFBooleanTrue && CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMDuckSwitchEnabled", kCFPreferencesCurrentApplication) != kCFBooleanTrue)
{    
    setCategoryOriginal([AVAudioSession sharedInstance], @selector(setCategory:mode:options:error:), AVAudioSessionCategoryPlayback, AVAudioSessionModeDefault, AVAudioSessionCategoryOptionMixWithOthers, &err);
    NSLog(@"[dora]2 error: %@", err);

    [ringerAudioSwitch setOn:YES];
    [allowMixingSwitch setOn:YES];
}
else if (CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMRingerAudioSwitchEnabled", kCFPreferencesCurrentApplication) != kCFBooleanTrue && CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMAllowMixingSwitchEnabled", kCFPreferencesCurrentApplication) == kCFBooleanTrue && CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMDuckSwitchEnabled", kCFPreferencesCurrentApplication) != kCFBooleanTrue)
{
    setCategoryOriginal([AVAudioSession sharedInstance], @selector(setCategory:mode:options:error:), AVAudioSessionCategoryAmbient, AVAudioSessionModeDefault, 0, nil);
    NSLog(@"[dora]3 %@", err);
    [allowMixingSwitch setOn:YES];

    [duckSwitch setEnabled:NO];

}
else if (CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMRingerAudioSwitchEnabled", kCFPreferencesCurrentApplication) == kCFBooleanTrue && CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMAllowMixingSwitchEnabled", kCFPreferencesCurrentApplication) != kCFBooleanTrue && CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMDuckSwitchEnabled", kCFPreferencesCurrentApplication) != kCFBooleanTrue)
{
    setCategoryOriginal([AVAudioSession sharedInstance], @selector(setCategory:mode:options:error:), AVAudioSessionCategoryPlayback, AVAudioSessionModeDefault, 0, nil);
    NSLog(@"[dora]4 %@", err);
    [ringerAudioSwitch setOn:YES];

    [duckSwitch setEnabled:NO];

    [resumeButton setEnabled:NO];
    [nextButton setEnabled:NO];
    [previousButton setEnabled:NO];
}
else if (CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMRingerAudioSwitchEnabled", kCFPreferencesCurrentApplication) != kCFBooleanTrue && CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMAllowMixingSwitchEnabled", kCFPreferencesCurrentApplication) != kCFBooleanTrue && CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMDuckSwitchEnabled", kCFPreferencesCurrentApplication) != kCFBooleanTrue)
{
    setCategoryOriginal([AVAudioSession sharedInstance], @selector(setCategory:mode:options:error:), AVAudioSessionCategorySoloAmbient, AVAudioSessionModeDefault, 0, nil);
    NSLog(@"[dora]5 %@", err);
    [duckSwitch setEnabled:NO];

    [resumeButton setEnabled:NO];
    [nextButton setEnabled:NO];
    [previousButton setEnabled:NO];
}

}
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (dispatch_time_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
[[NSNotificationCenter defaultCenter] removeObserver:resumer];
NSLog(@"[dora] persistence removedObserver");
});
});


}