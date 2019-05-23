//
//  TableViewCell.m
//  HenryCellFolder
//
//  Created by Henry on 2019/5/22.
//  Copyright © 2019年 Henry. All rights reserved.
//

#import "TableViewCell.h"
#import <Masonry.h>

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

static CGFloat lineSpace=3;//行间距
static NSInteger maxLineNumber=5;//收起时最大显示行数

@interface TableViewCell()
@property(nonatomic,strong) UILabel *contentLbl;
@property(nonatomic,strong) UIButton *folderBtn;
@end

@implementation Message
@end

@implementation TableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)buildUI{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    _contentLbl=[[UILabel alloc] init];
    _contentLbl.numberOfLines=maxLineNumber;
    [self.contentView addSubview:_contentLbl];
    [_contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    _folderBtn=[[UIButton alloc] init];
    [_folderBtn setImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
    [_folderBtn setBackgroundColor:UIColor.lightGrayColor];
    [_folderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_folderBtn addTarget:self action:@selector(folderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_folderBtn];
    [_folderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(self.contentLbl.mas_bottom).mas_offset(10);
    }];
}

-(void)folderAction:(UIButton*)sender{
    if (self.expandBlock) {
        self.expandBlock(self);
    }
}

-(void)setMessage:(Message *)message{
    _message=message;
    
    self.contentLbl.text=message.content;
    self.contentLbl.attributedText=[self getContentAttributedString:message.content];
    CGFloat contentWidth=SCREEN_WIDTH-15*2;
    NSMutableParagraphStyle *paraStyle=[[NSMutableParagraphStyle alloc] init];
    [paraStyle setLineSpacing:lineSpace];
    CGRect contentRect=[message.content boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],NSParagraphStyleAttributeName:paraStyle} context:nil];
    
    if (contentRect.size.height>self.contentLbl.font.lineHeight*maxLineNumber + lineSpace*(maxLineNumber-1)) {
        if (message.isShrink) {
            _contentLbl.numberOfLines=maxLineNumber;
        }else{
            _contentLbl.numberOfLines=0;
        }
        _contentLbl.preferredMaxLayoutWidth=contentWidth;
    }else{
        _contentLbl.numberOfLines=0;
    }
    [self.folderBtn setImage:[UIImage imageNamed:(message.isShrink?@"zhankai":@"shouqi")] forState:UIControlStateNormal];
}

-(NSAttributedString*)getContentAttributedString:(NSString*)content{
    if (!content) {
        return nil;
    }
    NSMutableAttributedString *attributeStr=[[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    return attributeStr;
}
@end
