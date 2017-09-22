//
//  HXSAddressDecorationView.h
//  store
//
//  Created by hudezhi on 15/11/2.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSSelectCityViewController.h"
#import "HXSSiteSelectViewController.h"
#import "HXSBuildingAreaSelectVC.h"
#import "HXSBuildingSelectViewController.h"

#import "HXSCity.h"
#import "HXSSite.h"
#import "HXSBuildingArea.h"
#import "HXSBuildingEntry.h"

typedef NS_ENUM(NSInteger, HXSAddressSelectionType) {
    HXSAddressSelectionCity,
    HXSAddressSelectionSite,
    HXSAddressSelectionBuildingArea,
    HXSAddressSelectionBuilding,
};

@protocol HXSAddressDecorationViewDelegate <NSObject>

- (void)addressSelectCity:(HXSCity *)city;
- (void)addressSelectSite:(HXSSite*)site;
- (void)addressSelectBuildArea:(HXSBuildingArea *)buildingArea;
- (void)addressSelectBuilding:(HXSBuildingEntry *)building;
- (void)addressDecorationViewCurrentSelectionChange:(HXSAddressSelectionType)selectionType;

- (void)refreshCityInfo:(HXSCity *)city;
- (void)refreshSiteInfo:(HXSSite*)site;
- (void)refreshBuildingAreaInfo:(HXSBuildingArea *)buildingArea;
- (void)refreshBuildingBuildingInfo:(HXSBuildingEntry *)building;

@end

@interface HXSAddressDecorationView : UIScrollView

@property (strong, nonatomic) HXSCity *city;
@property (strong, nonatomic) HXSSite *site;
@property (strong, nonatomic) HXSBuildingArea *buildingArea;
@property (strong, nonatomic) HXSBuildingEntry *building;
@property (nonatomic, assign) HXSAddressSelectionType selectionDestination;

@property (nonatomic, weak) UIViewController *containerController;

- (instancetype)initWithDelegate:(id<HXSAddressDecorationViewDelegate>) delegate containerController:(UIViewController *)controller;
- (void)showAddressSelectionType:(HXSAddressSelectionType)type;

@end
