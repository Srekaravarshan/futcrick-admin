import 'package:cloud_firestore/cloud_firestore.dart';

class MatchDataModel {
  final String _imageUrl;
  final String _stateOfMatch;
  final String _homeTeamName;
  final String _awayTeamName;
  final String _homeTeamShortName;
  final String _awayTeamShortName;
  final String _place;
  final Timestamp _date;
  final Timestamp _startTime;
  final Timestamp _endTime;

  final int _goalT1;
  final int _goalT2;

  final int _freeKickT1;
  final int _freeKickT2;

  final int _cornerKickT1;
  final int _cornerKickT2;

  final int _possessionT1;
  final int _possessionT2;

  final int _shotsTakenT1;
  final int _shotsTakenT2;

  final int _shotsOnTargetT1;
  final int _shotsOnTargetT2;

  final Map<String, dynamic> _yellowCardsT1;
  final Map<String, dynamic> _yellowCardsT2;

  final int _yellowCardsCountT1;
  final int _yellowCardsCountT2;

  final Map<String, dynamic> _redCardsT1;
  final Map<String, dynamic> _redCardsT2;

  final int _redCardsCountT1;
  final int _redCardsCountT2;

  final String _winner;

  final String _description;

  final String _matchId;

  final Map<String, dynamic> _playerScoresT1;

  final Map<String, dynamic> _playerScoresT2;

  final Map<String, dynamic> _recentGoals;

  MatchDataModel(
      this._imageUrl,
      this._stateOfMatch,
      this._homeTeamName,
      this._awayTeamName,
      this._homeTeamShortName,
      this._awayTeamShortName,
      this._place,
      this._date,
      this._startTime,
      this._endTime,
      this._goalT1,
      this._goalT2,
      this._freeKickT1,
      this._freeKickT2,
      this._cornerKickT1,
      this._cornerKickT2,
      this._possessionT1,
      this._possessionT2,
      this._shotsTakenT1,
      this._shotsTakenT2,
      this._shotsOnTargetT1,
      this._shotsOnTargetT2,
      this._yellowCardsT1,
      this._yellowCardsT2,
      this._redCardsT1,
      this._redCardsT2,
      this._winner,
      this._description,
      this._matchId,
      this._playerScoresT1,
      this._playerScoresT2,
      this._yellowCardsCountT1,
      this._yellowCardsCountT2,
      this._redCardsCountT1,
      this._redCardsCountT2,
      this._recentGoals);

  factory MatchDataModel.fromDocument(DocumentSnapshot doc) {
    return MatchDataModel(
      doc['imageUrl'],
      doc['stateOfMatch'],
      doc['homeTeamName'],
      doc['awayTeamName'],
      doc['homeTeamShortName'],
      doc['awayTeamShortName'],
      doc['place'],
      doc['date'],
      doc['startTime'],
      doc['endTime'],
      doc['goalT1'],
      doc['goalT2'],
      doc['freeKickT1'],
      doc['freeKickT2'],
      doc['cornerKickT1'],
      doc['cornerKickT2'],
      doc['possessionT1'],
      doc['possessionT2'],
      doc['shotsTakenT1'],
      doc['shotsTakenT2'],
      doc['shotsOnTargetT1'],
      doc['shotsOnTargetT2'],
      doc['yellowCardsT1'],
      doc['yellowCardsT2'],
      doc['redCardsT1'],
      doc['redCardsT2'],
      doc['winner'],
      doc['description'],
      doc['matchId'],
      doc['playerScoresT1'],
      doc['playerScoresT2'],
      doc['yellowCardsCountT1'],
      doc['yellowCardsCountT2'],
      doc['redCardsCountT1'],
      doc['redCardsCountT2'],
      doc['recentGoals'],
    );
  }

  Map<String, dynamic> get recentGoals => _recentGoals;

  String get description => _description;

  String get winner => _winner;

  int get yellowCardsCountT1 => _yellowCardsCountT1;

  Map<String, dynamic> get redCardsT2 => _redCardsT2;

  Map<String, dynamic> get redCardsT1 => _redCardsT1;

  Map<String, dynamic> get yellowCardsT2 => _yellowCardsT2;

  Map<String, dynamic> get yellowCardsT1 => _yellowCardsT1;

  int get shotsOnTargetT2 => _shotsOnTargetT2;

  int get shotsOnTargetT1 => _shotsOnTargetT1;

  int get shotsTakenT2 => _shotsTakenT2;

  int get shotsTakenT1 => _shotsTakenT1;

  int get possessionT2 => _possessionT2;

  int get possessionT1 => _possessionT1;

  int get cornerKickT2 => _cornerKickT2;

  int get cornerKickT1 => _cornerKickT1;

  int get freeKickT2 => _freeKickT2;

  int get freeKickT1 => _freeKickT1;

  int get goalT2 => _goalT2;

  String get homeTeamShortName => _homeTeamShortName;

  int get goalT1 => _goalT1;

  Timestamp get endTime => _endTime;

  Timestamp get startTime => _startTime;

  Timestamp get date => _date;

  String get matchId => _matchId;

  String get place => _place;

  String get awayTeamName => _awayTeamName;

  String get homeTeamName => _homeTeamName;

  String get stateOfMatch => _stateOfMatch;

  Map<String, dynamic> get playerScoresT2 => _playerScoresT2;

  String get imageUrl => _imageUrl;

  String get awayTeamShortName => _awayTeamShortName;

  Map<String, dynamic> get playerScoresT1 => _playerScoresT1;

  int get yellowCardsCountT2 => _yellowCardsCountT2;

  int get redCardsCountT1 => _redCardsCountT1;

  int get redCardsCountT2 => _redCardsCountT2;
}
