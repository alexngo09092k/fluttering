import 'package:version_comparator/version_comparator.dart';

abstract class IInAppUpdateVersion {}

class InAppUpdateVersion extends IInAppUpdateVersion {
  static final IInAppUpdateVersion _instance = InAppUpdateVersion._internal();
  static IInAppUpdateVersion get instance => _instance;

  InAppUpdateVersion._internal();

  Future<UpdateVersion?> checkUpdateVersion({
    RemoteDataService? dataService,
    String? androidId,
    String? iosId,
    String? huaweiId,
    String? customLocalVersion,
  }) async {
    final response = await VersionComparator.instance.versionCompare(
      dataService: dataService,
      androidId: androidId,
      iosId: iosId,
      huaweiId: huaweiId,
      customLocalVersion: customLocalVersion,
    );
    if (response.isSuccess && response.data != null) {
      final data = response.data!;
      return UpdateVersion(
        localVersion: data.localVersion,
        storeVersion: data.storeVersion,
        updateLink: data.updateLink,
      );
    }
    return null;
  }
}

class UpdateVersion extends VersionResponseModel {
  UpdateVersion({
    required super.localVersion,
    required super.storeVersion,
    required super.updateLink,
  });
}
