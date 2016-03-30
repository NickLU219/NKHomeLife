//
//  NKTopicPictureView.m
//  NK百思不得姐
//
//  Created by 陆金龙 on 16/1/26.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKTopicPictureView.h"
#import "NKTopic.h"
#import <UIImageView+WebCache.h>
#import "NKProgressView.h"
#import "NKShowPictureViewController.h"


@interface NKTopicPictureView ()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** gif标识 */
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
/** 查看大图按钮 */
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
/** 进度条控件   */
@property (weak, nonatomic) IBOutlet NKProgressView *progressView;
@end


@implementation NKTopicPictureView

+ (instancetype)pictureView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingNone;

    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

- (void)showPicture {
    NKShowPictureViewController *showPicture = [[NKShowPictureViewController alloc] init];
    showPicture.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}

- (void)setTopic:(NKTopic *)topic {
    _topic = topic;

    [self.progressView setProgress:topic.pictureProgress animated:NO];

    // 设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {

        topic.pictureProgress = 1.0 * receivedSize / expectedSize;
        
        self.progressView.hidden = NO;
        
        [self.progressView setProgress:topic.pictureProgress animated:NO];

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;

        // 如果是大图片, 才需要进行绘图处理
        if (topic.isBigPicture == NO) return;

        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topic.pictureF.size, YES, 0.0);

        // 将下载完的image对象绘制到图形上下文
        CGFloat width = topic.pictureF.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, height)];

        // 获得图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();

        // 结束图形上下文
        UIGraphicsEndImageContext();
    }];

    // 判断是否为gif
    NSString *extension = topic.large_image.pathExtension;
    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];

    // 判断是否显示"点击查看全图"
    if (topic.isBigPicture) { // 大图
        self.seeBigButton.hidden = NO;
    } else { // 非大图
        self.seeBigButton.hidden = YES;
    }
}
@end