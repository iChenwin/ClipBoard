//
//  TodayViewController.m
//  ClipBoardExtension
//
//  Created by wayne on 16/10/26.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *clipArr = [self getSavedClipArr];
    UITableViewCell *lastCell = [clipArr lastObject];
    if ([lastCell.textLabel.text isEqualToString:[UIPasteboard generalPasteboard].string]) {
        return [clipArr count];
    } else {
        return [clipArr count] + 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *clipArr = [self getSavedClipArr];
    NSArray* reversedArray = [[clipArr reverseObjectEnumerator] allObjects];
    UITableViewCell *lastCell = [reversedArray firstObject];
    if ([lastCell.textLabel.text isEqualToString:[UIPasteboard generalPasteboard].string]) {
        if (indexPath.row < [clipArr count]) {
            UITableViewCell *cell = reversedArray[indexPath.row];
            return cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 375, 30)];
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 375, 30)];
            cell.textLabel.text = [UIPasteboard generalPasteboard].string;
            
            UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(310, 0, 30, 30)];
            [addBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [addBtn setTitle:@"+" forState:UIControlStateNormal];
            [addBtn.titleLabel setFont:[UIFont systemFontOfSize:30]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAction:)];
            [addBtn addGestureRecognizer:tap];
            [cell addSubview:addBtn];
            
            return cell;
        } else {
            UITableViewCell *cell = reversedArray[indexPath.row - 1];
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(void)addAction:(UIGestureRecognizer *)sender {
    NSArray *clipArr = [self getSavedClipArr];
    UITableViewCell *lastCell = [clipArr lastObject];
    if ([lastCell.textLabel.text isEqualToString:[UIPasteboard generalPasteboard].string]) {
        
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 375, 30)];
        cell.textLabel.text = [UIPasteboard generalPasteboard].string;
        NSMutableArray *cellArr = [[NSMutableArray alloc] initWithArray:clipArr];
        [cellArr addObject:cell];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cellArr];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:data forKey:@"clipArr"];
        [userDefaults synchronize];
        [self.tableView reloadData];
    }
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    self.preferredContentSize = CGSizeMake(0, 200);
}

-(NSMutableArray *)getSavedClipArr {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:@"clipArr"];
    NSMutableArray *clipArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return clipArr;
}

#pragma mark - ncwedgetproviding
// 一般默认的View是从图标的右边开始的...如果你想变换,就要实现这个方法
//- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
//    return UIEdgeInsetsMake(0.0, 0.0, 0, 0);
//}



@end
