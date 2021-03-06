//
//  LRNContainerView.m
//  LottieReactNative
//
//  Created by Leland Richardson on 12/12/16.
//  Copyright © 2016 Airbnb. All rights reserved.
//

#import "LRNContainerView.h"

// import UIView+React.h
#if __has_include(<React/UIView+React.h>)
#import <React/UIView+React.h>
#elif __has_include("UIView+React.h")
#import "UIView+React.h"
#else
#import "React/UIView+React.h"
#endif

typedef void (^AnimationFrameTime)(CGFloat);
typedef void (^AnimationProgressTime)(CGFloat);

@implementation LRNContainerView {
    AnimationView *_animationView;
}

- (void)reactSetFrame:(CGRect)frame
{
    [super reactSetFrame:frame];
    if (_animationView != nil) {
        [_animationView reactSetFrame:frame];
    }
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    if (_animationView != nil) {
        _animationView.currentProgress = _progress;
    }
}

- (void)setSpeed:(CGFloat)speed {
    _speed = speed;
    if (_animationView != nil) {
        _animationView.animationSpeed = _speed;
    }
}

- (void)setLoop:(BOOL)loop {
    _loop = loop;
    if (_animationView != nil) {
        _animationView.loopMode = _loop ? LottieLoopModeLoop : LottieLoopModePlayOnce;
    }
}

- (void)setResizeMode:(NSString *)resizeMode {
    if ([resizeMode isEqualToString:@"cover"]) {
        [_animationView setContentMode:UIViewContentModeScaleAspectFill];
    } else if ([resizeMode isEqualToString:@"contain"]) {
        [_animationView setContentMode:UIViewContentModeScaleAspectFit];
    } else if ([resizeMode isEqualToString:@"center"]) {
        [_animationView setContentMode:UIViewContentModeCenter];
    }
}

- (void)setSourceJson:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    Animation *animation = [Animation json:jsonData];
    AnimationView *animationView = [[AnimationView alloc] initWithAnimation:animation];
    [self replaceAnimationView:animationView];
}

- (void)setSourceName:(NSString *)name {
    Animation *animation = [Animation named:name
                                     bundle:NSBundle.mainBundle
                               subdirectory:nil
                             animationCache:nil];
    AnimationView *animationView = [[AnimationView alloc] initWithAnimation:animation];
    [self replaceAnimationView:animationView];
}

- (void)play {
    if (_animationView != nil) {
        [_animationView playWithCompletion:nil];
    }
}

- (void)play:(nullable LottieCompletionBlock)completion {
    if (_animationView != nil) {
        if (completion != nil) {
            [_animationView playWithCompletion:completion];
        } else {
            [_animationView playWithCompletion:nil];
        }
    }
}

- (void)playFromFrame:(NSNumber *)startFrame
              toFrame:(NSNumber *)endFrame
       withCompletion:(nullable LottieCompletionBlock)completion {
    if (_animationView != nil) {
        [_animationView playWithStartingFrame:startFrame.floatValue
                                      toFrame:endFrame.floatValue
                                     isLooped:_loop
                                   completion:completion];
    }
}

- (void)reset {
    if (_animationView != nil) {
        _animationView.currentProgress = 0;
        [_animationView pause];
    }
}

# pragma mark Private

- (void)replaceAnimationView:(AnimationView *)next {
    UIViewContentMode contentMode = UIViewContentModeScaleAspectFit;
    if (_animationView != nil) {
        contentMode = _animationView.contentMode;
        [_animationView removeFromSuperview];
    }
    _animationView = next;
    [self addSubview: next];
    [_animationView reactSetFrame:self.frame];
    [_animationView setContentMode:contentMode];
    [self applyProperties];
}

- (void)applyProperties {
    _animationView.currentProgress = _progress;
    _animationView.animationSpeed = _speed;
    _animationView.loopMode = _loop ? LottieLoopModeLoop : LottieLoopModePlayOnce;
}

@end
