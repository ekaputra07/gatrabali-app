import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<RemoteConfig> setupRemoteConfig() async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
  remoteConfig.setDefaults(<String, dynamic>{
    'cloudinary_fetch_url': '',
  });
  return remoteConfig;
}
