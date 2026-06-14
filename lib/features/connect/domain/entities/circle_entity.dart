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

  /// Number of members in this circle.
  /// Hydrated by the data source via `circle_members(count)` aggregate join.
  final int memberCount;
  final bool isMember;

  /// Whether the user has enabled notifications for this circle.
  /// TODO: back with a circle_member_settings table (currently always false).
  final bool isNotifying;

  /// Whether this circle has posts unread by the current user since last visit.
  /// TODO: back with a last_seen_at column in circle_members (currently always false).
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
