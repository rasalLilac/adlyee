import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:solofy_vendor_app/application/core/utils/alert_dialog.dart';
import 'package:solofy_vendor_app/application/core/utils/enums.dart';

class PickImages {
  static Future<void> callPicker({
    required void Function(String) onCompleted,
    CropStyle? cropStyle,
    CropAspectRatioPreset? initAspectRatio,
  }) async {
    final picker = ImagePicker();

    final res = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (res != null) {
      final creoppedPath = await cropImage(
        res.path,
        cropStyle: cropStyle,
        initAspectRatio: initAspectRatio,
      );
      if (creoppedPath != null) {
        onCompleted.call(creoppedPath.path);
      } else {
        CustomAlertDialog.showCustomDialog(
          title: 'Faild to crop image',
          typeAlert: TypeAlert.error,
        );
      }
    } else {
      CustomAlertDialog.showCustomDialog(
        title: 'Faild to pick image',
        typeAlert: TypeAlert.error,
      );
    }
  }

  static Future<void> pickImageFromCamera({
    required void Function(String) onCompleted,
    CropStyle? cropStyle,
    CropAspectRatioPreset? initAspectRatio,
    AppThemeMode appThemeMode = AppThemeMode.light,
  }) async {
    final picker = ImagePicker();

    final res = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (res != null) {
      final creoppedPath = await cropImage(
        res.path,
        cropStyle: cropStyle,
        initAspectRatio: initAspectRatio,
      );
      if (creoppedPath != null) {
        onCompleted.call(creoppedPath.path);
      } else {
        CustomAlertDialog.showCustomDialog(
          title: 'Faild to crop image',
          typeAlert: TypeAlert.error,
        );
      }
    } else {
      CustomAlertDialog.showCustomDialog(
        title: 'Faild to capture image',
        typeAlert: TypeAlert.error,
      );
    }
  }

  static Future<CroppedFile?> cropImage(
    String path, {
    CropStyle? cropStyle,
    CropAspectRatioPreset? initAspectRatio,
  }) async {
    return ImageCropper().cropImage(
      sourcePath: path,
      uiSettings: [
        AndroidUiSettings(
          lockAspectRatio: false,
          toolbarTitle: 'Cropper',
          // toolbarColor: ColorResources.primary,
          // toolbarWidgetColor:
          //     AppDetails.globalNavigatorKey.currentContext!.secondary,
          hideBottomControls: true,
          initAspectRatio: initAspectRatio ?? CropAspectRatioPreset.square,
          cropStyle: cropStyle ?? CropStyle.circle,
          aspectRatioPresets: [
            initAspectRatio ?? CropAspectRatioPreset.square,
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          cropStyle: cropStyle ?? CropStyle.circle,
          aspectRatioPresets: [
            initAspectRatio ?? CropAspectRatioPreset.square,
          ],
        ),
      ],
    );
  }
}
