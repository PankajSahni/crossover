//
//  SettingsViewController.m
//  crossover
//
//  Created by Pankaj on 18/04/13.
//
//

#import "SettingsViewController.h"
#import "SettingsBackgroundUIView.h"
#import "GlobalSingleton.h"
#import "iPhoneCGRect.h"
#import "iPadCGRect.h"
#import "GameModel.h"
#import "MyEnums.h"
@interface SettingsViewController ()
@property (readonly) SettingsBackgroundUIView *settingsBackgroundUIViewObject;
@property (readonly) GameModel *gameModelObject;
@end

@implementation SettingsViewController
@synthesize timer;
@synthesize delegate_SettingsViewController;
- (SettingsBackgroundUIView *) settingsBackgroundUIViewObject{
    if(!settingsBackgroundUIViewObject){
        settingsBackgroundUIViewObject = [[SettingsBackgroundUIView alloc] init];
    }
    return settingsBackgroundUIViewObject;
}
- (GameModel *) gameModelObject{
    if(!gameModelObject){
        gameModelObject = [[GameModel alloc] init];
    }
    return gameModelObject;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self createCGRectObjectForDevice];
        [self.view addSubview:self.settingsBackgroundUIViewObject];
        [self setAllEvents];
        // Custom initialization
    }
    return self;
}
-(void)createCGRectObjectForDevice{
    if ([[GlobalSingleton sharedManager].string_my_device_type isEqualToString:@"iphone"] ||
        [[GlobalSingleton sharedManager].string_my_device_type isEqualToString:@"iphone5"]) {
        cgRectObject = [[iPhoneCGRect alloc] init];
    }else{
        cgRectObject = [[iPadCGRect alloc] init];
    }
}
-(void)setAllEvents{
    active_player = 1;
    [self playButton];
    [self leftRightScrollButtons];
    [self setSelectPlayerBackgrounds];
    [self loadAllCoins];
    [self setPlayerLabels];
    [self soundOnOffButtonDefaultOn];
    [self timerOnOffButtonDefaultOn];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(blinkActivePlayer) userInfo:nil repeats:YES];
    
}
-(void)blinkActivePlayer{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    if (active_player == 2) {
        label_player_two.alpha = 0.0;
        
    }else{
        label_player_one.alpha = 0.0;
        
    }
    [UIView commitAnimations];
}
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    label_player_one.alpha = 1.0;
    label_player_two.alpha = 1.0;
}
-(void)soundOnOffButtonDefaultOn{
    CGRect cgrect_offbutton_case_on =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:640 yValue:290 width:90 height:35];
        CGRect cgrect_onbutton_case_off =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:710 yValue:290 width:90 height:35];
        CGRect cgrect_onbutton_case_on =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:710 yValue:290 width:90 height:35];
        CGRect cgrect_offbutton_case_off =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:640 yValue:290 width:90 height:35];
    button_offbutton_case_on_sound = [UIButton buttonWithType:UIButtonTypeCustom];
    button_onbutton_case_off_sound = [UIButton buttonWithType:UIButtonTypeCustom];
    button_onbutton_case_on_sound = [UIButton buttonWithType:UIButtonTypeCustom];
    button_offbutton_case_off_sound = [UIButton buttonWithType:UIButtonTypeCustom];
    button_offbutton_case_on_sound.frame = cgrect_offbutton_case_on;
    button_onbutton_case_off_sound.frame = cgrect_onbutton_case_off;
    button_onbutton_case_on_sound.frame = cgrect_onbutton_case_on;
    button_offbutton_case_off_sound.frame = cgrect_offbutton_case_off;
    [button_offbutton_case_on_sound setBackgroundImage:
     [UIImage imageNamed:@"offbutton_case_off.png"] forState:UIControlStateNormal];
    [button_onbutton_case_on_sound setBackgroundImage:
     [UIImage imageNamed:@"onbutton_case_off.png"] forState:UIControlStateNormal];
    [button_onbutton_case_off_sound setBackgroundImage:
     [UIImage imageNamed:@"onbutton_case_on.png"] forState:UIControlStateNormal];
    [button_offbutton_case_off_sound setBackgroundImage:
     [UIImage imageNamed:@"offbutton_case_on.png"] forState:UIControlStateNormal];
    [self setSoundButtons];
}
-(void)timerOnOffButtonDefaultOn{
    CGRect cgrect_offbutton_case_on =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:640 yValue:340 width:90 height:35];
    CGRect cgrect_onbutton_case_off =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:710 yValue:340 width:90 height:35];
    CGRect cgrect_onbutton_case_on =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:710 yValue:340 width:90 height:35];
    CGRect cgrect_offbutton_case_off =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:640 yValue:340 width:90 height:35];
    button_offbutton_case_on_timer = [UIButton buttonWithType:UIButtonTypeCustom];
    button_onbutton_case_off_timer = [UIButton buttonWithType:UIButtonTypeCustom];
    button_onbutton_case_on_timer = [UIButton buttonWithType:UIButtonTypeCustom];
    button_offbutton_case_off_timer = [UIButton buttonWithType:UIButtonTypeCustom];
    button_offbutton_case_on_timer.frame = cgrect_offbutton_case_on;
    button_onbutton_case_off_timer.frame = cgrect_onbutton_case_off;
    button_onbutton_case_on_timer.frame = cgrect_onbutton_case_on;
    button_offbutton_case_off_timer.frame = cgrect_offbutton_case_off;
    [button_offbutton_case_on_timer setBackgroundImage:
     [UIImage imageNamed:@"offbutton_case_off.png"] forState:UIControlStateNormal];
    [button_onbutton_case_on_timer setBackgroundImage:
     [UIImage imageNamed:@"onbutton_case_off.png"] forState:UIControlStateNormal];
    [button_onbutton_case_off_timer setBackgroundImage:
     [UIImage imageNamed:@"onbutton_case_on.png"] forState:UIControlStateNormal];
    [button_offbutton_case_off_timer setBackgroundImage:
     [UIImage imageNamed:@"offbutton_case_on.png"] forState:UIControlStateNormal];
    [self setTimerButtons];
}
-(void)setSoundButtons{
    if ([GlobalSingleton sharedManager].bool_sound) {
        [button_offbutton_case_off_sound addTarget:self action:@selector(soundOff) forControlEvents:UIControlEventTouchUpInside];
        [button_onbutton_case_off_sound removeFromSuperview];
        [button_offbutton_case_on_sound removeFromSuperview];
        [self.view addSubview:button_offbutton_case_off_sound];
        [self.view addSubview:button_onbutton_case_on_sound];
    }else {
        [button_onbutton_case_off_sound addTarget:self action:@selector(soundOn) forControlEvents:UIControlEventTouchUpInside];
        [button_offbutton_case_off_sound removeFromSuperview];
        [button_onbutton_case_on_sound removeFromSuperview];
        [self.view addSubview:button_onbutton_case_off_sound];
        [self.view addSubview:button_offbutton_case_on_sound];
    }
}
-(void)setTimerButtons{
    if ([GlobalSingleton sharedManager].need_timer) {
        [button_offbutton_case_off_timer addTarget:self action:@selector(timerOff) forControlEvents:UIControlEventTouchUpInside];
        [button_onbutton_case_off_timer removeFromSuperview];
        [button_offbutton_case_on_timer removeFromSuperview];
        [self.view addSubview:button_offbutton_case_off_timer];
        [self.view addSubview:button_onbutton_case_on_timer];
    }else {
        [button_onbutton_case_off_timer addTarget:self action:@selector(timerOn) forControlEvents:UIControlEventTouchUpInside];
        [button_offbutton_case_off_timer removeFromSuperview];
        [button_onbutton_case_on_timer removeFromSuperview];
        [self.view addSubview:button_onbutton_case_off_timer];
        [self.view addSubview:button_offbutton_case_on_timer];
    }
}
-(void)soundOff{
    [GlobalSingleton sharedManager].bool_sound = FALSE;
    [self setSoundButtons];
}
-(void)soundOn{
    [self.gameModelObject playSound:kButtonClick];
    [GlobalSingleton sharedManager].bool_sound = TRUE;
    [self setSoundButtons];
}
-(void)timerOff{
    [GlobalSingleton sharedManager].need_timer = FALSE;
    [self setTimerButtons];
}
-(void)timerOn{
    [self.gameModelObject playSound:kButtonClick];
    [GlobalSingleton sharedManager].need_timer = TRUE;
    [self setTimerButtons];
}
-(void)setPlayerLabels{
    CGRect cgrect_temp =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:260
                                                                                        yValue:404
                                                                                         width:100 height:30];
    label_player_one = [[UILabel alloc] initWithFrame: cgrect_temp];
    [self.view addSubview:label_player_one];
    cgrect_temp =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:660
                                                                                 yValue:404
                                                                                  width:100 height:30];
    label_player_two = [[UILabel alloc] initWithFrame: cgrect_temp];
    [self.view addSubview:label_player_two];
    UIFont *font_digital = [UIFont
                            fontWithName:@"Pump Demi Bold LET"
                            size:[cgRectObject settingFontSize]];
    [label_player_one setFont:font_digital];
    [label_player_two setFont:font_digital];
    label_player_one.textColor = [UIColor whiteColor];
    label_player_two.textColor = [UIColor whiteColor];
    label_player_one.backgroundColor = [UIColor clearColor];
    label_player_two.backgroundColor = [UIColor clearColor];
    label_player_one.text = @"player 1";    
    if ([[GlobalSingleton sharedManager].string_opponent isEqualToString:@"computer"]) {
        [label_player_two setText:@"computer"];
    }else{
        label_player_two.text = @"player 2";
    }
}
-(void)setSelectPlayerBackgrounds{
    UIImage *image_select_player_bg = [UIImage imageNamed:@"bg_select_player.png"];
    UIButton *button_select_player_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button_select_player_1.frame =
    [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:180 yValue:375 width:200 height:80];
    [button_select_player_1 setBackgroundImage:image_select_player_bg
                           forState:UIControlStateNormal];
    [button_select_player_1 addTarget:self action:@selector(selectplayer_one) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_select_player_1];
    UIButton *button_select_player_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button_select_player_2.frame =
    [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:640 yValue:375 width:200 height:80];
    [button_select_player_2 setBackgroundImage:image_select_player_bg
                                    forState:UIControlStateNormal];
    [button_select_player_2 addTarget:self action:@selector(selectplayer_two) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_select_player_2];
}
-(void)selectplayer_one{
    active_player = 1;
}
-(void)selectplayer_two{
    active_player = 2;
}
-(void)leftRightScrollButtons{
    CGRect cgrect_temp =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:180
                                                                                 yValue:475
                                                                                  width:30 height:60];
    UIImageView *imageview_previous = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_previous.png"]];
    imageview_previous.frame = cgrect_temp;
    [self.view addSubview:imageview_previous];
    cgrect_temp =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:820
                                                                                 yValue:475
                                                                                  width:30 height:60];
    UIImageView *imageview_next = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_next.png"]];
    imageview_next.frame = cgrect_temp;
    [self.view addSubview:imageview_next];
}
-(void)play{
    [self.gameModelObject playSound:kButtonClick];
    [delegate_SettingsViewController dismissedModal];
    [self dismissModalViewControllerAnimated:NO];

}

-(void)playButton{
    [self.gameModelObject playSound:kButtonClick];
    UIButton *play_button = [UIButton buttonWithType:UIButtonTypeCustom];
    play_button.frame =
    [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:460 yValue:620 width:100 height:50];
    [play_button setBackgroundImage:[UIImage imageNamed:@"button_play.png"]
                               forState:UIControlStateNormal];
    [play_button addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:play_button];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setCoinColor:(UIControl *)ctrl withEvent:(UIEvent *) event{
    [self.gameModelObject playSound:kButtonClick];
     int tag_coin_clicked = ctrl.tag - 3000;
    if (active_player == 1) {
        [GlobalSingleton sharedManager].int_player_one_coin = tag_coin_clicked;
    }else {
        [GlobalSingleton sharedManager].int_player_two_coin = tag_coin_clicked;
    }
    [self loadAllCoins]; 
}

-(void)loadAllCoins{
    for (int i = 0; i <= 16; i++) {
        coin = (UIButton *)[scrollview_coins viewWithTag:i+3000];
        [coin removeFromSuperview];
    }
    CGRect cgrect_temp;
    cgrect_temp =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:210
                                                                                 yValue:480
                                                                                  width:610 height:56];
    scrollview_coins = [[UIScrollView alloc] initWithFrame:cgrect_temp];
    
    [scrollview_coins setContentSize:CGSizeMake(1200, 12)];
    NSArray *all_coins = [self.gameModelObject getArrayOfCoinColors];
    int x = 3; int y = 3;
    for (int i = 0; i <= 16; i++) {
        if ([GlobalSingleton sharedManager].int_player_one_coin != i &&
            [GlobalSingleton sharedManager].int_player_two_coin != i) {
            coin = [UIButton buttonWithType:UIButtonTypeCustom];
            coin.tag = i + 3000;
            [coin setBackgroundImage:[UIImage imageNamed:[all_coins objectAtIndex:i]]
                              forState:UIControlStateNormal];
            [coin addTarget:self action:@selector(setCoinColor:withEvent:) forControlEvents:UIControlEventTouchUpInside];
           cgrect_temp =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:x
                                                                          yValue:y
                                                                           width:50 height:50];
            coin.frame = cgrect_temp;
            cgrect_temp =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:x-3
                                                                                         yValue:y-3
                                                                                          width:56 height:56];
            UIImageView *coin_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_white.png"]];
            coin_background.frame = cgrect_temp;
            //[coin_background addSubview:coin];
            [scrollview_coins addSubview:coin];
            scrollview_coins.scrollEnabled = YES;
            scrollview_coins.autoresizesSubviews = YES;
            
            x = x + 100;
        }else if ([GlobalSingleton sharedManager].int_player_one_coin == i) {
            player_one_coin = [UIButton buttonWithType:UIButtonTypeCustom];
            cgrect_temp =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:200
                                                                                         yValue:390
                                                                                          width:50 height:50];
            [player_one_coin setBackgroundImage:[UIImage imageNamed:[all_coins objectAtIndex:i]]
                            forState:UIControlStateNormal];
            player_one_coin.frame = cgrect_temp;
            [self.view addSubview:player_one_coin];
        }else {
            player_two_coin = [UIButton buttonWithType:UIButtonTypeCustom];
            cgrect_temp =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:780
                                                                                         yValue:390
                                                                                          width:50 height:50];
            [player_two_coin setBackgroundImage:[UIImage imageNamed:[all_coins objectAtIndex:i]]
                            forState:UIControlStateNormal];
            player_two_coin.frame = cgrect_temp;
            [self.view addSubview:player_two_coin];
        }
    }
    [self.view addSubview:scrollview_coins];
    
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}
@end
