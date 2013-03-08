//
//  Global.m
//  Ruckus
//
//  Created by Shruti Sharma on 5/24/10.
//

/**
 *	This private interface allows the class to synthesize and make use of
 *	private properties without them being externally accessible.
 */

#import "Global.h"
#import "Utility.h"
#import "RRSingletonManager.h"

@interface Global ()
@property (nonatomic, assign) CGRect screenFrame;

-(void)setSubPathsArrayForPath:(NSString*)path;
@end


@implementation Global

@synthesize bookName = bookName_;
@synthesize bookPrefix = bookPrefix_;
@synthesize subPathsArray = subPathsArray_;


#pragma mark Initializers
/**
 *	Store the display frame of the application on the current device, in landscape mode;
 */
-(id)init {
	if((self = [super init])){
        
        UIScreen* mainscr = [UIScreen mainScreen];
        
		screenFrame = CGRectMake(0.0, 0.0, mainscr.currentMode.size.width, mainscr.currentMode.size.height); //Get the pixel dimensions of the application on the current device.
    }
	return self;
}

/**
 *	Return the singleton instance of this class;
 */

+ (Global *)global {
	static Global * master = nil;
	@synchronized(self)
	{
		if (master == nil)
			master = [self new];
	}
	return master;
}


#pragma mark Screen metrics

/**
 *	calculate screen frame size as per device
 */
+ (void)resetScreenDimensionsOnRotation
{
    UIScreen* mainscr = [UIScreen mainScreen];
    
    [Global global].screenFrame = CGRectMake(0.0, 0.0, mainscr.currentMode.size.width, mainscr.currentMode.size.height); 
    [Global getScreenFrameSize];
}

/**
 *	calculate screen frame size as per device
 */
+ (CGSize)getScreenFrameSize
{
    CGSize screenSize = CGSizeZero;
    // CGRect deviceScreenFrame  =[Global global].screenFrame;
    CGRect deviceScreenFrame = [[UIScreen mainScreen] applicationFrame];
    
    if([Global getCurrentDeviceType] == kDeviceTypeIPad
       || [Global getCurrentDeviceType] == kDeviceTypeIPadRetina)
    {
        //Swap width and height for landscape orientation for ipad
        screenSize = CGSizeMake(deviceScreenFrame.size.height, deviceScreenFrame.size.width); 
    }
    else 
        screenSize = CGSizeMake(deviceScreenFrame.size.width, deviceScreenFrame.size.height); 
    
    if([RRSingletonManager sharedManager].showBookForiPhone){
        
        UIScreen* mainscr = [UIScreen mainScreen];
        
		deviceScreenFrame = CGRectMake(0.0, 0.0, mainscr.currentMode.size.width, mainscr.currentMode.size.height);
        
        //Swap width and height for landscape orientation for iphone
        screenSize = CGSizeMake(480,320); 
    }
    
    return screenSize;
}

/**
 *	Synthesize setters and getters for the class properties;
 */
@synthesize screenFrame;

+ (CGRect)screenFrame {
	return [Global global].screenFrame;
}
+ (CGSize)screenSize {
	return [Global getScreenFrameSize];
}
+ (CGFloat)screenWidth {
    return [Global screenSize].width;
}
+ (CGFloat)screenHeight {
    return [Global screenSize].height;
}
+ (BOOL)isIPad {
    if([Global getCurrentDeviceType] == kDeviceTypeIPad)
    {
        return TRUE; 
    }
    else 
        return FALSE; 
}


#pragma mark Ios Version metrics
/**
 *	Detecting Ios version of current device;
 */

+ (CGFloat)iOsVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}


#pragma mark Detecting Device Type
/**
 *	Find the current device type;
 */
+ (NSInteger)getCurrentDeviceType
{
    float ver = [Global iOsVersion]; 
    
    UIScreen* mainscr = [UIScreen mainScreen];
    
    NSInteger deviceType = kDeviceTypeUnknown;
    
    if(ver >= 3.2f) 
    { 
        if(mainscr.currentMode.size.width == 480 || mainscr.currentMode.size.width == 320)
            deviceType = kDeviceTypeIPhone;
        else if(mainscr.currentMode.size.width == 960 || mainscr.currentMode.size.width == 640)
            deviceType = kDeviceTypeIPhoneRetina;
        else if(mainscr.currentMode.size.width == 1024 || mainscr.currentMode.size.width == 768)
            deviceType = kDeviceTypeIPad;
        else if(mainscr.currentMode.size.width == 2048 || mainscr.currentMode.size.width == 1536)
            deviceType = kDeviceTypeIPad;
    }
    else 
    {
        deviceType = kDeviceTypeIPhone; 
    }
    
    return deviceType;
}

#pragma mark Get Position 
/**
 *	Find the position as per the current device type;
 */

+ (CGPoint)convertPositionWithXOffset:(CGFloat)x withYOffset:(CGFloat)y
{    
    CGPoint pos ;
    if([RRSingletonManager sharedManager].currentDeviceID == kDeviceTypeIPhone ||
       [RRSingletonManager sharedManager].currentDeviceID     == kDeviceTypeIPhoneRetina){
        
        pos = CGPointMake(480*(x/1024), 
                          320*(y/768));
    }
    else{
        pos = CGPointMake([Global screenWidth]*(x/1024), 
                          [Global screenHeight]*(y/768));
        
    }
    return pos;
}

+ (CGFloat)convertValueAccordingToDevice:(CGFloat)val 
                              widthValue:(BOOL)isWidth 
                             heightValue:(BOOL)isHeight
{
    CGFloat deviceVal = 0;
    
    if([RRSingletonManager sharedManager].currentDeviceID != kDeviceTypeIPad)
    { 
        if(isWidth)
            deviceVal = ((val/1024)*480);
        else if(isHeight)
            deviceVal = ((val/768)*320);
    } 
    else 
    {
        deviceVal = val;
    }
    
    return deviceVal;
}

+ (CGRect )getFrameAccordingToDeviceWithXvalue:(float )xVal 
                                        yValue:(float )yVal 
                                         width:(float )widthVal 
                                        height:(float )heightVal{
    
    CGRect resizedFrame = CGRectMake(0,0,0,0);
    
    if([Global getCurrentDeviceType] != kDeviceTypeIPad){ 
        
        resizedFrame = CGRectMake((xVal*480)/1024 ,
                                  (yVal *320)/768,
                                  (widthVal*480)/1024 ,
                                  (heightVal *320)/768);
    }
    else{
        
        resizedFrame = CGRectMake(xVal,yVal,widthVal,heightVal);
    }
    return resizedFrame; 
    
}

#pragma mark Get File Name 
/**
 *	Find the file name as per the current device type;
 */

+ (NSString *)getNameAccordingToDevice:(NSString *)imageName
{
    
    NSString *finalImageName = nil;
    
    if(imageName == nil || [imageName isEqualToString:@""])
    {
        // NSLog(@"imageName:- %@ passed to method:- %@ is invalid", imageName, NSStringFromSelector(_cmd));
    }
    else 
    {
        NSString *deviceHardwareToAppend = nil;
        
        if([RRSingletonManager sharedManager].currentDeviceID == kDeviceTypeIPad || 
           [RRSingletonManager sharedManager].currentDeviceID == kDeviceTypeIPadRetina)
        {
            deviceHardwareToAppend = @"iPad";
        }
		
        
		if([RRSingletonManager sharedManager].currentDeviceID == kDeviceTypeIPhone)
        {
            deviceHardwareToAppend = @"iPhone";
        }
		
        else if([RRSingletonManager sharedManager].currentDeviceID == kDeviceTypeIPhoneRetina)
        {
            deviceHardwareToAppend = @"iPhone-hd";
        }
        
        NSString *fileExtension               = [imageName pathExtension];
        NSString *imageNameWithoutExtension   = [imageName stringByDeletingPathExtension];
        
        if([Global getCurrentDeviceType])
        { 
            if(fileExtension.length == 0){
				
                finalImageName = [NSString stringWithFormat:@"%@-%@", 
                                  imageNameWithoutExtension, 
                                  deviceHardwareToAppend];
            }
            else{
                
                finalImageName = [NSString stringWithFormat:@"%@-%@.%@", 
                                  imageNameWithoutExtension, 
                                  deviceHardwareToAppend, 
                                  fileExtension];
				
            }
        }
    }
    
    return finalImageName;
    
	
}


+ (NSString *)getNameAccordingToDeviceForUI:(NSString *)imageName
{
    
    NSString *finalImageName = nil;
    
    if(imageName == nil || [imageName isEqualToString:@""])
    {
        // NSLog(@"imageName:- %@ passed to method:- %@ is invalid", imageName, NSStringFromSelector(_cmd));
    }
    else 
    {
        NSString *deviceHardwareToAppend = nil;
        
        if([RRSingletonManager sharedManager].currentDeviceID == kDeviceTypeIPad)
        {
            deviceHardwareToAppend = @"iPad";
        }
		else if([RRSingletonManager sharedManager].currentDeviceID == kDeviceTypeIPadRetina)
        {
            deviceHardwareToAppend = @"iPad@2x";
        }
        else if([RRSingletonManager sharedManager].currentDeviceID == kDeviceTypeIPhone)
        {
            deviceHardwareToAppend = @"iPhone";
        }
        else if([RRSingletonManager sharedManager].currentDeviceID == kDeviceTypeIPhoneRetina)
        {
            deviceHardwareToAppend = @"iPhone@2x";
        }

        
        NSString *fileExtension               = [imageName pathExtension];
        NSString *imageNameWithoutExtension   = [imageName stringByDeletingPathExtension];
        
        if([Global getCurrentDeviceType])
        { 
            if(fileExtension.length == 0){
				
                finalImageName = [NSString stringWithFormat:@"%@-%@", 
                                  imageNameWithoutExtension, 
                                  deviceHardwareToAppend];
            }
            else{
                
                finalImageName = [NSString stringWithFormat:@"%@-%@.%@", 
                                  imageNameWithoutExtension, 
                                  deviceHardwareToAppend, 
                                  fileExtension];
				
            }
        }
    }
    
    return finalImageName;
    
	
}


+ (BOOL)checkIfFileExistsAtPath:(NSString *)fileName
{    
    BOOL fileFound             = NO;
    
	NSString *filePath         = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] 
                                                                 ofType:[fileName pathExtension]];
    
	if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
	{
       // NSLog(@"File %@ does not exist in Bundle Resources", fileName);
	}
    else 
    {
        fileFound = YES;
    }
    
    return fileFound;
    
}

+ (NSString*)getImageNamefromfullLibraryPathForResource:(NSString*) resourceName{
	
    NSAssert(resourceName != nil, @"Global: Invalid resourceName");
    NSString *imgName = nil; 
    
    NSArray *tempArray= [resourceName componentsSeparatedByString:@"/"];
    imgName = [tempArray lastObject];
    
    NSString *fileExtension               = [imgName pathExtension];
    NSString *imageNameWithoutExtension   = [imgName stringByDeletingPathExtension];
    
    tempArray = [imageNameWithoutExtension componentsSeparatedByString:@"-"];
    
    imageNameWithoutExtension = [tempArray objectAtIndex:0];
    
    imgName = [NSString stringWithFormat:@"%@.%@",imageNameWithoutExtension,fileExtension];
	
    return imgName;
}

#pragma mark LibraryPath for resource--

+(NSString *)getLibraryDirRootPath {
    
    NSArray  *paths				= NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *libraryDirectory  = [paths objectAtIndex:0];
	libraryDirectory			= [libraryDirectory 
								   stringByAppendingPathComponent:[NSString stringWithFormat:@"Caches/Books"]];
    return libraryDirectory;
}


+ (NSString*)fullLibraryPathForSMIL:(NSString*) resourceName
{
	NSAssert(resourceName != nil, @"Global: Invalid resourceName");
    
	if(![Global global].subPathsArray){
		[[Global global] setSubPathsArrayForPath:[RRSingletonManager sharedManager].bookLibraryPath];
	}
    
	NSString *fullpath			= nil;
    
	NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF ENDSWITH '%@'",resourceName]];
	NSArray *filesArray = [[Global global].subPathsArray filteredArrayUsingPredicate:filter];
	
    if(filesArray && ([filesArray count] > 0)){
        for(int i=0; i < [filesArray count]; i++)
        {
            NSString *fileName = [[filesArray objectAtIndex:i] lastPathComponent];
            
            if([fileName isEqualToString:resourceName]){
                
                fullpath = [[RRSingletonManager sharedManager].bookLibraryPath
                            stringByAppendingPathComponent:[filesArray objectAtIndex:i]];
                
                if([[NSFileManager defaultManager] fileExistsAtPath:fullpath])
                {
                    return fullpath;
                }
            }
            
        }
    }
	return nil;
}



/*This is a method which searches for a file in NSLibraryDirectory and returns the absolute path
 for the file */
+ (NSString*)fullLibraryPathForResource:(NSString*) resourceName{
	
	NSAssert(resourceName != nil, @"Global: Invalid resourceName");
    
	resourceName = [self getNameAccordingToDevice:resourceName];

	if(![Global global].subPathsArray){
		[[Global global] setSubPathsArrayForPath:[RRSingletonManager sharedManager].bookLibraryPath];
	}

	NSString *fullpath			= nil;
    
//	if([Global global].subPathsArray && ([[Global global].subPathsArray count] > 0)){
//		for(int i=0; i<[[Global global].subPathsArray count]; i++)
//		{
//			fullpath = [[RRSingletonManager sharedManager].bookLibraryPath 
//						stringByAppendingPathComponent:[[[Global global].subPathsArray objectAtIndex:i] 
//														stringByAppendingPathComponent:resourceName]];
//			
//			if([[NSFileManager defaultManager] fileExistsAtPath:fullpath])
//			{
//				return fullpath;
//			}
//		}
//	}

	NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF ENDSWITH '%@'",resourceName]];
	NSArray *filesArray = [[Global global].subPathsArray filteredArrayUsingPredicate:filter];
	
			if(filesArray && ([filesArray count] > 0)){
				for(int i=0; i < [filesArray count]; i++)
				{
					NSString *fileName = [[filesArray objectAtIndex:i] lastPathComponent];
					
					if([fileName isEqualToString:resourceName]){
						
						fullpath = [[RRSingletonManager sharedManager].bookLibraryPath 
									stringByAppendingPathComponent:[filesArray objectAtIndex:i]];
						
						if([[NSFileManager defaultManager] fileExistsAtPath:fullpath])
						{
							return fullpath;
						}
					}	
					
				}
			}
	return nil;	
}



/*This is a method which searches for a file in NSLibraryDirectory and returns the absolute path 
 for the file */
+ (NSString*)fullLibraryPathForUIResource:(NSString*) resourceName{
	
	NSAssert(resourceName != nil, @"Global: Invalid resourceName");
    
	resourceName = [self getNameAccordingToDeviceForUI:resourceName];
    
	if(![Global global].subPathsArray){
		[[Global global] setSubPathsArrayForPath:[RRSingletonManager sharedManager].bookLibraryPath];
	}
    
	NSString *fullpath			= nil;
    
    //	if([Global global].subPathsArray && ([[Global global].subPathsArray count] > 0)){
    //		for(int i=0; i<[[Global global].subPathsArray count]; i++)
    //		{
    //			fullpath = [[RRSingletonManager sharedManager].bookLibraryPath 
    //						stringByAppendingPathComponent:[[[Global global].subPathsArray objectAtIndex:i] 
    //														stringByAppendingPathComponent:resourceName]];
    //			
    //			if([[NSFileManager defaultManager] fileExistsAtPath:fullpath])
    //			{
    //				return fullpath;
    //			}
    //		}
    //	}
    
	NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF ENDSWITH '%@'",resourceName]];
	NSArray *filesArray = [[Global global].subPathsArray filteredArrayUsingPredicate:filter];
	
    if(filesArray && ([filesArray count] > 0)){
        for(int i=0; i < [filesArray count]; i++)
        {
            NSString *fileName = [[filesArray objectAtIndex:i] lastPathComponent];
            
            if([fileName isEqualToString:resourceName]){
                
                fullpath = [[RRSingletonManager sharedManager].bookLibraryPath 
                            stringByAppendingPathComponent:[filesArray objectAtIndex:i]];
                
                if([[NSFileManager defaultManager] fileExistsAtPath:fullpath])
                {
                    return fullpath;
                }
            }	
            
        }
    }
	return nil;	
}



-(void)setSubPathsArrayForPath:(NSString*)path{
	
	if(path != nil && (![path isEqualToString:@""])){
		
		subPathsArray_		= [[[NSFileManager defaultManager]
								   subpathsOfDirectoryAtPath:path 
								   error:nil] retain];
		
	}
}

+ (BOOL)checkWhetherLibraryDirExists
{
    BOOL isDir;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:[Global getLibraryDirRootPath]
                                                       isDirectory:&isDir];
    if (exists) {
        /* file exists */
        if (isDir) {
            /* file is a directory */
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)checkWhetherbookResourcesExistForBook:(NSString*)bookPrefix
{
    NSString *bookResourcePath = [NSString stringWithFormat:@"%@/%@",
                                  [Global getLibraryDirRootPath],
                                  [Global getNameAccordingToDevice:bookPrefix]];
    BOOL isDir;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:bookResourcePath
                                                       isDirectory:&isDir];
    if (exists) {
        /* file exists */
        if (isDir) {
            /* file is a directory */
            return YES;
        }
    }
    
    return NO;
}


+(CGRect)getBottomPanelScrollFrame
{
    
    CGRect screenSize = CGRectZero;
    
    if([Global getCurrentDeviceType] == kDeviceTypeIPad
       || [Global getCurrentDeviceType] == kDeviceTypeIPadRetina )
    {
        //Swap width and height for landscape orientation for ipad
        screenSize = CGRectMake(300,0, 398, 85); 
    }
    else if([Global getCurrentDeviceType] == kDeviceTypeIPhone || [Global getCurrentDeviceType] == kDeviceTypeIPhoneRetina)
        screenSize = CGRectMake(70,70, 345, 85); 
    
    return screenSize;
    
}

+(CGPoint)getBottomPanelBlackCircleFrame
{
    
    CGPoint screenSize = CGPointZero;
    
    if([Global getCurrentDeviceType] == kDeviceTypeIPad
       || [Global getCurrentDeviceType] == kDeviceTypeIPadRetina )
    {
        //Swap width and height for landscape orientation for ipad
        screenSize = CGPointMake(23, 16) ;
    }
    else if([Global getCurrentDeviceType] == kDeviceTypeIPhone || [Global getCurrentDeviceType] == kDeviceTypeIPhoneRetina)
        screenSize = CGPointMake(25, 22) ; 
    
    return screenSize;
    
}

#pragma mark-
#pragma mark Get Device Orientation
+ (UIDeviceOrientation)getDeviceOrientation
{
	UIDeviceOrientation orientation    = [[UIDevice currentDevice] orientation];
//	UIDeviceOrientation orienStatusBar = [UIApplication sharedApplication].statusBarOrientation;
	return orientation;
}


#pragma mark-
#pragma mark Memory Management

-(void)dealloc{
	
	RELEASE(subPathsArray_);
	[super dealloc];
	
}
@end
