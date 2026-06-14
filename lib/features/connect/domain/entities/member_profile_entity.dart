/// Public profile of a community member.
class MemberProfileEntity {
  const MemberProfileEntity({
    required this.id,
    required this.name,
    this.handle,
    this.avatarUrl,
    this.isVerified = false,
    this.isMentor = false,
    this.bio,
    this.joinedYear,
    this.postsCount = 0,
    this.helpfulCount = 0,
    this.circlesCount = 0,
    this.isFollowedByMe = false,
  });

  final String id;
  final String name;
  final String? handle;
  final String? avatarUrl;
  final bool isVerified;
  final bool isMentor;
  final String? bio;
  final int? joinedYear;
  final int postsCount;
  final int helpfulCount;
  final int circlesCount;
  final bool isFollowedByMe;

  MemberProfileEntity copyWith({
    String? id,
    String? name,
    String? handle,
    String? avatarUrl,
    bool? isVerified,
    bool? isMentor,
    String? bio,
    int? joinedYear,
    int? postsCount,
    int? helpfulCount,
    int? circlesCount,
    bool? isFollowedByMe,
  }) {
    return MemberProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      isMentor: isMentor ?? this.isMentor,
      bio: bio ?? this.bio,
      joinedYear: joinedYear ?? this.joinedYear,
      postsCount: postsCount ?? this.postsCount,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      circlesCount: circlesCount ?? this.circlesCount,
      isFollowedByMe: isFollowedByMe ?? this.isFollowedByMe,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberProfileEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
