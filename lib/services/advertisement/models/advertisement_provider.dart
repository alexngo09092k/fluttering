import 'package:flutter/foundation.dart';

enum AdvertisementProvider { google, huawei }

extension AdvertisementProviderExtension on AdvertisementProvider {
  String get content => describeEnum(this);
}
