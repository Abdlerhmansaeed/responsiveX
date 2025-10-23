# Responsive X - Quick Reference

## 🚀 Setup

```dart
import 'package:resposive_xx/responsive_x.dart';

void main() {
  runApp(
    ResponsiveWrapper(
      config: ResponsiveConfig(
        baseWidth: 375.0,
        baseHeight: 812.0,
        scalingStrategy: ResponsiveScalingStrategy.width,
        maxScaleFactor: 1.5,
        minScaleFactor: 0.8,
      ),
      child: MaterialApp(...),
    ),
  );
}

// Or use presets
config: ResponsiveConfig.tabletFirst()
config: ResponsiveConfig.desktopFirst()
```

## 📱 Device Checks

```dart
R.isMobile              // Screen width <= 599
R.isTablet              // 600 <= width <= 1199
R.isDesktop             // Screen width >= 1200

R.isLandscape           // Landscape orientation
R.isPortrait            // Portrait orientation

R.isMobileLandscape     // Mobile in landscape
R.isMobilePortrait      // Mobile in portrait
R.isTabletLandscape     // Tablet in landscape
R.isTabletPortrait      // Tablet in portrait
R.isDesktopLandscape    // Desktop in landscape
```

## 📏 Screen Dimensions

```dart
R.screenWidth           // Full screen width
R.screenHeight          // Full screen height
R.screenSize            // Size object

R.safeScreenWidth       // Width minus safe area
R.safeScreenHeight      // Height minus safe area
R.availableHeight       // Height minus keyboard
```

## ⌨️ Keyboard & Safe Areas

```dart
R.isKeyboardVisible     // Is keyboard showing?
R.viewInsets.bottom     // Keyboard height
R.safeArea              // Status bar, notch, etc.
R.viewPadding           // Permanent system UI
```

## 🎨 Spacing (Const)

```dart
R.space4, R.space8, R.space12, R.space16
R.space20, R.space24, R.space32, R.space40
R.space48, R.space60, R.space80, R.space100

// SizedBox helpers
R.spaceH16              // SizedBox(height: 16)
R.spaceW16              // SizedBox(width: 16)
```

## 📐 Responsive Spacing

```dart
R.spaceXS               // 4.r
R.spaceSM               // 8.r
R.spaceMD               // 16.r
R.spaceLG               // 24.r
R.spaceXL               // 32.r
R.space2XL              // 48.r
R.space3XL              // 60.r
```

## 🔤 Typography (Const)

```dart
R.fontXS, R.fontSM, R.fontBase, R.fontMD
R.fontLG, R.fontXL, R.font2XL, R.font3XL
R.font4XL, R.font5XL
```

## 📝 Responsive Typography

```dart
R.textXS, R.textSM, R.textBase, R.textMD
R.textLG, R.textXL, R.text2XL, R.text3XL
R.text4XL, R.text5XL
```

## 🎯 Border Radius (Const)

```dart
R.radiusXS, R.radiusSM, R.radiusBase
R.radiusLG, R.radiusXL, R.radius2XL
R.radiusFull            // 999 (circular)
```

## 🔘 Component Sizes

```dart
// Buttons
R.buttonHeightSM        // 40
R.buttonHeight          // 50
R.buttonHeightLG        // 60
R.adaptiveButtonHeight  // Varies by device

// Icons
R.iconSM, R.iconBase, R.iconLG
R.iconXL, R.icon2XL
R.adaptiveIconSize      // Varies by device
```

## 📦 EdgeInsets (Const)

```dart
R.paddingXS             // EdgeInsets.all(4)
R.paddingSM             // EdgeInsets.all(8)
R.paddingMD             // EdgeInsets.all(16)
R.paddingLG             // EdgeInsets.all(24)
R.paddingXL             // EdgeInsets.all(32)

// Responsive
R.responsivePadding     // Adaptive padding
R.horizontalPadding     // Horizontal only
R.verticalPadding       // Vertical only
```

## 🔢 Number Extensions

```dart
200.w                   // Responsive width
100.h                   // Responsive height
14.sp                   // Responsive font size
12.r                    // Responsive radius/size
```

## 🎨 Widget Extensions

```dart
// Padding
MyWidget().paddingAll(16)
MyWidget().paddingSymmetric(horizontal: 20, vertical: 12)
MyWidget().paddingOnly(left: 10, top: 5, right: 10, bottom: 5)

// Margin
MyWidget().marginAll(16)
MyWidget().marginSymmetric(horizontal: 20, vertical: 12)
MyWidget().marginOnly(left: 10, top: 5, right: 10, bottom: 5)

// Border Radius
MyWidget().borderRadius(12)
MyWidget().circle
```

## 🌐 Context Extensions

```dart
context.isMobile
context.isTablet
context.isDesktop
context.isLandscape
context.isPortrait
context.isKeyboardVisible

context.screenWidth
context.screenHeight
context.textScale
context.availableHeight

context.adaptiveValue(
  mobile: 2,
  tablet: 3,
  desktop: 4,
)
```

## 🏗️ ResponsiveBuilder

```dart
ResponsiveBuilder(
  builder: (context, data) {
    // Only rebuilds when ResponsiveData changes
    return Container(
      width: data.screenWidth * 0.8,
      child: Text('Width: ${data.screenWidth}'),
    );
  },
)
```

## 🎛️ Configuration Options

```dart
ResponsiveConfig(
  baseWidth: 375.0,                           // Design base width
  baseHeight: 812.0,                          // Design base height
  mobileMax: 599.0,                           // Mobile max width
  tabletMin: 600.0,                           // Tablet min width
  tabletMax: 1199.0,                          // Tablet max width
  desktopMin: 1200.0,                         // Desktop min width
  scalingStrategy: ResponsiveScalingStrategy.width,
  useShortestSideForText: true,               // Better text on tablets
  maxScaleFactor: 1.5,                        // Max scale limit
  minScaleFactor: 0.8,                        // Min scale limit
)
```

## 🎯 Scaling Strategies

```dart
ResponsiveScalingStrategy.width             // Scale by width (default)
ResponsiveScalingStrategy.height            // Scale by height
ResponsiveScalingStrategy.shortestSide      // Better for tablets
ResponsiveScalingStrategy.diagonal          // Both dimensions
```

## 📊 Adaptive Values

```dart
R.adaptive(
  mobile: 2,
  tablet: 3,
  desktop: 4,
)

// Grid columns
R.gridColumns                               // Auto: 2/3/4

R.getCrossAxisCount(
  mobile: 2,
  tablet: 3,
  desktop: 4,
)
```

## 🎨 Common Patterns

### Card with Responsive Layout
```dart
Card(
  margin: R.paddingMD,
  child: Column(
    children: [
      Text('Title', style: TextStyle(fontSize: R.textXL)),
      R.spaceH12,
      Text('Content', style: TextStyle(fontSize: R.textBase)),
    ],
  ).paddingAll(16),
)
```

### Responsive Button
```dart
SizedBox(
  width: double.infinity,
  height: R.adaptiveButtonHeight,
  child: ElevatedButton(
    onPressed: () {},
    child: Text('Button', style: TextStyle(fontSize: 16.sp)),
  ),
)
```

### Keyboard-Aware Form
```dart
SingleChildScrollView(
  child: Container(
    height: R.availableHeight,
    padding: R.paddingLG,
    child: Column(
      children: [
        TextField(),
        R.spaceH16,
        TextField(),
        const Spacer(),
        if (!R.isKeyboardVisible)
          ElevatedButton(...),
      ],
    ),
  ),
)
```

### Adaptive Grid
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: R.gridColumns,
    crossAxisSpacing: R.space12,
    mainAxisSpacing: R.space12,
  ),
  itemBuilder: (context, index) => YourWidget(),
)
```

### Tablet Two-Column Layout
```dart
Widget build(BuildContext context) {
  if (R.isTabletLandscape || R.isDesktop) {
    return Row(
      children: [
        Expanded(child: LeftPane()),
        Expanded(child: RightPane()),
      ],
    );
  }
  return SingleColumnLayout();
}
```

## 🔥 Pro Tips

1. **Use const spacing in lists** for better performance:
   ```dart
   ListView.separated(
     separatorBuilder: (_, __) => R.spaceH8, // Const
   )
   ```

2. **Use ResponsiveBuilder in complex widgets**:
   ```dart
   ResponsiveBuilder(
     builder: (context, data) => ComplexWidget(data),
   )
   ```

3. **Handle keyboard properly**:
   ```dart
   AnimatedContainer(
     duration: Duration(milliseconds: 200),
     height: R.availableHeight,
     child: YourForm(),
   )
   ```

4. **Support accessibility**:
   ```dart
   Text(
     'Hello',
     style: TextStyle(fontSize: 16.sp * R.textScale),
   )
   ```

5. **Prevent extreme scaling**:
   ```dart
   config: ResponsiveConfig(
     maxScaleFactor: 1.4,
     minScaleFactor: 0.9,
   )
   ```

## 📱 Testing

```dart
// Test different devices
if (R.isMobile) print('Mobile: ${R.screenWidth}');
if (R.isTablet) print('Tablet: ${R.screenWidth}');
if (R.isDesktop) print('Desktop: ${R.screenWidth}');

// Test orientation
if (R.isTabletLandscape) print('Tablet landscape mode');

// Test keyboard
if (R.isKeyboardVisible) print('Keyboard height: ${R.viewInsets.bottom}');

// Test scaling
print('Text scale: ${R.textScale}');
print('DPR: ${R.devicePixelRatio}');
```

## 🎯 When to Use What

| Use Case | Use This |
|----------|----------|
| Consistent spacing | `R.space16`, `R.paddingMD` |
| Responsive sizes | `200.w`, `100.h`, `14.sp` |
| Quick padding | `.paddingAll(16)` |
| Device checks | `R.isMobile`, `context.isTablet` |
| Adaptive values | `R.adaptive(...)` |
| Efficient updates | `ResponsiveBuilder` |
| Layout based on device+orientation | `R.isTabletLandscape` |
| Keyboard handling | `R.isKeyboardVisible`, `R.availableHeight` |
