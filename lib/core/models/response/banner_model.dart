import 'package:equatable/equatable.dart';

class BannerResponse extends Equatable {
  final bool success;
  final List<BannerModel> banners;

  const BannerResponse({required this.success, required this.banners});

  factory BannerResponse.fromJson(Map<String, dynamic> json) {
    return BannerResponse(
      success: json['success'] ?? false,
      banners: (json['banners'] as List<dynamic>? ?? [])
          .map((e) => BannerModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'banners': banners.map((e) => e.toJson()).toList(),
    };
  }

  BannerResponse copyWith({bool? success, List<BannerModel>? banners}) {
    return BannerResponse(
      success: success ?? this.success,
      banners: banners ?? this.banners,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [success, banners];
}

class BannerModel extends Equatable {
  final String id;
  final String title;
  final String image;
  final String link;
  final String position;
  final bool isActive;
  final int sortOrder;
  final int clicks;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int version;

  const BannerModel({
    required this.id,
    required this.title,
    required this.image,
    required this.link,
    required this.position,
    required this.isActive,
    required this.sortOrder,
    required this.clicks,
    this.createdAt,
    this.updatedAt,
    required this.version,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      link: json['link'] ?? '',
      position: json['position'] ?? '',
      isActive: json['isActive'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
      clicks: json['clicks'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'image': image,
      'link': link,
      'position': position,
      'isActive': isActive,
      'sortOrder': sortOrder,
      'clicks': clicks,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
    };
  }

  BannerModel copyWith({
    String? id,
    String? title,
    String? image,
    String? link,
    String? position,
    bool? isActive,
    int? sortOrder,
    int? clicks,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return BannerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      link: link ?? this.link,
      position: position ?? this.position,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      clicks: clicks ?? this.clicks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    title,
    image,
    link,
    position,
    isActive,
    sortOrder,
    clicks,
    createdAt,
    updatedAt,
    version,
  ];
}
