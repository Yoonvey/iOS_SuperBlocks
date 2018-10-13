//
//  UIMapKitController.m
//  iOS_SuperBlocks
//
//  Created by Yoonvey on 2018/10/12.
//  Copyright © 2018年 EdwinChen. All rights reserved.
//

#import "UIMapKitController.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface UIMapKitController () <MKMapViewDelegate>

@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation UIMapKitController

//#pragma mark - <导航栏设置>
//- (NSMutableAttributedString *)setTitle
//{
//    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"MKMapKit"];
//    [title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title.length)];
//    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(17) range:NSMakeRange(0, title.length)];
//    return title;
//}

#pragma mark - <viewDidLoad>
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCommon];
    [self setupMapView];
}

#pragma makr - <设置基础样式>
- (void)setupCommon
{
    self.title = @"系统地图";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma makr - <加载子控件>
- (void)setupMapView
{
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, ScreenWidth, ScreenHeight - SafeAreaTopHeight)];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        //定位管理器
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - <MKMapViewDelegate>
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D location = [userLocation coordinate];
    //视图放大至定位点位置
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 250, 250);
    [self.mapView setRegion:region animated:YES];
}

@end
