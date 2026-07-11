import 'package:equatable/equatable.dart';

class HighlightDetailResponse extends Equatable {
  final bool success;
  final HighLightDetailModel highlight;

  const HighlightDetailResponse({
    required this.success,
    required this.highlight,
  });

  factory HighlightDetailResponse.fromJson(Map<String, dynamic> json) {
    return HighlightDetailResponse(
      success: json['success'] ?? false,
      highlight: HighLightDetailModel.fromJson(json['highlight']),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'highlight': highlight.toJson(),
      };

  HighlightDetailResponse copyWith({
    bool? success,
    HighLightDetailModel? highlight,
  }) {
    return HighlightDetailResponse(
      success: success ?? this.success,
      highlight: highlight ?? this.highlight,
    );
  }

  @override
  List<Object?> get props => [success, highlight];
}

class HighLightDetailModel extends Equatable {
  final String id;
  final String? matchId;
  final HighlightSeries series;
  final HighlightTeam teamA;
  final HighlightTeam teamB;
  final String title;
  final String description;
  final String category;
  final String sourceType;
  final String videoUrl;
  final String thumbnail;
  final int duration;
  final List<String> tags;
  final bool isPremium;
  final bool isFeatured;
  final String liveLogo;
  final bool showLiveLogo;
  final int views;
  final int order;
  final String createdBy;
  final bool isDeleted;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;

  const HighLightDetailModel({
    required this.id,
    this.matchId,
    required this.series,
    required this.teamA,
    required this.teamB,
    required this.title,
    required this.description,
    required this.category,
    required this.sourceType,
    required this.videoUrl,
    required this.thumbnail,
    required this.duration,
    required this.tags,
    required this.isPremium,
    required this.isFeatured,
    required this.liveLogo,
    required this.showLiveLogo,
    required this.views,
    required this.order,
    required this.createdBy,
    required this.isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HighLightDetailModel .fromJson(Map<String, dynamic> json) {
    return HighLightDetailModel(
      id: json['_id'] ?? '',
      matchId: json['matchId'],
      series: HighlightSeries.fromJson(json['seriesId']),
      teamA: HighlightTeam.fromJson(json['teamA']),
      teamB: HighlightTeam.fromJson(json['teamB']),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      sourceType: json['sourceType'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      duration: json['duration'] ?? 0,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isPremium: json['isPremium'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      liveLogo: json['liveLogo'] ?? '',
      showLiveLogo: json['showLiveLogo'] ?? false,
      views: json['views'] ?? 0,
      order: json['order'] ?? 0,
      createdBy: json['createdBy'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      deletedAt: json['deletedAt'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'matchId': matchId,
        'seriesId': series.toJson(),
        'teamA': teamA.toJson(),
        'teamB': teamB.toJson(),
        'title': title,
        'description': description,
        'category': category,
        'sourceType': sourceType,
        'videoUrl': videoUrl,
        'thumbnail': thumbnail,
        'duration': duration,
        'tags': tags,
        'isPremium': isPremium,
        'isFeatured': isFeatured,
        'liveLogo': liveLogo,
        'showLiveLogo': showLiveLogo,
        'views': views,
        'order': order,
        'createdBy': createdBy,
        'isDeleted': isDeleted,
        'deletedAt': deletedAt,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  HighLightDetailModel copyWith({
    String? id,
    String? matchId,
    HighlightSeries? series,
    HighlightTeam? teamA,
    HighlightTeam? teamB,
    String? title,
    String? description,
    String? category,
    String? sourceType,
    String? videoUrl,
    String? thumbnail,
    int? duration,
    List<String>? tags,
    bool? isPremium,
    bool? isFeatured,
    String? liveLogo,
    bool? showLiveLogo,
    int? views,
    int? order,
    String? createdBy,
    bool? isDeleted,
    String? deletedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return HighLightDetailModel(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      series: series ?? this.series,
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      sourceType: sourceType ?? this.sourceType,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnail: thumbnail ?? this.thumbnail,
      duration: duration ?? this.duration,
      tags: tags ?? this.tags,
      isPremium: isPremium ?? this.isPremium,
      isFeatured: isFeatured ?? this.isFeatured,
      liveLogo: liveLogo ?? this.liveLogo,
      showLiveLogo: showLiveLogo ?? this.showLiveLogo,
      views: views ?? this.views,
      order: order ?? this.order,
      createdBy: createdBy ?? this.createdBy,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        matchId,
        series,
        teamA,
        teamB,
        title,
        description,
        category,
        sourceType,
        videoUrl,
        thumbnail,
        duration,
        tags,
        isPremium,
        isFeatured,
        liveLogo,
        showLiveLogo,
        views,
        order,
        createdBy,
        isDeleted,
        deletedAt,
        createdAt,
        updatedAt,
      ];
}

class HighlightSeries extends Equatable {
  final String id;
  final String title;
  final String sport;
  final String banner;
  final String tournamentLogo;
  final String status;

  const HighlightSeries({
    required this.id,
    required this.title,
    required this.sport,
    required this.banner,
    required this.tournamentLogo,
    required this.status,
  });

  factory HighlightSeries.fromJson(Map<String, dynamic> json) {
    return HighlightSeries(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      sport: json['sport'] ?? '',
      banner: json['banner'] ?? '',
      tournamentLogo: json['tournamentLogo'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'sport': sport,
        'banner': banner,
        'tournamentLogo': tournamentLogo,
        'status': status,
      };

  HighlightSeries copyWith({
    String? id,
    String? title,
    String? sport,
    String? banner,
    String? tournamentLogo,
    String? status,
  }) {
    return HighlightSeries(
      id: id ?? this.id,
      title: title ?? this.title,
      sport: sport ?? this.sport,
      banner: banner ?? this.banner,
      tournamentLogo: tournamentLogo ?? this.tournamentLogo,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, sport, banner, tournamentLogo, status];
}

class HighlightTeam extends Equatable {
  final String id;
  final String name;
  final String sport;
  final String logo;
  final String shortName;

  const HighlightTeam({
    required this.id,
    required this.name,
    required this.sport,
    required this.logo,
    required this.shortName,
  });

  factory HighlightTeam.fromJson(Map<String, dynamic> json) {
    return HighlightTeam(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      sport: json['sport'] ?? '',
      logo: json['logo'] ?? '',
      shortName: json['shortName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'sport': sport,
        'logo': logo,
        'shortName': shortName,
      };

  HighlightTeam copyWith({
    String? id,
    String? name,
    String? sport,
    String? logo,
    String? shortName,
  }) {
    return HighlightTeam(
      id: id ?? this.id,
      name: name ?? this.name,
      sport: sport ?? this.sport,
      logo: logo ?? this.logo,
      shortName: shortName ?? this.shortName,
    );
  }

  @override
  List<Object?> get props => [id, name, sport, logo, shortName];
}