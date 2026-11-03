import 'dart:convert';
import 'dart:io';

import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:solofy_vendor_app/application/core/utils/alert_dialog.dart';

import 'package:url_launcher/url_launcher.dart';

// InputDecoration get defaultInputDecoration => InputDecoration(
//       errorStyle: font14W400.copyWith(color: ColorResources.RED),
//       hintStyle: body1.copyWith(color: ColorResources.GREY),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(width: 1, color: ColorResources.BORDER),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(width: 1, color: ColorResources.BORDER),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(width: 1, color: ColorResources.PRIMARY),
//       ),
//       disabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(
//           width: 1,
//           color: Color(0xffD9DBE9),
//         ),
//       ),
//     );

final RegExp emailRegex = RegExp(
  r"^[a-zA-Z0-9.!#$%&'+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)$",
);

final RegExp phoneRegex = RegExp(
  r'^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}$',
);
// check is a valid number
bool _isNumeric(String str) {
  if (str.isEmpty) {
    return false;
  }
  return double.tryParse(str) != null;
}

/// validate the given [value] is a valid phonenumber or email
String? validateEmailOrPhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an email or phone number.';
  } else if (_isNumeric(value) &&
      value.length == 10 &&
      !phoneRegex.hasMatch(value)) {
    return null;
  } else if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email/phone number';
  } else {
    return null;
  }
}

/// validate [value] lenth >= four and value.isEmpty)
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password.';
  } else if (value.length <= 3) {
    return 'minimum 4 character password';
  } else {
    return null;
  }
}

/// validate [value] contains any the [symbols]
bool passwordMatcher(String value) {
  String symbols = r'!@#$%^&*()_+{}|[]\:";<>,.?/~`';
  return value.split('').any((char) => symbols.contains(char));
}

class LaunchUrl {
  static void launchURL(String urllink) async {
    final Uri url = Uri.parse(urllink);
    if (!await launchUrl(url)) {
      CustomAlertDialog.showCustomDialog(
        title: 'Faild to launch',
        typeAlert: TypeAlert.error,
      );
    }
  }

  static void mailTo(String mail) async {
    try {
      launchUrl(Uri.parse('mailto:$mail'),
          // Uri.parse('tel:' + widget.model.mobile!),
          mode: LaunchMode.externalApplication);
    } catch (e) {
      // print(e);
    }
  }

  static void callFunction(String number) async {
    try {
      launchUrl(
        Uri.parse('tel:$number'),
        // Uri.parse('tel:' + widget.model.mobile!),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      // print(e);
    }
  }
}

String? convertImageToBase64(File? file) {
  if (file != null && file.path.isNotEmpty) {
    // Read the PDF file as bytes
    final bytes = file.readAsBytesSync();

    // Convert the bytes to base64
    String file64 = base64Encode(bytes);

    // Prepend the necessary data URL header with MIME type
    String dataUrl = 'data:image/jpeg;base64,$file64';

    return dataUrl;
  }
  return null;
}

// void showPlatformDatePicker({
//   required BuildContext context,
//   required void Function(DateTime?) onComplete,
//   DateTime? initialDate,
//   DateTime? maximumDate,
//   int? minimumYear,
// }) async {
//   final now = DateTime.now();
//   Logger.logSuccess('Showing Date Picker: $maximumDate, $minimumYear ');
//   if (Platform.isIOS) {
//     await showModalBottomSheet<DateTime>(
//       context: context,
//       builder: (BuildContext context) {
//         return SizedBox(
//           height: 300,
//           child: CupertinoDatePicker(
//             mode: CupertinoDatePickerMode.date,
//             initialDateTime: initialDate,
//             minimumYear: minimumYear ?? 1950,
//             maximumDate: maximumDate ?? DateTime.now(),
//             onDateTimeChanged: (DateTime newDate) {
//               onComplete(newDate);
//             },
//           ),
//         );
//       },
//     );
//   } else {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(minimumYear ?? 1950, now.month, now.day),
//       lastDate: maximumDate ?? DateTime.now(),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(primary: ColorResources.primary
//                 // Customize your color here
//                 ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     onComplete(date);
//   }
// }

// void showPlatformTimePicker({
//   required BuildContext context,
//   required void Function(TimeOfDay?) onComplete,
//   TimeOfDay? initialTime,
//   TimeOfDay? maximumDate,
//   int? minimumYear,
// }) async {
//   final res = await showTimePicker(
//     context: context,
//     initialTime: initialTime ?? TimeOfDay.now(),
//     builder: (context, child) {
//       return Theme(
//         data: ThemeData.light().copyWith(
//           dialogBackgroundColor: Colors.white, // Set the background color here
//           colorScheme: ColorScheme.fromSeed(
//             onPrimaryContainer: const Color(0xff4F378A),
//             seedColor: ColorResources.primary,
//             // Border color
//             onSurface: ColorResources.textColor, // Text color
//           ),
//         ),
//         child: child!,
//       );
//     },
//   );

//   if (res != null) {
//     onComplete.call(res);
//   }
// }

// BoxDecoration defaultContainerDecoration = BoxDecoration(
//   boxShadow: const [BoxShadow(blurRadius: 10, color: ColorResources.GREY3)],
//   color: Colors.white,
//   borderRadius: BorderRadius.circular(12),
// );


// void share() {
//   SocialShare.
// }