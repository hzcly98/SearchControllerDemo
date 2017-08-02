//
//  ViewController.m
//  ProductListDemo
//
//  Created by 黄章成 on 2017/8/2.
//  Copyright © 2017年 黄章成. All rights reserved.
//

#import "ViewController.h"
#import "SearchResultController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating>
@property (nonatomic, strong) UISearchController *searchVc;
@property (nonatomic, copy) NSMutableArray *allDatas;
@property (nonatomic, copy) NSMutableArray *resultDatas;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _allDatas = [NSMutableArray arrayWithObjects:@"ABC",@"DEF",@"efg",@"不错哦",@"错了吗？", nil];
    _resultDatas = [NSMutableArray array];
    
    _searchVc = [[UISearchController alloc] initWithSearchResultsController:nil]; // 这里设置SearchResultsController为另外一个控制器去单独显示搜索结果也是可以的。我这里用的就是当前控制器，所以是nil。
    _searchVc.searchBar.placeholder = @"搜索";
    [_searchVc.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
    _searchVc.searchBar.barTintColor = [UIColor purpleColor]; // 背景色
    _searchVc.searchBar.tintColor = [UIColor greenColor];  // 光标和按钮颜色
    _searchVc.searchResultsUpdater = self;
    _searchVc.dimsBackgroundDuringPresentation = NO; // 是否在present的时候dismiss掉之前的页面
//    _searchVc.hidesNavigationBarDuringPresentation = NO; // 是否在present的时候隐藏导航栏
    [_searchVc.searchBar sizeToFit];  // 少了这句代码的话，在iOS8中searchBar的高度是0，所以显示不出来，但在iOS9和iOS10上不会出现该问题。
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = _searchVc.searchBar;
    _tableView.tableFooterView = [UIView new];
    
    self.definesPresentationContext = YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchVc.isActive ?  _resultDatas.count : _allDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _searchVc.isActive ?  _resultDatas[indexPath.row] : _allDatas[indexPath.row];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"选择了   %@",selectCell.textLabel.text);
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSLog(@"%@",searchController.searchBar.text);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",searchController.searchBar.text];
    [_resultDatas removeAllObjects];
    [_resultDatas addObjectsFromArray:[_allDatas filteredArrayUsingPredicate:predicate]];
    
    [_tableView reloadData];
}

@end
