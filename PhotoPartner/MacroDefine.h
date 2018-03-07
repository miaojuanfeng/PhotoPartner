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
                                MARGIN_TOP = rectStatus.size.height; \
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
#define GET_LAYOUT_OFFSET_X(v) v.frame.origin.x
#define GET_LAYOUT_OFFSET_Y(v) v.frame.origin.y
#define COMMON_MACRO    SET_VIEW_BACKGROUND_COLOR; \
                        GET_LAYOUT_MARGIN; \
                        GET_VIEW_SIZE

#endif /* MacroDefine_h */
