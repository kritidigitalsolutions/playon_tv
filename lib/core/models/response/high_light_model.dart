import 'package:equatable/equatable.dart';
import 'package:playon/core/models/response/series_highlight_model.dart';
import 'package:playon/core/models/response/team_model.dart';

class HighlightResponse extends Equatable {
  final bool success;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final int count;
  final List<HighlightModel> highlights;

  const HighlightResponse({
    required this.success,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.count,
    required this.highlights,
  });

  factory HighlightResponse.fromJson(Map<String, dynamic> json) {
    return HighlightResponse(
      success: json['success'] ?? false,
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      count: json['count'] ?? 0,
      highlights: (json['highlights'] as List? ?? [])
          .map((e) => HighlightModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'total': total,
    'page': page,
    'limit': limit,
    'totalPages': totalPages,
    'count': count,
    'highlights': highlights.map((e) => e.toJson()).toList(),
  };

  HighlightResponse copyWith({
    bool? success,
    int? total,
    int? page,
    int? limit,
    int? totalPages,
    int? count,
    List<HighlightModel>? highlights,
  }) {
    return HighlightResponse(
      success: success ?? this.success,
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
      count: count ?? this.count,
      highlights: highlights ?? this.highlights,
    );
  }

  @override
  List<Object?> get props => [
    success,
    total,
    page,
    limit,
    totalPages,
    count,
    highlights,
  ];
}

class HighlightModel extends Equatable {
  final String id;
  final String? matchId;
  final SeriesHighlightModel series;
  final TeamModel teamA;
  final TeamModel teamB;
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
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int version;

  const HighlightModel({
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
    this.createdAt,
    this.updatedAt,
    required this.version,
  });

  factory HighlightModel.fromJson(Map<String, dynamic> json) {
    return HighlightModel(
      id: json['_id'] ?? '',
      matchId: json['matchId'],
      series: SeriesHighlightModel.fromJson(json['seriesId'] ?? {}),
      teamA: TeamModel.fromJson(json['teamA'] ?? {}),
      teamB: TeamModel.fromJson(json['teamB'] ?? {}),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      sourceType: json['sourceType'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      duration: json['duration'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      isPremium: json['isPremium'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      liveLogo: json['liveLogo'] ?? '',
      showLiveLogo: json['showLiveLogo'] ?? false,
      views: json['views'] ?? 0,
      order: json['order'] ?? 0,
      createdBy: json['createdBy'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      deletedAt: json['deletedAt'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {};

  HighlightModel copyWith({
    String? id,
    String? matchId,
    SeriesHighlightModel? series,
    TeamModel? teamA,
    TeamModel? teamB,
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
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) => HighlightModel(
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
    version: version ?? this.version,
  );

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
    version,
  ];
}
