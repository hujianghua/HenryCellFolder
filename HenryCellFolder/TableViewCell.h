//
//  TableViewCell.h
//  HenryCellFolder
//
//  Created by Henry on 2019/5/22.
//  Copyright © 2019年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface Message:NSObject
@property(nonatomic,strong) NSString *content;
//isShrink=YES-->收起，isShrink=NO-->展开
@property(nonatomic,assign) BOOL isShrink;
@end

@interface TableViewCell : UITableViewCell
@property(nonatomic,strong) Message *message;

@property(nonatomic,copy) void(^expandBlock)(TableViewCell*);
@end
