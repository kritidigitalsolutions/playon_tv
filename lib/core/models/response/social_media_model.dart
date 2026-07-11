import 'package:equatable/equatable.dart';

class SocialResponse extends Equatable {
  final bool success;
  final int count;
  final List<SocialModel> social;

  const SocialResponse({
    required this.success,
    required this.count,
    required this.social,
  });

  factory SocialResponse.fromJson(Map<String, dynamic> json) {
    return SocialResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      social: (json['social'] as List<dynamic>? ?? [])
          .map((e) => SocialModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'social': social.map((e) => e.toJson()).toList(),
    };
  }

  SocialResponse copyWith({
    bool? success,
    int? count,
    List<SocialModel>? social,
  }) {
    return SocialResponse(
      success: success ?? this.success,
      count: count ?? this.count,
      social: social ?? this.social,
    );
  }

  @override
  List<Object?> get props => [success, count, social];
}

class SocialModel extends Equatable {
  final String id;
  final String platform;
  final String url;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  const SocialModel({
    required this.id,
    required this.platform,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory SocialModel.fromJson(Map<String, dynamic> json) {
    return SocialModel(
      id: json['_id'] ?? '',
      platform: json['platform'] ?? '',
      url: json['url'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'platform': platform,
      'url': url,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }

  SocialModel copyWith({
    String? id,
    String? platform,
    String? url,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return SocialModel(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  @override
  List<Object?> get props => [
        id,
        platform,
        url,
        createdAt,
        updatedAt,
        v,
      ];
}