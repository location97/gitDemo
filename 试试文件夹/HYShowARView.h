//
//  HYShowARView.h
//  cMeeting
//
//  Created by location97 on 2017/2/20.
//  Copyright © 2017年 中移（杭州）信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYVideoRenderView.h"

#define TAG_ScanBtn_Start   0x800
#define TAG_ScanBtn_Stop    0x801
#define TAG_ScanBtn_Back    0x802
@protocol HYShowARViewScanDelegate <NSObject>

- (void)Scan:(UIButton*)btn;

- (void)StratUpInfoToServer;

@end

@interface HYShowARView : UIView
@property (nonatomic, strong) NSMutableArray   * imageDataArr; 
@property (nonatomic, strong) NSMutableArray   * imageArr; //从视频中间隔获取图片temp数组
@property (nonatomic, strong) AVCaptureSession * session;
//@property (nonatomic, strong) UIScrollView     * scrollView;
@property (nonatomic, weak) id  <HYShowARViewScanDelegate> delegate;
@property (nonatomic, strong) UIImageView      * exhibitionIV;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setExhibitionIVWithdownIv:(UIImage *)exhibitionIV;

@end
