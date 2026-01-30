/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class Briefing implements _i1.SerializableModel {
  Briefing._({
    this.id,
    required this.title,
    required this.summary,
    required this.priority,
    required this.createdAt,
  });

  factory Briefing({
    int? id,
    required String title,
    required String summary,
    required String priority,
    required DateTime createdAt,
  }) = _BriefingImpl;

  factory Briefing.fromJson(Map<String, dynamic> jsonSerialization) {
    return Briefing(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      summary: jsonSerialization['summary'] as String,
      priority: jsonSerialization['priority'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  String summary;

  String priority;

  DateTime createdAt;

  /// Returns a shallow copy of this [Briefing]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Briefing copyWith({
    int? id,
    String? title,
    String? summary,
    String? priority,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Briefing',
      if (id != null) 'id': id,
      'title': title,
      'summary': summary,
      'priority': priority,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BriefingImpl extends Briefing {
  _BriefingImpl({
    int? id,
    required String title,
    required String summary,
    required String priority,
    required DateTime createdAt,
  }) : super._(
         id: id,
         title: title,
         summary: summary,
         priority: priority,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Briefing]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Briefing copyWith({
    Object? id = _Undefined,
    String? title,
    String? summary,
    String? priority,
    DateTime? createdAt,
  }) {
    return Briefing(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
