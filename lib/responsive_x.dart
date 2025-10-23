/// Responsive X - A comprehensive responsive design system for Flutter
///
/// Provides a unified responsive design system that works without requiring
/// BuildContext to be passed every time. Combines performance benefits of
/// const values with flexibility of dynamic responsive values.
///
/// Key Features:
/// - Configuration layer for custom breakpoints and scaling strategies
/// - ValueNotifier-based reactive updates for efficient rebuilds
/// - Comprehensive metrics tracking (keyboard, text scale, safe areas)
/// - Number extensions (.w, .h, .sp, .r) for clean responsive code
/// - Widget extensions for padding, margin, and border radius
/// - Context extensions for easy access to device info
/// - ResponsiveBuilder for efficient widget rebuilds
///
/// Usage:
/// ```dart
/// // 1. Wrap MaterialApp with ResponsiveWrapper
/// ResponsiveWrapper(
///   config: ResponsiveConfig.tabletFirst(), // Optional
///   child: MaterialApp(...),
/// )
///
/// // 2. Use R class for design values
/// Container(
///   padding: R.paddingMD,
///   child: Text('Hello', style: TextStyle(fontSize: R.textLG)),
/// )
///
/// // 3. Use responsive extensions
/// Container(
///   width: 200.w,
///   height: 100.h,
///   child: Text('World', style: TextStyle(fontSize: 14.sp)),
/// )
///
/// // 4. Use widget extensions
/// MyWidget()
///   .paddingAll(16)
///   .marginSymmetric(horizontal: 12)
///   .borderRadius(8)
///
/// // 5. Use ResponsiveBuilder for efficient updates
/// ResponsiveBuilder(
///   builder: (context, data) {
///     return Text('Width: ${data.screenWidth}');
///   },
/// )
/// ```
library responsive_x;

export 'responsive/responsive_manager.dart';
export 'responsive/responsive_design.dart';
export 'responsive/responsive_extensions.dart';
