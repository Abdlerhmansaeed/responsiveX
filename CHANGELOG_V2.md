# Changelog - Responsive X v2.0.0

## 🎉 Major Updates - Version 2.0.0

### ✨ Enhancement #2: Configuration Layer

**Added comprehensive configuration system for maximum flexibility**

#### New Classes
- `ResponsiveConfig` - Configure all responsive behavior
- `ResponsiveScalingStrategy` enum - Choose how responsive values are calculated
  - `width` - Scale based on screen width (default)
  - `height` - Scale based on screen height
  - `shortestSide` - Better for tablets in landscape
  - `diagonal` - Considers both width and height

#### Features
- ✅ Custom base dimensions (match your design mockups)
- ✅ Custom breakpoints (define your own mobile/tablet/desktop ranges)
- ✅ Multiple scaling strategies
- ✅ Min/max scale factors (prevent extreme scaling on large screens)
- ✅ Text-specific scaling (better readability on tablets)
- ✅ Predefined configs: `ResponsiveConfig.tabletFirst()`, `ResponsiveConfig.desktopFirst()`

#### Usage
```dart
ResponsiveWrapper(
  config: ResponsiveConfig(
    baseWidth: 768.0,
    baseHeight: 1024.0,
    scalingStrategy: ResponsiveScalingStrategy.shortestSide,
    maxScaleFactor: 1.5,
    minScaleFactor: 0.8,
    useShortestSideForText: true,
  ),
  child: MaterialApp(...),
)
```

### ✨ Enhancement #3: Reactive Updates

**Added efficient rebuild system using ValueNotifier**

#### New Classes
- `ResponsiveData` - Immutable data class holding all responsive metrics
- `ResponsiveBuilder` - Widget that rebuilds only when ResponsiveData changes

#### Features
- ✅ ValueListenable-based updates (efficient rebuilds)
- ✅ Immutable state with proper equality checking
- ✅ Only affected widgets rebuild on changes
- ✅ Better performance for large widget trees
- ✅ Testable and debuggable

#### API
```dart
// Access notifier
ResponsiveManager.instance.dataNotifier // ValueListenable<ResponsiveData?>

// Use ResponsiveBuilder
ResponsiveBuilder(
  builder: (context, data) {
    return Text('Width: ${data.screenWidth}');
  },
)

// Listen to changes
ResponsiveManager.instance.dataNotifier.addListener(() {
  // Handle responsive data changes
});
```

### ✨ Enhancement #4: Additional Metrics

**Added comprehensive metrics tracking**

#### New Metrics in ResponsiveData
- `viewPadding` - System UI that's always present (status bar, navigation bar)
- `viewInsets` - Temporary UI overlays (keyboard, bottom sheets)
- `textScaleFactor` - User's text size preference (accessibility)
- `orientation` - Current device orientation (Orientation enum)

#### New Properties in ResponsiveManager & R class
- `R.viewPadding` - Permanent system UI insets
- `R.viewInsets` - Keyboard and overlay insets
- `R.textScale` - User's text scale factor
- `R.orientation` - Current orientation
- `R.isKeyboardVisible` - Is keyboard currently showing?
- `R.availableHeight` - Screen height minus keyboard
- `R.safeScreenWidth` - Screen width minus safe areas
- `R.safeScreenHeight` - Screen height minus safe areas

#### New Device + Orientation Checks
- `R.isMobileLandscape` - Mobile in landscape mode
- `R.isMobilePortrait` - Mobile in portrait mode
- `R.isTabletLandscape` - Tablet in landscape mode
- `R.isTabletPortrait` - Tablet in portrait mode
- `R.isDesktopLandscape` - Desktop in landscape mode

#### Usage
```dart
// Keyboard-aware layout
if (R.isKeyboardVisible) {
  // Adjust UI
}

// Available space
Container(height: R.availableHeight)

// Safe areas
Container(
  width: R.safeScreenWidth,
  height: R.safeScreenHeight,
)

// Accessibility
Text(
  'Hello',
  style: TextStyle(fontSize: 16.sp * R.textScale),
)

// Orientation-specific layouts
if (R.isTabletLandscape) {
  return TwoColumnLayout();
}
```

### 🎨 Bonus: Extensions API

**Added clean extension methods for better DX**

#### Number Extensions
```dart
200.w   // Responsive width
100.h   // Responsive height
14.sp   // Responsive font size
12.r    // Responsive radius/size
```

#### Widget Extensions
```dart
MyWidget()
  .paddingAll(16)
  .paddingSymmetric(horizontal: 20, vertical: 12)
  .paddingOnly(left: 10, top: 5)
  .marginAll(16)
  .marginSymmetric(horizontal: 20, vertical: 12)
  .marginOnly(left: 10, top: 5)
  .borderRadius(12)
  .circle
```

#### Context Extensions
```dart
context.isMobile
context.isTablet
context.isDesktop
context.isLandscape
context.isKeyboardVisible
context.screenWidth
context.screenHeight
context.textScale
context.availableHeight
context.adaptiveValue(mobile: 2, tablet: 3, desktop: 4)
```

---

## 📊 Performance Improvements

### Before
- ❌ Entire widget tree rebuilds on MediaQuery changes
- ❌ Recalculate responsive values on every access
- ❌ Multiple MediaQuery lookups per frame
- ❌ No scale clamping (extreme values on large screens)

### After
- ✅ Only ResponsiveBuilder widgets rebuild
- ✅ Values calculated once and cached in ResponsiveData
- ✅ Single ResponsiveData object shared across app
- ✅ Scale values clamped to min/max (prevents extremes)
- ✅ Smart scaling strategies (better tablet support)

---

## 🎯 API Additions

### ResponsiveManager
```dart
// New methods
void configure(ResponsiveConfig config)
double responsive(double value) // Uses configured strategy
double responsiveText(double fontSize) // Text-optimized scaling

// New getters
EdgeInsets get viewPadding
EdgeInsets get viewInsets
double get textScaleFactor
Orientation get orientation
bool get isKeyboardVisible
double get availableHeight
double get safeScreenWidth
double get safeScreenHeight
bool get isMobileLandscape
bool get isMobilePortrait
bool get isTabletLandscape
bool get isTabletPortrait
bool get isDesktopLandscape
ValueListenable<ResponsiveData?> get dataNotifier
ResponsiveData? get currentData
```

### R Class
```dart
// All ResponsiveManager getters exposed
R.viewPadding
R.viewInsets
R.textScale
R.orientation
R.isKeyboardVisible
R.availableHeight
R.safeScreenWidth
R.safeScreenHeight
R.isMobileLandscape
R.isMobilePortrait
R.isTabletLandscape
R.isTabletPortrait
R.isDesktopLandscape
```

### ResponsiveWrapper
```dart
ResponsiveWrapper({
  required Widget child,
  ResponsiveConfig? config, // NEW: Optional configuration
})
```

---

## 🔄 Breaking Changes

### None! 
All existing code continues to work. New features are opt-in.

The only change is that `ResponsiveWrapper` now accepts an optional `config` parameter, but it defaults to the original behavior if not provided.

---

## 📦 Migration Guide

### From v1.x to v2.0

#### No Changes Required
Your existing code works as-is:
```dart
ResponsiveWrapper(
  child: MaterialApp(...),
)
```

#### Optional: Add Configuration
```dart
ResponsiveWrapper(
  config: ResponsiveConfig.tabletFirst(),
  child: MaterialApp(...),
)
```

#### Optional: Use New Extensions
```dart
// Instead of
Container(width: R.w(200))

// You can now use
Container(width: 200.w)

// Instead of
Padding(
  padding: EdgeInsets.all(16),
  child: MyWidget(),
)

// You can now use
MyWidget().paddingAll(16)
```

#### Optional: Use ResponsiveBuilder
```dart
// For efficient rebuilds in complex widgets
ResponsiveBuilder(
  builder: (context, data) {
    return YourWidget(data);
  },
)
```

---

## 📝 Documentation

New documentation files:
- `ENHANCEMENTS.md` - Detailed before/after comparison
- `QUICK_REFERENCE.md` - API quick reference guide
- `example/example.dart` - Comprehensive usage examples

Updated files:
- `lib/responsive/README.md` - Updated with new features
- `lib/responsive_x.dart` - Better library documentation

---

## 🐛 Bug Fixes

- Fixed potential race condition in ResponsiveWrapper initialization
- Improved orientation detection logic
- Better handling of screen metric updates

---

## 🎨 Code Quality

- Added comprehensive documentation
- Improved type safety
- Better error handling
- More robust state management
- Cleaner API surface

---

## 🧪 Testing

- All features tested on mobile, tablet, and desktop
- Keyboard behavior verified
- Orientation changes tested
- Text scaling verified
- Safe area handling tested

---

## 🚀 What's Next

Future enhancements could include:
- Debug overlay widget
- Animation support
- Theme integration helpers
- Form validation with keyboard handling
- Split-screen support
- Foldable device support

---

## 📊 Stats

- **3 Major Enhancements** implemented
- **7 Bonus Features** added (extensions)
- **20+ New API Methods** added
- **0 Breaking Changes**
- **100% Backward Compatible**

---

## 🙏 Feedback

This is a major update! Please test thoroughly and report any issues.

For questions, suggestions, or bug reports, please open an issue on GitHub.

---

**Version**: 2.0.0  
**Release Date**: October 23, 2025  
**Status**: Stable ✅
