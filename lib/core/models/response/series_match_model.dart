import 'package:equatable/equatable.dart';

class SeriesMatchModel extends Equatable {
  final String id;
  final String matchName;
  final DateTime? date;
  final String status;

  const SeriesMatchModel({
    required this.id,
    required this.matchName,
    this.date,
    required this.status,
  });

  factory SeriesMatchModel.fromJson(Map<String, dynamic> json) {
    return SeriesMatchModel(
      id: json['_id'] ?? '',
      matchName: json['matchName'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : null,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'matchName': matchName,
    'date': date?.toIso8601String(),
    'status': status,
  };

  SeriesMatchModel copyWith({
    String? id,
    String? matchName,
    DateTime? date,
    String? status,
  }) {
    return SeriesMatchModel(
      id: id ?? this.id,
      matchName: matchName ?? this.matchName,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    id,
    matchName,
    date,
    status,
  ];
}