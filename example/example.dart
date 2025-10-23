import 'package:flutter/material.dart';
import 'package:resposive_xx/responsive/responsive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ AFTER: Wrap with ResponsiveWrapper with optional config
    return ResponsiveWrapper(
      // Optional: Provide custom configuration
      config: const ResponsiveConfig(
        baseWidth: 375.0,
        baseHeight: 812.0,
        scalingStrategy: ResponsiveScalingStrategy.width,
        useShortestSideForText: true,
        maxScaleFactor: 1.5,
        minScaleFactor: 0.8,
      ),
      // Or use predefined configs:
      // config: ResponsiveConfig.tabletFirst(),
      // config: ResponsiveConfig.desktopFirst(),
      child: MaterialApp(
        title: 'Responsive X Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive X Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: R.paddingMD,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========================================
            // BEFORE & AFTER: Number Extensions
            // ========================================
            _SectionTitle('1. Number Extensions (.w, .h, .sp, .r)'),
            _ExampleCard(
              title: 'BEFORE',
              color: Colors.red.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Had to pass context or use R class',
                    style: TextStyle(fontSize: R.textBase),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: R.w(200),
                    height: R.h(100),
                    color: Colors.grey,
                    child: Center(
                      child: Text(
                        'Fixed size',
                        style: TextStyle(fontSize: R.sp(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            R.spaceH12,
            _ExampleCard(
              title: 'AFTER ✨',
              color: Colors.green.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Clean number extensions!',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 200.w,
                    height: 100.h,
                    color: Colors.blue.shade200,
                    child: Center(
                      child: Text(
                        'Responsive!',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            R.spaceH24,

            // ========================================
            // BEFORE & AFTER: Widget Extensions
            // ========================================
            _SectionTitle('2. Widget Extensions (padding, margin)'),
            _ExampleCard(
              title: 'BEFORE',
              color: Colors.red.shade50,
              child: Padding(
                padding: EdgeInsets.all(R.space16),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: R.space12),
                  padding: EdgeInsets.all(R.space8),
                  color: Colors.grey.shade300,
                  child: const Text('Nested Padding/Container'),
                ),
              ),
            ),
            R.spaceH12,
            _ExampleCard(
              title: 'AFTER ✨',
              color: Colors.green.shade50,
              child: Container(
                color: Colors.blue.shade300,
                child: const Text(
                  'Clean chaining!',
                ).paddingAll(8).marginSymmetric(horizontal: 12),
              ).paddingAll(16),
            ),

            R.spaceH24,

            // ========================================
            // ENHANCEMENT 2: Configuration Layer
            // ========================================
            _SectionTitle('3. Enhancement #2: Configuration Layer'),
            _ExampleCard(
              title: 'BEFORE',
              color: Colors.red.shade50,
              child: const Text(
                '❌ Fixed breakpoints and base dimensions\n'
                '❌ No control over scaling strategy\n'
                '❌ One-size-fits-all approach',
              ),
            ),
            R.spaceH12,
            _ExampleCard(
              title: 'AFTER ✨',
              color: Colors.green.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '✅ Custom breakpoints & base dimensions\n'
                    '✅ Choose scaling strategy (width/height/shortestSide/diagonal)\n'
                    '✅ Min/max scale factors to prevent extremes\n'
                    '✅ Predefined configs: tabletFirst(), desktopFirst()',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  R.spaceH12,
                  const Text('Current config:'),
                  Text(
                    'Base: ${R.screenWidth.toStringAsFixed(0)} x ${R.screenHeight.toStringAsFixed(0)}',
                  ),
                  Text(
                    'Device: ${R.isMobile
                        ? "Mobile"
                        : R.isTablet
                        ? "Tablet"
                        : "Desktop"}',
                  ),
                ],
              ),
            ),

            R.spaceH24,

            // ========================================
            // ENHANCEMENT 3: ResponsiveBuilder
            // ========================================
            _SectionTitle('4. Enhancement #3: Reactive Updates'),
            _ExampleCard(
              title: 'BEFORE',
              color: Colors.red.shade50,
              child: const Text(
                '❌ MediaQuery.of(context) rebuilds entire tree\n'
                '❌ No way to listen to specific changes\n'
                '❌ Inefficient updates',
              ),
            ),
            R.spaceH12,
            _ExampleCard(
              title: 'AFTER ✨',
              color: Colors.green.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '✅ ResponsiveBuilder rebuilds only when metrics change\n'
                    '✅ ValueNotifier for efficient updates\n'
                    '✅ ResponsiveData with all metrics',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  R.spaceH12,
                  ResponsiveBuilder(
                    builder: (context, data) {
                      return Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Screen: ${data.screenWidth.toStringAsFixed(0)} x ${data.screenHeight.toStringAsFixed(0)}',
                            ),
                            Text('Orientation: ${data.orientation.name}'),
                            Text(
                              'Text Scale: ${data.textScaleFactor.toStringAsFixed(2)}',
                            ),
                            Text(
                              'DPR: ${data.devicePixelRatio.toStringAsFixed(2)}',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            R.spaceH24,

            // ========================================
            // ENHANCEMENT 4: Additional Metrics
            // ========================================
            _SectionTitle('5. Enhancement #4: Additional Metrics'),
            _ExampleCard(
              title: 'BEFORE',
              color: Colors.red.shade50,
              child: const Text(
                '❌ Only basic screen size tracking\n'
                '❌ No keyboard detection\n'
                '❌ No safe area helpers\n'
                '❌ No text scale factor',
              ),
            ),
            R.spaceH12,
            _ExampleCard(
              title: 'AFTER ✨',
              color: Colors.green.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '✅ Comprehensive metrics tracking',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  R.spaceH12,
                  _MetricRow(
                    'Text Scale Factor',
                    R.textScale.toStringAsFixed(2),
                  ),
                  _MetricRow(
                    'Device Pixel Ratio',
                    R.devicePixelRatio.toStringAsFixed(2),
                  ),
                  _MetricRow(
                    'Keyboard Visible',
                    R.isKeyboardVisible ? 'Yes' : 'No',
                  ),
                  _MetricRow(
                    'Available Height',
                    '${R.availableHeight.toStringAsFixed(0)}px',
                  ),
                  _MetricRow(
                    'Safe Width',
                    '${R.safeScreenWidth.toStringAsFixed(0)}px',
                  ),
                  _MetricRow(
                    'Safe Height',
                    '${R.safeScreenHeight.toStringAsFixed(0)}px',
                  ),
                  R.spaceH8,
                  const Text(
                    'View Insets:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Bottom: ${R.viewInsets.bottom.toStringAsFixed(0)}px (keyboard)',
                  ),
                  R.spaceH8,
                  const Text(
                    'Safe Area:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Top: ${R.safeArea.top.toStringAsFixed(0)}px'),
                  Text('Bottom: ${R.safeArea.bottom.toStringAsFixed(0)}px'),
                ],
              ),
            ),

            R.spaceH24,

            // ========================================
            // Context Extensions
            // ========================================
            _SectionTitle('6. Context Extensions'),
            _ExampleCard(
              title: 'AFTER ✨',
              color: Colors.green.shade50,
              child: Builder(
                builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '✅ Access responsive info directly from context',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      R.spaceH12,
                      Text('context.isMobile: ${context.isMobile}'),
                      Text('context.isTablet: ${context.isTablet}'),
                      Text('context.isDesktop: ${context.isDesktop}'),
                      Text(
                        'context.isKeyboardVisible: ${context.isKeyboardVisible}',
                      ),
                      Text(
                        'context.screenWidth: ${context.screenWidth.toStringAsFixed(0)}',
                      ),
                      R.spaceH12,
                      Text(
                        'Adaptive value: ${context.adaptiveValue(mobile: "2 columns", tablet: "3 columns", desktop: "4 columns")}',
                      ),
                    ],
                  );
                },
              ),
            ),

            R.spaceH24,

            // ========================================
            // Orientation-Specific Checks
            // ========================================
            _SectionTitle('7. Orientation-Specific Checks'),
            _ExampleCard(
              title: 'NEW FEATURE ✨',
              color: Colors.purple.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '✅ Combined device + orientation checks',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  R.spaceH12,
                  _MetricRow('Mobile Portrait', R.isMobilePortrait.toString()),
                  _MetricRow(
                    'Mobile Landscape',
                    R.isMobileLandscape.toString(),
                  ),
                  _MetricRow('Tablet Portrait', R.isTabletPortrait.toString()),
                  _MetricRow(
                    'Tablet Landscape',
                    R.isTabletLandscape.toString(),
                  ),
                  _MetricRow(
                    'Desktop Landscape',
                    R.isDesktopLandscape.toString(),
                  ),
                ],
              ),
            ),

            R.spaceH40,
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade900,
        ),
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Color? color;

  const _ExampleCard({required this.title, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          child,
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Colors.blue.shade700)),
        ],
      ),
    );
  }
}
