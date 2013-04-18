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
@interface SettingsViewController ()
@property (readonly) SettingsBackgroundUIView *settingsBackgroundUIViewObject;
@property (readonly) GameModel *gameModelObject;
@end

@implementation SettingsViewController
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
        [self.view addSubview:self.settingsBackgroundUIViewObject];
        [self createCGRectObjectForDevice];
        [self setAllEvents];
        // Custom initialization
    }
    return self;
}
-(void)setAllEvents{
    
    [self playButton];
    [self leftRightScrollButtons];
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
    [self dismissModalViewControllerAnimated:NO];
}
-(void)createCGRectObjectForDevice{
    if ([[GlobalSingleton sharedManager].string_my_device_type isEqualToString:@"iphone"] ||
        [[GlobalSingleton sharedManager].string_my_device_type isEqualToString:@"iphone5"]) {
        cgRectObject = [[iPhoneCGRect alloc] init];
    }else{
        cgRectObject = [[iPadCGRect alloc] init];
    }
}
-(void)playButton{
    UIButton *play_button = [UIButton buttonWithType:UIButtonTypeCustom];
    play_button.frame =
    [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:460 yValue:620 width:100 height:50];
    [play_button setBackgroundImage:[UIImage imageNamed:@"button_play.png"]
                               forState:UIControlStateNormal];
    [play_button addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self loadAllCoinsExceptUsedOnes];
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
-(void)loadAllCoinsExceptUsedOnes{
    NSArray *all_coins = [self.gameModelObject getArrayOfCoinColors];
    int x = 250; int y = 480;
    
    for (int i = 0; i <= 16; i++) {
        if ([GlobalSingleton sharedManager].int_player_one_coin != i &&
            [GlobalSingleton sharedManager].int_player_two_coin != i) {
            UIButton *coin = [UIButton buttonWithType:UIButtonTypeCustom];
            coin.tag = i + 3000;
            [coin setBackgroundImage:[UIImage imageNamed:[all_coins objectAtIndex:i]]
                              forState:UIControlStateNormal];
           CGRect cgrect_temp =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:x
                                                                          yValue:y
                                                                           width:50 height:50];
            coin.frame = cgrect_temp;
            cgrect_temp =  [[GlobalSingleton sharedManager] getFrameAccordingToDeviceWithXvalue:x-3
                                                                                         yValue:y-3
                                                                                          width:56 height:56];
            UIImageView *coin_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_white.png"]];
            coin_background.frame = cgrect_temp;
            [self.view addSubview:coin_background];
            [self.view addSubview:coin];
            x = x + 100;
        }
    }
    
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}
@end
