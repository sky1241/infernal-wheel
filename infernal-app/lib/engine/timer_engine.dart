import 'dart:async';
import 'dart:ui' show VoidCallback;
import '../core/infernal_day.dart';

/// Segment en cours (work, sleep, break, clope, etc.)
class Segment {
  String name;
  DateTime startedAt;
  DateTime? displayStartedAt;
  DateTime? endsAt;
  bool isWork;
  bool isSleep;
  bool requireOk;
  bool paused;
  int? pausedRemainSec;
  DateTime? overtimeStartedAt;

  Segment({
    required this.name,
    required this.startedAt,
    this.displayStartedAt,
    this.endsAt,
    this.isWork = false,
    this.isSleep = false,
    this.requireOk = false,
    this.paused = false,
    this.pausedRemainSec,
    this.overtimeStartedAt,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'startedAt': startedAt.toIso8601String(),
    'displayStartedAt': displayStartedAt?.toIso8601String(),
    'endsAt': endsAt?.toIso8601String(),
    'isWork': isWork,
    'isSleep': isSleep,
    'requireOk': requireOk,
    'paused': paused,
    'pausedRemainSec': pausedRemainSec,
    'overtimeStartedAt': overtimeStartedAt?.toIso8601String(),
  };

  factory Segment.fromJson(Map<String, dynamic> j) => Segment(
    name: j['name'] as String? ?? 'idle',
    startedAt: DateTime.tryParse(j['startedAt'] as String? ?? '') ?? DateTime.now(),
    displayStartedAt: j['displayStartedAt'] != null ? DateTime.tryParse(j['displayStartedAt'] as String) : null,
    endsAt: j['endsAt'] != null ? DateTime.tryParse(j['endsAt'] as String) : null,
    isWork: j['isWork'] as bool? ?? false,
    isSleep: j['isSleep'] as bool? ?? false,
    requireOk: j['requireOk'] as bool? ?? false,
    paused: j['paused'] as bool? ?? false,
    pausedRemainSec: j['pausedRemainSec'] as int?,
    overtimeStartedAt: j['overtimeStartedAt'] != null ? DateTime.tryParse(j['overtimeStartedAt'] as String) : null,
  );
}

/// Action configurable (work, dodo, clope, manger, etc.)
class ActionDef {
  final String key;
  final String label;
  final String mode; // work, sleep, break
  final int minutes;
  final bool requireOk;
  final bool custom;
  final String color;

  const ActionDef({
    required this.key,
    required this.label,
    this.mode = 'break',
    this.minutes = 0,
    this.requireOk = true,
    this.custom = false,
    this.color = '#ff9955',
  });

  Map<String, dynamic> toJson() => {
    'key': key, 'label': label, 'mode': mode,
    'minutes': minutes, 'requireOk': requireOk,
    'custom': custom, 'color': color,
  };

  factory ActionDef.fromJson(Map<String, dynamic> j) => ActionDef(
    key: j['key'] as String? ?? '',
    label: j['label'] as String? ?? '',
    mode: j['mode'] as String? ?? 'break',
    minutes: j['minutes'] as int? ?? 0,
    requireOk: j['requireOk'] as bool? ?? true,
    custom: j['custom'] as bool? ?? false,
    color: j['color'] as String? ?? '#ff9955',
  );
}

/// Etat complet du moteur timer
class EngineState {
  int goalWorkSeconds;
  int totalWorkSeconds;
  int totalSleepSeconds;
  int totalOverrunSeconds;
  int totalClopeCount;
  int totalClopeSeconds;
  int totalBreakSeconds;

  String dayKey;
  int dayWorkSeconds;
  int daySleepSeconds;
  int dayClopeCount;
  int dayClopeSeconds;
  int dayBreakSeconds;

  Segment current;
  bool started;
  bool awaitOk;
  DateTime lastTick;

  EngineState({
    this.goalWorkSeconds = 1800000, // 500h default
    this.totalWorkSeconds = 0,
    this.totalSleepSeconds = 0,
    this.totalOverrunSeconds = 0,
    this.totalClopeCount = 0,
    this.totalClopeSeconds = 0,
    this.totalBreakSeconds = 0,
    String? dayKey,
    this.dayWorkSeconds = 0,
    this.daySleepSeconds = 0,
    this.dayClopeCount = 0,
    this.dayClopeSeconds = 0,
    this.dayBreakSeconds = 0,
    Segment? current,
    this.started = false,
    this.awaitOk = false,
    DateTime? lastTick,
  }) : dayKey = dayKey ?? InfernalDay.today().key,
       current = current ?? Segment(name: 'idle', startedAt: DateTime.now()),
       lastTick = lastTick ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'GoalWorkSeconds': goalWorkSeconds,
    'TotalWorkSeconds': totalWorkSeconds,
    'TotalSleepSeconds': totalSleepSeconds,
    'TotalOverrunSeconds': totalOverrunSeconds,
    'TotalClopeCount': totalClopeCount,
    'TotalClopeSeconds': totalClopeSeconds,
    'TotalBreakSeconds': totalBreakSeconds,
    'DayKey': dayKey,
    'DayWorkSeconds': dayWorkSeconds,
    'DaySleepSeconds': daySleepSeconds,
    'DayClopeCount': dayClopeCount,
    'DayClopeSeconds': dayClopeSeconds,
    'DayBreakSeconds': dayBreakSeconds,
    'Current': current.toJson(),
    'Engine': {
      'Started': started,
      'AwaitOk': awaitOk,
      'LastTick': lastTick.toIso8601String(),
    },
  };

  factory EngineState.fromJson(Map<String, dynamic> j) {
    final engine = j['Engine'] as Map<String, dynamic>? ?? {};
    return EngineState(
      goalWorkSeconds: j['GoalWorkSeconds'] as int? ?? 1800000,
      totalWorkSeconds: j['TotalWorkSeconds'] as int? ?? 0,
      totalSleepSeconds: j['TotalSleepSeconds'] as int? ?? 0,
      totalOverrunSeconds: j['TotalOverrunSeconds'] as int? ?? 0,
      totalClopeCount: j['TotalClopeCount'] as int? ?? 0,
      totalClopeSeconds: j['TotalClopeSeconds'] as int? ?? 0,
      totalBreakSeconds: j['TotalBreakSeconds'] as int? ?? 0,
      dayKey: j['DayKey'] as String?,
      dayWorkSeconds: j['DayWorkSeconds'] as int? ?? 0,
      daySleepSeconds: j['DaySleepSeconds'] as int? ?? 0,
      dayClopeCount: j['DayClopeCount'] as int? ?? 0,
      dayClopeSeconds: j['DayClopeSeconds'] as int? ?? 0,
      dayBreakSeconds: j['DayBreakSeconds'] as int? ?? 0,
      current: j['Current'] != null ? Segment.fromJson(j['Current'] as Map<String, dynamic>) : null,
      started: engine['Started'] as bool? ?? false,
      awaitOk: engine['AwaitOk'] as bool? ?? false,
      lastTick: engine['LastTick'] != null ? DateTime.tryParse(engine['LastTick'] as String) : null,
    );
  }
}

/// Callback pour les logs (debut/fin de segment)
typedef LogCallback = void Function(DateTime start, DateTime end, String name, bool isWork, bool isSleep);

/// Moteur timer — replique la logique de InfernalWheel.ps1
class TimerEngine {
  static final TimerEngine _instance = TimerEngine._internal();
  factory TimerEngine() => _instance;
  TimerEngine._internal();

  EngineState _state = EngineState();
  Timer? _timer;
  LogCallback? onLog;
  VoidCallback? onStateChanged;

  // Actions par defaut
  List<ActionDef> _actions = const [
    ActionDef(key: 'work', label: 'Work', mode: 'work', minutes: 0, requireOk: false),
    ActionDef(key: 'dodo', label: 'Dodo', mode: 'sleep', minutes: 0, requireOk: false),
    ActionDef(key: 'clope', label: 'Clope', mode: 'break', minutes: 10, requireOk: true),
    ActionDef(key: 'manger', label: 'Manger', mode: 'break', minutes: 30, requireOk: true),
    ActionDef(key: 'douche', label: 'Douche', mode: 'break', minutes: 10, requireOk: true),
  ];

  EngineState get state => _state;
  List<ActionDef> get actions => _actions;
  bool get isRunning => _timer != null;

  /// Demarre le moteur (tick toutes les secondes)
  void start({EngineState? savedState, List<ActionDef>? actions}) {
    if (savedState != null) _state = savedState;
    if (actions != null) _actions = actions;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  /// Arrete le moteur
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// Traite une commande (start, work, dodo, clope, ok, pause, resume, extend, jpp)
  void processCommand(String cmdLine) {
    final parts = cmdLine.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return;
    final cmd = parts[0].toLowerCase();
    final arg = parts.length >= 2 ? parts[1] : null;

    switch (cmd) {
      case 'start':
        _state.started = true;
        _state.awaitOk = false;
        _switchSegment('work', 0, true, false, false);
      case 'work':
      case 'ok':
        _state.awaitOk = false;
        _switchSegment('work', 0, true, false, false);
      case 'dodo':
        _state.awaitOk = false;
        _switchSegment('sleep', 0, false, true, false);
      case 'jpp':
        _state.awaitOk = true;
        _switchSegment('WAIT_OK', 0, false, false, false);
        _startOvertimeIfNeeded();
      case 'pause':
        _suspendCountdown();
      case 'resume':
        _resumeCountdown();
      case 'extend':
        _extend(arg);
      default:
        _handleAction(cmd);
    }
    onStateChanged?.call();
  }

  /// Met a jour les actions
  void updateActions(List<ActionDef> actions) {
    _actions = actions;
  }

  /// Met a jour le goal
  void setGoal(int hours) {
    _state.goalWorkSeconds = hours * 3600;
    onStateChanged?.call();
  }

  // --- Core tick logic (replique InfernalWheel.ps1 main loop) ---

  void _tick() {
    final now = DateTime.now();
    final dt = now.difference(_state.lastTick).inSeconds.clamp(0, 20);

    // Day rollover (jour infernal commence a 4h)
    final dk = InfernalDay.from(now).key;
    if (_state.dayKey != dk) {
      _state.dayKey = dk;
      _state.dayWorkSeconds = 0;
      _state.daySleepSeconds = 0;
      _state.dayClopeCount = 0;
      _state.dayClopeSeconds = 0;
      _state.dayBreakSeconds = 0;
    }

    // Account time
    if (dt > 0) {
      final seg = _state.current;
      if (seg.isWork) {
        _state.totalWorkSeconds += dt;
        _state.dayWorkSeconds += dt;
      }
      if (seg.isSleep) {
        _state.totalSleepSeconds += dt;
        _state.daySleepSeconds += dt;
      }
      if (seg.name == 'clope') {
        _state.totalClopeSeconds += dt;
        _state.dayClopeSeconds += dt;
      }
      if (!seg.isWork && !seg.isSleep && seg.name != 'WAIT_OK' && seg.name != 'idle') {
        _state.totalBreakSeconds += dt;
        _state.dayBreakSeconds += dt;
      }
      if (seg.name == 'WAIT_OK' && seg.overtimeStartedAt != null) {
        _state.totalOverrunSeconds += dt;
      }
    }

    // Check timed segment expiry
    final endsAt = _state.current.endsAt;
    if (endsAt != null && !_state.current.paused && now.isAfter(endsAt)) {
      if (_state.current.requireOk) {
        _state.awaitOk = true;
        _switchSegment('WAIT_OK', 0, false, false, false);
        _startOvertimeIfNeeded();
      } else {
        _state.awaitOk = false;
        _switchSegment('work', 0, true, false, false);
      }
    }

    _state.lastTick = now;
    onStateChanged?.call();
  }

  void _switchSegment(String name, int minutes, bool isWork, bool isSleep, bool requireOk) {
    final now = DateTime.now();
    final old = _state.current;

    // Log le segment qui se termine
    onLog?.call(old.startedAt, now, old.name, old.isWork, old.isSleep);

    // Compter les clopes
    if (old.name == 'clope') {
      _state.totalClopeCount += 1;
      if (InfernalDay.from(old.startedAt).key == _state.dayKey) {
        _state.dayClopeCount += 1;
      }
    }

    // Nouveau segment
    _state.current = Segment(
      name: name,
      startedAt: now,
      endsAt: minutes > 0 ? now.add(Duration(minutes: minutes)) : null,
      isWork: isWork,
      isSleep: isSleep,
      requireOk: requireOk,
    );
  }

  void _handleAction(String cmd) {
    final action = _actions.where((a) => a.key.toLowerCase() == cmd).firstOrNull;
    if (action == null) return;

    switch (action.mode) {
      case 'work':
        _state.awaitOk = false;
        _switchSegment(action.key, action.minutes, true, false, action.requireOk);
      case 'sleep':
        _state.awaitOk = false;
        _switchSegment(action.key, action.minutes, false, true, action.requireOk);
      default: // break
        _switchSegment(action.key, action.minutes, false, false, action.requireOk);
    }
  }

  void _suspendCountdown() {
    final seg = _state.current;
    if (seg.paused || seg.endsAt == null) return;
    final remain = seg.endsAt!.difference(DateTime.now()).inSeconds.clamp(0, 999999);
    seg.paused = true;
    seg.pausedRemainSec = remain;
    seg.endsAt = null;
  }

  void _resumeCountdown() {
    final seg = _state.current;
    if (!seg.paused) return;
    final remain = seg.pausedRemainSec ?? 0;
    seg.paused = false;
    seg.pausedRemainSec = null;
    if (remain > 0) {
      seg.endsAt = DateTime.now().add(Duration(seconds: remain));
    }
  }

  void _extend(String? arg) {
    var n = 5;
    if (arg != null) {
      final parsed = int.tryParse(arg);
      if (parsed != null && parsed >= 1) n = parsed;
    }
    final seg = _state.current;
    if (seg.endsAt != null) {
      seg.endsAt = seg.endsAt!.add(Duration(minutes: n));
    } else if (seg.paused && seg.pausedRemainSec != null) {
      seg.pausedRemainSec = seg.pausedRemainSec! + (n * 60);
    }
  }

  void _startOvertimeIfNeeded() {
    _state.current.overtimeStartedAt ??= DateTime.now();
  }
}
