import 'package:cloud_firestore/cloud_firestore.dart';

class TrophiesData {
  final String _teamShortName;
  final String _teamName;
  final int _matches;
  final int _totalGoals;
  final int _matchesWon;
  final int _matchesLost;
  final int _matchesTied;
  final int _points;
  final Map<String, dynamic> _trophies;

  TrophiesData(
      this._teamShortName,
      this._teamName,
      this._matches,
      this._totalGoals,
      this._matchesWon,
      this._matchesLost,
      this._matchesTied,
      this._points,
      this._trophies);

  factory TrophiesData.fromDocument(DocumentSnapshot doc) {
    return TrophiesData(
        doc['teamShortName'],
        doc['teamName'],
        doc['matches'],
        doc['totalGoals'],
        doc['matchesWon'],
        doc['matchesLost'],
        doc['matchesTied'],
        doc['points'],
        doc['trophies']);
  }

  Map<String, dynamic> get trophies => _trophies;

  int get points => _points;

  int get matchesTied => _matchesTied;

  int get matchesLost => _matchesLost;

  int get matchesWon => _matchesWon;

  int get totalGoals => _totalGoals;

  int get matches => _matches;

  String get teamName => _teamName;

  String get teamShortName => _teamShortName;
}
