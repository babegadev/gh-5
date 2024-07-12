import 'package:flutter/material.dart';
import 'flutter_flow/request_manager.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import 'backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String _currentUserStory = '';
  String get currentUserStory => _currentUserStory;
  set currentUserStory(String value) {
    _currentUserStory = value;
  }

  List<String> _matchedStories = [];
  List<String> get matchedStories => _matchedStories;
  set matchedStories(List<String> value) {
    _matchedStories = value;
  }

  void addToMatchedStories(String value) {
    matchedStories.add(value);
  }

  void removeFromMatchedStories(String value) {
    matchedStories.remove(value);
  }

  void removeAtIndexFromMatchedStories(int index) {
    matchedStories.removeAt(index);
  }

  void updateMatchedStoriesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    matchedStories[index] = updateFn(_matchedStories[index]);
  }

  void insertAtIndexInMatchedStories(int index, String value) {
    matchedStories.insert(index, value);
  }

  String _currentSelectedRequestUser = '';
  String get currentSelectedRequestUser => _currentSelectedRequestUser;
  set currentSelectedRequestUser(String value) {
    _currentSelectedRequestUser = value;
  }

  DocumentReference? _currentSelectedUserRequest;
  DocumentReference? get currentSelectedUserRequest =>
      _currentSelectedUserRequest;
  set currentSelectedUserRequest(DocumentReference? value) {
    _currentSelectedUserRequest = value;
  }

  DocumentReference? _currentlySelectedRequestedUser;
  DocumentReference? get currentlySelectedRequestedUser =>
      _currentlySelectedRequestedUser;
  set currentlySelectedRequestedUser(DocumentReference? value) {
    _currentlySelectedRequestedUser = value;
  }

  final _userDocQueryManager = FutureRequestManager<UsersRecord>();
  Future<UsersRecord> userDocQuery({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<UsersRecord> Function() requestFn,
  }) =>
      _userDocQueryManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearUserDocQueryCache() => _userDocQueryManager.clear();
  void clearUserDocQueryCacheKey(String? uniqueKey) =>
      _userDocQueryManager.clearRequest(uniqueKey);
}
