//
//  UIImageCropperViewController.m
//  iOS_SuperBlocks
//
//  Created by Yoonvey on 2018/10/12.
//  Copyright © 2018年 EdwinChen. All rights reserved.
//

#import "UIImageCropperViewController.h"

#import "YVImageCropperViewController.h"

@interface UIImageCropperViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,YVImageCropperViewControllerDelegate>

@property (nonatomic, strong) UIImageView *customImageView;
@property (nonatomic, strong) UIImagePickerController *imageCamera;//相机
@property (nonatomic, strong) UIImagePickerController *imagePhoto;//相册

@end

@implementation UIImageCropperViewController

#pragma mark - << === 懒加载=== >>
//系统相机
- (UIImagePickerController *)imageCamera
{
    if (!_imageCamera)
    {
        _imageCamera = [[UIImagePickerController alloc] init];
        _imageCamera.allowsEditing = NO;
        _imageCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    return _imageCamera;
}
//系统相册
- (UIImagePickerController *)imagePhoto {
    if (!_imagePhoto) {
        _imagePhoto= [[UIImagePickerController alloc] init];
        _imagePhoto.allowsEditing = NO;
        _imagePhoto.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePhoto.delegate = self;
    }
    return _imagePhoto;
}

- (void)dealloc
{
    SLog(@"UIImageCropperViewController Dealloc!");
}

#pragma mark - <viewDidLoad>
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCommon];
    [self setUpImageView];
}

#pragma makr - <设置基础样式>
- (void)setupCommon
{
    self.title = @"图片裁剪";
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

#pragma makr - <加载子控件>
- (void)setUpImageView
{
    _customImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth*0.5-150, ScreenHeight*0.5-230, 300, 400)];
    [_customImageView setUserInteractionEnabled:YES];
    [_customImageView setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:_customImageView];
    
    UITapGestureRecognizer *gestureRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setUpAlertController)];
    [_customImageView addGestureRecognizer:gestureRec];
}

#pragma mark - <弹出对话框>
- (void)setUpAlertController
{
    __weak typeof(id) mySelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加照片" message:@"请选择图片来源" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //访问相机
        self.imageCamera.delegate = mySelf;
        [self presentViewController:self.imageCamera animated:YES completion:nil];
    }];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePhoto.delegate = mySelf;
        [self presentViewController:self.imagePhoto animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:camera];
    [alertController addAction:photo];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - <加载图片>
//加载沙盒路径下的图片
- (void)resetImageWithImagePath:(NSString *)imagePath
{
    UIImage *sandBoxImage = [UIImage imageWithContentsOfFile:imagePath];
    if (sandBoxImage)
    {
        [self.customImageView setImage:sandBoxImage];
    }
}

//加载回传的图片
- (void)resetImageWithImage:(UIImage *)image
{
    if (image)
    {
        [self.customImageView setImage:image];
    }
}

#pragma  mark - <系统选择图片代理回调>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:NO completion:^()
    {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        // present the cropper view controller
        YVImageCropperViewController *imgCropperVC = [[YVImageCropperViewController alloc] initWithImage:portraitImg cropperSize:CGSizeMake(300, 400)];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

#pragma mark - <自定义裁剪控制器图片处理、取消后的代理回调>
- (void)imageCropperController:(YVImageCropperViewController *)cropperViewController didFinishedWithImagePath:(NSString *)imagePath andImage:(UIImage *)image
{
    //    SLog(@"imagePath>%@",imagePath);
    //    SLog(@"image>%@",image);
    __weak typeof(id) mySelf = self;
    [cropperViewController dismissViewControllerAnimated:YES completion:^
    {
        // TO DO
        [mySelf resetImageWithImagePath:imagePath];
    }];
}

- (void)imageCropperDidCancel:(YVImageCropperViewController *)cropperViewController
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^
    {
        // TO DO
    }];
}


@end
