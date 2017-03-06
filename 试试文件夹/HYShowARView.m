//
//  HYShowARView.m
//  cMeeting
//
//  Created by location97 on 2017/2/20.
//  Copyright © 2017年 中移（杭州）信息技术有限公司. All rights reserved.
//

#import "HYShowARView.h"
#import <AVFoundation/AVFoundation.h>


@interface HYShowARView ()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * Videolayer;
@property (nonatomic, strong) UIButton         * startBtn;
@property (nonatomic, strong) UIButton         * stopBtn;
@property (nonatomic, strong) UIButton         * backBtn;

@end

@implementation HYShowARView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
       // [self addSubview:self.scrollView];
        
        [self.layer addSublayer:self.Videolayer];
        
        [self addSubview:self.startBtn];
        
        [self addSubview:self.stopBtn];
        
        [self addSubview:self.backBtn];
        
        [self addSubview:self.exhibitionIV];
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
        
        AVCaptureStillImageOutput *output = [[AVCaptureStillImageOutput alloc] init];
        
        dispatch_queue_t captureQueue = dispatch_queue_create("com.kai.captureQueue", NULL);
        
        AVCaptureVideoDataOutput *output2 = [[AVCaptureVideoDataOutput alloc] init];
        
        output2.videoSettings = @{(NSString*)kCVPixelBufferPixelFormatTypeKey: [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]};
        
        output2.alwaysDiscardsLateVideoFrames = YES;
        
        [output2 setSampleBufferDelegate:self queue:captureQueue];
        
        if ([self.session canAddInput:input]){
            
            [self.session addInput:input];
        }
        
        if ([self.session canAddOutput:output]) {
            
            [self.session addOutput:output];
            
            [self.session addOutput:output2];
        }
    }
    return self;
}

- (void)addTarget:(UIButton *)btn
{
    [btn addTarget:self action:@selector(Scan:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)Scan:(UIButton *)btn
{
     if (self.delegate && [self.delegate respondsToSelector:@selector(Scan:)])
     {
         [self.delegate Scan:btn];
     }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection{
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    CGRect rect = CGRectMake(0, 0, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer));
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef imageRef = [context createCGImage:ciImage fromRect:rect];
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    image = [UIImage imageWithCGImage:imageRef scale:1.0f orientation:UIImageOrientationRight];
    
    NSData * imageData = UIImageJPEGRepresentation(image,0.5);
    [self.imageDataArr addObject:imageData];
    
    CGImageRelease(imageRef);
}

- (void)setExhibitionIVWithdownIv:(UIImage *)exhibitionIV
{
    [self.exhibitionIV setImage:exhibitionIV];
}

#pragma mark  - getter && setter

- (AVCaptureSession *)session
{
    if (_session == nil)
    {
        _session = [[AVCaptureSession alloc] init];
        
        _session.sessionPreset = AVCaptureSessionPresetPhoto;
    }
    return _session;
}

- (NSMutableArray *)imageArr
{
    if (_imageArr == nil)
    {
        _imageArr = [[NSMutableArray alloc] init];
    }
    return _imageArr;
}

- (NSMutableArray *)imageDataArr
{
    if (_imageDataArr == nil)
    {
        _imageDataArr = [[NSMutableArray alloc] init];
    }
    return _imageDataArr;
}

//- (UIScrollView *)scrollView
//{
//    if (_scrollView == nil)
//    {
//        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2-30)];
//        
//        _scrollView.backgroundColor = [UIColor redColor];
//        
//        _scrollView.alwaysBounceHorizontal = YES;
//        
//        _scrollView.contentSize = CGSizeZero;
//        
//        _scrollView.pagingEnabled = YES;
//    }
//    return _scrollView;
//}

- (AVCaptureVideoPreviewLayer *)Videolayer
{
    if (_Videolayer == nil)
    {
        _Videolayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        
        _Videolayer.frame = [UIScreen mainScreen].bounds;
        
        _Videolayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _Videolayer;
}

- (UIButton *)startBtn
{
    if (_startBtn == nil)
    {
        _startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _startBtn.tag = TAG_ScanBtn_Start;
        
        [_startBtn setTitle:@"开启" forState:UIControlStateNormal];
        
        [self addTarget:_startBtn];
        
        _startBtn.bounds = CGRectMake(0, 0, 100, 40);
        
        _startBtn.center = self.center;
    }
    return _startBtn;
}

- (UIButton *)stopBtn
{
    if (_stopBtn == nil)
    {
        _stopBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _stopBtn.tag = TAG_ScanBtn_Stop;
        
        [_stopBtn setTitle:@"关闭" forState:UIControlStateNormal];
        
        [self addTarget:_stopBtn];
        
        //_stopBtn.frame = CGRectMake(40, 40, 60, 40);
        
        _stopBtn.bounds = CGRectMake(0, 0, 60, 40);
        
        _stopBtn.center = CGPointMake(self.center.x, self.center.y+50);
    }
    return _stopBtn;
}

- (UIButton *)backBtn
{
    if (_backBtn == nil)
    {
        _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _backBtn.tag = TAG_ScanBtn_Back;
        
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        
        [self addTarget:_backBtn];
        
        _backBtn.frame = CGRectMake(40, 40, 120, 80);
    }
    return _backBtn;
}

- (UIImageView *)exhibitionIV
{
    if (_exhibitionIV == nil)
    {
        _exhibitionIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1/2 * SCREEN_WIDTH, 1/2 * SCREEN_HEIGHT)];
    }
    return _exhibitionIV;
}
@end
