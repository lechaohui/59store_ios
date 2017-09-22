//
//  UITableView+RowsSectionsTools.h
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/28.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (RowsSectionsTools)

/**
 *  刷新一个section
 *
 *  @param sectionIndex
 *  @param aniamation
 */
- (void)reloadSectionsWithSectionIndex:(NSInteger)sectionIndex
                          andAnimation:(UITableViewRowAnimation)aniamation;

/**
 *  刷新一个row
 *
 *  @param rowIndex
 *  @param sectionIndex
 *  @param aniamation
 */
- (void)reloadSingleRowWithRowIndex:(NSInteger)rowIndex
                    andSectionIndex:(NSInteger)sectionIndex
                       andAnimation:(UITableViewRowAnimation)aniamation;

/**
 *  删除一个row
 *
 *  @param rowIndex
 *  @param sectionIndex
 *  @param array
 *  @param aniamation
 */
- (void)deleteSingleRowWithRowIndex:(NSInteger)rowIndex
                    andSectionIndex:(NSInteger)sectionIndex
                 andDataSourceArray:(NSMutableArray *)array
                       andAnimation:(UITableViewRowAnimation)aniamation
                           Complete:(void (^)())block;

/**
 *  插入一个row
 *
 *  @param rowIndex
 *  @param sectionIndex
 *  @param aniamation
 */
- (void)insertSingleRowToSection:(NSInteger)sectionIndex
                     andRowIndex:(NSInteger)rowIndex
                    andAnimation:(UITableViewRowAnimation)aniamation;

@end
