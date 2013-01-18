

#import "LTMatrixCell.h"
#import "LTMatrixView.h"

@implementation LTMatrixCell

@synthesize iconBorder = _iconBorder;
@synthesize thumbnail = _thumbnail;
@synthesize stateLabel = _stateLabel;
@synthesize titleLabel = _titleLabel;
@synthesize pickFrame=_pickFrame;
@synthesize maskLabel = _maskLabel;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
        flagHorizon:(Boolean)isHorizon
{
    self = [super initWithStyle:style 
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:self.frame] autorelease];
//        self.selectedBackgroundView.backgroundColor = CELL_SELECT_BACKGROUNDCOLOR;
        
        _pickFrame=[[UIImageView alloc]init];
        [self.contentView addSubview:_pickFrame];
        
        self.thumbnail = [[[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 60, 60)] autorelease];
        self.thumbnail.backgroundColor = [UIColor clearColor];
        self.thumbnail.opaque = YES;
        
        [self.contentView addSubview:self.thumbnail];
        
        self.iconBorder = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 68, 68)] autorelease];
        self.iconBorder.backgroundColor = [UIColor clearColor];
        //self.iconBorder.opaque = YES;
        [self.contentView addSubview:self.iconBorder];
        
        self.stateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, self.thumbnail.frame.size.height * 0.632, self.thumbnail.frame.size.width, self.thumbnail.frame.size.height * 0.37)] autorelease];
        self.stateLabel.backgroundColor = [UIColor clearColor];
        self.stateLabel.opaque = YES;
        self.stateLabel.textColor = [UIColor blackColor];
        self.stateLabel.font = [UIFont systemFontOfSize:11];
        self.stateLabel.textAlignment = UITextAlignmentCenter;
        self.stateLabel.numberOfLines = 1;
    }
    
    self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);    
    return self;
}

- (void)setMaskTitle:(NSString *)title
{
    _maskLabel.hidden = NO;
    _maskLabel.text = title;
}

#pragma mark pravite methods

- (void)dealloc {
    self.iconBorder = nil;
    self.thumbnail = nil;
    self.stateLabel = nil;
    self.titleLabel = nil;
    self.pickFrame=nil;
    
    [super dealloc];
}


@end
