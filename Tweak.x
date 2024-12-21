#include "sharedHeader.h"

tweakMenuViewController* menuViewController;
UILongPressGestureRecognizer* gestureRecognizer;
UISwitch* ringerAudioSwitch;
UISwitch* allowMixingSwitch;
UISwitch* duckSwitch;
UIButton* resumeButton;
UIButton* nextButton;
UIButton* previousButton;
UIView* menu;
musicResumer* resumer;

BOOL firstTime = YES;

@implementation musicResumer

-(void) resumeMusic{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"[dora] resumeMusic removedObserver");  
if(CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMAllowMixingSwitchEnabled", kCFPreferencesCurrentApplication) == kCFBooleanTrue)
{
    MRMediaRemoteSendCommand(0, nil);
    NSLog(@"[dora] resumeMusic");  
}   
}

@end

@implementation tweakMenuViewController

-(void) showMenu{

if(firstTime){

    self.view = menu;
    menu.layer.cornerCurve = kCACornerCurveCircular;
    menu.layer.cornerRadius = 12;
    menu.layer.masksToBounds = YES;
    menu.translatesAutoresizingMaskIntoConstraints = NO;
    menu.alpha = 0;

    UIBlurEffect* blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
    UIVisualEffectView* blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;

    UIStackView* stackView = [UIStackView new];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 5;

    UILabel *titleText = [UILabel new]; 
    titleText.lineBreakMode = NSLineBreakByCharWrapping;
    [titleText setText:@"Audio Master"];
    [titleText setTextColor:[UIColor labelColor]];
    [titleText setBackgroundColor:[UIColor clearColor]];
    [titleText setFont:[UIFont systemFontOfSize: 20.0f]]; 
    titleText.translatesAutoresizingMaskIntoConstraints = NO;
    

    [menu insertSubview: blurEffectView atIndex:0];
    [menu addSubview: stackView];
    [menu addSubview: titleText];
    [UIApplication.sharedApplication.keyWindow addSubview:menu];

    
    [NSLayoutConstraint activateConstraints:@[


        [menu.leadingAnchor constraintGreaterThanOrEqualToAnchor:menu.superview.safeAreaLayoutGuide.leadingAnchor constant:16],
        [menu.topAnchor constraintGreaterThanOrEqualToAnchor:menu.superview.safeAreaLayoutGuide.topAnchor constant:8],
        [menu.centerXAnchor constraintEqualToAnchor:menu.superview.safeAreaLayoutGuide.centerXAnchor],
        [menu.centerYAnchor constraintEqualToAnchor:menu.superview.safeAreaLayoutGuide.centerYAnchor],
        
        [stackView.leadingAnchor constraintEqualToAnchor:menu.leadingAnchor constant:10],
        [stackView.topAnchor constraintEqualToAnchor:titleText.bottomAnchor constant:24],
        [menu.bottomAnchor constraintEqualToAnchor:stackView.bottomAnchor constant:6], 
        [menu.trailingAnchor constraintEqualToAnchor:stackView.trailingAnchor constant:16],
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [blurEffectView.widthAnchor constraintEqualToAnchor:menu.widthAnchor],
        [blurEffectView.heightAnchor constraintEqualToAnchor:menu.heightAnchor],

        [blurEffectView.centerXAnchor constraintEqualToAnchor:menu.centerXAnchor],
        [blurEffectView.centerYAnchor constraintEqualToAnchor:menu.centerYAnchor]
    ]];


       [NSLayoutConstraint activateConstraints:@[
        [titleText.widthAnchor constraintEqualToConstant:120],
        [titleText.heightAnchor constraintEqualToConstant:25],

        [titleText.centerXAnchor constraintEqualToAnchor:menu.centerXAnchor],
        [titleText.topAnchor constraintEqualToAnchor:menu.topAnchor constant:24]
    ]];

//ringer
UIView* ringerRowView = [UIView new];
ringerRowView.translatesAutoresizingMaskIntoConstraints = NO;


UILabel *ringerAudioText = [[UILabel alloc] init]; 
[ringerAudioText setText:@"Allow audio when ringer switch is on silent"];
[ringerAudioText setTextColor:[UIColor labelColor]];
[ringerAudioText setBackgroundColor:[UIColor clearColor]];
[ringerAudioText setFont:[UIFont systemFontOfSize: 13.0f]]; 
ringerAudioText.translatesAutoresizingMaskIntoConstraints = NO;
[ringerRowView addSubview: ringerAudioText];

if(!ringerAudioSwitch)
ringerAudioSwitch = [[UISwitch alloc] init]; 

ringerAudioSwitch.translatesAutoresizingMaskIntoConstraints = NO;
[ringerRowView addSubview: ringerAudioSwitch];

[ringerAudioSwitch addTarget:self action:@selector(allowRingerAudio:) forControlEvents:UIControlEventValueChanged];

[stackView addArrangedSubview:ringerRowView];

[NSLayoutConstraint activateConstraints:@[
            [ringerAudioText.leadingAnchor constraintEqualToAnchor:ringerRowView.leadingAnchor constant:0],
            [ringerAudioText.centerYAnchor constraintEqualToAnchor:ringerAudioSwitch.centerYAnchor],
            [ringerAudioSwitch.leadingAnchor constraintGreaterThanOrEqualToAnchor:ringerAudioText.trailingAnchor constant:8],
            
            [ringerRowView.trailingAnchor constraintEqualToAnchor:ringerAudioSwitch.trailingAnchor constant:0],
            [ringerAudioSwitch.topAnchor constraintEqualToAnchor:ringerRowView.topAnchor constant:4],
            [ringerRowView.bottomAnchor constraintEqualToAnchor:ringerAudioSwitch.bottomAnchor constant:4],
        ]];


//mix
UIView* mixRowView = [UIView new];
mixRowView.translatesAutoresizingMaskIntoConstraints = NO;

UILabel *allowMixingSwitchText = [[UILabel alloc] init];
[allowMixingSwitchText setText:@"Allow external audio to mix with this app"];
[allowMixingSwitchText setTextColor:[UIColor labelColor]];
[allowMixingSwitchText setBackgroundColor:[UIColor clearColor]];
[allowMixingSwitchText setFont:[UIFont systemFontOfSize: 13.0f]]; 
allowMixingSwitchText.translatesAutoresizingMaskIntoConstraints = NO;
[mixRowView addSubview: allowMixingSwitchText];

if(!allowMixingSwitch)
allowMixingSwitch = [[UISwitch alloc] init];

allowMixingSwitch.translatesAutoresizingMaskIntoConstraints = NO;
[mixRowView addSubview: allowMixingSwitch];

[allowMixingSwitch addTarget:self action:@selector(allowMixingAudio:) forControlEvents:UIControlEventValueChanged];

[stackView addArrangedSubview:mixRowView];

[NSLayoutConstraint activateConstraints:@[
            [allowMixingSwitchText.leadingAnchor constraintEqualToAnchor:mixRowView.leadingAnchor constant:0],
            [allowMixingSwitchText.centerYAnchor constraintEqualToAnchor:allowMixingSwitch.centerYAnchor],
            [allowMixingSwitch.leadingAnchor constraintGreaterThanOrEqualToAnchor:allowMixingSwitchText.trailingAnchor constant:8],
            
            [mixRowView.trailingAnchor constraintEqualToAnchor:allowMixingSwitch.trailingAnchor constant:0],
            [allowMixingSwitch.topAnchor constraintEqualToAnchor:mixRowView.topAnchor constant:4],
            [mixRowView.bottomAnchor constraintEqualToAnchor:allowMixingSwitch.bottomAnchor constant:4],
        ]];

//duck
UIView* duckRowView = [UIView new];
duckRowView.translatesAutoresizingMaskIntoConstraints = NO;

UILabel *duckSwitchText = [[UILabel alloc] init];
[duckSwitchText setText:@"Lower external audio"];
[duckSwitchText setTextColor:[UIColor labelColor]];
[duckSwitchText setBackgroundColor:[UIColor clearColor]];
[duckSwitchText setFont:[UIFont systemFontOfSize: 13.0f]]; 
duckSwitchText.translatesAutoresizingMaskIntoConstraints = NO;
[duckRowView addSubview: duckSwitchText];

if(!duckSwitch)
duckSwitch = [[UISwitch alloc] init];

duckSwitch.translatesAutoresizingMaskIntoConstraints = NO;
[duckRowView addSubview: duckSwitch];

[duckSwitch addTarget:self action:@selector(playbackShouldDuckOthers:) forControlEvents:UIControlEventValueChanged];

[stackView addArrangedSubview:duckRowView];

[NSLayoutConstraint activateConstraints:@[
            [duckSwitchText.leadingAnchor constraintEqualToAnchor:duckRowView.leadingAnchor constant:0],
            [duckSwitchText.centerYAnchor constraintEqualToAnchor:duckSwitch.centerYAnchor],
            [duckSwitch.leadingAnchor constraintGreaterThanOrEqualToAnchor:duckSwitchText.trailingAnchor constant:8],
            
            [duckRowView.trailingAnchor constraintEqualToAnchor:duckSwitch.trailingAnchor constant:0],
            [duckSwitch.topAnchor constraintEqualToAnchor:duckRowView.topAnchor constant:4],
            [duckRowView.bottomAnchor constraintEqualToAnchor:duckSwitch.bottomAnchor constant:4],
        ]];

    [stackView setCustomSpacing:24 afterView:duckRowView];

UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeClose];
[closeButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
closeButton.translatesAutoresizingMaskIntoConstraints = NO;
[menu addSubview: closeButton];
[NSLayoutConstraint activateConstraints:@[
        [closeButton.trailingAnchor constraintEqualToAnchor:menu.trailingAnchor constant:-15],
        [closeButton.centerYAnchor constraintEqualToAnchor:titleText.centerYAnchor],
        [closeButton.widthAnchor constraintEqualToConstant:20],
        [closeButton.heightAnchor constraintEqualToConstant:20]
    ]];

[closeButton addTarget:self action:@selector(menuShouldDismiss:) forControlEvents:UIControlEventTouchUpInside];

UIButton* settingsButton = [UIButton systemButtonWithImage:[UIImage systemImageNamed:@"gearshape.fill"] target:self action:@selector(openSettingsSheet)];
settingsButton.translatesAutoresizingMaskIntoConstraints = NO;  
settingsButton.tintColor = [UIColor whiteColor];
[menu addSubview: settingsButton];
[NSLayoutConstraint activateConstraints:@[
        [settingsButton.leadingAnchor constraintEqualToAnchor:menu.leadingAnchor constant:15],
        [settingsButton.centerYAnchor constraintEqualToAnchor:titleText.centerYAnchor],
        [settingsButton.widthAnchor constraintEqualToConstant:20],
        [settingsButton.heightAnchor constraintEqualToConstant:20]
    ]];

UIView* mediaControlRowView = [UIView new];
mediaControlRowView.translatesAutoresizingMaskIntoConstraints = NO;

if(!resumeButton)
resumeButton = [UIButton systemButtonWithImage:[UIImage systemImageNamed:@"play.fill"] target:self action:@selector(nowPlayingSongShouldResume:)];

resumeButton.translatesAutoresizingMaskIntoConstraints = NO;
resumeButton.tintColor = [UIColor whiteColor];
resumeButton.imageView.contentMode = UIViewContentModeScaleAspectFit; //idk if this does anything at all

if(!nextButton)
nextButton = [UIButton systemButtonWithImage:[UIImage systemImageNamed:@"forward.fill"] target:self action:@selector(nowPlayingSongShouldSkipNext:)];

nextButton.translatesAutoresizingMaskIntoConstraints = NO;
nextButton.tintColor = [UIColor whiteColor];
nextButton.imageView.contentMode = UIViewContentModeScaleAspectFit;

if(!previousButton)
previousButton = [UIButton systemButtonWithImage:[UIImage systemImageNamed:@"backward.fill"] target:self action:@selector(nowPlayingSongShouldSkipPrev:)];

previousButton.translatesAutoresizingMaskIntoConstraints = NO;
previousButton.tintColor = [UIColor whiteColor];
previousButton.imageView.contentMode = UIViewContentModeScaleAspectFit;


[mediaControlRowView addSubview: resumeButton];
[mediaControlRowView addSubview: nextButton];
[mediaControlRowView addSubview: previousButton];

[stackView addArrangedSubview: mediaControlRowView];

[NSLayoutConstraint activateConstraints:@[
            [resumeButton.centerXAnchor constraintEqualToAnchor:mediaControlRowView.centerXAnchor],
            [resumeButton.centerYAnchor constraintEqualToAnchor:mediaControlRowView.centerYAnchor],
            [resumeButton.heightAnchor constraintEqualToConstant:30],
            [resumeButton.widthAnchor constraintEqualToConstant:30],

            [nextButton.centerYAnchor constraintEqualToAnchor:mediaControlRowView.centerYAnchor],
            [nextButton.heightAnchor constraintEqualToAnchor:resumeButton.heightAnchor multiplier:0.8f],
            [nextButton.widthAnchor constraintEqualToConstant:26],
            [nextButton.leadingAnchor constraintEqualToAnchor:resumeButton.leadingAnchor constant: 50],

            [previousButton.centerYAnchor constraintEqualToAnchor:mediaControlRowView.centerYAnchor],
            [previousButton.heightAnchor constraintEqualToAnchor:resumeButton.heightAnchor multiplier:0.8f],
            [previousButton.widthAnchor constraintEqualToConstant:26],
            [previousButton.trailingAnchor constraintEqualToAnchor:resumeButton.trailingAnchor constant: -50],

        ]];

        //detect current settings of the app if persistence isn't enabled
if(CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMPersistenceEnabled", kCFPreferencesCurrentApplication) != kCFBooleanTrue){
if([[AVAudioSession sharedInstance] category] == AVAudioSessionCategoryPlayback){
    [ringerAudioSwitch setOn:YES]; //no way to detect if media mixing is allowed, so we lie that it isn't for stability reasons. rip
    [allowMixingSwitch setOn:NO];
    [duckSwitch setEnabled:NO];

    [resumeButton setEnabled:NO];
    [nextButton setEnabled:NO];
    [previousButton setEnabled:NO];
}
else if([[AVAudioSession sharedInstance] category]  == AVAudioSessionCategoryAmbient){
    [ringerAudioSwitch setOn:NO];
    [allowMixingSwitch setOn:YES];
    [duckSwitch setEnabled:NO];
}
else if([[AVAudioSession sharedInstance] category]  == AVAudioSessionCategorySoloAmbient){
    [ringerAudioSwitch setOn:NO];
    [allowMixingSwitch setOn:NO];
    [duckSwitch setEnabled:NO];

    [resumeButton setEnabled:NO];
    [nextButton setEnabled:NO];
    [previousButton setEnabled:NO];
}
}

[self updateResumeButton];


firstTime = NO;}


[self.twoFingerGestureRecognizer setEnabled:NO];

[UIView transitionWithView:menu duration:0.5
    options:UIViewAnimationOptionPreferredFramesPerSecond60 
    animations:^ { menu.alpha = 1; }
    completion:nil];
}

-(IBAction) openSettingsSheet {

UIAlertController* settingsAlertController = [UIAlertController alertControllerWithTitle:@"Settings" 
                                 message:nil 
                          preferredStyle:UIAlertControllerStyleActionSheet];

UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
   handler:^(UIAlertAction * action) {}];

[settingsAlertController addAction:cancelAction];

UIAlertAction* pressDurationAction = [UIAlertAction actionWithTitle:@"Change press duration" style:UIAlertActionStyleDefault
   handler:^(UIAlertAction * action) {

        UIAlertController* durationInputAlertController = [UIAlertController alertControllerWithTitle:@"Enter new duration"
                               message:nil
                               preferredStyle:UIAlertControllerStyleAlert];

          [durationInputAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                if(self.pressDuration != 0.0f)
                 textField.placeholder = [NSString stringWithFormat:@"%f", self.pressDuration];
                else{
                 textField.placeholder = @"0.7";
                } }];
 
        UIAlertAction* durationInputAction = [UIAlertAction actionWithTitle:@"Change" style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction * action) {

                    if([[durationInputAlertController textFields][0] text] != nil){

                        NSCharacterSet* filterCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
                        
                        NSString *trimmedString = [[[durationInputAlertController textFields][0] text] stringByTrimmingCharactersInSet:filterCharacterSet];
                        if([trimmedString length] != 0){
                        NSLog(@"[dora] apple is lying float:%f length:%lu", [trimmedString floatValue], (unsigned long)[trimmedString length]);                        
                        self.pressDuration = [trimmedString floatValue];
                        self.twoFingerGestureRecognizer.minimumPressDuration = self.pressDuration;    
                        }
                        else if([trimmedString length] == 0){
                        NSLog(@"[dora] apple is lying(empty) float:%f length:%lu", [trimmedString floatValue], (unsigned long)[trimmedString length]);                        
                        self.pressDuration =  0.7f;
                        self.twoFingerGestureRecognizer.minimumPressDuration = self.pressDuration;  
                        }
                        
                    }else{
                        NSLog(@"[dora] apple is not lying");
                        self.pressDuration =  0.7f;
                        self.twoFingerGestureRecognizer.minimumPressDuration = self.pressDuration;
                    }

                if(CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMPersistenceEnabled", kCFPreferencesCurrentApplication) == kCFBooleanTrue){
                    float numberCreatePressDuration = self.pressDuration;
                     CFPreferencesSetAppValue((__bridge CFStringRef)@"AMPressDuration", CFNumberCreate(NULL, kCFNumberFloatType, &numberCreatePressDuration), kCFPreferencesCurrentApplication);
                     CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
                  }
                    
                    }];
 
            [durationInputAlertController addAction:durationInputAction];

            UIAlertAction* durationInputCancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
            handler:^(UIAlertAction * action) {}];

            [durationInputAlertController addAction:durationInputCancelAction];

        [self presentViewController:durationInputAlertController animated:YES completion:nil];

     }];

[settingsAlertController addAction:pressDurationAction];

UIAlertAction* persistenceAction = [UIAlertAction actionWithTitle:@"Change persistence" style:UIAlertActionStyleDefault
   handler:^(UIAlertAction * action) {

        UIAlertController* persistenceInputController = [UIAlertController alertControllerWithTitle:@"Do you want tweak to persist"
                               message:nil
                               preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* persistenceNoAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action) {

                            CFPreferencesSetAppValue((__bridge CFStringRef)@"AMPersistenceEnabled", kCFBooleanFalse, kCFPreferencesCurrentApplication);
                            CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);

            }];

            [persistenceInputController addAction:persistenceNoAction];


            UIAlertAction* persistenceYesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction * action) {

                            CFPreferencesSetAppValue((__bridge CFStringRef)@"AMPersistenceEnabled", kCFBooleanTrue, kCFPreferencesCurrentApplication);
                            CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
                    }];
 
            [persistenceInputController addAction:persistenceYesAction];

        [self presentViewController:persistenceInputController animated:YES completion:nil];

     }];

[settingsAlertController addAction:persistenceAction];


[self presentViewController:settingsAlertController animated:YES completion:nil];

}


-(IBAction) nowPlayingSongShouldResume:(id) sender{

MRMediaRemoteSendCommand(2, nil); 

}

-(IBAction) nowPlayingSongShouldSkipNext:(id) sender{

MRMediaRemoteSendCommand(4, nil);

}

-(IBAction) nowPlayingSongShouldSkipPrev:(id) sender{

MRMediaRemoteSendCommand(5, nil);

}


-(IBAction) allowMixingAudio:(id) sender{

    if(CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMPersistenceEnabled", kCFPreferencesCurrentApplication) == kCFBooleanTrue){

if(((UISwitch *)sender).on){
        CFPreferencesSetAppValue((__bridge CFStringRef)@"AMAllowMixingSwitchEnabled", kCFBooleanTrue, kCFPreferencesCurrentApplication);
        CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);        
    }else{
        CFPreferencesSetAppValue((__bridge CFStringRef)@"AMAllowMixingSwitchEnabled", kCFBooleanFalse, kCFPreferencesCurrentApplication);
        CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication); 
    }
    }

if (((UISwitch *)sender).on){ 

    [resumeButton setEnabled:YES];
    [nextButton setEnabled:YES];
    [previousButton setEnabled:YES];

    if([[AVAudioSession sharedInstance] category]  == AVAudioSessionCategoryAmbient){

    }
    else if([[AVAudioSession sharedInstance] category] == AVAudioSessionCategoryPlayback){

        setCategoryOriginal([AVAudioSession sharedInstance], @selector(setCategory:mode:options:error:), AVAudioSessionCategoryPlayback, AVAudioSessionModeDefault, AVAudioSessionCategoryOptionMixWithOthers, nil);

    }
    else if([[AVAudioSession sharedInstance] category]  == AVAudioSessionCategorySoloAmbient){

        setCategoryOriginal([AVAudioSession sharedInstance], @selector(setCategory:mode:options:error:), AVAudioSessionCategoryAmbient, AVAudioSessionModeDefault, 0, nil);

    }

    

    }
else{

 if([[AVAudioSession sharedInstance] category]  == AVAudioSessionCategoryAmbient){

        setCategoryOriginal([AVAudioSession sharedInstance], @selector(setCategory:mode:options:error:), AVAudioSessionCategorySoloAmbient, AVAudioSessionModeDefault, 0, nil);        
    }
    else if([[AVAudioSession sharedInstance] category] == AVAudioSessionCategoryPlayback){

        setCategoryOriginal([AVAudioSession sharedInstance], @selector(setCategory:mode:options:error:), AVAudioSessionCategoryPlayback, AVAudioSessionModeDefault, 0, nil);

    }
    else if([[AVAudioSession sharedInstance] category]  == AVAudioSessionCategorySoloAmbient){
    }

    [resumeButton setEnabled:NO];
    [nextButton setEnabled:NO];
    [previousButton setEnabled:NO];

}

if([allowMixingSwitch isOn] && [ringerAudioSwitch isOn]){

    [duckSwitch setEnabled:YES];

  }
  else{
    
    [duckSwitch setEnabled:NO];

  }
}


-(IBAction) playbackShouldDuckOthers:(id) sender{

    if(CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMPersistenceEnabled", kCFPreferencesCurrentApplication) == kCFBooleanTrue){

if(((UISwitch *)sender).on){
        CFPreferencesSetAppValue((__bridge CFStringRef)@"AMDuckSwitchEnabled", kCFBooleanTrue, kCFPreferencesCurrentApplication);
        CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);        
    }else{
        CFPreferencesSetAppValue((__bridge CFStringRef)@"AMDuckSwitchEnabled", kCFBooleanFalse, kCFPreferencesCurrentApplication);
        CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication); 
    }
    }

if (((UISwitch *)sender).on){

    [ringerAudioSwitch setEnabled:NO];
    [allowMixingSwitch setEnabled:NO];

    setCategoryOriginal([AVAudioSession sharedInstance], @selector(setCategory:mode:options:error:), AVAudioSessionCategoryPlayback, AVAudioSessionModeDefault, AVAudioSessionCategoryOptionDuckOthers, nil);

}
else{

        setCategoryOriginal([AVAudioSession sharedInstance], @selector(setCategory:mode:options:error:), AVAudioSessionCategoryPlayback, AVAudioSessionModeDefault, AVAudioSessionCategoryOptionMixWithOthers, nil);

        [allowMixingSwitch setEnabled:YES];
        [ringerAudioSwitch setEnabled:YES];
    }
    
     }

-(IBAction) allowRingerAudio:(id) sender{

if(CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMPersistenceEnabled", kCFPreferencesCurrentApplication) == kCFBooleanTrue){

if(((UISwitch *)sender).on){
        CFPreferencesSetAppValue((__bridge CFStringRef)@"AMRingerAudioSwitchEnabled", kCFBooleanTrue, kCFPreferencesCurrentApplication);
        CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);        
    }else{
        CFPreferencesSetAppValue((__bridge CFStringRef)@"AMRingerAudioSwitchEnabled", kCFBooleanFalse, kCFPreferencesCurrentApplication);
        CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication); 
    }
    }

if (((UISwitch *)sender).on){

    if([[AVAudioSession sharedInstance] category] == AVAudioSessionCategoryAmbient){
         [allowMixingSwitch setOn:NO animated:YES];
         [resumeButton setEnabled:NO];
         [nextButton setEnabled:NO];
         [previousButton setEnabled:NO];
    }
        setCategoryOriginal([AVAudioSession sharedInstance], @selector(setCategory:mode:options:error:), AVAudioSessionCategoryPlayback, AVAudioSessionModeDefault, 0, nil);

}
else{

if([allowMixingSwitch isOn]){
    setCategoryOriginal([AVAudioSession sharedInstance], @selector(setCategory:mode:options:error:), AVAudioSessionCategoryAmbient, AVAudioSessionModeDefault, 0, nil);
}
else{
    setCategoryOriginal([AVAudioSession sharedInstance], @selector(setCategory:mode:options:error:), AVAudioSessionCategorySoloAmbient, AVAudioSessionModeDefault, 0, nil);
}
}


if([[[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] class] isSubclassOfClass: objc_getClass("WKWebView")]){
    if(((UISwitch *)sender).on){
        [[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] setCategoryToPlayback];
    }
    else{
        [[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] setCategoryToAuto];
  }
  }

  if([allowMixingSwitch isOn] && [ringerAudioSwitch isOn]){

    [duckSwitch setEnabled:YES];

  }
  else{
    
    [duckSwitch setEnabled:NO];

  }
  
}

-(IBAction) menuShouldDismiss:(id) sender{

    [UIView animateWithDuration:0.5
     animations:^{self.view.alpha = 0.0;}
     completion:nil];

    [self.twoFingerGestureRecognizer setEnabled:YES];
}

-(void) updateResumeButton{
NSLog(@"[dora] updateButton");
MRMediaRemoteGetNowPlayingApplicationIsPlayingCompletion completion = ^(Boolean isPlaying) {
    if (isPlaying) {
        [resumeButton setImage:[UIImage systemImageNamed:@"pause.fill"] forState:UIControlStateNormal];
    }else{
        
        [resumeButton setImage:[UIImage systemImageNamed:@"play.fill"] forState:UIControlStateNormal];
    }
};

MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_get_main_queue(), completion);
}

@end


%hook UIWindow

%property (nonatomic) BOOL gestureRecognizerAdded;

- (void)becomeKeyWindow {
    %orig;

    BOOL isStatusBar = [self isKindOfClass:[UIStatusBarWindow class]];

    if (!self.gestureRecognizerAdded && !isStatusBar) {

    gestureRecognizer.numberOfTouchesRequired = 2;
    if(menuViewController.pressDuration == 0.0f){
    menuViewController.pressDuration = 0.7f;
    gestureRecognizer.minimumPressDuration = menuViewController.pressDuration;       
    }

    [self addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer addTarget:menuViewController action:@selector(showMenu)];

    if(menuViewController.twoFingerGestureRecognizer == nil)
    [menuViewController setTwoFingerGestureRecognizer:gestureRecognizer];
    self.gestureRecognizerAdded = YES;

    }
}

%end

BOOL (*setCategoryOriginal)(id, SEL, AVAudioSessionCategory, AVAudioSessionMode, AVAudioSessionCategoryOptions, NSError **);


__attribute__ ((constructor(997)))
void springBoardCheck(){ //we don't want to inject into springboard

if ([safe_getBundleIdentifier() isEqualToString: @"com.apple.springboard"]){
    return;
}

}

__attribute__ ((constructor(998))) 
void setup(){
    NSLog(@"[dora] consSetup");
    if (CFPreferencesCopyAppValue((__bridge CFStringRef)@"AMDontShowIncompatible", kCFPreferencesCurrentApplication) != kCFBooleanTrue) {
    NSLog(@"[dora] inside key conditions if");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (dispatch_time_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if ([[AVAudioSession sharedInstance] category] != AVAudioSessionCategoryAmbient && [[AVAudioSession sharedInstance] category] != AVAudioSessionCategorySoloAmbient && [[AVAudioSession sharedInstance] category] != AVAudioSessionCategoryPlayback){
           NSLog(@"[dora] inside session conditions if");

            UIAlertController* warningAlertController = [UIAlertController alertControllerWithTitle:@"Warning" 
                                 message:@"Audio Master seems to be incompatible with this app."
                               preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* dontShowAction = [UIAlertAction actionWithTitle:@"Don't show again" style:UIAlertActionStyleDestructive
            handler:^(UIAlertAction * action) {
                CFPreferencesSetAppValue((__bridge CFStringRef)@"AMDontShowIncompatible", kCFBooleanTrue, kCFPreferencesCurrentApplication);
                CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
            }];
            [warningAlertController addAction:dontShowAction];

            UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action) {NSLog(@"[dora] ok");     }];
            [warningAlertController addAction:okAction];

            [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:warningAlertController animated:YES completion:nil];
            
    }
    });
    }
    menuViewController = [tweakMenuViewController new];
    menu  = [UIView new];
    gestureRecognizer = [UILongPressGestureRecognizer new];
    SEL selector = NSSelectorFromString(@"setCategory:mode:options:error:");
    Method method = class_getInstanceMethod([AVAudioSession class], selector);
    setCategoryOriginal = (BOOL (*)(id, SEL, NSString *, NSString *, AVAudioSessionCategoryOptions, NSError **))method_getImplementation(method);
    
    MRMediaRemoteRegisterForNowPlayingNotifications(dispatch_get_main_queue());
    [[NSNotificationCenter defaultCenter] addObserver:menuViewController selector:@selector(updateResumeButton) name:(__bridge NSString *)kMRMediaRemoteNowPlayingApplicationIsPlayingDidChangeNotification object:nil];
}