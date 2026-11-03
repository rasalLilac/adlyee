import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';

/// Full-screen clean page scaffold without fake presentation frames or grey backgrounds.
class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.child,
    this.bottomBar,
    this.resizeToAvoidBottomInset = true,
    this.statusBar = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
    this.horizontalPadding = 18.0,
    this.scrollable = true,
    this.contentPadding,
    this.backgroundColor = ColorResources.white,
  });

  final Widget child;
  final Widget? bottomBar;
  final bool resizeToAvoidBottomInset;
  final SystemUiOverlayStyle statusBar;
  final double horizontalPadding;
  final bool scrollable;
  final EdgeInsetsGeometry? contentPadding;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    Widget bodyContent = child;
    if (scrollable) {
      bodyContent = SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: contentPadding ??
            EdgeInsets.fromLTRB(
              horizontalPadding.s,
              0,
              horizontalPadding.s,
              24.s + (bottomBar == null ? bottomSafe : 8.s),
            ),
        child: child,
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBar,
      child: Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: SafeArea(
          bottom: bottomBar == null,
          child: Column(
            children: [
              Expanded(child: bodyContent),
              if (bottomBar != null)
                SafeArea(
                  top: false,
                  child: bottomBar!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

