// ignore_for_file: must_be_immutable (hand-rolled copyWith pattern matching project style)

/// A peer-support circle (topic group) in the Connect community.
///
/// [slug] matches the [PostEntity.topic] value so circle threads can be
/// filtered by `ConnectRepository.getFeed(topic: slug)` with no schema join.
class CircleEntity {
  const CircleEntity({
    required this.id,
    required this.slug,
    required this.name,
    this.description,
    this.about,
    this.iconKey,
    this.colorKey,
    this.pinnedNote,
    this.memberCount = 0,
    this.isMember = false,
    this.isNotifying = false,
    this.unread = false,
  });

  final String id;
  final String slug;
  final String name;
  final String? description;
  final String? about;
  final String? iconKey;
  final String? colorKey;
  final String? pinnedNote;
  final int memberCount;
  final bool isMember;
  final bool isNotifying;
  final bool unread;

  CircleEntity copyWith({
    String? id,
    String? slug,
    String? name,
    String? description,
    String? about,
    String? iconKey,
    String? colorKey,
    String? pinnedNote,
    int? memberCount,
    bool? isMember,
    bool? isNotifying,
    bool? unread,
  }) {
    return CircleEntity(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      description: description ?? this.description,
      about: about ?? this.about,
      iconKey: iconKey ?? this.iconKey,
      colorKey: colorKey ?? this.colorKey,
      pinnedNote: pinnedNote ?? this.pinnedNote,
      memberCount: memberCount ?? this.memberCount,
      isMember: isMember ?? this.isMember,
      isNotifying: isNotifying ?? this.isNotifying,
      unread: unread ?? this.unread,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CircleEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
