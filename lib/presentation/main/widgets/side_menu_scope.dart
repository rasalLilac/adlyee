import 'package:flutter/material.dart';

/// InheritedWidget providing open/close/toggle functions and state for the side menu.
class SideMenuScope extends InheritedWidget {
  const SideMenuScope({
    super.key,
    required this.isOpen,
    required this.open,
    required this.close,
    required this.toggle,
    required super.child,
  });

  final bool isOpen;
  final VoidCallback open;
  final VoidCallback close;
  final VoidCallback toggle;

  static SideMenuScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SideMenuScope>();
    assert(scope != null, 'No SideMenuScope found in context');
    return scope!;
  }

  static SideMenuScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SideMenuScope>();
  }

  @override
  bool updateShouldNotify(SideMenuScope oldWidget) => isOpen != oldWidget.isOpen;
}

