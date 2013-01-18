

#import <UIKit/UIKit.h>
#import "LTRatingView.h"
#import "LTUIButton.h"
#import "StyleLabel.h"

@interface LTMatrixCell : UITableViewCell {
    UIImageView *_iconBorder;
    UIImageView *_thumbnail;
    UILabel *_stateLabel;
    LTUIButton *_detailButton;
    UILabel *_titleLabel;
    UIImageView *_pickFrame;
    StyleLabel *_chartLabel;
    UILabel *_maskLabel;
}
@property (nonatomic, retain) UIImageView *iconBorder;
@property (nonatomic, retain) UIImageView *thumbnail;
@property (nonatomic, retain) UILabel *stateLabel;
@property (nonatomic, retain) LTUIButton *detailButton;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *pickFrame;
@property (nonatomic, retain) StyleLabel *chartLabel;
@property (nonatomic, retain) UILabel *maskLabel;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
        flagHorizon:(Boolean)isHorizon;

- (void)setMaskTitle:(NSString *)title;

- (void) setVerticalLayout;
- (void) setHorizontalLayout;

@end
