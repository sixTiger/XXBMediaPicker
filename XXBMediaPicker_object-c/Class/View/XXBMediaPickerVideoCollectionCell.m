//
//  XXBMediaPickerVideoCollectionCell.m
//  XXBMediaPicker
//
//  Created by xiaobing on 16/2/3.
//  Copyright © 2016年 xiaobing. All rights reserved.
//

#import "XXBMediaPickerVideoCollectionCell.h"
#import <AVFoundation/AVFoundation.h>

@interface XXBMediaPickerVideoCollectionCell ()

@property (nonatomic, strong) dispatch_queue_t              cameraQueue;
@property (nonatomic, strong) AVCaptureSession              *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer    *captureVideoPreviewLayer;
@property (weak, nonatomic)  UIImageView                    *videoLayer;
@property(nonatomic , weak) UIImageView                     *iconImageView;
@end

@implementation XXBMediaPickerVideoCollectionCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        self.iconImageView.image = [UIImage imageNamed:@"XXBMakePhoto"];
    });
}

- (void)start
{
    [self performSelectorOnMainThread:@selector(p_getPhoto) withObject:nil waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
}

- (void)stop
{
    [self performSelectorOnMainThread:@selector(p_stop) withObject:nil waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
}

- (void)p_getPhoto
{
    dispatch_async(self.cameraQueue, ^{
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if ( status != AVAuthorizationStatusAuthorized &&
            status != AVAuthorizationStatusNotDetermined)
        {
            return;
        }
        
        if (!self.session)
        {
            self.session = [[AVCaptureSession alloc] init];
            self.session.sessionPreset = AVCaptureSessionPresetLow;
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            NSError *error = nil;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            if (input)
            {
                [self.session addInput:input];
            }
            else
            {
                NSLog(@"Error: %@", error);
                return;
            }
        }
        if (!self.session.isRunning){
            [self.session startRunning];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.captureVideoPreviewLayer removeFromSuperlayer];
                CALayer *viewLayer = self.videoLayer.layer;
                self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
                self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                self.captureVideoPreviewLayer.frame = viewLayer.bounds;
                [viewLayer addSublayer:self.captureVideoPreviewLayer];
            });
        }
    });
    
}

- (void)p_stop
{
    if ([self.session isRunning])
    {
        [self.session stopRunning];
    }
}

- (dispatch_queue_t)cameraQueue
{
    if (_cameraQueue == nil) {
        _cameraQueue = dispatch_queue_create("camear", DISPATCH_QUEUE_SERIAL);
    }
    return _cameraQueue;
}

- (UIImageView *)videoLayer
{
    if (_videoLayer == nil)
    {
        UIImageView *videoLayer = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:videoLayer];
        videoLayer.autoresizingMask = (1 << 6) - 1;
        _videoLayer = videoLayer;
    }
    return _videoLayer;
}

- (UIImageView *)iconImageView
{
    if (_iconImageView == nil)
    {
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView insertSubview:iconImageView aboveSubview:self.videoLayer];
        iconImageView.contentMode = UIViewContentModeCenter;
        _iconImageView = iconImageView;
    }
    return _iconImageView;
}
@end
