
//

#import <UIKit/UIKit.h>
#import "LTMatrixCell.h"
#import "LTHorizontalTableCell_iPhone.h"

typedef enum {
    LTMatrixViewCellEditingStyleNone,
    LTMatrixViewCellEditingStyleDelete,
    LTMatrixViewCellEditingStyleCheckMark,
} LTMatrixViewViewCellEditingStyle;

@class LTMatrixView;

@protocol LTMatrixViewDataSource<NSObject>
 @required
- (NSInteger) numberOfSectionsInMatrixView:(LTMatrixView *)matrixView;
- (NSInteger)matrixView:(LTMatrixView *)matrixView numberOfCellsInSection:(NSInteger)section;
- (UITableViewCell *)matrixView:(LTMatrixView *)matrixView 
               sectionTableView:(UITableView *)sectionTableView 
         matrixCellForIndexPath:(NSIndexPath *)indexPath;
- (CGFloat) matrixCellWidth:(LTMatrixView *)matrixView widthForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat) matrixCellHeight:(LTMatrixView *)matrixView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
 @optional
- (CGFloat) matrixView:(LTMatrixView *)matrixView heightForHeaderInSection:(NSInteger)section;
- (UIView *) matrixView:(LTMatrixView *)matrixView viewForHeaderInSection:(NSInteger)section;
- (void) matrixCellBackgroundColor:(UITableView *)matrixView cell:(LTHorizontalTableCell_iPhone*)cellView;
@end

@protocol LTMatrixViewDelegate<UIScrollViewDelegate>
 @required
- (void)matrixView:(LTMatrixView *)matrixView didSelectCellAtIndexPath:(NSIndexPath *)indexPath;
 @optional
- (LTMatrixViewViewCellEditingStyle)matrixView:(LTMatrixView *)matrixView editingStyleForIndex:(NSIndexPath *)indexPath;
- (void)matrixView:(LTMatrixView *)matrixView commitEditingStyle:(LTMatrixViewViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)matrixViewDidScroll:(UIScrollView *)matrixView;
- (BOOL)matrixViewAllowSectionScrolled:(LTMatrixView *)matrixView;
- (BOOL)matrixViewAllowSectionAlwaysScrolled:(LTMatrixView *)matrixView;
- (BOOL)matrixViewAllowShowHorizontalScrollIndicator:(LTMatrixView*)matrixView;
- (NSString*) matrixViewSectionIndentifier:(LTMatrixView *)matrixView indexPath:(NSIndexPath *)indexPath;
@end


@interface LTMatrixView : UITableView
<
    UIScrollViewDelegate,
    UITableViewDataSource,
    UITableViewDelegate
>{
  id<LTMatrixViewDataSource> _matrixDataSource;
	id<LTMatrixViewDelegate> _matrixDelegate;
    id<UIScrollViewDelegate> _scrollDelegate;
	
	NSInteger _rowNumber;
	NSInteger _columnNumber;	
	CGFloat _cellWidth;
	CGFloat _cellHeight;
    BOOL _enterEditMode;
    NSInteger _selectedColumnNumber;
    NSInteger _selectedRowNumber;
}

@property (nonatomic, assign) id<LTMatrixViewDataSource> matrixDataSource;
@property (nonatomic, assign) id<LTMatrixViewDelegate> matrixDelegate;
@property (nonatomic, assign) id<UIScrollViewDelegate> scrollDelegate;
@property (nonatomic, assign) NSInteger rowNumber;
@property (nonatomic, assign) NSInteger columnNumber;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) BOOL enterEditMode;

- (NSInteger)numberOfColumnsInSection:(NSInteger)section;
- (NSIndexPath *)indexPathForMatrixCell:(UITableViewCell *)cell;
- (void)scrollToMatrixCellAtIndexPath:(NSIndexPath*)indexPath;
- (UITableViewCell *)matrixCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (LTHorizontalTableCell_iPhone*)sectionTableAtSection:(NSInteger)section;
- (NSArray *)visibleMatrixCells;

@end
