//
//  HXStoreDocumentLibraryShareTagSettingViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/27.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryShareTagSettingViewController.h"

//views
#import "HXStoreDocumentLibraryShareTagSettingTableViewCell.h"

//model
#import "HXStoreDocumentLibraryViewModel.h"

//other
#import "HXStoreDocumentLibraryImport.h"
#import "UITableView+RowsSectionsTools.h"
#import "NSString+InputLimit.h"
#import "NSString+Addition.h"

NSInteger const tagsMaxNums = 3;//最大标签数量
NSInteger const tagsMaxInputCounts = 10;//标签输入最大字符串数量

@interface HXStoreDocumentLibraryShareTagSettingViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView                *mainTableView;
@property (nonatomic, strong) HXStoreDocumentLibraryViewModel   *viewModel;
@property (nonatomic, strong) UIBarButtonItem                   *rightBarButton;
@property (nonatomic, strong) HXStoreDocumentLibraryDocumentModel *docModel;
@property (nonatomic, strong) NSMutableArray<NSString *>        *tagsArray;
@property (nonatomic, strong) UIView                            *headerView;

@end

@implementation HXStoreDocumentLibraryShareTagSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];

    [self initTableView];
    
    [self initDocTags];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)createDocumentLibraryShareTagSettingWithDoc:(HXStoreDocumentLibraryDocumentModel *)docModel;
{
    HXStoreDocumentLibraryShareTagSettingViewController *vc = [HXStoreDocumentLibraryShareTagSettingViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    
    vc.docModel = docModel;
    
    return vc;
}

#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"标签设置";
    
    [self.navigationItem setRightBarButtonItem:self.rightBarButton];
}

- (void)initTableView
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStoreDocumentLibrary" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXStoreDocumentLibraryShareTagSettingTableViewCell class])
                                               bundle:bundle]
         forCellReuseIdentifier:NSStringFromClass([HXStoreDocumentLibraryShareTagSettingTableViewCell class])];
    
    [_mainTableView setTableHeaderView:self.headerView];
}

- (void)initDocTags
{
    NSMutableArray *array = [self.viewModel createTagsArrayForTagsStr:_docModel.tagsStr];
    if(array) {
        _tagsArray = array;
    } else {
        _tagsArray = [[NSMutableArray<NSString *> alloc] init];
        [_tagsArray addObject:@""];
    }
    
    [self checkRightBarButtonStatus];
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger section = 0;
    
    if(_docModel) {
        section = 1;
    }
    
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 1;
    
    if(_tagsArray
       && _tagsArray.count > 0) {
        rows = _tagsArray.count;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryShareTagSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXStoreDocumentLibraryShareTagSettingTableViewCell class])
                                                                                     forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 59.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXStoreDocumentLibraryShareTagSettingTableViewCell *tempCell = (HXStoreDocumentLibraryShareTagSettingTableViewCell *)cell;
    [tempCell.inputTextField setText:@""];
    NSString *tagsStr;
    
    if(_tagsArray) {
        tagsStr = [_tagsArray objectAtIndex:indexPath.row];
    }
    
    [tempCell initDocumentLibraryShareTagSettingTableViewCellWithTags:tagsStr];
    [tempCell.addButton setTag:indexPath.row];
    [tempCell.addButton addTarget:self
                           action:@selector(addButtonAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [tempCell.deleteButton setTag:indexPath.row];
    [tempCell.deleteButton addTarget:self
                              action:@selector(deleteButtonAction:)
                    forControlEvents:UIControlEventTouchUpInside];
    
    [self checkCurrentTagsSettingAddDeleteButtonWithCell:tempCell
                                             andRowIndex:indexPath.row];
    tempCell.inputTextField.delegate = self;
    [tempCell.inputTextField setTag:indexPath.row];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFiledEditChanged:)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:tempCell.inputTextField];
     
     
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL isPass = [string checkInputLimitNoSpecialCharactersWithCounts:tagsMaxInputCounts];
    
    if(!isPass) {
        return NO;
    }
    
    if([newString trim].length > tagsMaxInputCounts) {
        NSRange rangeRange = [newString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, tagsMaxInputCounts)];
        textField.text = [newString substringWithRange:rangeRange];
    }
    
    NSInteger index = textField.tag;
    NSMutableString *stringText = [[NSMutableString alloc]initWithString:textField.text];
    if(![[string trim] isEqualToString:@""]) {
        [stringText appendString:string];
    }
    [_tagsArray replaceObjectAtIndex:index withObject:stringText];
     
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger index = textField.tag;
    NSString *text = textField.text;
    
    BOOL isPass = [text checkInputLimitNoSpecialCharactersWithCounts:tagsMaxInputCounts];
    
    if(!isPass) {
        text = @"";
        textField.text = text;
        [MBProgressHUD showInViewWithoutIndicator:self.view
                                           status:@"请不要输入标点符号和空格等特殊字符"
                                       afterDelay:1.5];
        [_tagsArray replaceObjectAtIndex:index
                              withObject:text];
        [self checkRightBarButtonStatus];
        return;
    }
    
    [_tagsArray replaceObjectAtIndex:index withObject:text];
    
    [self checkRightBarButtonStatus];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSInteger index = textField.tag;
    [textField resignFirstResponder];
    [_tagsArray replaceObjectAtIndex:index
                          withObject:@""];
    [self checkRightBarButtonStatus];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = [textField.text trim];
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start
                                                        offset:0];
    if (!position) {
        if (toBeString.length > tagsMaxInputCounts) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:tagsMaxInputCounts];
            if (rangeIndex.length == 1) {
                textField.text = [toBeString substringToIndex:tagsMaxInputCounts];
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, tagsMaxInputCounts)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
    NSInteger index = textField.tag;
    [_tagsArray replaceObjectAtIndex:index
                          withObject:toBeString];
    [self checkRightBarButtonStatus];
}


#pragma mark - Button Action

- (void)rightBarButtonAction
{
    [self saveTagsAndBackToShareView];
}

- (void)addButtonAction:(UIButton *)button
{
    NSInteger index = button.tag;
    
    if(index < tagsMaxNums - 1) {
        [_tagsArray addObject:@""];
        
        [_mainTableView insertSingleRowToSection:0
                                     andRowIndex:index + 1
                                    andAnimation:UITableViewRowAnimationTop];
        
        [_mainTableView reloadSingleRowWithRowIndex:index
                                    andSectionIndex:0
                                       andAnimation:UITableViewRowAnimationNone];
    }
}

- (void)deleteButtonAction:(UIButton *)button
{
    NSInteger index = button.tag;
    if(index < _tagsArray.count) {
        [_tagsArray removeObjectAtIndex:index];
    }
    [_mainTableView deleteSingleRowWithRowIndex:index
                                andSectionIndex:0
                             andDataSourceArray:_tagsArray
                                   andAnimation:UITableViewRowAnimationBottom
                                       Complete:nil];
    
    [_mainTableView reloadData];
}


#pragma mark - JumpAction

- (void)saveTagsAndBackToShareView
{
    NSString *currentTags = [self.viewModel createTagsStrWithTagsArray:_tagsArray];
    
    if(currentTags
       && ![[currentTags trim] isEqualToString:@""]) {
        [_docModel setTagsStr:currentTags];
        
        if(self.delegate
           && [self.delegate respondsToSelector:@selector(saveTags:)]) {
            [self.delegate saveTags:_docModel];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - check RightBar Button Status

- (void)checkRightBarButtonStatus
{
    BOOL hasGotTags = NO;
    
    NSString *currentTags = [self.viewModel createTagsStrWithTagsArray:_tagsArray];
    
    if(!currentTags
       || [[currentTags trim] isEqualToString:@""]) {
        hasGotTags = NO;
    } else {
        hasGotTags = YES;
    }
    
    [_rightBarButton setEnabled:hasGotTags];
}


#pragma mark - check Curret Tags setting add delete button

- (void)checkCurrentTagsSettingAddDeleteButtonWithCell:(HXStoreDocumentLibraryShareTagSettingTableViewCell *)cell
                                           andRowIndex:(NSInteger)rowIndex
{
    if(_tagsArray.count == 0) {
        [cell.addButton     setHidden:NO];
        [cell.deleteButton  setHidden:YES];
    } else if(_tagsArray.count == tagsMaxNums
              && rowIndex == _tagsArray.count - 1) {
        [cell.addButton     setHidden:YES];
        [cell.deleteButton  setHidden:NO];
    } else if(rowIndex < _tagsArray.count - 1) {
        [cell.addButton     setHidden:YES];
        [cell.deleteButton  setHidden:NO];
    } else {
        [cell.addButton     setHidden:NO];
        [cell.deleteButton  setHidden:YES];
    }
}


#pragma mark - getter

- (HXStoreDocumentLibraryViewModel *)viewModel
{
    if(nil == _viewModel) {
        _viewModel = [[HXStoreDocumentLibraryViewModel alloc]init];
    }
    
    return _viewModel;
}

- (UIBarButtonItem *)rightBarButton
{
    if(nil == _rightBarButton) {
        _rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(rightBarButtonAction)];
        [_rightBarButton setEnabled:NO];
    }
    
    return _rightBarButton;
}

- (UIView *)headerView
{
    if(nil == _headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [_headerView setBackgroundColor:[UIColor colorWithRGBHex:0xF3FCFF]];
        UILabel *contentLabel = [[UILabel alloc]init];
        [contentLabel setText:@"标签越精准，越利于别人找到你的文档哦~"];
        [contentLabel setFont:[UIFont systemFontOfSize:13]];
        [contentLabel setTextColor:[UIColor colorWithRGBHex:0x07A9FA]];
        
        [_headerView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(15);
            make.centerY.equalTo(_headerView);
        }];
    }
    
    return _headerView;
}

@end
