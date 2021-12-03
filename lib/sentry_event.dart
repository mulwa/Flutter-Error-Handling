import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
Future<SentryEvent> getSentryEvent(dynamic exception) async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();

  if (Platform.isIOS) {
    final IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
    return SentryEvent(
        release: packageInfo.version,
        environment: 'production',
        tags: {'buildNumber': packageInfo.buildNumber},
        extra: <String, dynamic>{
          'name': iosDeviceInfo.name,
          'model': iosDeviceInfo.model,
          'systemName': iosDeviceInfo.systemName,
          'systemVersion': iosDeviceInfo.systemVersion,
          'localizedModel': iosDeviceInfo.localizedModel,
          'utsname': iosDeviceInfo.utsname.sysname,
          'identifierForVendor': iosDeviceInfo.identifierForVendor,
          'isPhysicalDevice': iosDeviceInfo.isPhysicalDevice,
        },
        exceptions: exception);
  }
  if (Platform.isAndroid) {
    final AndroidDeviceInfo androidDeviceInfo =
        await deviceInfoPlugin.androidInfo;
    return SentryEvent(
      release: packageInfo.version,
      environment: 'production', // replace it as it's desired
      tags: {
        'buildNumber': packageInfo.buildNumber,
      },
      extra: <String, dynamic>{
        'type': androidDeviceInfo.type,
        'model': androidDeviceInfo.model,
        'device': androidDeviceInfo.device,
        'id': androidDeviceInfo.id,
        'androidId': androidDeviceInfo.androidId,
        'brand': androidDeviceInfo.brand,
        'display': androidDeviceInfo.display,
        'hardware': androidDeviceInfo.hardware,
        'manufacturer': androidDeviceInfo.manufacturer,
        'product': androidDeviceInfo.product,
        'version': androidDeviceInfo.version.release,
        'supported32BitAbis': androidDeviceInfo.supported32BitAbis,
        'supported64BitAbis': androidDeviceInfo.supported64BitAbis,
        'supportedAbis': androidDeviceInfo.supportedAbis,
        'isPhysicalDevice': androidDeviceInfo.isPhysicalDevice,
      },
      exceptions: exception,
    );
  }

  return SentryEvent(
    release: '${packageInfo.version}-${packageInfo.buildNumber}',
    environment: 'production',
    exceptions: exception,
  );
}
