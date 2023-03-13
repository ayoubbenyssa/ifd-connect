import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static Future<String> fetchConfig() async {
    // final remoteConfig = FirebaseRemoteConfig.instance;
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: const Duration(hours: 5));


    // await remoteConfig.setConfigSettings(
    //   RemoteConfigSettings(
    //
    //     fetchTimeout: const Duration(minutes: 2),
    //     minimumFetchInterval: const Duration(seconds: 1),
    //   ),
    // );
    await remoteConfig.activateFetched();
    // await remoteConfig.fetchAndActivate();
    print("&&&&&&&&&&&&&&&&&&");
    print(remoteConfig.getString('api_school').toString());
    print("&&&&&&&&&&&&&&&&&&");
    await remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: false));
    return remoteConfig.getString('api_school').toString();
  }
}