//
//  LRNContainerView.h
//  LottieReactNative
//
//  Created by Leland Richardson on 12/12/16.
//  Copyright © 2016 Airbnb. All rights reserved.
//


// import RCTView.h
#if __has_include(<React/RCTView.h>)
#import <React/RCTView.h>
#elif __has_include("RCTView.h")
#import "RCTView.h"
#else
#import "React/RCTView.h"
#endif

#import <Lottie/Lottie-Swift.h>

typedef void (^LottieCompletionBlock)(BOOL animationFinished);

@interface LRNContainerView : RCTView

@property (nonatomic, assign) BOOL loop;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) NSDictionary *sourceJson;
@property (nonatomic, strong) NSString *sourceName;
@property (nonatomic, copy) RCTBubblingEventBlock onAnimationFinish;

- (void)play;
- (void)play:(nullable LottieCompletionBlock)completion;
- (void)playFromFrame:(NSNumber *)startFrame
              toFrame:(NSNumber *)endFrame
       withCompletion:(nullable LottieCompletionBlock)completion;
- (void)reset;

@end
