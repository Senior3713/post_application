import 'package:firebase_remote_config/firebase_remote_config.dart';

sealed class RCService {
  static final rc = FirebaseRemoteConfig.instance;

  static Future<void> init() async {
    await rc.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 1),
    ));


    await rc.setDefaults(const {
      "isDark": true,
      "season": "winter",
      "language": "{}",
    });
  }

  static bool get mode {
    return rc.getBool("isDark");
  }

  static String get getLanguage {
    return rc.getString("language");
  }

  static String get getSeason {
    return rc.getString("season");
  }

  static Future<void> activate() async {
    await rc.fetchAndActivate();
  }
}

enum Seasons {
  summer,
  spring,
  winter,
  autumn,
}