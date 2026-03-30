import 'package:flutter_test/flutter_test.dart';
import 'package:infernal_wheel/engine/timer_engine.dart';
import 'package:infernal_wheel/core/infernal_day.dart';

void main() {
  group('InfernalDay', () {
    test('day starts at 4am', () {
      // 3:59 AM → previous day
      final d1 = InfernalDay.from(DateTime(2026, 3, 30, 3, 59));
      expect(d1.key, '2026-03-29');

      // 4:00 AM → current day
      final d2 = InfernalDay.from(DateTime(2026, 3, 30, 4, 0));
      expect(d2.key, '2026-03-30');

      // 11 PM → current day
      final d3 = InfernalDay.from(DateTime(2026, 3, 30, 23, 0));
      expect(d3.key, '2026-03-30');
    });

    test('previous and next', () {
      final day = InfernalDay(2026, 3, 30);
      expect(day.previous.key, '2026-03-29');
      expect(day.next.key, '2026-03-31');
    });

    test('previous/next across month boundary', () {
      final day = InfernalDay(2026, 4, 1);
      expect(day.previous.key, '2026-03-31');
      final day2 = InfernalDay(2026, 3, 31);
      expect(day2.next.key, '2026-04-01');
    });

    test('key format', () {
      final day = InfernalDay(2026, 1, 5);
      expect(day.key, '2026-01-05');
    });

    test('tryParse', () {
      expect(InfernalDay.tryParse('2026-03-30')?.key, '2026-03-30');
      expect(InfernalDay.tryParse('invalid'), isNull);
      expect(InfernalDay.tryParse(''), isNull);
    });

    test('fromKey', () {
      final day = InfernalDay.fromKey('2026-03-30');
      expect(day.year, 2026);
      expect(day.month, 3);
      expect(day.day, 30);
    });

    test('display methods', () {
      final day = InfernalDay(2026, 3, 30); // Monday
      expect(day.dayName, 'Lundi');
      expect(day.formattedDate, '30 mars 2026');
    });

    test('equality', () {
      expect(InfernalDay(2026, 3, 30), equals(InfernalDay(2026, 3, 30)));
      expect(InfernalDay(2026, 3, 30), isNot(equals(InfernalDay(2026, 3, 31))));
    });
  });

  group('TimerEngine', () {
    late TimerEngine engine;

    setUp(() {
      engine = TimerEngine();
      engine.start();
    });

    tearDown(() {
      engine.stop();
    });

    test('initial state is idle', () {
      expect(engine.state.current.name, 'idle');
      expect(engine.state.started, false);
    });

    test('start command switches to work', () {
      engine.processCommand('start');
      expect(engine.state.current.name, 'work');
      expect(engine.state.current.isWork, true);
      expect(engine.state.started, true);
    });

    test('dodo command switches to sleep', () {
      engine.processCommand('dodo');
      expect(engine.state.current.name, 'sleep');
      expect(engine.state.current.isSleep, true);
    });

    test('clope action has timer', () {
      engine.processCommand('clope');
      expect(engine.state.current.name, 'clope');
      expect(engine.state.current.endsAt, isNotNull);
      expect(engine.state.current.requireOk, true);
    });

    test('ok command returns to work', () {
      engine.processCommand('clope');
      engine.processCommand('ok');
      expect(engine.state.current.name, 'work');
      expect(engine.state.current.isWork, true);
    });

    test('pause and resume', () {
      engine.processCommand('clope');
      engine.processCommand('pause');
      expect(engine.state.current.paused, true);
      expect(engine.state.current.pausedRemainSec, isNotNull);

      engine.processCommand('resume');
      expect(engine.state.current.paused, false);
      expect(engine.state.current.endsAt, isNotNull);
    });

    test('extend adds time', () {
      engine.processCommand('clope');
      final originalEnd = engine.state.current.endsAt!;
      engine.processCommand('extend 10');
      expect(engine.state.current.endsAt!.isAfter(originalEnd), true);
    });

    test('jpp sets overtime', () {
      engine.processCommand('jpp');
      expect(engine.state.current.name, 'WAIT_OK');
      expect(engine.state.awaitOk, true);
      expect(engine.state.current.overtimeStartedAt, isNotNull);
    });

    test('setGoal updates goal', () {
      engine.setGoal(100);
      expect(engine.state.goalWorkSeconds, 360000);
    });

    test('state serialization roundtrip', () {
      engine.processCommand('start');
      engine.setGoal(200);

      final json = engine.state.toJson();
      final restored = EngineState.fromJson(json);

      expect(restored.goalWorkSeconds, 200 * 3600);
      expect(restored.started, true);
      expect(restored.current.name, 'work');
    });
  });

  group('EngineState JSON', () {
    test('default state serializes', () {
      final state = EngineState();
      final json = state.toJson();
      expect(json['GoalWorkSeconds'], isNotNull);
      expect(json['Current'], isNotNull);
      expect(json['Engine'], isNotNull);
    });

    test('roundtrip preserves all fields', () {
      final state = EngineState(
        goalWorkSeconds: 100000,
        totalWorkSeconds: 5000,
        totalSleepSeconds: 3000,
        totalClopeCount: 7,
        dayWorkSeconds: 1000,
      );
      final json = state.toJson();
      final restored = EngineState.fromJson(json);

      expect(restored.goalWorkSeconds, 100000);
      expect(restored.totalWorkSeconds, 5000);
      expect(restored.totalSleepSeconds, 3000);
      expect(restored.totalClopeCount, 7);
      expect(restored.dayWorkSeconds, 1000);
    });
  });

  group('ActionDef', () {
    test('fromJson defaults', () {
      final action = ActionDef.fromJson({'key': 'test', 'label': 'Test'});
      expect(action.mode, 'break');
      expect(action.minutes, 0);
      expect(action.requireOk, true);
    });

    test('roundtrip', () {
      const action = ActionDef(key: 'sport', label: 'Sport', mode: 'break', minutes: 45);
      final json = action.toJson();
      final restored = ActionDef.fromJson(json);
      expect(restored.key, 'sport');
      expect(restored.minutes, 45);
    });
  });
}
