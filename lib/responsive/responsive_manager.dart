import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Configuration for responsive behavior
class ResponsiveConfig {
  /// Base design dimensions (usually from your design mockup)
  final double baseWidth;
  final double baseHeight;

  /// Device breakpoints
  final double mobileMax;
  final double tabletMin;
  final double tabletMax;
  final double desktopMin;

  /// Scaling strategy
  final ResponsiveScalingStrategy scalingStrategy;

  /// Whether to use shortest side for text scaling (better for tablets)
  final bool useShortestSideForText;

  /// Maximum scale factor to prevent extreme values
  final double maxScaleFactor;

  /// Minimum scale factor to prevent extreme values
  final double minScaleFactor;

  const ResponsiveConfig({
    this.baseWidth = 375.0,
    this.baseHeight = 812.0,
    this.mobileMax = 599.0,
    this.tabletMin = 600.0,
    this.tabletMax = 1199.0,
    this.desktopMin = 1200.0,
    this.scalingStrategy = ResponsiveScalingStrategy.width,
    this.useShortestSideForText = true,
    this.maxScaleFactor = 1.5,
    this.minScaleFactor = 0.8,
  });

  /// Tablet-first configuration
  factory ResponsiveConfig.tabletFirst() {
    return const ResponsiveConfig(
      baseWidth: 768.0,
      baseHeight: 1024.0,
      mobileMax: 599.0,
      tabletMin: 600.0,
      tabletMax: 1199.0,
      desktopMin: 1200.0,
    );
  }

  /// Desktop-first configuration
  factory ResponsiveConfig.desktopFirst() {
    return const ResponsiveConfig(
      baseWidth: 1440.0,
      baseHeight: 900.0,
      mobileMax: 599.0,
      tabletMin: 600.0,
      tabletMax: 1199.0,
      desktopMin: 1200.0,
    );
  }
}

/// Strategy for calculating responsive values
enum ResponsiveScalingStrategy {
  /// Scale based on width (default)
  width,

  /// Scale based on height
  height,

  /// Scale based on shortest side (better for tablets in landscape)
  shortestSide,

  /// Scale based on diagonal
  diagonal,
}

/// Immutable data class holding current responsive state
class ResponsiveData {
  final Size screenSize;
  final EdgeInsets safeArea;
  final EdgeInsets viewPadding;
  final EdgeInsets viewInsets;
  final double devicePixelRatio;
  final double textScaleFactor;
  final Orientation orientation;

  const ResponsiveData({
    required this.screenSize,
    required this.safeArea,
    required this.viewPadding,
    required this.viewInsets,
    required this.devicePixelRatio,
    required this.textScaleFactor,
    required this.orientation,
  });

  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  bool get isLandscape => orientation == Orientation.landscape;
  bool get isPortrait => orientation == Orientation.portrait;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponsiveData &&
          runtimeType == other.runtimeType &&
          screenSize == other.screenSize &&
          safeArea == other.safeArea &&
          viewPadding == other.viewPadding &&
          viewInsets == other.viewInsets &&
          devicePixelRatio == other.devicePixelRatio &&
          textScaleFactor == other.textScaleFactor &&
          orientation == other.orientation;

  @override
  int get hashCode =>
      screenSize.hashCode ^
      safeArea.hashCode ^
      viewPadding.hashCode ^
      viewInsets.hashCode ^
      devicePixelRatio.hashCode ^
      textScaleFactor.hashCode ^
      orientation.hashCode;
}

/// Global responsive manager that tracks screen dimensions without requiring BuildContext
class ResponsiveManager {
  static ResponsiveManager? _instance;
  static ResponsiveManager get instance => _instance ??= ResponsiveManager._();
  ResponsiveManager._();

  // Configuration
  ResponsiveConfig _config = const ResponsiveConfig();

  // Notifier for reactive updates
  final ValueNotifier<ResponsiveData?> _dataNotifier = ValueNotifier(null);

  /// Listen to responsive data changes
  ValueListenable<ResponsiveData?> get dataNotifier => _dataNotifier;

  /// Get current responsive data
  ResponsiveData? get currentData => _dataNotifier.value;

  /// Initialize with MediaQuery data - call this in your app initialization
  void initialize(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _updateData(mediaQuery);
  }

  /// Configure the responsive manager with custom settings
  void configure(ResponsiveConfig config) {
    _config = config;
  }

  /// Update screen dimensions when they change
  void updateScreenSize(
    Size newSize,
    EdgeInsets safeArea,
    double devicePixelRatio, {
    EdgeInsets? viewPadding,
    EdgeInsets? viewInsets,
    double? textScaleFactor,
    Orientation? orientation,
  }) {
    final data = ResponsiveData(
      screenSize: newSize,
      safeArea: safeArea,
      viewPadding: viewPadding ?? safeArea,
      viewInsets: viewInsets ?? EdgeInsets.zero,
      devicePixelRatio: devicePixelRatio,
      textScaleFactor: textScaleFactor ?? 1.0,
      orientation:
          orientation ??
          (newSize.width > newSize.height
              ? Orientation.landscape
              : Orientation.portrait),
    );
    _dataNotifier.value = data;
  }

  /// Internal method to update data from MediaQuery
  void _updateData(MediaQueryData mediaQuery) {
    final data = ResponsiveData(
      screenSize: mediaQuery.size,
      safeArea: mediaQuery.padding,
      viewPadding: mediaQuery.viewPadding,
      viewInsets: mediaQuery.viewInsets,
      devicePixelRatio: mediaQuery.devicePixelRatio,
      textScaleFactor: mediaQuery.textScaleFactor,
      orientation: mediaQuery.orientation,
    );
    _dataNotifier.value = data;
  }

  // Getters for screen info
  Size get screenSize => currentData?.screenSize ?? const Size(375, 812);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get safeArea => currentData?.safeArea ?? EdgeInsets.zero;
  EdgeInsets get viewPadding => currentData?.viewPadding ?? EdgeInsets.zero;
  EdgeInsets get viewInsets => currentData?.viewInsets ?? EdgeInsets.zero;
  double get devicePixelRatio => currentData?.devicePixelRatio ?? 1.0;
  double get textScaleFactor => currentData?.textScaleFactor ?? 1.0;
  Orientation get orientation =>
      currentData?.orientation ?? Orientation.portrait;

  // Device type checks
  bool get isMobile => screenWidth <= _config.mobileMax;
  bool get isTablet =>
      screenWidth >= _config.tabletMin && screenWidth <= _config.tabletMax;
  bool get isDesktop => screenWidth >= _config.desktopMin;
  bool get isLandscape => orientation == Orientation.landscape;
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isSmallScreen => screenHeight < 700;
  bool get isLargeScreen => screenHeight > 900;

  // Additional device checks
  bool get isMobileLandscape => isMobile && isLandscape;
  bool get isMobilePortrait => isMobile && isPortrait;
  bool get isTabletLandscape => isTablet && isLandscape;
  bool get isTabletPortrait => isTablet && isPortrait;
  bool get isDesktopLandscape => isDesktop && isLandscape;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// Get available screen height (minus keyboard)
  double get availableHeight => screenHeight - viewInsets.bottom;

  /// Get safe screen width (minus system UI)
  double get safeScreenWidth => screenWidth - safeArea.left - safeArea.right;

  /// Get safe screen height (minus system UI)
  double get safeScreenHeight => screenHeight - safeArea.top - safeArea.bottom;

  // Responsive calculations with clamping
  double responsiveWidth(double designWidth) {
    final scaleFactor = (screenWidth / _config.baseWidth).clamp(
      _config.minScaleFactor,
      _config.maxScaleFactor,
    );
    return designWidth * scaleFactor;
  }

  double responsiveHeight(double designHeight) {
    final scaleFactor = (screenHeight / _config.baseHeight).clamp(
      _config.minScaleFactor,
      _config.maxScaleFactor,
    );
    return designHeight * scaleFactor;
  }

  /// Responsive value based on scaling strategy
  double responsive(double value) {
    switch (_config.scalingStrategy) {
      case ResponsiveScalingStrategy.width:
        return responsiveWidth(value);
      case ResponsiveScalingStrategy.height:
        return responsiveHeight(value);
      case ResponsiveScalingStrategy.shortestSide:
        final shortestSide =
            screenWidth < screenHeight ? screenWidth : screenHeight;
        final baseShortestSide =
            _config.baseWidth < _config.baseHeight
                ? _config.baseWidth
                : _config.baseHeight;
        final scaleFactor = (shortestSide / baseShortestSide).clamp(
          _config.minScaleFactor,
          _config.maxScaleFactor,
        );
        return value * scaleFactor;
      case ResponsiveScalingStrategy.diagonal:
        final diagonal = math.sqrt(
          screenWidth * screenWidth + screenHeight * screenHeight,
        );
        final baseDiagonal = math.sqrt(
          _config.baseWidth * _config.baseWidth +
              _config.baseHeight * _config.baseHeight,
        );
        final scaleFactor = (diagonal / baseDiagonal).clamp(
          _config.minScaleFactor,
          _config.maxScaleFactor,
        );
        return value * scaleFactor;
    }
  }

  /// Text responsive value (uses shortest side if configured)
  double responsiveText(double fontSize) {
    if (_config.useShortestSideForText) {
      final shortestSide =
          screenWidth < screenHeight ? screenWidth : screenHeight;
      final baseShortestSide =
          _config.baseWidth < _config.baseHeight
              ? _config.baseWidth
              : _config.baseHeight;
      final scaleFactor = (shortestSide / baseShortestSide).clamp(
        _config.minScaleFactor,
        _config.maxScaleFactor,
      );
      return fontSize * scaleFactor;
    }
    return responsiveWidth(fontSize);
  }

  /// Smart responsive value that automatically decides when to use const vs dynamic
  /// Use this for values that should be responsive on mobile but can be const on larger screens
  double smartResponsive(double value, {bool forceResponsive = false}) {
    if (forceResponsive || isMobile) {
      return responsiveWidth(value);
    }
    return value; // Use const value for tablets and desktop
  }

  /// Get adaptive value based on screen size
  T adaptiveValue<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}

/// Mixin to easily access responsive manager in widgets
mixin ResponsiveMixin {
  ResponsiveManager get responsive => ResponsiveManager.instance;
}
