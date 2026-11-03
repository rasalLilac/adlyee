import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/presentation/main/widgets/side_menu_content.dart';
import 'package:solofy_vendor_app/presentation/main/widgets/side_menu_scope.dart';

/// Wraps the entire MainShell body in an animated 3D stacked card side-menu host.
class SideMenuHost extends StatefulWidget {
  const SideMenuHost({
    super.key,
    required this.child,
    required this.currentStatusBar,
  });

  final Widget child;
  final SystemUiOverlayStyle currentStatusBar;

  @override
  State<SideMenuHost> createState() => _SideMenuHostState();
}

class _SideMenuHostState extends State<SideMenuHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  static const _duration = Duration(milliseconds: 350);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void open() {
    if (!_controller.isCompleted) _controller.forward();
  }

  void close() {
    if (!_controller.isDismissed) _controller.reverse();
  }

  void toggle() {
    if (_controller.value > 0.5) {
      close();
    } else {
      open();
    }
  }

  bool get isOpen => _controller.value > 0.5;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return SideMenuScope(
      isOpen: isOpen,
      open: open,
      close: close,
      toggle: toggle,
      child: PopScope(
        canPop: _controller.value == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && _controller.value > 0) {
            close();
          }
        },
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, staticChild) {
            final value = _animation.value;
            final isMenuOpen = value > 0.5;

            // When menu is open, status bar is transparent with light icons (on blue background)
            final activeStatusBar = isMenuOpen
                ? const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.light,
                    statusBarBrightness: Brightness.dark,
                  )
                : widget.currentStatusBar;

            // Geometry calculations matching reference implementation
            final mainSlide = screenWidth * 0.80 * value;
            final mainScale = 1.0 - (0.20 * value);

            final layer1Slide = screenWidth * 0.74 * value;
            final layer1Scale = 1.0 - (0.25 * value);

            final layer2Slide = screenWidth * 0.68 * value;
            final layer2Scale = 1.0 - (0.30 * value);

            final cornerRadius = 40.s * value;

            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: activeStatusBar,
              child: Material(
                color: ColorResources.primary,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 1. Menu Content (static behind)
                    const SideMenuContent(),

                    // 2. Translucent Layer 2 (~0.3 opacity)
                    if (value > 0.01)
                      Transform.translate(
                        offset: Offset(layer2Slide, 0),
                        child: Transform.scale(
                          scale: layer2Scale,
                          alignment: Alignment.centerLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40.s),
                            child: ColoredBox(
                              color: Colors.white.withValues(alpha: 0.30),
                            ),
                          ),
                        ),
                      ),

                    // 3. Translucent Layer 1 (~0.5 opacity)
                    if (value > 0.01)
                      Transform.translate(
                        offset: Offset(layer1Slide, 0),
                        child: Transform.scale(
                          scale: layer1Scale,
                          alignment: Alignment.centerLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40.s),
                            child: ColoredBox(
                              color: Colors.white.withValues(alpha: 0.50),
                            ),
                          ),
                        ),
                      ),

                    // 4. Main App Content (scaled & translated card)
                    Transform.translate(
                      offset: Offset(mainSlide, 0),
                      child: Transform.scale(
                        scale: mainScale,
                        alignment: Alignment.centerLeft,
                        child: RepaintBoundary(
                          child: GestureDetector(
                            onTap: value > 0.05 ? close : null,
                            onHorizontalDragUpdate: value > 0.05
                                ? (details) {
                                    if (details.primaryDelta != null &&
                                        details.primaryDelta! < -8) {
                                      close();
                                    }
                                  }
                                : null,
                            behavior: HitTestBehavior.translucent,
                            child: AbsorbPointer(
                              absorbing: value > 0.05,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(cornerRadius),
                                  boxShadow: value > 0.02
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.18 * value,
                                            ),
                                            blurRadius: 24.s,
                                            offset: Offset(-8.s, 4.s),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(cornerRadius),
                                  child: staticChild,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}

