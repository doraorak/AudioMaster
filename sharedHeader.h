#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFAudio/AVFAudio.h>
#import <WebKit/WebKit.h>
#import <objc/runtime.h>
#import <AVKit/AVKit.h>
#import <MediaRemote/MediaRemote.h>
#import <CoreFoundation/CoreFoundation.h>

static NSString *safe_getBundleIdentifier(void) {
    const CFBundleRef mainBundle = CFBundleGetMainBundle();
    return mainBundle ? (__bridge NSString *)CFBundleGetIdentifier(mainBundle) : nil;
}

extern BOOL (*setCategoryOriginal)(id, SEL, AVAudioSessionCategory, AVAudioSessionMode, AVAudioSessionCategoryOptions, NSError **);

extern UILongPressGestureRecognizer* gestureRecognizer;

extern UISwitch* ringerAudioSwitch;
extern UISwitch* allowMixingSwitch;
extern UISwitch* duckSwitch;

extern UIButton* resumeButton;
extern UIButton* nextButton;
extern UIButton* previousButton;

@interface UIView (thisTweak)
-(void) setCategoryToPlayback;
-(void) setCategoryToAuto;
@end

@interface UIWindow (thisTweak)

@property (nonatomic) BOOL gestureRecognizerAdded;

@end

@interface UIStatusBarWindow
+(id) class;
@end

@interface musicResumer : NSObject

-(void) resumeMusic;

@end

extern musicResumer* resumer;

@interface tweakMenuViewController : UIViewController

@property UILongPressGestureRecognizer* twoFingerGestureRecognizer;
@property float pressDuration;

-(void) showMenu;
-(IBAction) menuShouldDismiss:(id) sender;
-(IBAction) openSettingsSheet;

-(IBAction) allowRingerAudio:(id) sender;
-(IBAction) playbackShouldDuckOthers:(id) sender;
-(IBAction) allowMixingAudio:(id) sender;

-(void) updateResumeButton;
-(IBAction) nowPlayingSongShouldResume:(id) sender;
-(IBAction) nowPlayingSongShouldSkipNext:(id) sender;
-(IBAction) nowPlayingSongShouldSkipPrev:(id) sender;

@end

extern tweakMenuViewController* menuViewController;

