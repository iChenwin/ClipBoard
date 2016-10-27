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
    NSArray *clipArr = [self getSavedClipArr];
    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 120, [clipArr count] * 30);
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
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, 30)];
//            [cell setTranslatesAutoresizingMaskIntoConstraints:NO];
//            //layout 子view
//            //子view的上边缘离父view的上边缘40个像素
//            NSLayoutConstraint *contraint1 = [NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
//            //子view的左边缘离父view的左边缘40个像素
//            NSLayoutConstraint *contraint2 = [NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
//            //子view的下边缘离父view的下边缘40个像素
//            NSLayoutConstraint *contraint3 = [NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
//            //子view的右边缘离父view的右边缘40个像素
//            NSLayoutConstraint *contraint4 = [NSLayoutConstraint constraintWithItem:cell attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
//            //把约束添加到父视图上
//            NSArray *array = [NSArray arrayWithObjects:contraint1, contraint2, contraint3, contraint4, nil];
//            [self.tableView addConstraints:array];
            [cell.leftAnchor constraintEqualToAnchor:self.tableView.leftAnchor].active = YES;
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];//WithFrame:CGRectMake(0, 0, 375, 30)];
            cell.textLabel.text = [UIPasteboard generalPasteboard].string;
            
            UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 0, 30, 30)];
            [addBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [addBtn setTitle:@"+" forState:UIControlStateNormal];
            [addBtn.titleLabel setFont:[UIFont systemFontOfSize:30]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAction:)];
            [addBtn addGestureRecognizer:tap];
            [cell addSubview:addBtn];
            
//            [addBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
//            //layout 子view
//            //子view的上边缘离父view的上边缘40个像素
//            NSLayoutConstraint *contraint1 = [NSLayoutConstraint constraintWithItem:addBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
//            //子view的左边缘离父view的左边缘40个像素
////            NSLayoutConstraint *contraint2 = [NSLayoutConstraint constraintWithItem:addBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
//            //子view的下边缘离父view的下边缘40个像素
//            NSLayoutConstraint *contraint3 = [NSLayoutConstraint constraintWithItem:addBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
//            //子view的右边缘离父view的右边缘40个像素
//            NSLayoutConstraint *contraint4 = [NSLayoutConstraint constraintWithItem:addBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:10.0];
//            //把约束添加到父视图上
//            NSArray *array = [NSArray arrayWithObjects:contraint1, contraint3, contraint4, nil];
//            [cell addConstraints:array];
            
            return cell;
        } else {
            UITableViewCell *cell = reversedArray[indexPath.row - 1];
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

-(void)addAction:(UIGestureRecognizer *)sender {
    NSArray *clipArr = [self getSavedClipArr];
    UITableViewCell *lastCell = [clipArr lastObject];
    if ([lastCell.textLabel.text isEqualToString:[UIPasteboard generalPasteboard].string]) {
        
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, 30)];
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

//-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    self.preferredContentSize = CGSizeMake(0, 200);
//}

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
