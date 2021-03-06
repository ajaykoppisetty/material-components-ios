/*
 Copyright 2016-present the Material Components for iOS authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <XCTest/XCTest.h>

#import "MaterialButtons.h"
#import "MaterialShadowElevations.h"
#import "MaterialTypography.h"

static const CGFloat kEpsilonAccuracy = 0.001f;
// A value greater than the largest value created by combining normal values of UIControlState.
// This is a complete hack, but UIControlState doesn't expose anything useful here.
// This assumes that UIControlState is actually a set of bitfields and ignores application-specific
// values.
static const UIControlState kNumUIControlStates = 2 * UIControlStateSelected - 1;
static const UIControlState kUIControlStateDisabledHighlighted =
    UIControlStateHighlighted | UIControlStateDisabled;

static CGFloat randomNumber() {
  return arc4random_uniform(100) / (CGFloat)10;
}

static CGFloat randomNumberNotEqualTo(const CGFloat targetNumber) {
  while (1) {
    CGFloat number = randomNumber();
    if (number != targetNumber) {
      return number;
    }
  }
}

static UIColor *randomColor() {
  switch (arc4random_uniform(5)) {
    case 0:
      return [UIColor whiteColor];
      break;
    case 1:
      return [UIColor blackColor];
      break;
    case 2:
      return [UIColor redColor];
      break;
    case 3:
      return [UIColor orangeColor];
      break;
    case 4:
      return [UIColor greenColor];
      break;
    default:
      return [UIColor blueColor];
      break;
  }
}

static NSString *controlStateDescription(UIControlState controlState) {
  if (controlState == UIControlStateNormal) {
    return @"Normal";
  }
  NSMutableString *string = [NSMutableString string];
  if ((UIControlStateHighlighted & controlState) == UIControlStateHighlighted) {
    [string appendString:@"Highlighted "];
  }
  if ((UIControlStateDisabled & controlState) == UIControlStateDisabled) {
    [string appendString:@"Disabled "];
  }
  if ((UIControlStateSelected & controlState) == UIControlStateSelected) {
    [string appendString:@"Selected "];
  }
  return [string copy];
}

@interface ButtonsTests : XCTestCase
@end

@implementation ButtonsTests

- (void)testUppercaseTitleYes {
  // Given
  MDCButton *button = [[MDCButton alloc] init];
  NSString *originalTitle = @"some Text";

  // When
  button.uppercaseTitle = YES;
  [button setTitle:originalTitle forState:UIControlStateNormal];

  // Then
  XCTAssertEqualObjects(button.currentTitle,
                        [originalTitle uppercaseStringWithLocale:[NSLocale currentLocale]]);
}

- (void)testUppercaseTitleNo {
  // Given
  MDCButton *button = [[MDCButton alloc] init];
  NSString *originalTitle = @"some Text";

  // When
  button.uppercaseTitle = NO;
  [button setTitle:originalTitle forState:UIControlStateNormal];

  // Then
  XCTAssertEqualObjects(button.currentTitle, originalTitle);
}

- (void)testUppercaseTitleNoChangedToYes {
  // Given
  MDCButton *button = [[MDCButton alloc] init];
  NSString *originalTitle = @"some Text";

  // When
  button.uppercaseTitle = NO;
  [button setTitle:originalTitle forState:UIControlStateNormal];
  button.uppercaseTitle = YES;

  // Then
  XCTAssertEqualObjects(button.currentTitle,
                        [originalTitle uppercaseStringWithLocale:[NSLocale currentLocale]]);
}

- (void)testUppercaseTitleYesChangedToNo {
  // Given
  MDCButton *button = [[MDCButton alloc] init];
  NSString *originalTitle = @"some Text";

  // When
  button.uppercaseTitle = YES;
  [button setTitle:originalTitle forState:UIControlStateNormal];
  button.uppercaseTitle = NO;

  // Then
  XCTAssertEqualObjects(button.currentTitle, originalTitle);
}

- (void)testSetEnabledAnimated {
  // Given
  MDCButton *button = [[MDCButton alloc] init];

  NSArray *boolValues = @[ @YES, @NO ];
  for (id enabled in boolValues) {
    for (id animated in boolValues) {
      // When
      [button setEnabled:[enabled boolValue] animated:[animated boolValue]];

      // Then
      XCTAssertEqual(button.enabled, [enabled boolValue]);
    }
  }
}

- (void)testElevationForState {
  // Given
  MDCButton *button = [[MDCButton alloc] init];

  for (NSUInteger controlState = 0; controlState < kNumUIControlStates; ++controlState) {
    // And given
    CGFloat elevation = randomNumber();

    // When
    [button setElevation:elevation forState:controlState];

    // Then
    XCTAssertEqual([button elevationForState:controlState], elevation);
  }
}

- (void)testElevationNormal {
  // Given
  MDCButton *button = [[MDCButton alloc] init];
  CGFloat normalElevation = randomNumberNotEqualTo(0);

  // When
  [button setElevation:normalElevation forState:UIControlStateNormal];

  // Then
  XCTAssertEqual([button elevationForState:UIControlStateNormal], normalElevation);
  XCTAssertEqual([button elevationForState:UIControlStateHighlighted], normalElevation);
  XCTAssertEqual([button elevationForState:UIControlStateDisabled], normalElevation);
  XCTAssertEqual([button elevationForState:UIControlStateSelected], normalElevation);
}

- (void)testElevationNormalZeroElevation {
  // Given
  MDCButton *button = [[MDCButton alloc] init];

  // When
  [button setElevation:0 forState:UIControlStateNormal];

  // Then
  XCTAssertEqual([button elevationForState:UIControlStateNormal], 0);
}

- (void)testBackgroundColorForState {
  // Given
  MDCButton *button = [[MDCButton alloc] init];

  for (NSUInteger controlState = 0; controlState < kNumUIControlStates; ++controlState) {
    // And given
    UIColor *color = randomColor();

    // When
    [button setBackgroundColor:color forState:controlState];

    // Then
    XCTAssertEqualObjects([button backgroundColorForState:controlState], color);
  }
}

- (void)testCurrentBackgroundColorNormal {
  // Given
  MDCButton *button = [[MDCButton alloc] init];
  UIColor *normalColor = [UIColor redColor];
  [button setBackgroundColor:normalColor forState:UIControlStateNormal];

  // Then
  XCTAssertEqualObjects([button backgroundColor], normalColor);
}

- (void)testCurrentBackgroundColorHighlighted {
  // Given
  MDCButton *button = [[MDCButton alloc] init];
  UIColor *normalColor = [UIColor redColor];
  UIColor *color = [UIColor orangeColor];
  [button setBackgroundColor:normalColor forState:UIControlStateNormal];
  [button setBackgroundColor:color forState:UIControlStateHighlighted];

  // When
  button.highlighted = YES;

  // Then
  XCTAssertEqualObjects([button backgroundColor], color);
}

- (void)testCurrentBackgroundColorDisabled {
  // Given
  MDCButton *button = [[MDCButton alloc] init];
  UIColor *normalColor = [UIColor redColor];
  UIColor *color = [UIColor orangeColor];
  [button setBackgroundColor:normalColor forState:UIControlStateNormal];
  [button setBackgroundColor:color forState:UIControlStateDisabled];

  // When
  button.enabled = NO;

  // Then
  XCTAssertEqualObjects([button backgroundColor], color);
}

- (void)testCurrentBackgroundColorSelected {
  // Given
  MDCButton *button = [[MDCButton alloc] init];
  UIColor *normalColor = [UIColor redColor];
  UIColor *color = [UIColor orangeColor];
  [button setBackgroundColor:normalColor forState:UIControlStateNormal];
  [button setBackgroundColor:color forState:UIControlStateSelected];

  // When
  button.selected = YES;

  // Then
  XCTAssertEqualObjects([button backgroundColor], color);
}

- (void)testCurrentElevationNormal {
  // Given
  MDCButton *button = [[MDCButton alloc] init];
  CGFloat normalElevation = 10;
  [button setElevation:normalElevation forState:UIControlStateNormal];

  // Then
  XCTAssertEqualWithAccuracy([button elevationForState:button.state],
                             normalElevation,
                             kEpsilonAccuracy);
}

- (void)testCurrentElevationHighlighted {
  // Given
  MDCButton *button = [[MDCButton alloc] init];
  CGFloat normalElevation = 10;
  CGFloat elevation = 40;
  [button setElevation:normalElevation forState:UIControlStateNormal];
  [button setElevation:elevation forState:UIControlStateHighlighted];

  // When
  button.highlighted = YES;

  // Then
  XCTAssertEqualWithAccuracy([button elevationForState:button.state], elevation, kEpsilonAccuracy);
}

- (void)testCurrentElevationDisabled {
  // Given
  MDCButton *button = [[MDCButton alloc] init];
  CGFloat normalElevation = 10;
  CGFloat elevation = 40;
  [button setElevation:normalElevation forState:UIControlStateNormal];
  [button setElevation:elevation forState:UIControlStateDisabled];

  // When
  button.enabled = NO;

  // Then
  XCTAssertEqualWithAccuracy([button elevationForState:button.state], elevation, kEpsilonAccuracy);
}

- (void)testCurrentElevationSelected {
  // Given
  MDCButton *button = [[MDCButton alloc] init];
  CGFloat normalElevation = 10;
  CGFloat elevation = 40;
  [button setElevation:normalElevation forState:UIControlStateNormal];
  [button setElevation:elevation forState:UIControlStateSelected];

  // When
  button.selected = YES;

  // Then
  XCTAssertEqualWithAccuracy([button elevationForState:button.state], elevation, kEpsilonAccuracy);
}

- (void)testInkColors {
  // Given
  MDCButton *button = [[MDCButton alloc] init];
  UIColor *color = randomColor();

  // When
  button.inkColor = color;

  // Then
  XCTAssertEqualObjects(button.inkColor, color);
}

/*
 TODO: things to unit test
 (should these even be a thing?)
 - hitAreaInset
 - disabledAlpha
 - underlyingColor (text color)
 */

- (void)testEncode {
  // Given
  MDCButton *button = [[MDCButton alloc] init];
  button.inkStyle = arc4random_uniform(2) ? MDCInkStyleBounded : MDCInkStyleUnbounded;
  button.inkMaxRippleRadius = randomNumber();
  button.uppercaseTitle = arc4random_uniform(2) ? YES : NO;
  button.hitAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
  button.inkColor = randomColor();
  button.underlyingColorHint = randomColor();
  for (NSUInteger controlState = 0; controlState < kNumUIControlStates; ++controlState) {
    [button setBackgroundColor:randomColor() forState:controlState];
    [button setElevation:randomNumber() forState:controlState];
  }
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:button];

  // When
  MDCButton *unarchivedButton = [NSKeyedUnarchiver unarchiveObjectWithData:data];

  // Then
  XCTAssertEqualObjects(button.inkColor, unarchivedButton.inkColor);
  XCTAssertEqual(button.uppercaseTitle, unarchivedButton.uppercaseTitle);
  XCTAssertEqual(button.inkStyle, unarchivedButton.inkStyle);
  XCTAssertEqualWithAccuracy(button.inkMaxRippleRadius,
                             unarchivedButton.inkMaxRippleRadius,
                             kEpsilonAccuracy);
  XCTAssertEqualWithAccuracy(button.hitAreaInsets.bottom,
                             unarchivedButton.hitAreaInsets.bottom,
                             kEpsilonAccuracy);
  XCTAssertEqualWithAccuracy(button.hitAreaInsets.top,
                             unarchivedButton.hitAreaInsets.top,
                             kEpsilonAccuracy);
  XCTAssertEqualWithAccuracy(button.hitAreaInsets.right,
                             unarchivedButton.hitAreaInsets.right,
                             kEpsilonAccuracy);
  XCTAssertEqualWithAccuracy(button.hitAreaInsets.left,
                             unarchivedButton.hitAreaInsets.left,
                             kEpsilonAccuracy);
  XCTAssertEqual(button.underlyingColorHint, unarchivedButton.underlyingColorHint);
  for (NSUInteger controlState = 0; controlState < kNumUIControlStates; ++controlState) {
    XCTAssertEqualWithAccuracy([button elevationForState:controlState],
                               [unarchivedButton elevationForState:controlState],
                               kEpsilonAccuracy);
    XCTAssertEqual([button backgroundColorForState:controlState],
                   [unarchivedButton backgroundColorForState:controlState]);
  }
}

- (void)testPointInsideWithoutHitAreaInsets {
  // Given
  MDCButton *button = [[MDCButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];

  CGPoint touchPointInsideBoundsTopLeft = CGPointMake(0, 0);
  CGPoint touchPointInsideBoundsTopRight = CGPointMake(79.9, 0);
  CGPoint touchPointInsideBoundsBottomRight = CGPointMake(79.9, 49.9);
  CGPoint touchPointInsideBoundsBottomLeft = CGPointMake(0, 49.9);

  CGPoint touchPointOutsideBoundsTopLeft = CGPointMake(0, -0.1);
  CGPoint touchPointOutsideBoundsTopRight = CGPointMake(80, 0);
  CGPoint touchPointOutsideBoundsBottomRight = CGPointMake(80, 50);
  CGPoint touchPointOutsideBoundsBottomLeft = CGPointMake(0, 50);

  // Then
  XCTAssertTrue([button pointInside:touchPointInsideBoundsTopLeft withEvent:nil]);
  XCTAssertTrue([button pointInside:touchPointInsideBoundsTopRight withEvent:nil]);
  XCTAssertTrue([button pointInside:touchPointInsideBoundsBottomRight withEvent:nil]);
  XCTAssertTrue([button pointInside:touchPointInsideBoundsBottomLeft withEvent:nil]);

  XCTAssertFalse([button pointInside:touchPointOutsideBoundsTopLeft withEvent:nil]);
  XCTAssertFalse([button pointInside:touchPointOutsideBoundsTopRight withEvent:nil]);
  XCTAssertFalse([button pointInside:touchPointOutsideBoundsBottomRight withEvent:nil]);
  XCTAssertFalse([button pointInside:touchPointOutsideBoundsBottomLeft withEvent:nil]);
}

- (void)testPointInsideWithoutHitAreaInsetsTooSmall {
  // Given
  MDCButton *button = [[MDCButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];

  CGPoint touchPointInsideBoundsTopLeft = CGPointMake(0, 0);
  CGPoint touchPointInsideBoundsTopRight = CGPointMake(9.9, 0);
  CGPoint touchPointInsideBoundsBottomRight = CGPointMake(9.9, 9.9);
  CGPoint touchPointInsideBoundsBottomLeft = CGPointMake(0, 9.9);

  CGPoint touchPointOutsideBoundsTopLeft = CGPointMake(0, -0.1);
  CGPoint touchPointOutsideBoundsTopRight = CGPointMake(10, 0);
  CGPoint touchPointOutsideBoundsBottomRight = CGPointMake(10, 10);
  CGPoint touchPointOutsideBoundsBottomLeft = CGPointMake(0, 10);

  // Then
  XCTAssertTrue([button pointInside:touchPointInsideBoundsTopLeft withEvent:nil]);
  XCTAssertTrue([button pointInside:touchPointInsideBoundsTopRight withEvent:nil]);
  XCTAssertTrue([button pointInside:touchPointInsideBoundsBottomRight withEvent:nil]);
  XCTAssertTrue([button pointInside:touchPointInsideBoundsBottomLeft withEvent:nil]);

  XCTAssertFalse([button pointInside:touchPointOutsideBoundsTopLeft withEvent:nil]);
  XCTAssertFalse([button pointInside:touchPointOutsideBoundsTopRight withEvent:nil]);
  XCTAssertFalse([button pointInside:touchPointOutsideBoundsBottomRight withEvent:nil]);
  XCTAssertFalse([button pointInside:touchPointOutsideBoundsBottomLeft withEvent:nil]);
}

- (void)testPointInsideWithCustomHitAreaInsets {
  // Given
  MDCButton *button = [[MDCButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];

  CGPoint touchPointInsideHitAreaTopLeft = CGPointMake(-5, -5);
  CGPoint touchPointInsideHitAreaTopRight = CGPointMake(-5, 14.9);
  CGPoint touchPointInsideHitAreaBottomRight = CGPointMake(14.9, 14.9);
  CGPoint touchPointInsideHitAreaBottomLeft = CGPointMake(14.9, -5);

  CGPoint touchPointOutsideHitAreaTopLeft = CGPointMake(-5.1, -5);
  CGPoint touchPointOutsideHitAreaTopRight = CGPointMake(-5, 15);
  CGPoint touchPointOutsideHitAreaBottomRight = CGPointMake(15, 15);
  CGPoint touchPointOutsideHitAreaBottomLeft = CGPointMake(15, -5);

  // When
  button.hitAreaInsets = UIEdgeInsetsMake(-5, -5, -5, -5);

  // Then
  XCTAssertTrue([button pointInside:touchPointInsideHitAreaTopLeft withEvent:nil]);
  XCTAssertTrue([button pointInside:touchPointInsideHitAreaTopRight withEvent:nil]);
  XCTAssertTrue([button pointInside:touchPointInsideHitAreaBottomRight withEvent:nil]);
  XCTAssertTrue([button pointInside:touchPointInsideHitAreaBottomLeft withEvent:nil]);

  XCTAssertFalse([button pointInside:touchPointOutsideHitAreaTopLeft withEvent:nil]);
  XCTAssertFalse([button pointInside:touchPointOutsideHitAreaTopRight withEvent:nil]);
  XCTAssertFalse([button pointInside:touchPointOutsideHitAreaBottomRight withEvent:nil]);
  XCTAssertFalse([button pointInside:touchPointOutsideHitAreaBottomLeft withEvent:nil]);
}

- (void)testPointInsideWithNonStandardizedBounds {
  // Given
  MDCButton *button = [[MDCButton alloc] initWithFrame:CGRectZero];
  // This is (-10, -10, 20, 20) in standardized form
  CGRect bounds = CGRectMake(10, 10, -20, -20);
  // Once applied, these insets should increase the hitArea to (-15, -20, 30, 40)
  UIEdgeInsets insets = UIEdgeInsetsMake(-10, -5, -10, -5);

  CGPoint touchPointInsideHitAreaTopLeft = CGPointMake(-15, -20);
  CGPoint touchPointInsideHitAreaTopRight = CGPointMake(14.9, -20);
  CGPoint touchPointInsideHitAreaBottomRight = CGPointMake(14.9, 19.9);
  CGPoint touchPointInsideHitAreaBottomLeft = CGPointMake(-15, 19.9);

  CGPoint touchPointOutsideHitAreaTopLeft = CGPointMake(-15.1, -20);
  CGPoint touchPointOutsideHitAreaTopRight = CGPointMake(20, -20);
  CGPoint touchPointOutsideHitAreaBottomRight = CGPointMake(15, 20);
  CGPoint touchPointOutsideHitAreaBottomLeft = CGPointMake(-15, 20);

  // When
  button.bounds = bounds;
  button.hitAreaInsets = insets;

  // Then
  XCTAssertTrue([button pointInside:touchPointInsideHitAreaTopLeft withEvent:nil]);
  XCTAssertTrue([button pointInside:touchPointInsideHitAreaTopRight withEvent:nil]);
  XCTAssertTrue([button pointInside:touchPointInsideHitAreaBottomRight withEvent:nil]);
  XCTAssertTrue([button pointInside:touchPointInsideHitAreaBottomLeft withEvent:nil]);

  XCTAssertFalse([button pointInside:touchPointOutsideHitAreaTopLeft withEvent:nil]);
  XCTAssertFalse([button pointInside:touchPointOutsideHitAreaTopRight withEvent:nil]);
  XCTAssertFalse([button pointInside:touchPointOutsideHitAreaBottomRight withEvent:nil]);
  XCTAssertFalse([button pointInside:touchPointOutsideHitAreaBottomLeft withEvent:nil]);
}

#pragma mark - UIButton strangeness

- (void)testTitleColorForState {
  for (NSUInteger controlState = 0; controlState < kNumUIControlStates; ++controlState) {
    if (controlState & kUIControlStateDisabledHighlighted) {
      // We skip the Disabled Highlighted state because UIButton titleColorForState ignores it.
      continue;
    }
    // Given
    MDCButton *button = [[MDCButton alloc] init];
    UIColor *color = [UIColor blueColor];

    // When
    [button setTitleColor:color forState:controlState];

    // Then
    XCTAssertEqualObjects([button titleColorForState:controlState],
                          color,
                          @"for control state:%@ ",
                          controlStateDescription(controlState));
  }
}
- (void)testTitleColorForStateDisabledHighlight {
  // This is strange that setting the color for a state does not return the value of that state.
  // It turns out that it returns the value set to the normal state.

  // Given
  UIControlState controlState = kUIControlStateDisabledHighlighted;
  MDCButton *button = [[MDCButton alloc] init];
  UIColor *color = [UIColor blueColor];
  UIColor *normalColor = [UIColor greenColor];
  [button setTitleColor:normalColor forState:UIControlStateNormal];

  // When
  [button setTitleColor:color forState:controlState];

  // Then
  XCTAssertEqualObjects([button titleColorForState:controlState],
                        normalColor,
                        @"for control state:%@ ",
                        controlStateDescription(controlState));
  XCTAssertNotEqualObjects([button titleColorForState:controlState],
                           color,
                           @"for control state:%@ ",
                           controlStateDescription(controlState));
}

#pragma mark - UIButton state changes

- (void)testEnabled {
  // Given
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.highlighted = arc4random_uniform(2);
  button.selected = arc4random_uniform(2);
  button.enabled = arc4random_uniform(2);

  // When
  button.enabled = YES;

  // Then
  XCTAssertTrue(button.enabled);
  XCTAssertFalse(button.state & UIControlStateDisabled);
}

- (void)testDisabled {
  // Given
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.highlighted = arc4random_uniform(2);
  button.selected = arc4random_uniform(2);
  button.enabled = arc4random_uniform(2);

  // When
  button.enabled = NO;

  // Then
  XCTAssertFalse(button.enabled);
  XCTAssertTrue(button.state & UIControlStateDisabled);
}

- (void)testHighlighted {
  // Given
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.highlighted = NO;
  button.selected = arc4random_uniform(2);

  // For some reason we can only set the highlighted state to YES if its enabled is also YES.
  button.enabled = YES;

  UIControlState oldState = button.state;
  XCTAssertFalse(button.highlighted);

  // When
  button.highlighted = YES;

  // Then
  XCTAssertTrue(button.highlighted);
  XCTAssertTrue(button.state & UIControlStateHighlighted);
  XCTAssertEqual(button.state, (oldState | UIControlStateHighlighted));
}

- (void)testUnhighlighted {
  // Given
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.highlighted = YES;
  button.selected = arc4random_uniform(2);
  button.enabled = arc4random_uniform(2);
  UIControlState oldState = button.state;
  XCTAssertTrue(button.highlighted);

  // When
  button.highlighted = NO;

  // Then
  XCTAssertFalse(button.highlighted);
  XCTAssertFalse(button.state & UIControlStateHighlighted);
  XCTAssertEqual(button.state, (oldState & ~UIControlStateHighlighted));
}

- (void)testSelected {
  // Given
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.highlighted = arc4random_uniform(2);
  button.selected = NO;
  button.enabled = arc4random_uniform(2);
  UIControlState oldState = button.state;

  // When
  button.selected = YES;

  // Then
  XCTAssertTrue(button.selected);
  XCTAssertTrue(button.state & UIControlStateSelected);
  XCTAssertEqual(button.state, (oldState | UIControlStateSelected));
}

- (void)testUnselected {
  // Given
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.highlighted = arc4random_uniform(2);
  button.selected = YES;
  button.enabled = arc4random_uniform(2);

  // When
  button.selected = NO;

  // Then
  XCTAssertFalse(button.selected);
  XCTAssertFalse(button.state & UIControlStateSelected);
}

- (void)testDefaultAdjustsFontProperty {
  // Given
  MDCButton *button = [[MDCButton alloc] init];

  // Then
  XCTAssertFalse(button.mdc_adjustsFontForContentSizeCategory);
}

- (void)testAdjustsFontProperty {
  // Given
  MDCButton *button = [[MDCButton alloc] init];
  UIFont *preferredFont = [UIFont mdc_preferredFontForMaterialTextStyle:MDCFontTextStyleButton];

  // When
  button.mdc_adjustsFontForContentSizeCategory = YES;

  // Then
  XCTAssertTrue(button.mdc_adjustsFontForContentSizeCategory);
  XCTAssertEqualWithAccuracy(button.titleLabel.font.pointSize,
                             preferredFont.pointSize,
                             kEpsilonAccuracy,
                             @"Font size should be equal to MDCFontTextStyleButton's.");
}

@end
