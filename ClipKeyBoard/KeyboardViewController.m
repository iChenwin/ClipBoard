//
//  KeyboardViewController.m
//  ClipKeyBoard
//
//  Created by wayne on 16/10/27.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import "KeyboardViewController.h"

@interface KeyboardViewController ()
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (strong, nonatomic) NSMutableArray *clipArr;
@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Perform custom UI setup here
    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.nextKeyboardButton setTitle:NSLocalizedString(@"Next Keyboard", @"Title for 'Next Keyboard' button") forState:UIControlStateNormal];
    [self.nextKeyboardButton sizeToFit];
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.nextKeyboardButton];
    [self.nextKeyboardButton.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.nextKeyboardButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.nextKeyboardButton addTarget:self action:@selector(handleInputModeListFromView:withEvent:) forControlEvents:UIControlEventAllTouchEvents];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteBtn sizeToFit];
    deleteBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:deleteBtn];
    [deleteBtn.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [deleteBtn.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [deleteBtn addTarget:self action:@selector(handleDeleteEvent:) forControlEvents:UIControlEventAllEvents];
    
    //获取剪贴板里缓存的所有文字
//    NSArray *clipArr = [self getSavedClipArr];
//    clipArr = [[clipArr reverseObjectEnumerator] allObjects];
    self.clipArr = [[NSMutableArray alloc] initWithObjects:@"hello world!", @"你好", @"哈哈哈", @"嘿嘿嘿", @"呵呵呵", @"嘻嘻嘻", nil];
    int i = 0;
    for (NSString *cell in self.clipArr) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, i * 30, [UIScreen mainScreen].bounds.size.width - 40, 30)];
        [button setTitle:cell forState:UIControlStateNormal];
        [self.view addSubview:button];
        [button setTag:i];
        UITapGestureRecognizer *tapAKey = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAKey:)];
        [button addGestureRecognizer:tapAKey];
        i++;
    }
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width - 40, 30)];
//    [button setTitle:@"Hello world!" forState:UIControlStateNormal];
//    button.layer.borderWidth = 1.0f;
//    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

-(NSMutableArray *)getSavedClipArr {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:@"clipArr"];
    NSMutableArray *clipArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return clipArr;
}

-(void)tapAKey:(UITapGestureRecognizer *)sender {
    [self.textDocumentProxy insertText:self.clipArr[sender.view.tag]];
}

-(void)handleDeleteEvent:(UIGestureRecognizer *)sender {
//    NSArray *tokens = [self.textDocumentProxy.documentContextBeforeInput componentsSeparatedByString:@" "];
//    for (int i = 0; i < [[tokens lastObject] length];i++) {
//        [self.textDocumentProxy deleteBackward];
//    }
    [self.textDocumentProxy deleteBackward];
}

-(void) removeLastWordFromInput{
    for (unsigned long i = self.textDocumentProxy.documentContextBeforeInput.length - 1;i > 0; i--) {
        if ([self.textDocumentProxy.documentContextBeforeInput characterAtIndex:i] == ' ')
            return;
        
        //delete last character
        [self.textDocumentProxy deleteBackward];
    }
}
@end
