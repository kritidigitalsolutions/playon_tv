import 'package:equatable/equatable.dart';

class CategoryResponse extends Equatable {
  final bool success;
  final int count;
  final List<ChannelCatagoryModel> categories;

  const CategoryResponse({
    required this.success,
    required this.count,
    required this.categories,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map((e) => ChannelCatagoryModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }

  CategoryResponse copyWith({
    bool? success,
    int? count,
    List<ChannelCatagoryModel>? categories,
  }) {
    return CategoryResponse(
      success: success ?? this.success,
      count: count ?? this.count,
      categories: categories ?? this.categories,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [success, count, categories];
}

class ChannelCatagoryModel extends Equatable {
  final String id;
  final String name;
  final String slug;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  const ChannelCatagoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ChannelCatagoryModel.fromJson(Map<String, dynamic> json) {
    return ChannelCatagoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }

  ChannelCatagoryModel copyWith({
    String? id,
    String? name,
    String? slug,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return ChannelCatagoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    name,
    slug,
    isActive,
    createdAt,
    updatedAt,
    v,
  ];
}
