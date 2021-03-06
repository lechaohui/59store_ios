//
//  HXSShippingAddressVC.m
//  store
//
//  Created by 格格 on 16/8/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  收货地址

#import "HXSShoppingAddressVC.h"

// Models
#import "HXSBuildingArea.h"
#import "HXSShoppingAddressViewModel.h"

// Views
#import "HXSInfoInputCell.h"
#import "HXSLineView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "HXSActionSheet.h"
#import "HXSKeyAndTextViewCell.h"

// others
#import "NSString+YFEmoji.h"

static CGFloat const kTableRowHeight = 44.0;

static NSInteger const kPhoneLength  = 11;  // 手机号长度
static NSInteger const kNameLength   = 9;   // 姓名长度


@interface HXSShoppingAddressVC ()<UITableViewDelegate,
                                  UITableViewDataSource,
                                  UIActionSheetDelegate,
                                  UITextFieldDelegate,
                                  HXSKeyAndTextViewCellDelegate>

@property (nonatomic,weak) IBOutlet TPKeyboardAvoidingTableView *myTable;

@property (nonatomic,strong) HXSInfoInputCell *contactCell;
@property (nonatomic,strong) HXSInfoInputCell *sexCell;
@property (nonatomic,strong) HXSInfoInputCell *phoneCell;
@property (nonatomic,strong) HXSInfoInputCell *shoppingAddreddCell;
@property (nonatomic,strong) HXSKeyAndTextViewCell *detialAddressCell;
@property (nonatomic,strong) NSArray <HXSInfoInputCell *> *dataArray;

@property (nonatomic,strong) UIBarButtonItem *saveButtonItem;

@property (nonatomic,strong) HXSShoppingAddress *currentAddress;

// 这里的参数用来保存HXSLocationManager原有的值
@property (nonatomic, strong) HXSCity *currentCity;
@property (nonatomic, strong) HXSSite *currentSite;
@property (nonatomic, strong) HXSBuildingArea *currentBuildingArea;
@property (nonatomic, strong) HXSBuildingEntry *buildingEntry;

// 用来保存收货地址
@property (nonatomic, strong) HXSCity *tempCity;
@property (nonatomic, strong) HXSSite *tempSite;
@property (nonatomic, strong) HXSBuildingArea *tempBuildingArea;
@property (nonatomic, strong) HXSBuildingEntry *tempbuildingEntry;

@property (nonatomic, assign) BOOL changedAddress;

@end

@implementation HXSShoppingAddressVC


#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNav];
    
    [self initialDataArray];
    
    [self initialTable];
    
    [self registeNotice];
    
    [self saveOriginalLocation];
    
    [self fetchShoppingAddressList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self changeNavigationBarBackgroundColor:[UIColor colorWithHexString:@"fde25c"]
                        pushBackButItemImage:[UIImage imageNamed:@"btn_back_normal"]
                     presentBackButItemImage:[UIImage imageNamed:@"xia"]
                                  titleColor:[UIColor whiteColor]];
    
//    [self changeNavigationBarBackgroundColor:[UIColor colorWithRGBHex:navBarWhiteBgColorValue]
//                        pushBackButItemImage:[UIImage imageNamed:@"fanhui"]
//                     presentBackButItemImage:[UIImage imageNamed:@"xia"]
//                                  titleColor:[UIColor colorWithRGBHex:navBarWhiteTitleVolorValue]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self changeNavigationBarNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)registeNotice
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.contactCell.valueTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.sexCell.valueTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.phoneCell.valueTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.shoppingAddreddCell.valueTextField];
    
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:self.contactCell.valueTextField];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:self.sexCell.valueTextField];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:self.phoneCell.valueTextField];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:self.shoppingAddreddCell.valueTextField];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


#pragma mark - initial

- (void)initialNav
{    
    self.navigationItem.title = @"收货地址";
    // 保存按钮
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 17)];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRGBHex:0x303030] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRGBHex:0x303030] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithRGBHex:0xb2b2b2] forState:UIControlStateDisabled];
    [button addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    rightItem.enabled = NO;
    self.saveButtonItem = rightItem;
}

- (void)initialDataArray
{
    self.dataArray = @[self.contactCell,self.sexCell,self.phoneCell,self.shoppingAddreddCell,self.detialAddressCell];
}

- (void)initialTable
{
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.separatorColor = HXS_COLOR_SEPARATION_STRONG;
    self.myTable.rowHeight = kTableRowHeight;
    
    // 最后一个cell下面的横线
    HXSLineView *lineView = [[HXSLineView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [lineView setBackgroundColor:HXS_COLOR_SEPARATION_STRONG];
    [self.myTable setTableFooterView:lineView];
}


#pragma mark - webservice

- (void)fetchShoppingAddressList
{
    [HXSLoadingView showLoadingInView:self.view];
    WS(weakSelf);
    
    [HXSShoppingAddressViewModel fetchShoppingAddressComplete:^(HXSErrorCode code, NSString *message, NSArray *shoppingAddressArr) {
        [HXSLoadingView closeInView:weakSelf.view];
        if(kHXSNoError == code) {
            if(shoppingAddressArr&&shoppingAddressArr.count > 0) {
                
                weakSelf.currentAddress = [shoppingAddressArr firstObject];
                [weakSelf showShoppingAddressInfo:weakSelf.currentAddress];
                
            } else {
                [weakSelf updateShoppingAddress];
            }
        } else {
            [weakSelf updateShoppingAddress];
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        }
    }];
}

- (void)addNewShoppingAddress
{
    [HXSLoadingView showLoadingInView:self.view];
    
    HXSShoppingAddress *shoppingAddress = [[HXSShoppingAddress alloc]init];
    shoppingAddress.contactNameStr = self.contactCell.valueTextField.text;
    shoppingAddress.genderStr = [self.sexCell.valueTextField.text isEqualToString:@"女"] ? @"0" : @"1";
    shoppingAddress.siteIdStr = self.tempSite.site_id.stringValue;
    shoppingAddress.dormentryIdStr = self.tempbuildingEntry.dormentryIDNum.stringValue;
    shoppingAddress.contactPhoneStr = self.phoneCell.valueTextField.text;
    shoppingAddress.detailAddressStr = self.detialAddressCell.valueTextField.text;
    
    WS(weakSelf);
    [HXSShoppingAddressViewModel addNewShoppingAddressWithModel:shoppingAddress
                                                       complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                                           
                                                           [HXSLoadingView closeInView:weakSelf.view];
                                                           
                                                           if(kHXSNoError == code) {
                                                               
                                                               if ( [weakSelf.delegate respondsToSelector:@selector(saveAddressFinished)]) {
                                                                   [weakSelf.delegate saveAddressFinished];
                                                               }
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               
                                                           } else {
                                                               [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                                           }
    }];
}

- (void)updateAddressInfo
{
    [HXSLoadingView showLoadingInView:self.view];
    
    self.currentAddress.contactNameStr = self.contactCell.valueTextField.text;
    self.currentAddress.genderStr = [self.sexCell.valueTextField.text isEqualToString:@"女"] ? @"0" : @"1";
    
    // 如果地址信息修改过
    if (nil != self.tempCity
       && nil != self.tempSite
       && nil != self.tempBuildingArea
       && nil != self.tempbuildingEntry) {
        
        self.currentAddress.siteIdStr = self.tempSite.site_id.stringValue;
        self.currentAddress.dormentryIdStr = self.tempbuildingEntry.dormentryIDNum.stringValue;
    }
    
    self.currentAddress.contactPhoneStr = self.phoneCell.valueTextField.text;
    self.currentAddress.detailAddressStr = self.detialAddressCell.valueTextField.text;
    
    WS(weakSelf);
    [HXSShoppingAddressViewModel updateShoppingAddressWithModel:self.currentAddress
                                                       complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                                           
                                                           [HXSLoadingView closeInView:weakSelf.view];
                                                           
                                                           if(kHXSNoError == code) {
                                                               
                                                               if ( [weakSelf.delegate respondsToSelector:@selector(saveAddressFinished)]) {
                                                                   [weakSelf.delegate saveAddressFinished];
                                                               }
                                                               
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                           } else {
                                                               [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                                           }
                                                           
                                                       }];
}


#pragma mark - Target/Action

- (void)sexCellSelected
{
    HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:nil cancelButtonTitle:@"取消"];
    
    WS(weakSelf);
    
    HXSActionSheetEntity *maleActionSheetEntity = [[HXSActionSheetEntity alloc]init];
    maleActionSheetEntity.nameStr = @"男";
    HXSAction *maleAction = [HXSAction actionWithMethods:maleActionSheetEntity
                                                 handler:^(HXSAction *action) {
                                                     weakSelf.sexCell.valueTextField.text = @"男";
                                                     [weakSelf updateSaveButtonEnabled];
                                                 }];
    [sheet addAction:maleAction];
    
    HXSActionSheetEntity *femaleActionSheetEntity = [[HXSActionSheetEntity alloc]init];
    femaleActionSheetEntity.nameStr = @"女";
    HXSAction *femaleAction = [HXSAction actionWithMethods:femaleActionSheetEntity
                                                   handler:^(HXSAction *action) {
                                                       weakSelf.sexCell.valueTextField.text = @"女";
                                                       [weakSelf updateSaveButtonEnabled];
                                                   }];
    [sheet addAction:femaleAction];
    [sheet show];
}

- (void)saveButtonClicked
{
    if(self.currentAddress) {
        [self updateAddressInfo];
    } else {
        [self addNewShoppingAddress];
    }
}


#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSInfoInputCell *cell = [self.dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSInfoInputCell *cell = [self.dataArray objectAtIndex:indexPath.row];
    if(cell == self.shoppingAddreddCell) {
        
        [self completeShoppingAddress];
        
        WS(weakSelf);
        [[HXSLocationManager manager] resetPosition:PositionBuilding completion:^{
            [weakSelf updateShoppingAddress];
        }];
        
    } else if(cell == self.sexCell) {
        [self sexCellSelected];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self updateSaveButtonEnabled];
}

- (void)textFieldTextChanged:(NSNotification *)obj
{
    [self checkTheTextViewTextIsMoreThanMax:(UITextField *)obj.object];
    [self updateSaveButtonEnabled];
}


#pragma mark - HXSKeyAndTextViewCellDelegate

- (void)valueTextFieldChange:(UITextField *)valueTextField
{
    [self updateSaveButtonEnabled];
}

#pragma mark - private methods

- (void)updateShoppingAddress
{
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    
    // 保存选择的地址
    self.tempCity = locationMgr.currentCity;
    self.tempSite = locationMgr.currentSite;
    self.tempBuildingArea = locationMgr.currentBuildingArea;
    self.tempbuildingEntry = locationMgr.buildingEntry;
    
    // 复制为原来地址
    [self resumeOriginalLocation];

    if ((nil != self.tempSite.name)
        && (0 < [self.tempSite.name length])
        && (nil != self.tempBuildingArea)
        && (0 < [self.tempBuildingArea.name length])
        && (nil != self.tempbuildingEntry)
        && (0 < [self.tempbuildingEntry.buildingNameStr length])) {
        self.shoppingAddreddCell.valueTextField.text = [NSString stringWithFormat:@"%@%@%@", self.tempSite.name, self.tempBuildingArea.name, self.tempbuildingEntry.buildingNameStr];
    }
    [self updateSaveButtonEnabled];
}

- (void)updateSaveButtonEnabled
{
    if(self.contactCell.valueTextField.text.length > 0
       &&self.sexCell.valueTextField.text.length > 0
       &&self.phoneCell.valueTextField.text.length > 0
       &&self.shoppingAddreddCell.valueTextField.text.length >0
       &&self.detialAddressCell.valueTextField.text.length > 0) {
        self.saveButtonItem.enabled = YES;
    } else {
        self.saveButtonItem.enabled = NO;
    }
}

- (void)showShoppingAddressInfo:(HXSShoppingAddress *)shoppingAddress
{
    self.contactCell.valueTextField.text = shoppingAddress.contactNameStr;
    self.sexCell.valueTextField.text = shoppingAddress.genderStr.intValue == HXSShoppingAddressGenderFemale ? @"女" : @"男";
    self.phoneCell.valueTextField.text = shoppingAddress.contactPhoneStr;
    self.shoppingAddreddCell.valueTextField.text = [NSString stringWithFormat:@"%@%@%@",shoppingAddress.siteNameStr,shoppingAddress.dormentryZoneNameStr,shoppingAddress.dormentryNameStr];
    self.detialAddressCell.valueTextField.text = shoppingAddress.detailAddressStr;
    
    [self updateSaveButtonEnabled];
}

- (void)checkTheTextViewTextIsMoreThanMax:(UITextField *)textField
{
    NSString *toBeString = textField.text;
    NSString *lang =  [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            toBeString = [toBeString stringByRemoveAllEmoji];
            if (textField == self.phoneCell.valueTextField) {  // 手机号码不能超过11位
                if (toBeString.length >= kPhoneLength) {
                    textField.text = [toBeString substringToIndex:kPhoneLength];
                }
            }
            if (textField == self.contactCell.valueTextField) {  // 联系人不超过9个字
                if (toBeString.length >= kNameLength) {
                    textField.text = [toBeString substringToIndex:kNameLength];
                }
            }
            
        } else {  // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {  // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        toBeString = [toBeString stringByRemoveAllEmoji];
        
        if (textField == self.phoneCell.valueTextField) {  // 手机号码不能超过11位
            if (toBeString.length >= kPhoneLength) {
                textField.text = [toBeString substringToIndex:kPhoneLength];
            }
        }
        if (textField == self.contactCell.valueTextField) {  // 联系人不超过9个字
            if (toBeString.length >= kNameLength) {
                textField.text = [toBeString substringToIndex:kNameLength];
            }
        }
    }
  
}

- (void)saveOriginalLocation
{
    // 保存HXSLocationManager中原来的值
    
    self.currentCity = [HXSLocationManager manager].currentCity;
    self.currentSite = [HXSLocationManager manager].currentSite;
    self.currentBuildingArea = [HXSLocationManager manager].currentBuildingArea;
    self.buildingEntry = [HXSLocationManager manager].buildingEntry;
}

- (void)resumeOriginalLocation
{
    // 恢复HXSLocationManager中原来的值
    [HXSLocationManager manager].currentCity         = self.currentCity;
    [HXSLocationManager manager].currentSite         = self.currentSite;
    [HXSLocationManager manager].currentBuildingArea = self.currentBuildingArea;
    [HXSLocationManager manager].buildingEntry       = self.buildingEntry;

}


/*
 判断是否有收货地址并且收货地址是否是完整的（从城市到楼栋的信息都有叫完整）
 完整的收货地址，将收货地址赋值为首页地址
 */
- (void)completeShoppingAddress
{
    if (nil != self.tempCity
        && nil != self.tempSite
        && nil != self.tempBuildingArea
        && nil != self.tempbuildingEntry ) {
        
        [HXSLocationManager manager].currentCity = self.tempCity;
        [HXSLocationManager manager].currentSite = self.tempSite;
        [HXSLocationManager manager].currentBuildingArea = self.tempBuildingArea;
        [HXSLocationManager manager].buildingEntry = self.tempbuildingEntry;
        
    } else if (self.currentAddress) {
        
        if(self.currentAddress.cityIdStr.length > 0
           && self.currentAddress.dormentryZoneNameStr.length > 0
           && self.currentAddress.siteIdStr.length > 0
           && self.currentAddress.dormentryIdStr.length > 0) {
            
            HXSCity *city = [[HXSCity alloc]init];
            city.city_id  = @(self.currentAddress.cityIdStr.integerValue);
            city.name     = self.currentAddress.cityNameStr;
            [HXSLocationManager manager].currentCity = city;
            
            HXSSite *site = [[HXSSite alloc]init];
            site.site_id  = @(self.currentAddress.siteIdStr.integerValue);
            site.name     = self.currentAddress.siteNameStr;
            [HXSLocationManager manager].currentSite = site;
            
            HXSBuildingArea *area = [[HXSBuildingArea alloc]init];
            area.name  = self.currentAddress.dormentryZoneNameStr;
            [HXSLocationManager manager].currentBuildingArea = area;
            
            HXSBuildingEntry *entry = [[HXSBuildingEntry alloc]init];
            entry.buildingNameStr   = self.currentAddress.dormentryNameStr;
            entry.dormentryIDNum    = @(self.currentAddress.dormentryIdStr.integerValue);
            [HXSLocationManager manager].buildingEntry = entry;
            
        }
    } else {
        // do nothing
    }
}


#pragma mark - Getter

- (HXSInfoInputCell *)contactCell
{
    if(!_contactCell) {
        _contactCell = [HXSInfoInputCell infoInputCell];
        _contactCell.keyLabel.text = @"联系人";
        _contactCell.valueTextField.placeholder = @"请填写收货人姓名";
        _contactCell.valueTextField.delegate = self;
        _contactCell.valueTextField.returnKeyType = UIReturnKeyDone;
    }
    return _contactCell;
}

- (HXSInfoInputCell *)sexCell
{
    if(!_sexCell) {
        _sexCell = [HXSInfoInputCell infoInputCell];
        _sexCell.keyLabel.text = @"性别";
        _sexCell.valueTextField.placeholder = @"请选择";
        _sexCell.valueTextField.enabled = NO;
        _sexCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return _sexCell;
}

- (HXSInfoInputCell *)phoneCell
{
    if(!_phoneCell) {
        _phoneCell = [HXSInfoInputCell infoInputCell];
        _phoneCell.keyLabel.text = @"手机号";
        _phoneCell.valueTextField.placeholder = @"请填写手机号";
        _phoneCell.valueTextField.text = [HXSUserAccount currentAccount].userInfo.basicInfo.phone;
        _phoneCell.valueTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneCell;
}

- (HXSInfoInputCell *)shoppingAddreddCell
{
    if(!_shoppingAddreddCell) {
        _shoppingAddreddCell = [HXSInfoInputCell infoInputCell];
        _shoppingAddreddCell.keyLabel.text = @"收货地址";
        _shoppingAddreddCell.valueTextField.placeholder = @"请选择";
        _shoppingAddreddCell.valueTextField.enabled = NO;
        _shoppingAddreddCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    return _shoppingAddreddCell;
}

- (HXSKeyAndTextViewCell *)detialAddressCell
{
    if(!_detialAddressCell) {
        _detialAddressCell = [HXSKeyAndTextViewCell keyAndTextViewCell];
        _detialAddressCell.keyLabel.text = @"详细地址";
        _detialAddressCell.valueTextField.placeholder = @"如：2单元113室";
        _detialAddressCell.delegate = self;
    }
    return _detialAddressCell;
}

@end
