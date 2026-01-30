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
import 'package:serverpod/serverpod.dart' as _i1;
import 'task.dart' as _i2;
import 'briefing.dart' as _i3;
import 'package:lifeflow_butler_server/src/generated/protocol.dart' as _i4;

abstract class DailyOverview
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  DailyOverview._({
    required this.greeting,
    required this.tasks,
    required this.briefings,
  });

  factory DailyOverview({
    required String greeting,
    required List<_i2.Task> tasks,
    required List<_i3.Briefing> briefings,
  }) = _DailyOverviewImpl;

  factory DailyOverview.fromJson(Map<String, dynamic> jsonSerialization) {
    return DailyOverview(
      greeting: jsonSerialization['greeting'] as String,
      tasks: _i4.Protocol().deserialize<List<_i2.Task>>(
        jsonSerialization['tasks'],
      ),
      briefings: _i4.Protocol().deserialize<List<_i3.Briefing>>(
        jsonSerialization['briefings'],
      ),
    );
  }

  String greeting;

  List<_i2.Task> tasks;

  List<_i3.Briefing> briefings;

  /// Returns a shallow copy of this [DailyOverview]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DailyOverview copyWith({
    String? greeting,
    List<_i2.Task>? tasks,
    List<_i3.Briefing>? briefings,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailyOverview',
      'greeting': greeting,
      'tasks': tasks.toJson(valueToJson: (v) => v.toJson()),
      'briefings': briefings.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DailyOverview',
      'greeting': greeting,
      'tasks': tasks.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'briefings': briefings.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _DailyOverviewImpl extends DailyOverview {
  _DailyOverviewImpl({
    required String greeting,
    required List<_i2.Task> tasks,
    required List<_i3.Briefing> briefings,
  }) : super._(
         greeting: greeting,
         tasks: tasks,
         briefings: briefings,
       );

  /// Returns a shallow copy of this [DailyOverview]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DailyOverview copyWith({
    String? greeting,
    List<_i2.Task>? tasks,
    List<_i3.Briefing>? briefings,
  }) {
    return DailyOverview(
      greeting: greeting ?? this.greeting,
      tasks: tasks ?? this.tasks.map((e0) => e0.copyWith()).toList(),
      briefings:
          briefings ?? this.briefings.map((e0) => e0.copyWith()).toList(),
    );
  }
}
