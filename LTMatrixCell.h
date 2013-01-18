

#import <UIKit/UIKit.h>

@interface LTMatrixCell : UITableViewCell {
    UIImageView *_iconBorder;
    UIImageView *_thumbnail;
    UILabel *_stateLabel;
    UILabel *_titleLabel;
    UIImageView *_pickFrame;
    UILabel *_maskLabel;
}
@property (nonatomic, retain) UIImageView *iconBorder;
@property (nonatomic, retain) UIImageView *thumbnail;
@property (nonatomic, retain) UILabel *stateLabel;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *pickFrame;
@property (nonatomic, retain) UILabel *maskLabel;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
        flagHorizon:(Boolean)isHorizon;

- (void)setMaskTitle:(NSString *)title;

- (void) setVerticalLayout;
- (void) setHorizontalLayout;

@end
