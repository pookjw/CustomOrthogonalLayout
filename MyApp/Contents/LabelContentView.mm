//
//  LabelContentView.mm
//  MyApp
//
//  Created by Jinwoo Kim on 4/20/24.
//

#import "LabelContentView.hpp"

__attribute__((objc_direct_members))
@interface LabelContentConfiguration ()
@property (retain, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *text;
@end

@implementation LabelContentConfiguration

+ (LabelContentConfiguration *)configurationWithImage:(UIImage *)image text:(NSString *)text {
    return [[[LabelContentConfiguration alloc] initWithImage:image text:text] autorelease];
}

- (instancetype)initWithImage:(UIImage *)image text:(NSString *)text {
    if (self = [super init]) {
        _image = [image retain];
        _text = [text copy];
    }
    
    return self;
}

- (void)dealloc {
    [_image release];
    [_text release];
    [super dealloc];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        LabelContentConfiguration *_other = other;
        return [_image isEqual:_other->_image] &&
        [_text isEqualToString:_other->_text];
    }
}

- (NSUInteger)hash {
    return _image.hash ^ _text.hash;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    LabelContentConfiguration *copy = [[self class] new];
    
    if (copy) {
        copy->_image = [_image retain];
        copy->_text = [_text copy];
    }
    
    return copy;
}

- (__kindof UIView<UIContentView> *)makeContentView {
    return [[[LabelContentView alloc] initWithContentConfiguration:self] autorelease];
}

- (instancetype)updatedConfigurationForState:(id<UIConfigurationState>)state {
    return self;
}

@end

__attribute__((objc_direct_members))
@interface LabelContentView ()
@property (copy, nonatomic) LabelContentConfiguration *contentConfiguration;
@property (retain, nonatomic) UIStackView *stackView;
@property (retain, nonatomic) UIImageView *imageView;
@property (retain, nonatomic) UILabel *label;
@end

@implementation LabelContentView
@synthesize stackView = _stackView;
@synthesize imageView = _imageView;
@synthesize label = _label;

- (instancetype)initWithContentConfiguration:(LabelContentConfiguration *)contentConfiguration {
    if (self = [super initWithFrame:CGRectNull]) {
        UIStackView *stackView = self.stackView;
        
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:stackView];
        
        [NSLayoutConstraint activateConstraints:@[
            [stackView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
        ]];
        
        self.contentConfiguration = contentConfiguration;
    }
    
    return self;
}

- (void)dealloc {
    [_contentConfiguration release];
    [_stackView release];
    [_imageView release];
    [_label release];
    [super dealloc];
}

- (UIStackView *)stackView {
    if (auto stackView = _stackView) return stackView;
    
    UIImageView *imageView = self.imageView;
    UILabel *label = self.label;
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[imageView, label]];
    
    [imageView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [imageView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.spacing = 8.f;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.distribution = UIStackViewDistributionFillProportionally;
    
    _stackView = [stackView retain];
    return [stackView autorelease];
}

- (UIImageView *)imageView {
    if (auto imageView = _imageView) return imageView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    _imageView = [imageView retain];
    return [imageView autorelease];
}

- (UILabel *)label {
    if (auto label = _label) return label;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    
    _label = [label retain];
    return [label autorelease];
}

- (id<UIContentConfiguration>)configuration {
    return _contentConfiguration;
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    self.contentConfiguration = reinterpret_cast<LabelContentConfiguration *>(configuration);
}

- (BOOL)supportsConfiguration:(id<UIContentConfiguration>)configuration {
    return [configuration isKindOfClass:[LabelContentConfiguration class]];
}

- (void)setContentConfiguration:(LabelContentConfiguration *)contentConfiguration {
    LabelContentConfiguration *old = _contentConfiguration;
    LabelContentConfiguration *copy = [contentConfiguration copy];
    
    [old release];
    _contentConfiguration = copy;
    
    //
    
    self.imageView.image = copy.image;
    self.label.text = copy.text;
}

@end
