import 'package:flutter/material.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';

enum OwnerMark {
  definitelySuitable,
  tentativelySuitable,
  notSuitable;

  String get label {
    switch (this) {
      case OwnerMark.definitelySuitable:
        return 'Definitely Suitable';
      case OwnerMark.tentativelySuitable:
        return 'Tentatively Suitable';
      case OwnerMark.notSuitable:
        return 'Not Suitable';
    }
  }

  Color get color {
    switch (this) {
      case OwnerMark.definitelySuitable:
        return ColorResources.green;
      case OwnerMark.tentativelySuitable:
        return ColorResources.orange;
      case OwnerMark.notSuitable:
        return ColorResources.red;
    }
  }
}

