import 'package:flutter/cupertino.dart';

class SlowScrollPhysics extends ScrollPhysics {
  final double scrollFactor;

  const SlowScrollPhysics({
    super.parent,
    this.scrollFactor = 0.2,
  });

  @override
  SlowScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SlowScrollPhysics(
        parent: buildParent(ancestor), scrollFactor: scrollFactor);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return super.applyPhysicsToUserOffset(position, offset * scrollFactor);
  }
}
