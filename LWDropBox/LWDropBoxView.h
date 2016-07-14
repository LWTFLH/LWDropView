//
//  LWDropBoxView.h
//  LWDropTextfield
//
//  Created by 李伟 on 16/7/13.
//  Copyright © 2016年 TFLH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LWDropBoxView;
/**
 *  选中电话的协议代理
 */
@protocol LWDropBoxDelegate <NSObject>

- (void)selectAtIndex:(int)index WithLWDrooBox:(LWDropBoxView *)dropbox;

@end

@interface LWDropBoxView : UIView <UITableViewDelegate, UITableViewDataSource>

//视图控件部分
@property (nonatomic, strong) UITextField *textfiled;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIImageView *imageview;

/**
 *  装电话的容器
 */
@property (nonatomic, strong) NSMutableArray *arr;
/**
 *  按钮选中标志
 */
@property (nonatomic, assign) BOOL buttonImageFlag;
@property (nonatomic, assign) id<LWDropBoxDelegate> delegate;

/**
 * 第一个参数设置：frame.origin.x 第二个参数：frame.origin.y  第三个参数：textfield宽度 第四个参数：textfield高度
 第五个参数：button宽度
 第六个参数：tableview的高度 第七个参数：设置是否能够编辑  yes能编辑  no不能编辑
 默认button高度和textfiled高度一样
 默认tableview宽度为textfield和button的宽度只和
 */
- (void)setControlsViewOriginx:(int)originx
                   ViewOriginy:(int)originy
                     TextWidth:(int)textwidth
            TextAndButtonHigth:(int)hight
                   ButtonWidth:(int)buttonwidth
                    TableHigth:(int)tableHight
                    Editortype:(BOOL)type;
- (void)tableShowAndHide:(UIButton *)btn;
- (void)reloadataTableview;
- (void)closeTableview;
@end
