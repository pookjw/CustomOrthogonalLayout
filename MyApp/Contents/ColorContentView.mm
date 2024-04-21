//
//  ColorContentView.mm
//  MyApp
//
//  Created by Jinwoo Kim on 4/20/24.
//

#import "ColorContentView.hpp"

__attribute__((objc_direct_members))
@interface ColorContentConfiguration ()
@property (retain, nonatomic) UIColor *color;
@end

@implementation ColorContentConfiguration

+ (ColorContentConfiguration *)configurationWithColor:(UIColor *)color {
    return [[[ColorContentConfiguration alloc] initWithColor:color] autorelease];
}

- (instancetype)initWithColor:(UIColor *)color {
    if (self = [super init]) {
        _color = [color retain];
    }
    
    return self;
}

- (void)dealloc {
    [_color release];
    [super dealloc];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        ColorContentConfiguration *_other = other;
        return [_color isEqual:_other->_color];
    }
}

- (NSUInteger)hash {
    return _color.hash;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    ColorContentConfiguration *copy = [[self class] new];
    
    if (copy) {
        copy->_color = [_color retain];
    }
    
    return copy;
}

- (__kindof UIView<UIContentView> *)makeContentView {
    return [[[ColorContentView alloc] initWithContentConfiguration:self] autorelease];
}

- (instancetype)updatedConfigurationForState:(id<UIConfigurationState>)state {
    return self;
}

@end

__attribute__((objc_direct_members))
@interface ColorContentView ()
@property (copy, nonatomic) ColorContentConfiguration *contentConfiguration;
@end

@implementation ColorContentView

- (instancetype)initWithContentConfiguration:(ColorContentConfiguration *)contentConfiguration {
    if (self = [super initWithFrame:CGRectNull]) {
        self.contentConfiguration = contentConfiguration;
    }
    
    return self;
}

- (void)dealloc {
    [_contentConfiguration release];
    [super dealloc];
}

- (id<UIContentConfiguration>)configuration {
    return _contentConfiguration;
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    self.contentConfiguration = reinterpret_cast<ColorContentConfiguration *>(configuration);
}

- (BOOL)supportsConfiguration:(id<UIContentConfiguration>)configuration {
    return [configuration isKindOfClass:ColorContentConfiguration.class];
}

- (void)setContentConfiguration:(ColorContentConfiguration *)contentConfiguration {
    ColorContentConfiguration *old = _contentConfiguration;
    ColorContentConfiguration *copy = [contentConfiguration copy];
    
    [old release];
    _contentConfiguration = copy;
    
    //
    
    self.backgroundColor = copy.color;
}

@end
