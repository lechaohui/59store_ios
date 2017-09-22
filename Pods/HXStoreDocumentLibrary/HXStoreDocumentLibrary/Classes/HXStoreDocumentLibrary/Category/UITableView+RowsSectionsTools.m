//
//  UITableView+RowsSectionsTools.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/28.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "UITableView+RowsSectionsTools.h"

@implementation UITableView (RowsSectionsTools)


- (void)reloadSectionsWithSectionIndex:(NSInteger)sectionIndex
                          andAnimation:(UITableViewRowAnimation)aniamation
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
    
    [self beginUpdates];
    [self reloadSections:indexSet
        withRowAnimation:aniamation];
    [self endUpdates];
}

- (void)reloadSingleRowWithRowIndex:(NSInteger)rowIndex
                    andSectionIndex:(NSInteger)sectionIndex
                       andAnimation:(UITableViewRowAnimation)aniamation
{
    NSMutableArray<NSIndexPath *> *indexPathArray = [[NSMutableArray alloc]init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex
                                                inSection:sectionIndex];
    [indexPathArray addObject:indexPath];
    
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:indexPathArray
                withRowAnimation:UITableViewRowAnimationFade];
    [self endUpdates];
}

- (void)deleteSingleRowWithRowIndex:(NSInteger)rowIndex
                    andSectionIndex:(NSInteger)sectionIndex
                 andDataSourceArray:(NSMutableArray *)array
                       andAnimation:(UITableViewRowAnimation)aniamation
                           Complete:(void (^)())block

{
    if(!array) {
        return;
    }
    
    if(array.count == 0) {
        [self reloadData];
        block();
    } else {
        [self beginUpdates];
        NSMutableArray<NSIndexPath *> *indexPathArray = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex
                                                    inSection:sectionIndex];
        [indexPathArray addObject:indexPath];
        [self deleteRowsAtIndexPaths:indexPathArray
                    withRowAnimation:aniamation];
        [self endUpdates];
    }
}

- (void)insertSingleRowToSection:(NSInteger)sectionIndex
                     andRowIndex:(NSInteger)rowIndex
                    andAnimation:(UITableViewRowAnimation)aniamation
{
    [self beginUpdates];
    NSMutableArray<NSIndexPath *> *indexPathArray = [[NSMutableArray alloc]init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex
                                                inSection:sectionIndex];
    [indexPathArray addObject:indexPath];
    [self insertRowsAtIndexPaths:indexPathArray
                withRowAnimation:aniamation];
    [self endUpdates];
}

@end
