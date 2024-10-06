import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:async';

class FirebaseRemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  final StreamController<bool> _maskEmailStreamController =
      StreamController<bool>.broadcast();

  Stream<bool> get maskEmailStream => _maskEmailStreamController.stream;

  Future<void> initialize() async {
    try {
      _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(seconds: 10),
      ));

      await _remoteConfig.fetchAndActivate();

      bool initialMaskEmail = _remoteConfig.getBool("mask_email");

      _maskEmailStreamController.add(initialMaskEmail);

      _remoteConfig.onConfigUpdated.listen((event) async {
        await _remoteConfig.activate();
        bool updatedMaskEmail = _remoteConfig.getBool("mask_email");

        _maskEmailStreamController.add(updatedMaskEmail);
      }, onDone: () {
        print("Done");
      });
    } catch (e) {
      print("Error initializing Remote Config: $e");
      throw Exception("Failed to fetch remote config");
    }
  }

  void dispose() {
    _maskEmailStreamController.close();
  }
}
