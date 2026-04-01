import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import '../core/infernal_day.dart';
import '../engine/timer_engine.dart';
import 'data_store.dart';

/// Serveur HTTP local qui sert le dashboard + API
/// Tourne sur localhost, port auto (0 = l'OS choisit)
class LocalServer {
  HttpServer? _server;
  String? _cachedHtml;
  int _port = 0;

  final _engine = TimerEngine();
  final _store = DataStore();

  bool get isRunning => _server != null;
  int get port => _port;
  String get url => 'http://127.0.0.1:$_port';
  TimerEngine get engine => _engine;

  Future<void> start() async {
    if (isRunning) return;

    // Init data store + charger le state sauvegarde
    await _store.init();
    final savedState = await _store.loadState();
    final settings = await _store.loadSettings();
    final actions = (settings['actions'] as List?)
        ?.map((a) => ActionDef.fromJson(a as Map<String, dynamic>))
        .toList();

    // Demarrer le timer engine
    _engine.start(
      savedState: savedState != null ? EngineState.fromJson(savedState) : null,
      actions: actions,
    );
    _engine.onLog = _store.addLogRow;
    _engine.onStateChanged = _saveState;

    // Charger le HTML
    _cachedHtml ??= await rootBundle.loadString('assets/web/index.html');

    final router = Router()
      ..get('/', _handleIndex)
      // GET endpoints
      ..get('/api/state', _handleApiState)
      ..get('/api/settings', _handleApiSettings)
      ..get('/api/consumption/all', _handleApiConsumptionAll)
      ..get('/api/drinks/weeks', _handleApiDrinksWeeks)
      ..get('/api/monthly-summary', _handleApiMonthlySummary)
      ..get('/api/note', _handleApiNoteGet)
      ..get('/api/notes/all', _handleApiNotesAll)
      ..get('/api/quicknote', _handleApiQuickNote)
      ..get('/api/actionnote', _handleApiActionNote)
      // POST endpoints
      ..post('/api/cmd', _handleApiCmd)
      ..post('/api/drinks/add', _handleApiDrinksAdd)
      ..post('/api/drinks/adjust', _handleApiDrinksAdjust)
      ..post('/api/note', _handleApiNotePost)
      ..post('/api/quicknote', _handleApiQuickNotePost)
      ..post('/api/actionnote', _handleApiActionNotePost)
      ..post('/api/goal', _handleApiGoal)
      ..post('/api/settings/custom-actions', _handleApiCustomActions)
      ..post('/api/settings/remove-action', _handleApiRemoveAction)
      ..post('/api/settings/alcohol-volumes', _handleApiAlcoholVolumes);

    final handler = const Pipeline()
        .addMiddleware(_corsMiddleware())
        .addMiddleware(_noCacheMiddleware())
        .addHandler(router.call);

    _server = await shelf_io.serve(handler, '127.0.0.1', 0);
    _port = _server!.port;
  }

  Future<void> stop() async {
    _engine.stop();
    await _saveStateAsync();
    await _server?.close(force: true);
    _server = null;
    _port = 0;
  }

  // --- State persistence (debounced) ---

  DateTime _lastSave = DateTime(2000);

  void _saveState() {
    final now = DateTime.now();
    // Sauvegarder max toutes les 5 secondes
    if (now.difference(_lastSave).inSeconds >= 5) {
      _lastSave = now;
      _saveStateAsync();
    }
  }

  Future<void> _saveStateAsync() async {
    try {
      await _store.saveState(_engine.state.toJson());
    } catch (_) {}
  }

  // --- Middleware ---

  Middleware _corsMiddleware() {
    return (Handler innerHandler) {
      return (Request request) async {
        if (request.method == 'OPTIONS') {
          return Response.ok('', headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type',
          });
        }
        final response = await innerHandler(request);
        return response.change(headers: {
          'Access-Control-Allow-Origin': '*',
        });
      };
    };
  }

  Middleware _noCacheMiddleware() {
    return (Handler innerHandler) {
      return (Request request) async {
        final response = await innerHandler(request);
        return response.change(headers: {
          'Cache-Control': 'no-store, no-cache, must-revalidate',
        });
      };
    };
  }

  // --- Helpers ---

  Response _handleIndex(Request request) {
    return Response.ok(_cachedHtml!, headers: {'Content-Type': 'text/html; charset=utf-8'});
  }

  Response _jsonOk(Object data) {
    return Response.ok(jsonEncode(data), headers: {'Content-Type': 'application/json; charset=utf-8'});
  }

  Response _jsonError(int status, String error) {
    return Response(status, body: jsonEncode({'ok': false, 'error': error}),
        headers: {'Content-Type': 'application/json; charset=utf-8'});
  }

  Future<Map<String, dynamic>?> _readBody(Request request) async {
    try {
      final body = await request.readAsString();
      if (body.isEmpty) return {};
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // =======================================================
  // GET ENDPOINTS
  // =======================================================

  Response _handleApiState(Request request) {
    final s = _engine.state;
    final now = DateTime.now();
    final todayKey = InfernalDay.from(now).key;
    final yesterdayKey = InfernalDay.from(now.subtract(const Duration(days: 1))).key;

    final elapsedSec = now.difference(s.current.startedAt).inSeconds;
    final remainSec = s.current.endsAt != null
        ? s.current.endsAt!.difference(now).inSeconds.clamp(0, 999999)
        : 0;

    return _jsonOk({
      'ok': true,
      'currentName': s.current.name,
      'remainSec': remainSec,
      'goalSec': s.goalWorkSeconds,
      'doneSec': s.totalWorkSeconds + s.totalOverrunSeconds,
      'overrunSec': s.totalOverrunSeconds,
      'dayWorkSec': s.dayWorkSeconds,
      'daySleepSec': s.daySleepSeconds,
      'dayBreakSec': s.dayBreakSeconds,
      'dayClopeSec': s.dayClopeSeconds,
      'dayClopeCount': s.dayClopeCount,
      'elapsedSec': elapsedSec,
      'started': s.started,
      'awaitOk': s.awaitOk,
      'paused': s.current.paused,
      'pausedRemainSec': s.current.pausedRemainSec,
      'overtimeStartedAt': s.current.overtimeStartedAt?.toIso8601String(),
      'todayKey': todayKey,
      'yesterdayKey': yesterdayKey,
      'dailyAlcohol': {'wine': 0, 'beer': 0, 'strong': 0},
      'yesterdayAlcohol': {'wine': 0, 'beer': 0, 'strong': 0},
      'dailyActions': [],
      'recentDrinks': [],
      'firsts': {},
      'timelineHtml': '',
    });
  }

  Future<Response> _handleApiSettings(Request request) async {
    final settings = await _store.loadSettings();
    return _jsonOk(settings);
  }

  Future<Response> _handleApiConsumptionAll(Request request) async {
    final data = await _store.getAllConsumption();
    return _jsonOk({'ok': true, 'data': data});
  }

  Response _handleApiDrinksWeeks(Request request) {
    // Weekly aggregates from drinks.csv will be computed here
    return _jsonOk([]);
  }

  Response _handleApiMonthlySummary(Request request) {
    final ym = request.url.queryParameters['m'] ?? DateTime.now().toIso8601String().substring(0, 7);
    return _jsonOk({
      'ok': true,
      'month': ym,
      'totalWorkMin': (_engine.state.totalWorkSeconds / 60).round(),
      'totalSleepMin': (_engine.state.totalSleepSeconds / 60).round(),
      'avgWorkMin': 0,
      'avgSleepMin': 0,
      'totalClope': _engine.state.totalClopeCount,
      'avgClope': 0,
      'clopeFreeDays': 0,
      'alcoholFreeDays': 0,
      'activeDays': 0,
      'daily': [],
    });
  }

  Future<Response> _handleApiNoteGet(Request request) async {
    final d = request.url.queryParameters['d'] ?? InfernalDay.today().key;
    final content = await _store.loadNote(d);
    return _jsonOk({'ok': true, 'day': d, 'content': content});
  }

  Future<Response> _handleApiNotesAll(Request request) async {
    final notes = await _store.loadAllNotes();
    return _jsonOk({'ok': true, 'notes': notes});
  }

  Future<Response> _handleApiQuickNote(Request request) async {
    final content = await _store.loadQuickNote();
    return _jsonOk({'ok': true, 'content': content});
  }

  Future<Response> _handleApiActionNote(Request request) async {
    final content = await _store.loadActionNote();
    return _jsonOk({'ok': true, 'content': content});
  }

  // =======================================================
  // POST ENDPOINTS
  // =======================================================

  Future<Response> _handleApiCmd(Request request) async {
    final data = await _readBody(request);
    if (data == null) return _jsonError(400, 'Invalid body');
    final cmd = (data['cmd'] as String? ?? '').trim();
    if (cmd.isEmpty) return _jsonError(400, 'empty cmd');
    _engine.processCommand(cmd);
    await _saveStateAsync();
    return _jsonOk({'ok': true, 'cmd': cmd});
  }

  Future<Response> _handleApiDrinksAdd(Request request) async {
    final data = await _readBody(request);
    if (data == null) return _jsonError(400, 'Invalid body');
    final type = (data['type'] as String? ?? '').toLowerCase();
    final n = (data['n'] as int?) ?? 1;
    final day = data['day'] as String?;
    if (!['wine', 'beer', 'strong'].contains(type)) {
      return _jsonError(400, 'type must be wine|beer|strong');
    }
    await _store.addDrink(type, n, day: day);
    final dayKey = day == 'yesterday'
        ? InfernalDay.yesterday().key
        : InfernalDay.today().key;
    final totals = await _store.getDailyAlcohol(dayKey);
    return _jsonOk({'ok': true, 'type': type, 'n': n, 'day': dayKey, 'totals': totals});
  }

  Future<Response> _handleApiDrinksAdjust(Request request) async {
    final data = await _readBody(request);
    if (data == null) return _jsonError(400, 'Invalid body');
    final type = (data['type'] as String? ?? '').toLowerCase();
    final total = (data['total'] as int?) ?? 0;
    if (!['wine', 'beer', 'strong'].contains(type)) {
      return _jsonError(400, 'type must be wine|beer|strong');
    }
    final dayKey = InfernalDay.today().key;
    final current = await _store.getDailyAlcohol(dayKey);
    final currentVal = current[type] ?? 0;
    final added = (total - currentVal).clamp(0, 999);
    if (added > 0) await _store.addDrink(type, added);
    return _jsonOk({'ok': true, 'total': total, 'current': currentVal, 'added': added});
  }

  Future<Response> _handleApiNotePost(Request request) async {
    final data = await _readBody(request);
    if (data == null) return _jsonError(400, 'Invalid body');
    final day = data['day'] as String? ?? InfernalDay.today().key;
    final content = data['content'] as String? ?? '';
    await _store.saveNote(day, content);
    return _jsonOk({'ok': true});
  }

  Future<Response> _handleApiQuickNotePost(Request request) async {
    final data = await _readBody(request);
    if (data == null) return _jsonError(400, 'Invalid body');
    await _store.saveQuickNote(data['content'] as String? ?? '');
    return _jsonOk({'ok': true});
  }

  Future<Response> _handleApiActionNotePost(Request request) async {
    final data = await _readBody(request);
    if (data == null) return _jsonError(400, 'Invalid body');
    await _store.saveActionNote(data['content'] as String? ?? '');
    return _jsonOk({'ok': true});
  }

  Future<Response> _handleApiGoal(Request request) async {
    final data = await _readBody(request);
    if (data == null) return _jsonError(400, 'Invalid body');
    final hours = data['hours'] as int? ?? 500;
    if (hours < 1 || hours > 9999) return _jsonError(400, 'hours must be 1-9999');
    _engine.setGoal(hours);
    await _saveStateAsync();
    return _jsonOk({'ok': true, 'goalHours': hours});
  }

  Future<Response> _handleApiCustomActions(Request request) async {
    final data = await _readBody(request);
    if (data == null) return _jsonError(400, 'Invalid body');
    final incoming = (data['actions'] as List?)?.take(3).toList() ?? [];
    final settings = await _store.loadSettings();
    final existing = (settings['actions'] as List? ?? [])
        .where((a) => a['custom'] != true).toList();
    for (final raw in incoming) {
      final label = ((raw as Map)['label'] as String? ?? '').trim();
      if (label.isEmpty) continue;
      final key = label.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
      if (key.isEmpty) continue;
      existing.add({
        'key': key, 'label': label, 'mode': 'break',
        'minutes': 0, 'requireOk': true, 'custom': true,
        'color': raw['color'] ?? '#ff9955',
      });
    }
    settings['actions'] = existing;
    await _store.saveSettings(settings);
    _engine.updateActions(existing.map((a) => ActionDef.fromJson(a as Map<String, dynamic>)).toList());
    return _jsonOk({'ok': true});
  }

  Future<Response> _handleApiRemoveAction(Request request) async {
    final data = await _readBody(request);
    if (data == null) return _jsonError(400, 'Invalid body');
    final key = (data['key'] as String? ?? '').trim();
    if (key.isEmpty) return _jsonError(400, 'Missing key');
    if (key == 'work' || key == 'dodo') return _jsonError(400, 'Cannot remove system action');
    final settings = await _store.loadSettings();
    final actions = (settings['actions'] as List? ?? [])
        .where((a) => a['key'] != key).toList();
    settings['actions'] = actions;
    await _store.saveSettings(settings);
    _engine.updateActions(actions.map((a) => ActionDef.fromJson(a as Map<String, dynamic>)).toList());
    return _jsonOk({'ok': true});
  }

  Future<Response> _handleApiAlcoholVolumes(Request request) async {
    final data = await _readBody(request);
    if (data == null) return _jsonError(400, 'Invalid body');
    var beer = (data['beer'] as num?)?.toDouble() ?? 0.5;
    var wine = (data['wine'] as num?)?.toDouble() ?? 0.2;
    var strong = (data['strong'] as num?)?.toDouble() ?? 0.2;
    beer = beer.clamp(0.05, 3.0);
    wine = wine.clamp(0.05, 2.0);
    strong = strong.clamp(0.02, 2.0);
    final settings = await _store.loadSettings();
    settings['alcoholVolumes'] = {'beer': beer, 'wine': wine, 'strong': strong};
    await _store.saveSettings(settings);
    return _jsonOk({'ok': true, 'beer': beer, 'wine': wine, 'strong': strong});
  }
}
