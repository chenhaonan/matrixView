
//

#import "LTMatrixView.h"
//#import "LTMatrixCell.h"
#import "LTHorizontalTableCell_iPhone.h"

#pragma mark private methods
@interface LTMatrixView()

@end


@implementation LTMatrixView

@synthesize rowNumber = _rowNumber, 
            columnNumber = _columnNumber, 
            cellWidth = _cellWidth, 
            cellHeight = _cellHeight,
            matrixDataSource = _matrixDataSource, 
            matrixDelegate = _matrixDelegate,
            scrollDelegate = _scrollDelegate;
@synthesize enterEditMode = _enterEditMode;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.allowsSelection = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.dataSource = self;
        self.delegate = self;
        _rowNumber = 0;
        _columnNumber  = 0;  
        _cellWidth = 0;
        _cellHeight = 0;
    }
    return self;
}

#pragma mark 
- (NSInteger)numberOfColumnsInSection:(NSInteger)section
{
    if (section > [self numberOfSections]) {
        return 0;
    }
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    LTHorizontalTableCell_iPhone *tmp = (LTHorizontalTableCell_iPhone *)[cell viewWithTag:1000];
    return [tmp numberOfRowsInSection:0];
}

- (LTHorizontalTableCell_iPhone*)sectionTableAtSection:(NSInteger)section
{
    if (section > [self numberOfSections]) {
        return nil;
    }
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    LTHorizontalTableCell_iPhone *tmp = (LTHorizontalTableCell_iPhone *)[cell viewWithTag:1000];
    return tmp;
}

- (UITableViewCell *)matrixCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section > [self numberOfSections] || row > [self numberOfRowsInSection:section]) {
        return nil;
    }
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    LTHorizontalTableCell_iPhone *tmp = (LTHorizontalTableCell_iPhone *)[cell viewWithTag:1000];
    return (UITableViewCell*)[tmp cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
}

- (NSIndexPath *)indexPathForMatrixCell:(UITableViewCell *)cell
{
    NSInteger section, row;
    LTHorizontalTableCell_iPhone *tmp = (LTHorizontalTableCell_iPhone*)[cell superview];
    NSIndexPath *indexPath = [tmp indexPathForCell:cell];
    row = indexPath.row;
    indexPath = [self indexPathForCell:(UITableViewCell *)[tmp superview]];
    section = indexPath.section;
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (void)scrollToMatrixCellAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section >= [self numberOfSections] || row >= [self numberOfRowsInSection:section]) {
        return;
    }
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    LTHorizontalTableCell_iPhone *tmp = (LTHorizontalTableCell_iPhone *)[cell viewWithTag:1000];
    [tmp scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (NSArray *)visibleMatrixCells
{
    NSMutableArray *activeArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *visibleSections = [self visibleCells];
    for (UITableViewCell *hCell in visibleSections) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        LTHorizontalTableCell_iPhone *activeCell = (LTHorizontalTableCell_iPhone *)[hCell viewWithTag:1000];
        [activeArray addObjectsFromArray:[activeCell visibleCells]];
        [pool release];
    }
    
    return activeArray;
}

#pragma mark self tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self &&
        _matrixDataSource && 
        [_matrixDataSource respondsToSelector:@selector(matrixView:heightForHeaderInSection:)]) {
            return [_matrixDataSource matrixView:self heightForHeaderInSection:section];
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self &&
        _matrixDataSource && 
        [_matrixDataSource respondsToSelector:@selector(matrixView:viewForHeaderInSection:)]) {
        return [_matrixDataSource matrixView:self viewForHeaderInSection:section];
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self) {
        _rowNumber = [_matrixDataSource numberOfSectionsInMatrixView:self];
        if (_rowNumber < 0) {
            return 0;
        }
        
        return _rowNumber;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self) {        
        if (_rowNumber <= 0) {
            return 0;
        }
        
        return 1;
    } else {
        NSInteger numberOfCell = [_matrixDataSource matrixView:self
                                        numberOfCellsInSection:((LTHorizontalTableCell_iPhone*)tableView).horizontalRowNumber];
        if (numberOfCell < 0) {
            return 0;
        }
        return numberOfCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self) {
        _cellHeight = [self.matrixDataSource matrixCellHeight:self heightForRowAtIndexPath:indexPath];
        if (_cellHeight < 0) {
            _cellHeight = 0;
        }
        
        return _cellHeight;
    } else {
        NSInteger activeSection = ((LTHorizontalTableCell_iPhone*)tableView).horizontalRowNumber;
        _cellWidth = [self.matrixDataSource matrixCellWidth:self widthForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:activeSection]];
        //NSLog(@"cell width %f",_cellWidth);
        if (_cellWidth < 0) {
            _cellWidth = 0;
        }
        return _cellWidth;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{        
    NSInteger section = indexPath.section;
    NSInteger currentRow = indexPath.row;
    
    // current matrix table
    if (tableView == self) {        
        //init cell
        static NSString *cellIdentifier = @"horizontalTable";
        if (self.delegate && [self.matrixDelegate respondsToSelector:@selector(matrixViewSectionIndentifier: indexPath:)]) {
            cellIdentifier = [self.matrixDelegate matrixViewSectionIndentifier:self indexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        _cellWidth = [self.matrixDataSource matrixCellWidth:self widthForRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:section]];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            //use one rotate table to replace a normal table cell
            _cellHeight = [self.matrixDataSource matrixCellHeight:self heightForRowAtIndexPath:indexPath];
             CGRect rect=[[UIScreen mainScreen]bounds];
            LTHorizontalTableCell_iPhone *hTableCell = [[LTHorizontalTableCell_iPhone alloc] initWithFrame:CGRectMake(0, 0, _cellHeight, rect.size.height)];
            // adjust scroll indicator position for rotation
            hTableCell.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, _cellHeight - 8);
            if (_matrixDelegate && [_matrixDelegate respondsToSelector:@selector(matrixViewAllowShowHorizontalScrollIndicator:)]) {
                hTableCell.showsVerticalScrollIndicator = [_matrixDelegate matrixViewAllowShowHorizontalScrollIndicator:self];
            } else {
                hTableCell.showsVerticalScrollIndicator = YES;
            }
            hTableCell.showsHorizontalScrollIndicator = NO;
            if (_matrixDelegate && [_matrixDelegate respondsToSelector:@selector(matrixViewAllowSectionScrolled:)]) {
                hTableCell.scrollEnabled = [_matrixDelegate matrixViewAllowSectionScrolled:self];
            }
            
            if (_matrixDelegate && [_matrixDelegate respondsToSelector:@selector(matrixViewAllowSectionAlwaysScrolled:)]) {
                hTableCell.alwaysBounceVertical = [_matrixDelegate matrixViewAllowSectionAlwaysScrolled:self];
                hTableCell.scrollEnabled = YES;
            } else {
                hTableCell.alwaysBounceHorizontal = NO;
                hTableCell.alwaysBounceVertical = NO;
            }
            hTableCell.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
            //_cellWidth = [self.matrixDataSource matrixCellWidth:self widthForRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:section]];
            //hTableCell.rowHeight = _cellWidth;
            [hTableCell setFrame:CGRectMake(0, 0, self.frame.size.width, _cellHeight)];	
            if (_matrixDelegate && [_matrixDelegate respondsToSelector:@selector(matrixViewAllowSectionAlwaysScrolled:)]) {
                //hTableCell.frame = CGRectMake(0, 0, self.frame.size.width-1, _cellHeight);
                //hTableCell.alwaysBounceVertical = [_matrixDelegate matrixViewAllowSectionAlwaysScrolled:self];
                hTableCell.scrollEnabled = YES;
            }
						
            if ([self.matrixDataSource respondsToSelector:@selector(matrixCellBackgroundColor:cell:)]) {
                [self.matrixDataSource matrixCellBackgroundColor:tableView cell:hTableCell];
            }else {
                hTableCell.backgroundColor = [UIColor clearColor];
            }

            hTableCell.separatorStyle = UITableViewCellSeparatorStyleNone;
            hTableCell.separatorColor = [UIColor clearColor];
            
            hTableCell.dataSource = self;
            hTableCell.delegate = self;
            
            hTableCell.horizontalRowNumber = section;
            hTableCell.tag = 1000;
            hTableCell.contentOffset = CGPointMake(0, 0);
            [cell addSubview:hTableCell];
            [hTableCell release];
        }else
        {
            ((LTHorizontalTableCell_iPhone*)[cell viewWithTag:1000]).contentOffset = CGPointMake(0, 0);
            [(LTHorizontalTableCell_iPhone*)[cell viewWithTag:1000] setHorizontalRowNumber:section];
            [(LTHorizontalTableCell_iPhone*)[cell viewWithTag:1000] reloadData];
        }
        
        return cell;
    } else {//active cell in horizontal table
        NSInteger activeSection = ((LTHorizontalTableCell_iPhone*)tableView).horizontalRowNumber;

        return [self.matrixDataSource matrixView:self sectionTableView:tableView
                          matrixCellForIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:activeSection]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (tableView != self) {
        NSInteger section = ((LTHorizontalTableCell_iPhone*)tableView).horizontalRowNumber;
        NSInteger row = indexPath.row;
        NSIndexPath *currentIndex = [NSIndexPath indexPathForRow:0 inSection:_selectedColumnNumber];
        NSIndexPath *sub = [NSIndexPath indexPathForRow:_selectedRowNumber inSection:0];
        
        if (_selectedColumnNumber != section || _selectedRowNumber != row) {
            for (UIView *subview in [self cellForRowAtIndexPath:currentIndex].subviews) {
                if ([subview isKindOfClass:[LTHorizontalTableCell_iPhone class]]) {
                    [[((LTHorizontalTableCell_iPhone*)subview) cellForRowAtIndexPath:sub] setSelected:NO];
                }
            }
            _selectedRowNumber = row;
            _selectedColumnNumber = section;
        }
        
        NSInteger activeSection = ((LTHorizontalTableCell_iPhone*)tableView).horizontalRowNumber;
        [self.matrixDelegate matrixView:self didSelectCellAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:activeSection]];
        NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
        if(selIndexPath)
        {
            [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
        }
    }
}

#pragma makr scrollview delegate overide
- (void)scrollViewDidScroll:(UIScrollView *)scrollView// any offset changes
{
    if (self.matrixDelegate
        &&  [self.matrixDelegate respondsToSelector:@selector(matrixViewDidScroll:)]) {
        [self.matrixDelegate matrixViewDidScroll:scrollView];
    }
    
    if (self.scrollDelegate &&
        [self.scrollDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollDelegate scrollViewDidScroll:scrollView];
    }
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    if (self.scrollDelegate &&
        [self.scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.scrollDelegate scrollViewWillBeginDragging:scrollView];
    }
}
// called on finger up if the user dragged. velocity is in points/second. targetContentOffset may be changed to adjust where the scroll view comes to rest. not called when pagingEnabled is YES

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.scrollDelegate &&
        [self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndDragging: willDecelerate:)]) {
        [self.scrollDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

// called on finger up as we are moving
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollDelegate &&
        [self.scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.scrollDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollDelegate &&
        [self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.scrollDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)dealloc {
	self.matrixDataSource = nil;
    self.matrixDelegate = nil;
    [super dealloc];
}


#pragma mark private methods

@end
