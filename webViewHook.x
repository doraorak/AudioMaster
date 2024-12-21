#include "sharedHeader.h"

%hook WKWebView 

%new 
-(void) setCategoryToPlayback{ 

NSMutableString* jsInject = @"navigator.audioSession.type = 'playback';";

    [self evaluateJavaScript:jsInject completionHandler:^(id _Nullable result, NSError * _Nullable error){
        if(error == nil){
            NSLog(@"[dora] result:%@", result);
        }
        else{
                NSLog(@"[dora] %@", error);

        }
        
        
    }];

    NSLog(@"[dora]setplayback called");
}



%new 
-(void) setCategoryToAuto {

    [self evaluateJavaScript:@"navigator.audioSession.type = 'auto';" completionHandler:^(id _Nullable result, NSError * _Nullable error){
        if(error == nil){
            NSLog(@"[dora]auto result:%@", result);
        }
        else{
                NSLog(@"[dora]auto error:%@",error);
        }
        
        
    }]; 
    NSLog(@"[dora]setauto called");
}

%end