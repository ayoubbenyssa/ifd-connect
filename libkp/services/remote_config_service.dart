import 'package:firebase_remote_config/firebase_remote_config.dart';

const String _apiUrl = 'api_school';
const String _url_parce = 'url_parce';
const String _urlclasse = 'urlclasse';
const String appId_parce = 'appId_parce';
const String Parse_Id = 'Parse_Id';
const String Parse_Key = 'Parse_Key';
const String Content_type = 'Content_type';

class RemoteConfigService {
  final RemoteConfig _remoteConfig;
  RemoteConfigService({RemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;
  final defaults = <String, dynamic>{
    _apiUrl: "",
    _url_parce: "",
    _urlclasse: "",
  };
  static RemoteConfigService _instance;
  static Future<RemoteConfigService> getInstance() async {
    if (_instance == null) {
      _instance = RemoteConfigService(
        remoteConfig: await RemoteConfig.instance,
      );
    }
    return _instance;
  }

  String get getUrl => _remoteConfig.getString(_apiUrl);
  String get geturl_parce => _remoteConfig.getString(_url_parce);
  String get geturlclasse => _remoteConfig.getString(_urlclasse);
  String get getappId_parce => _remoteConfig.getString(appId_parce);
  String get getParse_Id => _remoteConfig.getString(Parse_Id);
  String get getParse_Key => _remoteConfig.getString(Parse_Key);
  String get getContent_type => _remoteConfig.getString(Content_type);


  Future initialize() async {
    try {
      await _remoteConfig.setDefaults(defaults);
      await _fetchAndActivate();
    } on FetchThrottledException catch (e) {
      print("Rmeote Config fetch throttled: $e");
    } catch (e) {
      print("Unable to fetch remote config. Default value will be used");
    }
  }

  Future _fetchAndActivate() async {
    await _remoteConfig.fetch(expiration: Duration(seconds: 0));
    await _remoteConfig.activateFetched();
    print("string getUrl::: $getUrl");
    print("string geturl_parce::: $geturl_parce");
    print("string geturlclasse::: $geturlclasse");
    print("string geturlclasse::: $getappId_parce");
    print("string getParse_Id::: $getParse_Id");
    print("string getParse_Key::: $getParse_Key");
    print("string getContent_type::: $getContent_type");


  }
}