//
//  MacroDefinition.h
//  PhotoPartner
//
//  Created by USER on 7/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#ifndef MacroDefine_h
#define MacroDefine_h

#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define SET_VIEW_BACKGROUND_COLOR self.view.backgroundColor = [UIColor whiteColor]
#define GET_LAYOUT_MARGIN   float MARGIN_TOP = 0; \
                            float MARGIN_BOTTOM = 0; \
                            do{ \
                                CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame]; \
                                MARGIN_TOP = rectStatus.size.height + GET_LAYOUT_HEIGHT(self.navigationController.navigationBar); \
                                if(IS_IPHONE_X){ \
                                    MARGIN_BOTTOM = 34; \
                                } \
                            }while(0)
#define GET_VIEW_WIDTH   float VIEW_WIDTH  = GET_LAYOUT_WIDTH(self.view)
#define GET_VIEW_HEIGHT  float VIEW_HEIGHT = GET_LAYOUT_HEIGHT(self.view) - MARGIN_TOP - MARGIN_BOTTOM
#define GET_VIEW_SIZE GET_VIEW_WIDTH;GET_VIEW_HEIGHT
#define GAP_WIDTH 5
#define GAP_HEIGHT 5
#define GET_LAYOUT_WIDTH(v) v.frame.size.width
#define GET_LAYOUT_HEIGHT(v) v.frame.size.height
#define GET_BOUNDS_WIDTH(v) v.bounds.size.width
#define GET_BOUNDS_HEIGHT(v) v.bounds.size.height
#define GET_LAYOUT_OFFSET_X(v) v.frame.origin.x
#define GET_LAYOUT_OFFSET_Y(v) v.frame.origin.y
#define COMMON_MACRO    SET_VIEW_BACKGROUND_COLOR; \
                        GET_LAYOUT_MARGIN; \
                        GET_VIEW_SIZE

#define RGBA_COLOR(r,g,b,a) [UIColor colorWithRed: r/255.0 green: g/255.0 blue: b/255.0 alpha: a]
#define BORDER_COLOR [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor
#define BORDER_WHITE_COLOR [UIColor whiteColor].CGColor
#define BORDER_FOCUS_COLOR RGBA_COLOR(27,163,232,1).CGColor
#define BORDER_WIDTH 1.0f

#define VIDEO_CHUNK_SIZE (1024*1024)

#define BASE_URL(url) [NSString stringWithFormat:@"https://well.bsimb.cn/%@", url]

#endif /* MacroDefine_h */
