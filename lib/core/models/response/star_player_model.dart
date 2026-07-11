import 'package:equatable/equatable.dart';

class StarPlayerResponse extends Equatable {
  final bool success;
  final int count;
  final List<StarPlayerModel> highlights;

  const StarPlayerResponse({
    required this.success,
    required this.count,
    required this.highlights,
  });

  factory StarPlayerResponse.fromJson(Map<String, dynamic> json) {
    return StarPlayerResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      highlights: (json['highlights'] as List<dynamic>? ?? [])
          .map((e) => StarPlayerModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'highlights': highlights.map((e) => e.toJson()).toList(),
    };
  }

  StarPlayerResponse copyWith({
    bool? success,
    int? count,
    List<StarPlayerModel>? highlights,
  }) {
    return StarPlayerResponse(
      success: success ?? this.success,
      count: count ?? this.count,
      highlights: highlights ?? this.highlights,
    );
  }

  @override
  List<Object?> get props => [
        success,
        count,
        highlights,
      ];
}

class StarPlayerModel extends Equatable {
  final String id;
  final SportModel? sport;
  final PlayerModel? player;
  final String playerName;
  final String team;
  final String title;
  final String thumbnail;
  final String videoUrl;
  final String type;
  final String duration;
  final bool isFeatured;
  final bool isPremium;
  final String liveLogo;
  final bool showLiveLogo;
  final List<dynamic> sources;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StarPlayerModel({
    required this.id,
    this.sport,
    this.player,
    required this.playerName,
    required this.team,
    required this.title,
    required this.thumbnail,
    required this.videoUrl,
    required this.type,
    required this.duration,
    required this.isFeatured,
    required this.isPremium,
    required this.liveLogo,
    required this.showLiveLogo,
    required this.sources,
    this.createdAt,
    this.updatedAt,
  });

  factory StarPlayerModel.fromJson(Map<String, dynamic> json) {
    return StarPlayerModel(
      id: json['_id'] ?? '',
      sport: json['sportId'] != null
          ? SportModel.fromJson(json['sportId'])
          : null,
      player: json['playerId'] != null
          ? PlayerModel.fromJson(json['playerId'])
          : null,
      playerName: json['playerName'] ?? '',
      team: json['team'] ?? '',
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      type: json['type'] ?? '',
      duration: json['duration'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
      isPremium: json['isPremium'] ?? false,
      liveLogo: json['liveLogo'] ?? '',
      showLiveLogo: json['showLiveLogo'] ?? false,
      sources: json['sources'] ?? [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sportId': sport?.toJson(),
      'playerId': player?.toJson(),
      'playerName': playerName,
      'team': team,
      'title': title,
      'thumbnail': thumbnail,
      'videoUrl': videoUrl,
      'type': type,
      'duration': duration,
      'isFeatured': isFeatured,
      'isPremium': isPremium,
      'liveLogo': liveLogo,
      'showLiveLogo': showLiveLogo,
      'sources': sources,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  StarPlayerModel copyWith({
    String? id,
    SportModel? sport,
    PlayerModel? player,
    String? playerName,
    String? team,
    String? title,
    String? thumbnail,
    String? videoUrl,
    String? type,
    String? duration,
    bool? isFeatured,
    bool? isPremium,
    String? liveLogo,
    bool? showLiveLogo,
    List<dynamic>? sources,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StarPlayerModel(
      id: id ?? this.id,
      sport: sport ?? this.sport,
      player: player ?? this.player,
      playerName: playerName ?? this.playerName,
      team: team ?? this.team,
      title: title ?? this.title,
      thumbnail: thumbnail ?? this.thumbnail,
      videoUrl: videoUrl ?? this.videoUrl,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      isFeatured: isFeatured ?? this.isFeatured,
      isPremium: isPremium ?? this.isPremium,
      liveLogo: liveLogo ?? this.liveLogo,
      showLiveLogo: showLiveLogo ?? this.showLiveLogo,
      sources: sources ?? this.sources,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        sport,
        player,
        playerName,
        team,
        title,
        thumbnail,
        videoUrl,
        type,
        duration,
        isFeatured,
        isPremium,
        liveLogo,
        showLiveLogo,
        sources,
        createdAt,
        updatedAt,
      ];
}

class SportModel extends Equatable {
  final String id;
  final String name;
  final String slug;

  const SportModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory SportModel.fromJson(Map<String, dynamic> json) {
    return SportModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
    };
  }

  SportModel copyWith({
    String? id,
    String? name,
    String? slug,
  }) {
    return SportModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
      ];
}

class PlayerModel extends Equatable {
  final String id;
  final String name;
  final String team;
  final String country;
  final String image;

  const PlayerModel({
    required this.id,
    required this.name,
    required this.team,
    required this.country,
    required this.image,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      team: json['team'] ?? '',
      country: json['country'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'team': team,
      'country': country,
      'image': image,
    };
  }

  PlayerModel copyWith({
    String? id,
    String? name,
    String? team,
    String? country,
    String? image,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      team: team ?? this.team,
      country: country ?? this.country,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        team,
        country,
        image,
      ];
}