import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

/// Serveur HTTP local qui sert le dashboard + API
/// Tourne sur localhost, port auto (0 = l'OS choisit)
class LocalServer {
  HttpServer? _server;
  String? _cachedHtml;
  int _port = 0;

  bool get isRunning => _server != null;
  int get port => _port;
  String get url => 'http://127.0.0.1:$_port';

  /// Demarre le serveur sur un port libre
  Future<void> start() async {
    if (isRunning) return;

    // Pre-charger le HTML depuis les assets Flutter
    _cachedHtml ??= await rootBundle.loadString('assets/web/index.html');

    final router = Router()
      // Dashboard HTML
      ..get('/', _handleIndex)
      // API endpoints (stub pour l'instant, sera rempli bloc par bloc)
      ..get('/api/state', _handleApiState)
      ..get('/api/settings', _handleApiSettings)
      ..get('/api/consumption/all', _handleApiConsumptionAll)
      ..get('/api/drinks/weeks', _handleApiDrinksWeeks)
      ..get('/api/monthly-summary', _handleApiMonthlySummary)
      ..get('/api/note', _handleApiNoteGet)
      ..get('/api/notes/all', _handleApiNotesAll)
      ..get('/api/quicknote', _handleApiQuickNote)
      ..get('/api/actionnote', _handleApiActionNote)
      // POST endpoints (stubs)
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

    // Port 0 = l'OS attribue un port libre automatiquement
    _server = await shelf_io.serve(handler, '127.0.0.1', 0);
    _port = _server!.port;
  }

  /// Arrete le serveur
  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
    _port = 0;
  }

  // --- Middleware ---

  Middleware _corsMiddleware() {
    return (Handler innerHandler) {
      return (Request request) async {
        final response = await innerHandler(request);
        return response.change(headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type',
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

  // --- Route handlers ---

  Response _handleIndex(Request request) {
    return Response.ok(
      _cachedHtml!,
      headers: {'Content-Type': 'text/html; charset=utf-8'},
    );
  }

  // --- API stubs (retournent des données vides mais valides) ---
  // Seront remplacés par de vraies implémentations dans les blocs suivants

  Response _jsonOk(Object data) {
    return Response.ok(
      jsonEncode(data),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );
  }

  Response _handleApiState(Request request) {
    return _jsonOk({
      'ok': true,
      'currentName': 'idle',
      'remainSec': 0,
      'goalSec': 500 * 3600,
      'doneSec': 0,
      'overrunSec': 0,
      'dayWorkSec': 0,
      'daySleepSec': 0,
      'dayBreakSec': 0,
      'dayClopeSec': 0,
      'dayClopeCount': 0,
      'elapsedSec': 0,
      'started': false,
      'awaitOk': false,
      'paused': false,
      'dailyAlcohol': {'wine': 0, 'beer': 0, 'strong': 0},
      'yesterdayAlcohol': {'wine': 0, 'beer': 0, 'strong': 0},
      'dailyActions': [],
      'recentDrinks': [],
      'firsts': {},
      'timelineHtml': '',
    });
  }

  Response _handleApiSettings(Request request) {
    return _jsonOk({
      'manualBreakOnly': true,
      'penalty': {'enableOvertimeCounter': true},
      'actions': [
        {'key': 'work', 'label': 'Work', 'mode': 'work', 'minutes': 0, 'requireOk': false},
        {'key': 'dodo', 'label': 'Dodo', 'mode': 'sleep', 'minutes': 0, 'requireOk': false},
        {'key': 'clope', 'label': 'Clope', 'mode': 'break', 'minutes': 10, 'requireOk': true},
        {'key': 'manger', 'label': 'Manger', 'mode': 'break', 'minutes': 30, 'requireOk': true},
        {'key': 'douche', 'label': 'Douche', 'mode': 'break', 'minutes': 10, 'requireOk': true},
      ],
      'alcoholVolumes': {'beer': 0.5, 'wine': 0.2, 'strong': 0.2},
    });
  }

  Response _handleApiConsumptionAll(Request request) {
    return _jsonOk({'ok': true, 'data': []});
  }

  Response _handleApiDrinksWeeks(Request request) {
    return _jsonOk([]);
  }

  Response _handleApiMonthlySummary(Request request) {
    return _jsonOk({
      'ok': true,
      'month': DateTime.now().toString().substring(0, 7),
      'totalWorkMin': 0,
      'totalSleepMin': 0,
      'avgWorkMin': 0,
      'avgSleepMin': 0,
      'totalClope': 0,
      'avgClope': 0,
      'clopeFreeDays': 0,
      'alcoholFreeDays': 0,
      'activeDays': 0,
      'daily': [],
    });
  }

  Response _handleApiNoteGet(Request request) {
    final d = request.url.queryParameters['d'] ?? '';
    return _jsonOk({'ok': true, 'day': d, 'content': ''});
  }

  Response _handleApiNotesAll(Request request) {
    return _jsonOk({'ok': true, 'notes': []});
  }

  Response _handleApiQuickNote(Request request) {
    return _jsonOk({'ok': true, 'content': ''});
  }

  Response _handleApiActionNote(Request request) {
    return _jsonOk({'ok': true, 'content': ''});
  }

  Future<Response> _handleApiCmd(Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final cmd = data['cmd'] as String? ?? '';
    return _jsonOk({'ok': true, 'cmd': cmd});
  }

  Future<Response> _handleApiDrinksAdd(Request request) async {
    await request.readAsString();
    return _jsonOk({'ok': true, 'type': '', 'n': 1, 'totals': {'wine': 0, 'beer': 0, 'strong': 0}});
  }

  Future<Response> _handleApiDrinksAdjust(Request request) async {
    await request.readAsString();
    return _jsonOk({'ok': true, 'total': 0, 'current': 0, 'added': 0});
  }

  Future<Response> _handleApiNotePost(Request request) async {
    await request.readAsString();
    return _jsonOk({'ok': true});
  }

  Future<Response> _handleApiQuickNotePost(Request request) async {
    await request.readAsString();
    return _jsonOk({'ok': true});
  }

  Future<Response> _handleApiActionNotePost(Request request) async {
    await request.readAsString();
    return _jsonOk({'ok': true});
  }

  Future<Response> _handleApiGoal(Request request) async {
    await request.readAsString();
    return _jsonOk({'ok': true});
  }

  Future<Response> _handleApiCustomActions(Request request) async {
    await request.readAsString();
    return _jsonOk({'ok': true});
  }

  Future<Response> _handleApiRemoveAction(Request request) async {
    await request.readAsString();
    return _jsonOk({'ok': true});
  }

  Future<Response> _handleApiAlcoholVolumes(Request request) async {
    await request.readAsString();
    return _jsonOk({'ok': true});
  }
}
