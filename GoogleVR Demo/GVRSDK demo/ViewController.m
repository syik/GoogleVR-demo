//
//  ViewController.m
//  GVRSDK demo
//
//  Created by 张骏 on 17/5/31.
//  Copyright © 2017年 末班车. All rights reserved.
//

#import "ViewController.h"
#import "GVRVideoView.h"

@interface ViewController () <GVRVideoViewDelegate>
@property (nonatomic, strong) GVRVideoView *videoView;
@end

@implementation ViewController{
    BOOL _isPaused;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    
    _videoView = [[GVRVideoView alloc] init];
    _videoView.frame = self.view.bounds;
    _videoView.backgroundColor = [UIColor whiteColor];
    _videoView.delegate = self;
    _videoView.enableFullscreenButton = NO;
    _videoView.enableCardboardButton = NO;
    _videoView.enableTouchTracking = YES;
    
    [self.view addSubview:_videoView];
    
    _isPaused = YES;
    
    // Load the sample 360 video, which is of type stereo-over-under.
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"vr" ofType:@"mp4"];
    [_videoView loadFromUrl:[[NSURL alloc] initFileURLWithPath:videoPath]
                     ofType:kGVRVideoTypeMono];
    
    // Alternatively, this is how to load a video from a URL:
    //NSURL *videoURL = [NSURL URLWithString:@"https://raw.githubusercontent.com/googlevr/gvr-ios-sdk"
    //                                       @"/master/Samples/VideoWidgetDemo/resources/congo.mp4"];
    //[_videoView loadFromUrl:videoURL ofType:kGVRVideoTypeStereoOverUnder];
    
}

#pragma mark - GVRVideoViewDelegate
- (void)widgetViewDidTap:(GVRWidgetView *)widgetView {
    NSLog(@"%s", __func__);
    
    if (_isPaused) {
        [_videoView play];
    } else {
        [_videoView pause];
    }
    _isPaused = !_isPaused;
}


- (void)widgetView:(GVRWidgetView *)widgetView didLoadContent:(id)content {
    NSLog(@"Finished loading video");
    [_videoView play];
    _isPaused = NO;
}


- (void)widgetView:(GVRWidgetView *)widgetView
didFailToLoadContent:(id)content
  withErrorMessage:(NSString *)errorMessage {
    NSLog(@"Failed to load video: %@", errorMessage);
}


- (void)videoView:(GVRVideoView*)videoView didUpdatePosition:(NSTimeInterval)position {
    // Loop the video when it reaches the end.
    if (position == videoView.duration) {
        [_videoView seekTo:0];
        [_videoView play];
    }
}

@end
