import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UtilClass {
  Future<File> cropImage(File file, BuildContext context) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
              ]
            : [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'ویرایش عکس پروفایل',
            toolbarColor: Theme.of(context).primaryColor,
            cropFrameColor: Theme.of(context).primaryColor,
            statusBarColor: Theme.of(context).primaryColor,
            activeControlsWidgetColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'ویرایش عکس پروفایل',
        ));
    if (croppedFile != null) {
      return Future.value(croppedFile);
    }
  }

  static getTextLabel(label) {
    if (label == "featured_property") return "ویژه";
    else if (label == "gold_property") return "طلایی";
    else if (label == "normal_property") return "عادی";
    else return "";
  }

  Future<File> _getImage(BuildContext context, ImageSource source) async {
    return ImagePicker.pickImage(source: source);
  }
}
