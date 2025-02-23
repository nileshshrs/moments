// test/features/interactions/presentation/view/follower_bottom_sheet_test.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moments/features/interactions/data/dto/follow_dto.dart' as follow_dto;
import 'package:moments/features/interactions/presentation/view/follow/follower_view.dart';
import 'package:moments/features/profile/view/user_screen.dart';
import 'package:mocktail/mocktail.dart';

/// Custom HttpOverrides so that any NetworkImage request returns a dummy response.
class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _TestHttpClient();
  }
}

class _TestHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return _TestHttpClientRequest(url);
  }
  // Forward any other unimplemented members.
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestHttpClientRequest implements HttpClientRequest {
  final Uri url;
  _TestHttpClientRequest(this.url);
  @override
  Future<HttpClientResponse> close() async {
    return _TestHttpClientResponse();
  }
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => 200;
  
  @override
  StreamSubscription<List<int>> listen(void Function(List<int>)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    // Return a subscription for an empty stream.
    return Stream<List<int>>.empty().listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
  
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Dummy implementation of mockNetworkImagesFor.
/// (In real tests you might use a package, but this dummy simply runs the callback.)
Future<T> mockNetworkImagesFor<T>(Future<T> Function() callback) async {
  return callback();
}

/// A mock NavigatorObserver to track navigation events.
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  // Override HTTP so that NetworkImage calls don’t attempt real network requests.
  HttpOverrides.global = TestHttpOverrides();

  TestWidgetsFlutterBinding.ensureInitialized();

  // Create a dummy FollowDTO using the follow_dto alias.
  final dummyFollowDTO = follow_dto.FollowDTO(
    followId: 'f1',
    follower: follow_dto.UserDTO(
      id: 'user1',
      username: 'Alice',
      image: ['https://example.com/alice.jpg'],
      email: 'alice@example.com',
    ),
    following: follow_dto.UserDTO(
      id: 'user2',
      username: 'Bob',
      image: ['https://example.com/bob.jpg'],
      email: 'bob@example.com',
    ),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    match: false,
  );

  group('FollowerBottomSheet Widget Test', () {
    testWidgets('shows "No followers available" when list is empty', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FollowerBottomSheet(followers: []),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('No followers available'), findsOneWidget);
      });
    });

  
  });
}
