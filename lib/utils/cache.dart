/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import './logs.dart';

/// ================== MANAGER CACHE ================

abstract class IManagerCache {
  Directory? get cacheDirectory;

  Directory? get appDirectory;

  Future<bool> initial();

  Future<void> clean();

  Future<File?> cacheImage(String imageBase64);

  void addFile(File? file);

  void addFiles(List<File?> files);
}

class ManagerCache extends IManagerCache {
  static final IManagerCache _instance = ManagerCache._internal();
  static IManagerCache get instance => _instance;

  factory ManagerCache() => _instance as ManagerCache;

  ManagerCache._internal();

  final List<File> _fileCaches = [];

  Directory? _cacheDirectory;
  @override
  Directory? get cacheDirectory => _cacheDirectory;

  Directory? _appDirectory;
  @override
  Directory? get appDirectory => _appDirectory;

  @override
  Future<bool> initial() async {
    try {
      _appDirectory = await getApplicationDocumentsDirectory();
      Debug.log('create cache directory');
      Directory cacheDir = (await getTemporaryDirectory());
      if (!await cacheDir.exists()) {
        cacheDir = await cacheDir.create(recursive: true);
      }
      _cacheDirectory = cacheDir;
      return true;
    } catch (error) {
      Debug.log(error);
      return false;
    }
  }

  @override
  Future<void> clean() async {
    try {
      if (_cacheDirectory != null && await _cacheDirectory!.exists()) {
        await _cacheDirectory!.delete(recursive: true);
        Debug.log('deleted cache dictory');
      }
      Debug.log('total cache files ${_fileCaches.length}');
      await _clearFileCache();
      Debug.log('deleted all cache files');
    } catch (error) {
      Debug.log(error);
    }
  }

  @override
  Future<File?> cacheImage(String imageBase64) async {
    try {
      final Uint8List imageBytes = base64.decode(imageBase64);
      final File imageFile = File('${_cacheDirectory!.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
      imageFile.writeAsBytesSync(List.from(imageBytes));
      if (await imageFile.exists()) {
        return imageFile;
      }
    } catch (error) {
      Debug.log(error);
      return null;
    }
    return null;
  }

  @override
  void addFile(File? file) async {
    if (file != null && await file.exists()) {
      _fileCaches.add(file);
    }
  }

  @override
  void addFiles(List<File?> files) {
    for (var file in files) {
      addFile(file);
    }
  }

  _clearFileCache() async {
    try {
      for (var file in _fileCaches) {
        await file.delete();
      }
    } catch (error) {
      Debug.log(error);
    }
  }
}
