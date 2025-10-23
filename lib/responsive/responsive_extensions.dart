import 'package:flutter/material.dart';
import 'responsive_manager.dart';

/// Widget that automatically initializes and updates ResponsiveManager
/// Wrap your MaterialApp with this widget
class ResponsiveWrapper extends StatefulWidget {
  final Widget child;
  final ResponsiveConfig? config;

  const ResponsiveWrapper({super.key, required this.child, this.config});

  @override
  State<ResponsiveWrapper> createState() => _ResponsiveWrapperState();
}

class _ResponsiveWrapperState extends State<ResponsiveWrapper>
    with WidgetsBindingObserver {
  final ResponsiveManager _manager = ResponsiveManager.instance;

  @override
  void initState() {
    super.initState();

    // Configure if config is provided
    if (widget.config != null) {
      _manager.configure(widget.config!);
    }

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _manager.initialize(context);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Update responsive manager when screen metrics change
    if (mounted) {
      final mediaQuery = MediaQuery.of(context);
      _manager.updateScreenSize(
        mediaQuery.size,
        mediaQuery.padding,
        mediaQuery.devicePixelRatio,
        viewPadding: mediaQuery.viewPadding,
        viewInsets: mediaQuery.viewInsets,
        textScaleFactor: mediaQuery.textScaleFactor,
        orientation: mediaQuery.orientation,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Update manager with current constraints
        final mediaQuery = MediaQuery.of(context);
        _manager.updateScreenSize(
          mediaQuery.size,
          mediaQuery.padding,
          mediaQuery.devicePixelRatio,
          viewPadding: mediaQuery.viewPadding,
          viewInsets: mediaQuery.viewInsets,
          textScaleFactor: mediaQuery.textScaleFactor,
          orientation: mediaQuery.orientation,
        );
        return widget.child;
      },
    );
  }
}

/// Builder widget that rebuilds only when responsive data changes
/// More efficient than using ResponsiveWrapper for local responsive widgets
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveData data) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final manager = ResponsiveManager.instance;
    return ValueListenableBuilder<ResponsiveData?>(
      valueListenable: manager.dataNotifier,
      builder: (context, data, child) {
        final mediaQuery = MediaQuery.of(context);
        if (data == null) {
          // Fallback if manager not initialized
          return builder(
            context,
            ResponsiveData(
              screenSize: mediaQuery.size,
              safeArea: mediaQuery.padding,
              viewPadding: mediaQuery.viewPadding,
              viewInsets: mediaQuery.viewInsets,
              devicePixelRatio: mediaQuery.devicePixelRatio,
              textScaleFactor: mediaQuery.textScaleFactor,
              orientation: mediaQuery.orientation,
            ),
          );
        }
        return builder(context, data);
      },
    );
  }
}

/// Extension on num for responsive calculations
extension ResponsiveNum on num {
  /// Responsive width
  double get w => ResponsiveManager.instance.responsiveWidth(toDouble());

  /// Responsive height
  double get h => ResponsiveManager.instance.responsiveHeight(toDouble());

  /// Responsive value (uses configured scaling strategy)
  double get r => ResponsiveManager.instance.responsive(toDouble());

  /// Responsive text/font size (optimized for readability)
  double get sp => ResponsiveManager.instance.responsiveText(toDouble());
}

/// Extension on Widget for responsive padding and margins
extension ResponsiveWidget on Widget {
  /// Add responsive padding to all sides
  Widget paddingAll(double value) {
    return Padding(padding: EdgeInsets.all(value.r), child: this);
  }

  /// Add responsive symmetric padding
  Widget paddingSymmetric({double? horizontal, double? vertical}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal?.r ?? 0,
        vertical: vertical?.r ?? 0,
      ),
      child: this,
    );
  }

  /// Add responsive padding to specific sides
  Widget paddingOnly({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left?.r ?? 0,
        top: top?.r ?? 0,
        right: right?.r ?? 0,
        bottom: bottom?.r ?? 0,
      ),
      child: this,
    );
  }

  /// Add responsive margin to all sides
  Widget marginAll(double value) {
    return Container(margin: EdgeInsets.all(value.r), child: this);
  }

  /// Add responsive symmetric margin
  Widget marginSymmetric({double? horizontal, double? vertical}) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontal?.r ?? 0,
        vertical: vertical?.r ?? 0,
      ),
      child: this,
    );
  }

  /// Add responsive margin to specific sides
  Widget marginOnly({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: left?.r ?? 0,
        top: top?.r ?? 0,
        right: right?.r ?? 0,
        bottom: bottom?.r ?? 0,
      ),
      child: this,
    );
  }

  /// Add border radius to widget (wraps in ClipRRect)
  Widget borderRadius(double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius.r),
      child: this,
    );
  }

  /// Add circular border radius to widget
  Widget get circle {
    return ClipRRect(borderRadius: BorderRadius.circular(1000), child: this);
  }
}

/// Extension on BuildContext for easy access to responsive information
extension ResponsiveContext on BuildContext {
  /// Get responsive manager instance
  ResponsiveManager get responsive => ResponsiveManager.instance;

  /// Check if device is mobile
  bool get isMobile => responsive.isMobile;

  /// Check if device is tablet
  bool get isTablet => responsive.isTablet;

  /// Check if device is desktop
  bool get isDesktop => responsive.isDesktop;

  /// Check if device is in landscape mode
  bool get isLandscape => responsive.isLandscape;

  /// Check if device is in portrait mode
  bool get isPortrait => responsive.isPortrait;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => responsive.isKeyboardVisible;

  /// Get screen width
  double get screenWidth => responsive.screenWidth;

  /// Get screen height
  double get screenHeight => responsive.screenHeight;

  /// Get safe area insets
  EdgeInsets get safeAreaInsets => responsive.safeArea;

  /// Get view insets (keyboard, etc.)
  EdgeInsets get viewInsetsInsets => responsive.viewInsets;

  /// Get available height (minus keyboard)
  double get availableHeight => responsive.availableHeight;

  /// Get text scale factor
  double get textScale => responsive.textScaleFactor;

  /// Get adaptive value based on device type
  T adaptiveValue<T>({required T mobile, T? tablet, T? desktop}) {
    return responsive.adaptiveValue(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}
