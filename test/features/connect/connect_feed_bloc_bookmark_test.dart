// Unit tests for ConnectFeedBloc's bookmark toggle — covers optimistic
// update and revert-on-failure, mirroring the existing coverage style for
// toggleLike (no bloc_test/mocktail dependency; manual fake repository, same
// pattern as test/features/consultation/doctor_search_bloc_test.dart).
import 'package:flutter_test/flutter_test.dart';

import 'package:opto/core/error/failures.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/connect/domain/entities/post_media_entity.dart';
import 'package:opto/features/connect/domain/entities/post_reply_entity.dart';
import 'package:opto/features/connect/domain/repositories/connect_repository.dart';
import 'package:opto/features/connect/presentation/bloc/connect_feed_bloc.dart';

// =============================================================================
// FAKE
// =============================================================================

final _post = PostEntity(
  id: 'post-1',
  authorId: 'author-1',
  body: 'Hello community',
  createdAt: DateTime(2026, 1, 1),
);

class _FakeConnectRepository implements ConnectRepository {
  bool shouldThrowOnToggleBookmark = false;

  @override
  Future<List<PostEntity>> getFeed({
    int limit = 20,
    int offset = 0,
    String? topic,
  }) async =>
      [_post];

  @override
  Future<bool> toggleBookmark(String postId) async {
    if (shouldThrowOnToggleBookmark) {
      throw const ServerFailure('server error');
    }
    return true;
  }

  // ── Unused by these tests — not exercised, so a straightforward stub is
  // enough (mirrors doctor_search_bloc_test.dart's fake-repo style).
  @override
  Future<PostEntity> getPostById(String postId) =>
      throw UnimplementedError();

  @override
  Future<PostEntity> createPost({
    required String body,
    String? title,
    String? topic,
    String? voiceUrl,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> deletePost(String postId) => throw UnimplementedError();

  @override
  Future<PostMediaEntity> addMedia({
    required String postId,
    required String localPath,
    required String altText,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> removeMedia(String mediaId) => throw UnimplementedError();

  @override
  Future<List<PostReplyEntity>> getReplies(String postId) =>
      throw UnimplementedError();

  @override
  Future<PostReplyEntity> addReply({
    required String postId,
    required String body,
    String? parentReplyId,
    String? voiceUrl,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> deleteReply(String replyId) => throw UnimplementedError();

  @override
  Future<void> markBestAnswer({
    required String replyId,
    required String postId,
  }) =>
      throw UnimplementedError();

  @override
  Future<bool> toggleLike(String postId) => throw UnimplementedError();

  @override
  Stream<PostEntity> watchNewPosts() => const Stream.empty();

  @override
  Future<void> dispose() async {}
}

// =============================================================================
// TESTS
// =============================================================================

void main() {
  late _FakeConnectRepository repo;
  late ConnectFeedBloc bloc;

  setUp(() {
    repo = _FakeConnectRepository();
    bloc = ConnectFeedBloc(repo);
  });

  tearDown(() => bloc.close());

  group('ToggleBookmark', () {
    test('optimistically flips bookmarkedByMe, then stays flipped on success',
        () async {
      bloc.add(const ConnectFeedEvent.loadFeed());
      await bloc.stream.firstWhere((s) => s is FeedLoaded);

      bloc.add(const ConnectFeedEvent.toggleBookmark('post-1'));

      await expectLater(
        bloc.stream,
        emits(
          isA<FeedLoaded>().having(
            (s) => s.posts.single.bookmarkedByMe,
            'bookmarkedByMe',
            isTrue,
          ),
        ),
      );
    });

    test('reverts bookmarkedByMe when the repository throws', () async {
      repo.shouldThrowOnToggleBookmark = true;

      bloc.add(const ConnectFeedEvent.loadFeed());
      await bloc.stream.firstWhere((s) => s is FeedLoaded);

      bloc.add(const ConnectFeedEvent.toggleBookmark('post-1'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          // Optimistic flip to true...
          isA<FeedLoaded>().having(
            (s) => s.posts.single.bookmarkedByMe,
            'bookmarkedByMe',
            isTrue,
          ),
          // ...then reverted back to false after the repo call fails.
          isA<FeedLoaded>().having(
            (s) => s.posts.single.bookmarkedByMe,
            'bookmarkedByMe',
            isFalse,
          ),
        ]),
      );
    });
  });
}
