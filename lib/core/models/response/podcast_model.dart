import 'package:equatable/equatable.dart';

class PodcastResponse extends Equatable {
  final bool success;
  final int count;
  final List<PodcastModel> podcasts;

  const PodcastResponse({
    required this.success,
    required this.count,
    required this.podcasts,
  });

  factory PodcastResponse.fromJson(Map<String, dynamic> json) {
    return PodcastResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      podcasts: (json['podcasts'] as List<dynamic>? ?? [])
          .map((e) => PodcastModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'podcasts': podcasts.map((e) => e.toJson()).toList(),
    };
  }

  PodcastResponse copyWith({
    bool? success,
    int? count,
    List<PodcastModel>? podcasts,
  }) {
    return PodcastResponse(
      success: success ?? this.success,
      count: count ?? this.count,
      podcasts: podcasts ?? this.podcasts,
    );
  }

  @override
  List<Object?> get props => [success, count, podcasts];
}

class PodcastModel extends Equatable {
  final String id;
  final SportModel? sportId;
  final String title;
  final String description;
  final String url;
  final String type;
  final List<dynamic> sources;
  final String thumbnail;
  final String duration;
  final String category;
  final bool isFeatured;
  final String status;
  final bool isPremium;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int version;
  final String liveLogo;
  final bool showLiveLogo;

  const PodcastModel({
    required this.id,
    this.sportId,
    required this.title,
    required this.description,
    required this.url,
    required this.type,
    required this.sources,
    required this.thumbnail,
    required this.duration,
    required this.category,
    required this.isFeatured,
    required this.status,
    required this.isPremium,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
    required this.version,
    required this.liveLogo,
    required this.showLiveLogo,
  });

  factory PodcastModel.fromJson(Map<String, dynamic> json) {
    return PodcastModel(
      id: json['_id'] ?? '',
      sportId: json['sportId'] != null
          ? SportModel.fromJson(json['sportId'])
          : null,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      type: json['type'] ?? '',
      sources: List<dynamic>.from(json['sources'] ?? []),
      thumbnail: json['thumbnail'] ?? '',
      duration: json['duration'] ?? '',
      category: json['category'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
      status: json['status'] ?? '',
      isPremium: json['isPremium'] ?? false,
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      version: json['__v'] ?? 0,
      liveLogo: json['liveLogo'] ?? '',
      showLiveLogo: json['showLiveLogo'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sportId': sportId?.toJson(),
      'title': title,
      'description': description,
      'url': url,
      'type': type,
      'sources': sources,
      'thumbnail': thumbnail,
      'duration': duration,
      'category': category,
      'isFeatured': isFeatured,
      'status': status,
      'isPremium': isPremium,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
      'liveLogo': liveLogo,
      'showLiveLogo': showLiveLogo,
    };
  }

  PodcastModel copyWith({
    String? id,
    SportModel? sportId,
    String? title,
    String? description,
    String? url,
    String? type,
    List<dynamic>? sources,
    String? thumbnail,
    String? duration,
    String? category,
    bool? isFeatured,
    String? status,
    bool? isPremium,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    String? liveLogo,
    bool? showLiveLogo,
  }) {
    return PodcastModel(
      id: id ?? this.id,
      sportId: sportId ?? this.sportId,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      type: type ?? this.type,
      sources: sources ?? this.sources,
      thumbnail: thumbnail ?? this.thumbnail,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      isFeatured: isFeatured ?? this.isFeatured,
      status: status ?? this.status,
      isPremium: isPremium ?? this.isPremium,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      liveLogo: liveLogo ?? this.liveLogo,
      showLiveLogo: showLiveLogo ?? this.showLiveLogo,
    );
  }

  @override
  List<Object?> get props => [
    id,
    sportId,
    title,
    description,
    url,
    type,
    sources,
    thumbnail,
    duration,
    category,
    isFeatured,
    status,
    isPremium,
    createdBy,
    createdAt,
    updatedAt,
    version,
    liveLogo,
    showLiveLogo,
  ];
}

class SportModel extends Equatable {
  final String id;
  final String name;
  final String slug;

  const SportModel({required this.id, required this.name, required this.slug});

  factory SportModel.fromJson(Map<String, dynamic> json) {
    return SportModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'slug': slug};
  }

  SportModel copyWith({String? id, String? name, String? slug}) {
    return SportModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
    );
  }

  @override
  List<Object?> get props => [id, name, slug];
}
