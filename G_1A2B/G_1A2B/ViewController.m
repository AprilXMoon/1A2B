//
//  ViewController.m
//  G_1A2B
//
//  Created by AprilXMoon on 2014/9/15.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end


@implementation ViewController

@synthesize MessageLabel = _MessageLabel;
@synthesize TimeLabel = _TimeLabel;
@synthesize AnswerText = _AnswerText;
@synthesize StartButton = _StartButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _AnswerText.delegate = self;
    
    [self AudioPlayerSetting];
    [self startBackgroundMusic];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Setting Method
-(void)AudioPlayerSetting
{
    ButtonBeep = [self setupAudioPlayerWithFile:@"ButtonTap" type:@"wav"];
    BackgroundMusic = [self setupAudioPlayerWithFile:@"game_maoudamashii_5_village10" type:@"mp3"];
}

-(void)startBackgroundMusic
{
    [BackgroundMusic setVolume:0.3];
    BackgroundMusic.numberOfLoops = -1;
    [BackgroundMusic play];
}
#pragma mark Button Action Method
-(IBAction)StartButtonPressed:(id)sender
{
    QuestionNumber = [[self GenerateQuestionNumber]intValue];
    _MessageLabel.text = @"Start!!";
    
    NSLog(@"Question : %i",QuestionNumber);
    
    [ButtonBeep play];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    [self timerStart];
    [self.StartButton setTitle:@"Change question" forState:UIControlStateNormal];
}

-(IBAction)GuessButtonPressed:(id)sender
{
    if (QuestionNumber == 0) {
        _MessageLabel.text = @"Please press the 'Start' button";
        
    }else{
        int AnswerNum = [_AnswerText.text intValue];
        Acount = 0;
        Bcount = 0;
    
        [self CalculateAandBCount:AnswerNum];
        
        if (Acount == 4) {
            _MessageLabel.text = [NSString stringWithFormat:@"Congratulation! The number is %i.",AnswerNum];
            
            [timer invalidate];
            timer = nil;
            
            [self SaveResult];
            
        }else{
            _MessageLabel.text = [NSString stringWithFormat:@"%iA%iB",Acount,Bcount];
        }
        
    }
}

-(IBAction)RecordButtonPressed:(id)sender
{
    RecordView *recordview = [[RecordView alloc]initCenterPoint:self.view.center];
    
    [self.view addSubview:recordview];
}

#pragma mark Random Method
-(int)GetQuestionNumber
{
    int QuestionNum = arc4random() % 10000;
    
    return QuestionNum;
}

#pragma mark Precess Number Method

-(NSString *)GenerateQuestionNumber
{
    int QueNum = [self GetQuestionNumber];
    
    NSString * QuestionNumStr = [NSString stringWithFormat:@"%04d",QueNum];
    
    return QuestionNumStr;
}

-(void)CalculateAandBCount:(int)AnswerNumber
{
    //A count
    for (int N = 1; N <= 1000; N = N * 10) {
        if ((QuestionNumber/N % 10) == (AnswerNumber/N % 10)) {
            Acount ++;
        }
    }
    
    //B count
    for (int QueN = 1 ; QueN <= 1000; QueN = QueN * 10) {
        for (int AnsN = 1; AnsN <= 1000; AnsN = AnsN * 10) {
            if (QueN == AnsN) {
                AnsN = AnsN * 10;
            }
            if ((QuestionNumber/QueN % 10) == (AnswerNumber/AnsN % 10)) {
                Bcount ++;
            }
        }
    }
}


#pragma mark EndGame Methods
-(void)SaveResult
{
    NSDictionary *DataDic =@{@"Answer":_AnswerText.text,@"Time":_TimeLabel.text};
    
    [[EntityControl shareEntityControl] InsertNewRecord:DataDic];
}

#pragma mark TextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //limit 4 words.
    if (range.location > 3) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark TouchesEvent

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_AnswerText resignFirstResponder];
}

#pragma mark Timer
-(void)timerStart
{
    seconds = 0;
    minutes = 0;
    
    _TimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes,(long)seconds];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(additionTime) userInfo:nil repeats:YES];
}

-(void)additionTime
{
    seconds++;
    
    if (seconds == 60) {
        minutes++;
        seconds = 0;
    }
    
    _TimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes,(long)seconds];
}

#pragma mark AudioPlayer
-(AVAudioPlayer *)setupAudioPlayerWithFile:(NSString *)file type:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:type];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSError *error;
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (!audioPlayer) {
        NSLog(@"%@",[error description]);
    }
    
    return audioPlayer;
}

@end
