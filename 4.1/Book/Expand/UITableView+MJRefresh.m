//
//  UITableView+MJRefresh.m
//  Book
//
//  Created by 金波 on 15/12/27.
//  Copyright © 2015年 jikexueyuan. All rights reserved.
//

#import "UITableView+MJRefresh.h"


@implementation UITableView (MJRefresh)

-(void)headerAddMJRefresh:(MJRefreshComponentRefreshingBlock)block {
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
}

-(void)headerBeginRefresh {
    [self.mj_header beginRefreshing];
}

-(void)headerEndRefresh {
    [self.mj_header endRefreshing];
}

-(void)footerAddMJRefresh:(MJRefreshComponentRefreshingBlock)block {
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:block];
}

-(void)footerBeginRefresh {
    [self.mj_footer beginRefreshing];
}

-(void)footerEndRefresh {
    [self.mj_footer endRefreshing];
}

-(void)footerEndRefreshNoMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
}

-(void)footerResetNoMoreData {
    [self.mj_footer resetNoMoreData];
}

@end
