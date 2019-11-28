//
//  MacroHeader.h
//  iOS_SuperBlocks
//
//  Created by Yoonvey on 2018/10/12.
//  Copyright © 2018年 EdwinChen. All rights reserved.
//

#ifndef MacroHeader_h
#define MacroHeader_h

typedef enum
{
    ComparisonValueTypeLessThan = -1,//小于
    ComparisonValueTypeEquality = 0,//等于
    ComparisonValueTypeMoreThan,//大于
} ComparisonValueType;

#define Main_Screen_Width      [UIScreen mainScreen].bounds.size.width
#define Main_Screen_Height     [UIScreen mainScreen].bounds.size.height

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define SafeAreaTopHeight (ScreenHeight >= 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (ScreenHeight >= 812.0 ? 83.5 : 49.5)

//颜色设置
#define kBLUE [UIColor colorWithRed:48/255.0f green:184/255.0f blue:238/255.0f alpha:0.9]
#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define ThemeColor [RGB(63, 70, 74) colorWithAlphaComponent:0.91]


//字体设置
#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

//中文字体
#define CHINESE_FONT_NAME  @"Heiti SC"
#define CHINESE_SYSTEM(x) [UIFont fontWithName:CHINESE_FONT_NAME size:x]


#endif /* MacroHeader_h */
