//
//  ViewController.h
//  G_1A2B
//
//  Created by AprilXMoon on 2014/9/15.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "EntityControl.h"
#import "RecordView.h"


@interface ViewController : UIViewController <UITextFieldDelegate>
{
    int QuestionNumber;
    int Acount;
    int Bcount;
    
    NSTimer *timer;
    NSInteger seconds;
    NSInteger minutes;
    
    //Add AVAudioPlayer objects
    AVAudioPlayer *ButtonBeep;
    AVAudioPlayer *BackgroundMusic;
    

}

@property(retain,nonatomic)IBOutlet UILabel *MessageLabel;
@property(retain,nonatomic)IBOutlet UILabel *TimeLabel;
@property(retain,nonatomic)IBOutlet UITextField *AnswerText;
@property(retain,nonatomic)IBOutlet UIButton *StartButton;


@end

