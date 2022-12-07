/// Created Date: Sunday, Jan 9th 2022
/// Author: Brennan Ngo
///
/// Copyright (c) 2022 ThemePlace
library fluttering;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import './logs.dart';

/// ================== MANAGER CACHE ================

abstract class IManagerCache {
  Directory? get cacheDirectory;

  Directory? get appDirectory;

  Future<bool> initial();

  Future<void> clean();

  Future<File?> cacheImageBase64(String imageBase64);

  Future<File?> cacheImageNetwork(String src);

  Future<bool> addFile(File file);

  Future<void> removeFile(File file);

  Future<void> addFiles(List<File> files);

  Future<void> removeFiles(List<File> files);
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
      Debug.log('====== CREATE CACHE DIRECTORY =====');
      Directory cacheDir = (await getTemporaryDirectory());
      Debug.log('====== CACHE DIRECTORY $cacheDir =====');
      if (!await cacheDir.exists()) {
        cacheDir = await cacheDir.create(recursive: true);
        Debug.log('====== CACHE DIRECTORY $cacheDir =====');
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
        Debug.log('===== DELETE ALL CACHE =====');
      }
      Debug.log('===== TOTAL CACHE LENGTH ${_fileCaches.length} =====');
      for (var file in _fileCaches) {
        file.delete();
      }
      Debug.log('===== DELETE ALL FILE CACHE =====');
    } catch (error) {
      Debug.log(error);
    }
  }

  @override
  Future<File?> cacheImageBase64(String imageBase64) async {
    try {
      final Uint8List imageBytes = base64.decode(imageBase64);
      final File imageFile = File('${_cacheDirectory!.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
      imageFile.writeAsBytesSync(List.from(imageBytes));
      if (await imageFile.exists()) {
        _fileCaches.add(imageFile);
        return imageFile;
      }
    } catch (error) {
      Debug.log(error);
      return null;
    }
    return null;
  }

  @override
  Future<File?> cacheImageNetwork(String src) async {
    throw ErrorDescription('Dont support, you should use ImageCachedNetwork library');
  }

  @override
  Future<bool> addFile(File file) async {
    try {
      if (await file.exists()) {
        _fileCaches.add(file);
        return true;
      }
    } catch (e) {
      Debug.log(e);
    }
    return false;
  }

  @override
  Future<void> addFiles(List<File> files) async {
    for (var file in files) {
      addFile(file);
    }
  }

  @override
  Future<void> removeFile(File file) async {
    try {
      _fileCaches.remove(file);
      file.delete();
    } catch (e) {
      Debug.log(e);
    }
  }

  @override
  Future<void> removeFiles(List<File> files) async {
    try {
      for (var file in files) {
        _fileCaches.remove(file);
        file.delete();
      }
    } catch (e) {
      Debug.log(e);
    }
  }
}
