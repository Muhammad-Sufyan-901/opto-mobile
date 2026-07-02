// Native share-sheet action for a community post.
//
// Client-only — does NOT round-trip through the BLoC or repository, unlike
// like/bookmark. There is nothing to persist server-side.
import 'package:share_plus/share_plus.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';

/// Opens the OS share sheet for a community [post].
///
/// ponytail: links to the generic community tab (`opto://community`); a
/// per-post deep link (`opto://community/post/<id>`) needs DeepLinkHandler
/// path parsing + a matching GoRouter route — add when requested.
Future<void> sharePost(PostEntity post) {
  final author = post.authorName ?? 'a community member';
  final heading = post.title ?? post.body;
  final text = '$heading\n\n— shared by $author on Opto\nopto://community';
  return SharePlus.instance.share(ShareParams(text: text));
}
