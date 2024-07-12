import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/api_requests/api_manager.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

Future fetchSimilarStories(BuildContext context) async {
  UserStoriesRecord? currentUserStoryDocument;
  ApiCallResponse? matchedStoriesApiResponse;

  currentUserStoryDocument = await queryUserStoriesRecordOnce(
    queryBuilder: (userStoriesRecord) => userStoriesRecord.where(
      'userId',
      isEqualTo: currentUserReference,
    ),
    singleRecord: true,
  ).then((s) => s.firstOrNull);
  FFAppState().currentUserStory = currentUserStoryDocument!.story;
  FFAppState().update(() {});
  if (!(FFAppState().currentUserStory != null &&
      FFAppState().currentUserStory != '')) {
    return;
  }
  matchedStoriesApiResponse = await QueryStoriesCall.call(
    authToken: currentJwtToken,
    query: FFAppState().currentUserStory,
  );

  if ((matchedStoriesApiResponse?.succeeded ?? true)) {
    FFAppState().matchedStories = (getJsonField(
      (matchedStoriesApiResponse?.jsonBody ?? ''),
      r'''$.result.ids''',
      true,
    ) as List)
        .map<String>((s) => s.toString())
        .toList()!
        .toList()
        .cast<String>();
  } else {
    await showDialog(
      context: context,
      builder: (alertDialogContext) {
        return AlertDialog(
          title: Text('Error Occured'),
          content: Text('An error in api fetch occured'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(alertDialogContext),
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
