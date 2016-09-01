//
//  ViewController.m
//  G_1A2B
//
//  Created by AprilXMoon on 2014/9/15.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "EntityControl.h"
#import "RecordView.h"

@interface ViewController () <UITextFieldDelegate>
{
    int QuestionNumber;
    int Acount;
    int Bcount;
    int guessCount;
    
    NSTimer *timer;
    NSInteger seconds;
    NSInteger minutes;
    
    //Add AVAudioPlayer objects
    AVAudioPlayer *ButtonBeep;
    AVAudioPlayer *BackgroundMusic;
    
    NSMutableArray *questionArray;
    NSMutableArray *answerArray;
}


@property(retain,nonatomic)IBOutlet UILabel *messageLabel;
@property(retain,nonatomic)IBOutlet UILabel *timeLabel;
@property(retain,nonatomic)IBOutlet UITextField *answerText;
@property(retain,nonatomic)IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *historyButton;
@property (strong, nonatomic) IBOutlet UIButton *guessButton;
@property (strong, nonatomic) IBOutlet UITextView *guessHistory;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self settingDefaultValue];
    [self adjustComponentsSkin];
    [self AudioPlayerSetting];
    [self startBackgroundMusic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self adjustButtonColor];
}

#pragma mrak - components skin
- (void)adjustComponentsSkin
{
    _startButton.layer.cornerRadius = 5.0;
    _guessButton.layer.cornerRadius = 5.0;
    
    _historyButton.layer.cornerRadius = 22.0;
    
    _answerText.layer.cornerRadius = 5.0;
    _answerText.layer.borderColor = [[UIColor grayColor] CGColor];
    _answerText.layer.borderWidth = 1.0;
}

- (void)adjustButtonColor
{
    NSArray *startButtonColors = @[(id)[[UIColor colorWithRed:1.0 green:0.7562 blue:0.4366 alpha:1.0] CGColor],
                                   (id)[[UIColor colorWithRed:1.0 green:0.622 blue:0.2347 alpha:1.0] CGColor]];
    CAGradientLayer *startGradient = [self createGradientColorLayer: startButtonColors colorRange: _startButton.bounds];
    
    [_startButton.layer insertSublayer:startGradient atIndex:0];
    _startButton.clipsToBounds = YES;
    
    NSArray *guessButtonColors = @[(id)[[UIColor colorWithRed:0.5539 green:0.7476 blue:0.9939 alpha:1.0] CGColor],
                                   (id)[[UIColor colorWithRed:0.2103 green:0.4503 blue:0.9912 alpha:1.0] CGColor]];
    CAGradientLayer *guessGradient = [self createGradientColorLayer: guessButtonColors colorRange:_guessButton.bounds];
    
    [_guessButton.layer insertSublayer:guessGradient atIndex:0];
    _guessButton.clipsToBounds = YES;
}

- (CAGradientLayer *)createGradientColorLayer:(NSArray *)colors colorRange:(CGRect)range
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = range;
    gradient.colors = colors;
    
    return gradient;
}

#pragma mark - Setting Method

- (void)AudioPlayerSetting
{
    ButtonBeep = [self setupAudioPlayerWithFile:@"ButtonTap" type:@"wav"];
    BackgroundMusic = [self setupAudioPlayerWithFile:@"game_maoudamashii_5_village10" type:@"mp3"];
}

- (void)startBackgroundMusic
{
    [BackgroundMusic setVolume:0.3];
    BackgroundMusic.numberOfLoops = -1;
    [BackgroundMusic play];
}

- (void)settingDefaultValue
{
    _answerText.delegate = self;
    
    guessCount = 1;
    
    questionArray = [NSMutableArray array];
    answerArray = [NSMutableArray array];
}

#pragma mark - Button Action Method

-(IBAction)StartButtonPressed:(id)sender
{
    [self setGameStartValue];
    
    [ButtonBeep play];
    [self startTimer];
    [_startButton setTitle:@"Change question" forState:UIControlStateNormal];
}

- (void)setGameStartValue
{
    QuestionNumber = [self GetQuestionNumber];
    
    [self setNumberArray:questionArray number:QuestionNumber];
    
    _messageLabel.text = @"Game Start!!";
    guessCount = 1;
    _guessHistory.text = @"";
    
    NSLog(@"Question : %i",QuestionNumber);
}

-(IBAction)GuessButtonPressed:(id)sender
{
    if (QuestionNumber == 0) {
        _messageLabel.text = @"Please press the 'Start' button";
    }else{
        int AnswerNum = [_answerText.text intValue];
        [self setNumberArray:answerArray number:AnswerNum];
    
        [self CalculateAandBCount:AnswerNum];
        
        if (Acount == 4) {
            [self gameTheEnd];
        }else{
            [self changeGuessHistoryRecord];
        }
        guessCount++;
    }
    
    _answerText.text = @"";
    [_answerText resignFirstResponder];
}

- (void)changeGuessHistoryRecord
{
    NSString *guessText = _guessHistory.text;
    _guessHistory.text = [guessText stringByAppendingString:[NSString stringWithFormat:@"%i. %@ : %iA%iB \n",
                                                             guessCount, _answerText.text, Acount, Bcount]];
    _guessHistory.font = [UIFont systemFontOfSize:20.0];
}

-(IBAction)RecordButtonPressed:(id)sender
{
    RecordView *recordView = [[RecordView alloc] initWithFrame:self.view.bounds owner:self];
    
    [self.view addSubview:recordView];
}

- (void)gameTheEnd
{
    _messageLabel.text = [NSString stringWithFormat:@"Congratulation! The number is %@.", _answerText.text];
    [_startButton setTitle:@"Start!" forState:UIControlStateNormal];
    
    [self stopTimer];
    [self SaveResult];
}

#pragma mark - Random Method

-(int)GetQuestionNumber
{
    int QuestionNum = arc4random() % 10000;
    
    return QuestionNum;
}

#pragma mark - Precess Number Method

- (void)setNumberArray:(NSMutableArray *)numberArray number:(int)number
{
    [numberArray removeAllObjects];
    
    for (int idx = 1000 ; idx >= 1; idx = (idx / 10)) {
        [numberArray addObject:[NSNumber numberWithInt:((number/idx) %10)]];
    }
}

-(NSString *)GenerateQuestionNumber
{
    int QueNum = [self GetQuestionNumber];
    
    NSString * QuestionNumStr = [NSString stringWithFormat:@"%04d",QueNum];
    
    return QuestionNumStr;
}

-(void)CalculateAandBCount:(int)AnswerNumber
{
    Acount = 0;
    Bcount = 0;
    
    NSMutableArray *compareArray = [NSMutableArray arrayWithArray:questionArray];
    
    //A count
    for (int idx = 0; idx < compareArray.count; idx++) {
        if (compareArray[idx] == answerArray[idx]) {
            Acount++;
            [compareArray removeObjectAtIndex:idx];
            [answerArray removeObjectAtIndex:idx];
            idx--;
        }
    }
    
    for (int ansIdx = 0; ansIdx < answerArray.count; ansIdx++) {
        for (int pareIdx = 0; pareIdx < compareArray.count; pareIdx++) {
            if(answerArray[ansIdx] == compareArray[pareIdx]) {
                Bcount++;
                [compareArray removeObjectAtIndex:pareIdx];
                [answerArray removeObjectAtIndex:ansIdx];
                ansIdx--;
                break;
            }
        }
    }
}


#pragma mark - EndGame Methods

-(void)SaveResult
{
    NSDictionary *DataDic =@{@"Answer":_answerText.text,@"Time":_timeLabel.text};
    
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

#pragma mark - TouchesEvent

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_answerText resignFirstResponder];
}

#pragma mark - Timer

- (void)startTimer
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    [self timerStart];
}

- (void)stopTimer
{
    [timer invalidate];
    timer = nil;
    
}

-(void)timerStart
{
    seconds = 0;
    minutes = 0;
    
    _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes,(long)seconds];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(additionTime) userInfo:nil repeats:YES];
}

-(void)additionTime
{
    seconds++;
    
    if (seconds == 60) {
        minutes++;
        seconds = 0;
    }
    
    _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes,(long)seconds];
}

#pragma mark - AudioPlayer

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
