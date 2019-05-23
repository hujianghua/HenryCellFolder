//
//  ViewController.m
//  HenryCellFolder
//
//  Created by Henry on 2019/5/22.
//  Copyright © 2019年 Henry. All rights reserved.
//

#import "ViewController.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import <UITableView+FDIndexPathHeightCache.h>
#import "TableViewCell.h"

#define WeakSelf(type)  __weak typeof(type) weak##type = type;

static NSString *cellIdentifier = @"cell";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//测试数据
@property(nonatomic,strong) NSMutableArray *msgArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.msgArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    Message *msg=self.msgArray[indexPath.row];
    if (msg.isShrink) {
        //使用缓存的方式
        height=[tableView fd_heightForCellWithIdentifier:cellIdentifier cacheByKey:indexPath configuration:^(id cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
        
    }else{
        //使用不缓存方式
        height=[self.tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(id cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];

    }
    return height;
}

-(TableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    WeakSelf(self)
    cell.expandBlock = ^(TableViewCell *cell) {
        //展开或收起
        Message *msg=weakself.msgArray[indexPath.row];
        msg.isShrink=!msg.isShrink;
        NSIndexPath *index=[weakself.tableView indexPathForCell:cell];
        [weakself.tableView beginUpdates];
        [weakself.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        [weakself.tableView endUpdates];
    };
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureCell:(TableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
    cell.fd_enforceFrameLayout=NO;
    
    Message *msg=self.msgArray[indexPath.row];
    cell.message=msg;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSMutableArray*)msgArray{
    if (!_msgArray) {
        _msgArray=[NSMutableArray new];
        
        Message *msgFirst=[Message new];
        msgFirst.isShrink=YES;
        msgFirst.content=@"有记者提问，据报道，阿迪达斯，耐克，彪马以及美国170多家鞋类制造商和零售商联合致函美国总统特朗普称，美国对中国输美鞋类产征关税，将对美国消费者，制鞋企业和美国经济造成灾难性后果。支付关税的是美国消费者，这一点不容曲解，而企业也无法简单的从中国迁走工厂。中方对此有何评论？对此，陆慷表示已看到有关报道，事实上大家都注意到，这不是美国工商界第一次公开发出反对加征关税的声音了。而且从刚才所描述的有关报道情况，我们也能够看到，美国工商界也不满美国政府任意地解释贸易战的后果，这完全可以理解。事实上，中方也一直认为，贸易战根本没有赢家，美方任意挥舞关税大棒，到头来肯定会落在美国消费者和业界的身上。所以我们希望美国政府能够认真地倾听国内的理性呼声";
        [_msgArray addObject:msgFirst];
        
        Message *msgSecond=[Message new];
        msgSecond.isShrink=YES;
        msgSecond.content=@"据工信部网站消息，5月22日，工业和信息化部信息通信管理局就骚扰电话管控不力问题约谈了中国电信集团公司和广东、江苏、浙江、四川等问题突出的四省电信公司。";
        [_msgArray addObject:msgSecond];
        
        Message *msgThird=[Message new];
        msgThird.isShrink=YES;
        msgThird.content=@"工业和信息化部信息通信管理局通报了近期中国电信骚扰电话被投诉举报量快速增长、群众反映强烈的情况，要求中国电信务必坚持以人民为中心的发展思想，从讲政治的高度抓好问题整改，重点加强语音专线和码号等通信资源的管控，坚决落实治理骚扰电话部署要求，确保短期内见实效。";
        [_msgArray addObject:msgThird];
    }
    return _msgArray;
}
@end
