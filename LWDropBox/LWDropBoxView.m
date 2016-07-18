//
//  LWDropBoxView.m
//  LWDropTextfield
//
//  Created by 李伟 on 16/7/13.
//  Copyright © 2016年 TFLH. All rights reserved.
//

#import "LWDropBoxView.h"

#define VWidth(v) (v).frame.size.width
#define VHeight(v) (v).frame.size.height
#define VWIDTH(v) (v).frame.size.width + (v).frame.origin.x
#define VHEIGHT(v) (v).frame.size.height + (v).frame.origin.y
#define kTextColor [UIColor darkGrayColor]
#define kBorderColor [UIColor colorWithRed:219 / 255.0 green:217 / 255.0 blue:216 / 255.0 alpha:1]

@interface LWDropBoxView ()
@property(nonatomic ,assign)NSInteger tableWidth;
@end


@implementation LWDropBoxView {

    NSIndexPath *CurrentIndexPath;
    UIButton *dele;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserPhone:) name:@"update" object:nil];
    }
    return self;
}
#pragma 更新用户数据
- (void)updateUserPhone:(NSNotification *)noti {

    NSAssert(noti.userInfo != nil, @"数据错误");

    NSString *temp = noti.userInfo[@"phone"];

    [self.arr addObject:temp];
    NSString *file = [NSHomeDirectory() stringByAppendingString:@"/Documents/lw.data"];
    [self.arr writeToFile:file atomically:YES];
    NSLog(@"写入sucess");
    [self.tableview reloadData];
}
- (NSMutableArray *)arr {

    if (!_arr) {
        _arr = [NSMutableArray array];
        NSMutableArray *temp =
        [NSMutableArray arrayWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/lw.data"]];
        NSLog(@"%@", temp);
        if (temp.count > 0) {
            [_arr addObjectsFromArray:temp];
        }
    }
    return _arr;
}
- (void)setControlsViewOriginx:(int)originx
                   ViewOriginy:(int)originy
                     TextWidth:(int)textwidth
            TextAndButtonHigth:(int)hight
                   ButtonWidth:(int)buttonwidth
                    TableHigth:(int)tableHight
                    Editortype:(BOOL)type {
    self.backgroundColor = [UIColor whiteColor];
    CGRect rect = self.frame;
    rect.size.height = hight;
    rect.origin.x = originx;
    rect.origin.y = originy;
    rect.size.width = textwidth + buttonwidth;
    self.frame = rect;

    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, hight)];
    _view.layer.borderColor = kBorderColor.CGColor;
    _view.layer.borderWidth = 0.5;
    [self addSubview:_view];

    _textfiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, textwidth, hight)];
    _textfiled.userInteractionEnabled = type;
    [_view addSubview:_textfiled];

    _buttonImageFlag = YES;
    _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button.frame = CGRectMake(VWIDTH(_textfiled), 0, buttonwidth, hight);
    //[_button setBackgroundImage:[UIImage imageNamed:@"down_dark0"] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(tableShowAndHide:) forControlEvents:UIControlEventTouchUpInside];
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 10, 10)];
    _imageview.image = [UIImage imageNamed:@"down_dark0"];
    [_button addSubview:_imageview];
    [_view addSubview:_button];

    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, VHEIGHT(_textfiled), buttonwidth + textwidth, self.arr.count * 30)
                                            style:UITableViewStylePlain];
    self.tableWidth = (long)buttonwidth +textwidth;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableview.hidden = YES;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.showsHorizontalScrollIndicator = NO;
    _tableview.layer.borderColor = (__bridge CGColorRef)(kBorderColor);
    _tableview.layer.borderWidth = 0.5;
    [self addSubview:_tableview];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"告别了";
}
- (void)tableShowAndHide:(UIButton *)btn {
    if (_buttonImageFlag == YES) {
        [self reloadataTableview];
        CGRect rect = self.frame;
        rect.size.height = _textfiled.frame.size.height + _tableview.frame.size.height;
        self.frame = rect;
        _buttonImageFlag = NO;
        _imageview.transform = CGAffineTransformMakeScale(1.0, -1.0);

        [UIView animateWithDuration:.3
                              delay:0
             usingSpringWithDamping:10
              initialSpringVelocity:10
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _tableview.hidden = NO;
                         }
                         completion:nil];

    } else {
        [self closeTableview];
    }
}
//刷新表格
- (void)reloadataTableview {
    [_tableview reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.arr.count > 0) {

        if (editingStyle == UITableViewCellEditingStyleDelete) {
            /**  修改删除后，索引不匹配问题*/
           // [self.arr replaceObjectAtIndex:indexPath.row withObject:@""];

            [self.arr removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
            //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }

    } else {

        return;
    }

    NSLog(@"style");
}

//关闭表格
- (void)closeTableview {
    _buttonImageFlag = YES;
    CGRect rect = self.frame;
    rect.size.height = _textfiled.frame.size.height;
    self.frame = rect;
    //[_button setBackgroundImage:[UIImage imageNamed:@"down_dark0"] forState:UIControlStateNormal];
    _imageview.transform = CGAffineTransformMakeScale(1.0, 1.0);

    [UIView animateWithDuration:.3
                     animations:^{
                         _tableview.hidden = YES;
                     }];
}
#pragma mark tabelview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}

#pragma cell show
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdenttifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenttifier];
    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenttifier];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        dele = [UIButton buttonWithType:UIButtonTypeCustom];
        [dele setFrame:CGRectMake(tableView.frame.size.width - 30, 5, 20, 20)];
        //  [dele setBackgroundColor:[UIColor cyanColor]];
        //   [dele setTitle:@"删除" forState:UIControlStateNormal];
        [dele setBackgroundImage:[UIImage imageNamed:@"delete.jpg"] forState:UIControlStateNormal];
        dele.adjustsImageWhenHighlighted = NO;

        // CurrentIndexPath = indexPath;
        [dele addTarget:self action:@selector(deleteCurrentDataWithButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:dele];
    }
    dele.tag = indexPath.row;
    cell.tag = indexPath.row;
    cell.textLabel.text = self.arr[indexPath.row];
    return cell;
}

#pragma delegate data

- (void)deleteCurrentDataWithButton:(UIButton *)btn {

    CurrentIndexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];

    NSLog(@"<btn tag >%ld", btn.tag);

    /**  修改删除后，索引不匹配问题*/
    //    [self.tableview beginUpdates];
    [self.arr removeObjectAtIndex:btn.tag];
      NSString *file = [NSHomeDirectory() stringByAppendingString:@"/Documents/lw.data"];
    [self.arr writeToFile:file atomically:YES];
    // [self.arr replaceObjectAtIndex:btn.tag withObject:@""];
    NSLog(@"<数组个数>%ld", self.arr.count);
   
    [self.tableview reloadData];
    
   // [self resetLayout];
}
#pragma reset layout
-(void)resetLayout{

    CGRect frame = self.tableview.frame;
    frame.size = CGSizeMake(self.tableWidth, self.arr.count *30);
    
    self.tableview.frame = frame;
    NSLog(@"重新布局");
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, 0, tableView.frame.size.width, 0)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _textfiled.text = _arr[indexPath.row];
    [self closeTableview];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_delegate respondsToSelector:@selector(selectAtIndex:WithLWDrooBox:)]) {
        [_delegate selectAtIndex:(int)indexPath.row WithLWDrooBox:self];
    }
}
@end
