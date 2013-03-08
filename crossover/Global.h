//
//  Global.h
//  Ruckus
//
//  Created by Shruti Sharma on 5/24/10.
//

#import <Foundation/Foundation.h>

#define kDeviceTypeUnknown 0
#define kDeviceTypeIPhone 1
#define kDeviceTypeIPhoneRetina 3
#define kDeviceTypeIPad 2
#define kDeviceTypeIPadRetina 4

/**
 *	The Global class provides certain services that are needed throughout the app.
 *	One set of class functions provides shorthand access to screen metrics, and
 *	another simplifies the process of finding the path or URL of a given file
 *	within the application bundle.
 */


@interface Global : NSObject {
	CGRect screenFrame;
}

@property(nonatomic, retain) NSString*			bookName;
@property(nonatomic, retain) NSString*			bookPrefix;
@property(nonatomic, assign) NSArray*			subPathsArray;

+ (Global *)global;

+ (CGSize)getScreenFrameSize;
+ (CGRect)screenFrame;
+ (CGSize)screenSize;
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (CGFloat)iOsVersion;
+ (BOOL)isIPad;
+ (void)resetScreenDimensionsOnRotation;


+ (NSInteger)getCurrentDeviceType;
+ (CGPoint)convertPositionWithXOffset:(CGFloat)x 
                          withYOffset:(CGFloat)y;
+ (NSString *)getNameAccordingToDevice:(NSString *)imageName;
+ (CGFloat)convertValueAccordingToDevice:(CGFloat)val 
                              widthValue:(BOOL)isWidth 
                             heightValue:(BOOL)isHeight;
+ (CGRect )getFrameAccordingToDeviceWithXvalue:(float )xVal 
                                        yValue:(float )yVal 
                                         width:(float )widthVal 
                                        height:(float )heightVal;
+ (BOOL)checkIfFileExistsAtPath:(NSString *)fileName;
+ (NSString*)fullLibraryPathForResource:(NSString*) resourceName;
+ (NSString *)getLibraryDirRootPath;
+ (BOOL)checkWhetherLibraryDirExists;
+ (NSString*)getImageNamefromfullLibraryPathForResource:(NSString*) resourceName;
+ (BOOL)checkWhetherbookResourcesExistForBook:(NSString*)bookPrefix;
+(CGRect)getBottomPanelScrollFrame;
+(CGPoint)getBottomPanelBlackCircleFrame;
+ (NSString*)fullLibraryPathForUIResource:(NSString*) resourceName;

+ (NSString*)fullLibraryPathForSMIL:(NSString*) resourceName;

+ (UIDeviceOrientation)getDeviceOrientation;

@end
