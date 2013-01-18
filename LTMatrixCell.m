

#import "LTMatrixCell.h"
#import "LTMatrixView.h"

@implementation LTMatrixCell

@synthesize iconBorder = _iconBorder;
@synthesize thumbnail = _thumbnail;
@synthesize stateLabel = _stateLabel;
@synthesize detailButton = _detailButton;
@synthesize titleLabel = _titleLabel;
@synthesize pickFrame=_pickFrame;
@synthesize chartLabel = _chartLabel;
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
        
        self.thumbnail = [[[UIImageView alloc] initWithFrame:CGRectMake(VGAP, CELL_GAP, CELL_WIDTH_YSK, CELL_HEIGHT_YSK)] autorelease];
        self.thumbnail.backgroundColor = [UIColor clearColor];
        self.thumbnail.opaque = YES;
        
        [self.contentView addSubview:self.thumbnail];
        
        self.iconBorder = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_BG_WIDTH_YSK, CELL_BG_HEIGHT_YSK)] autorelease];
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
        //[self.thumbnail addSubview:self.stateLabel];
        
        self.detailButton = [[[LTUIButton alloc] init] autorelease];
        self.detailButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.detailButton];
        
        self.titleLabel = [[[UILabel alloc] init] autorelease];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = DEFAULT_FONT_COLOR;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textAlignment = UITextAlignmentLeft;
        [self.detailButton addSubview:self.titleLabel];
        
        const NSInteger maskLabelHeight = 14;
        _maskLabel = [[UILabel alloc] initWithFrame:CGRectMake(-2, (int)CELL_BG_HEIGHT_YSK-maskLabelHeight+4, CELL_BG_WIDTH_YSK+4, maskLabelHeight)];
        _maskLabel.backgroundColor = ICON_MASK_COLOR;
        _maskLabel.textColor = DEFAULT_FONT_COLOR;
        _maskLabel.font = [UIFont systemFontOfSize:10];
        _maskLabel.textAlignment = UITextAlignmentRight;
        _maskLabel.hidden = YES;
        [_thumbnail addSubview:_maskLabel];
        
        _chartLabel = [[StyleLabel alloc] initWithFrame:CGRectMake(_thumbnail.frame.origin.x+_thumbnail.frame.size.width-34,_thumbnail.frame.origin.y+_thumbnail.frame.size.height-34,34 , 34) andValue:0];
        _chartLabel.hidden=YES;
        [self addSubview:_chartLabel];
    }
    
    self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    
    if (isHorizon) {
        [self setHorizontalLayout];
    }
    else{
        [self setVerticalLayout];
    }
    
    return self;
}

- (void)setMaskTitle:(NSString *)title
{
    _maskLabel.hidden = NO;
    _maskLabel.text = title;
}

- (void) setVerticalLayout
{
    self.iconBorder.image = [UIImage imageNamed:@"channel_icon_border.png"];
    self.iconBorder.frame = CGRectMake(5,0, CELL_POSTER_WIDTH_YSK+7, CELL_POSTER_HEIGHT_YSK+8);
    
    self.thumbnail.frame = CGRectMake(9, 4, CELL_POSTER_WIDTH_YSK, CELL_POSTER_HEIGHT_YSK);
    self.thumbnail.center = self.iconBorder.center;
    
    self.chartLabel.frame=CGRectMake(_thumbnail.frame.origin.x+_thumbnail.frame.size.width-34,_thumbnail.frame.origin.y+_thumbnail.frame.size.height-34, 34, 34);
    
    self.detailButton.frame = CGRectMake(VGAP, CELL_GAP+CELL_BG_HEIGHT_YSK+2, CELL_BG_WIDTH_YSK, 30);
    self.titleLabel.frame = CGRectMake(0, 2, self.detailButton.frame.size.width, self.detailButton.frame.size.height);
    self.titleLabel.numberOfLines = 2;
}

- (void) setHorizontalLayout
{
    self.iconBorder.image = [UIImage imageNamed:@"channel_icon_border_horizon.png"];
    self.iconBorder.frame = CGRectMake(5, 0,  CELL_POSTER_WIDTH_WWW+6, CELL_POSTER_HEIGHT_WWW+6);
    
    self.thumbnail.frame = CGRectMake(8, 3, CELL_POSTER_WIDTH_WWW, CELL_POSTER_HEIGHT_WWW);
    self.thumbnail.center = self.iconBorder.center;
    
    self.chartLabel.frame=CGRectMake(_thumbnail.frame.origin.x+_thumbnail.frame.size.width-34,_thumbnail.frame.origin.y+_thumbnail.frame.size.height-34, 34, 34);

    self.detailButton.frame = CGRectMake(HGAP, CELL_GAP+CELL_BG_HEIGHT_WWW-2, CELL_BG_WIDTH_WWW, 30);
    self.titleLabel.frame = CGRectMake(0, 0, self.detailButton.frame.size.width, self.detailButton.frame.size.height);
    self.titleLabel.numberOfLines = 2;
}

#pragma mark pravite methods

- (void)dealloc {
    self.iconBorder = nil;
    self.thumbnail = nil;
    self.stateLabel = nil;
    self.detailButton = nil;
    self.titleLabel = nil;
    self.pickFrame=nil;
    
    [super dealloc];
}


@end
