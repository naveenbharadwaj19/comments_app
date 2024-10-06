import 'package:comments_app/models/comment_model.dart';
import 'package:comments_app/services/firebase/firebase_remote_config_service.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CommentProvider with ChangeNotifier {
  final FirebaseRemoteConfigService _remoteConfigService =
      FirebaseRemoteConfigService();
  List<Comment> _comments = [];
  bool _isLoading = false;

  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;

  Stream<bool> get maskEmailStream => _remoteConfigService.maskEmailStream;

  Future<void> fetchComments() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _remoteConfigService.initialize();
      _comments = await ApiService().fetchComments();
    } catch (error) {
      print(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
