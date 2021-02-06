import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futcrick_admin/Constants.dart';
import 'package:futcrick_admin/Pages/matches/TeamDetails.dart';
import 'package:futcrick_admin/datamodel/MatchDataModel.dart';
import 'package:futcrick_admin/main.dart';
import 'package:intl/intl.dart';

class MatchCard extends StatefulWidget {
  final MatchDataModel matchData;
  final File file;
  final bool isPreview;
  final bool isLive;
  final bool isUpcoming;
  final bool isFinished;
  final bool isClickable;

  const MatchCard(
      {Key key,
      this.matchData,
      this.file,
      this.isPreview = false,
      this.isLive = false,
      this.isUpcoming = false,
      this.isFinished = false,
      this.isClickable = true})
      : super(key: key);

  @override
  _MatchCardState createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  String _startTime;
  String _endTime;
  String _matchDate;
  String stateValue;
  List<String> stateList;
  bool stateUpdating = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
        widget.matchData.startTime.millisecondsSinceEpoch));
    _endTime = DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
        widget.matchData.endTime.millisecondsSinceEpoch));
    _matchDate = DateFormat('dd - MM - yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(
            widget.matchData.date.millisecondsSinceEpoch));
    stateList = ['Live', 'Upcoming', 'Finished'];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 320,
      child: InkWell(
        splashColor: widget.isClickable ? Colors.white24 : Colors.transparent,
        highlightColor:
            widget.isClickable ? Colors.white24 : Colors.transparent,
        focusColor: widget.isClickable ? Colors.white24 : Colors.transparent,
        onTap: widget.isClickable
            ? () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TeamDetails(
                              matchId: widget.matchData.matchId,
                              homeTeamShortName:
                                  widget.matchData.homeTeamShortName,
                              awayTeamShortName:
                                  widget.matchData.awayTeamShortName,
                              playerScoresT1: widget.matchData.playerScoresT1,
                              playerScoresT2: widget.matchData.playerScoresT2,
                              matchData: widget.matchData,
                            )));
              }
            : () {},
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: secondaryDark,
                border: Border.all(
                    color: widget.isLive ? Colors.white : Colors.white38,
                    width: 2),
                boxShadow: [
                  BoxShadow(
                      color:
                          widget.isLive ? Colors.white54 : Colors.transparent,
                      offset: Offset(1, 1),
                      blurRadius: 10)
                ],
                borderRadius: BorderRadius.all(Radius.circular(6)),
                image: DecorationImage(
                  image: widget.isPreview
                      ? FileImage(widget.file)
                      : NetworkImage(widget.matchData.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: backgroundColor.withOpacity(0.5),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Ubuntu',
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              // backgroundImage: AssetImage(
                              //     'assets/images/${widget.matchData.homeTeamShortName}.png'),
                              radius: 30.0,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.asset(
                                    'assets/images/${widget.matchData.homeTeamShortName}.png'),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              widget.matchData.homeTeamShortName,
                              style: TextStyle(
                                fontFamily: 'FiraSans',
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            )
                          ],
                        ),
                        widget.isUpcoming
                            ? Container()
                            : Row(
                                children: [
                                  Stack(
                                    children: [
                                      Text(
                                        '${widget.matchData.goalT1} - ${widget.matchData.goalT2}',
                                        style: TextStyle(
                                            fontFamily: 'Ubuntu',
                                            fontSize: 50,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        '${widget.matchData.goalT1} - ${widget.matchData.goalT2}',
                                        style: TextStyle(
                                            fontFamily: 'Ubuntu',
                                            fontSize: 50,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 2
                                              ..color = backgroundColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30.0,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.asset(
                                    'assets/images/${widget.matchData.awayTeamShortName}.png'),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              widget.matchData.awayTeamShortName,
                              style: TextStyle(
                                fontFamily: 'FiraSans',
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$_startTime - $_endTime\n$_matchDate',
                            style: TextStyle(
                                fontFamily: 'FiraSans', color: Colors.white70),
                          ),
                          SizedBox(width: 15),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'At ${widget.matchData.place}',
                                  style: TextStyle(
                                      fontFamily: 'FiraSans',
                                      color: Colors.white70),
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.right,
                                ),
                                widget.isClickable
                                    ? Text(
                                        'View more details >',
                                        style: TextStyle(
                                          fontFamily: 'FiraSans',
                                          fontSize: 12,
                                          color: Colors.white,
                                          decoration: TextDecoration.underline,
                                        ),
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.right,
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                right: 5,
                top: 5,
                child: InkWell(
                  onTap: editOnClick,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(Icons.edit, color: Colors.blue),
                  ),
                )),
            widget.isLive
                ? Positioned(
                    left: 8,
                    top: 8,
                    child: Row(
                      children: [
                        Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: backgroundColor, width: 2)),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Live',
                          style: TextStyle(fontFamily: 'Ubuntu'),
                        )
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  editOnClick() {
    stateValue = widget.matchData.stateOfMatch;

    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(44.0)),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => Container(
              decoration: BoxDecoration(
                color: sheetColor,
              ),
              height: MediaQuery.of(context).size.height * 0.85,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Text('Edit match details',
                      style: TextStyle(fontFamily: 'Ubuntu', fontSize: 22)),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          widget.matchData.homeTeamName,
                          style: TextStyle(fontFamily: 'Ubuntu', fontSize: 20),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                          child: Text(
                        'vs',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'FiraSans',
                            color: secondaryColor),
                        textAlign: TextAlign.center,
                      )),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          widget.matchData.awayTeamName,
                          style: TextStyle(fontFamily: 'Ubuntu', fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: StatefulBuilder(
                      builder: (context, setState) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: DropdownButton<String>(
                          value: stateValue,
                          style: TextStyle(color: Colors.white),
                          underline: Container(
                            height: 0,
                          ),
                          isExpanded: true,
                          onChanged: (String newValue) {
                            setState(() {
                              stateValue = newValue;
                            });
                          },
                          items: stateList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  StatefulBuilder(
                    builder: (context, setState) => InkWell(
                      onTap: () async {
                        setState(() {
                          stateUpdating = true;
                        });
                        await matchesRef
                            .doc(widget.matchData.matchId)
                            .update({'stateOfMatch': stateValue});
                        setState(() {
                          stateUpdating = false;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        padding: EdgeInsets.all(8),
                        child: stateUpdating
                            ? Center(
                                child: Container(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator()))
                            : Center(child: Text('Update')),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  EditCard(
                    title: 'Possession',
                    homeTeam: widget.matchData.possessionT1,
                    awayTeam: widget.matchData.possessionT2,
                    homeTeamFieldName: 'possessionT1',
                    awayTeamFieldName: 'possessionT2',
                    matchId: widget.matchData.matchId,
                  ),
                  SizedBox(height: 15),
                  EditCard(
                    title: 'Corner kick',
                    homeTeam: widget.matchData.cornerKickT1,
                    awayTeam: widget.matchData.cornerKickT2,
                    homeTeamFieldName: 'cornerKickT1',
                    awayTeamFieldName: 'cornerKickT2',
                    matchId: widget.matchData.matchId,
                  ),
                  SizedBox(height: 15),
                  EditCard(
                    title: 'Free kick',
                    homeTeam: widget.matchData.freeKickT1,
                    awayTeam: widget.matchData.cornerKickT2,
                    homeTeamFieldName: 'freeKickT1',
                    awayTeamFieldName: 'freeKickT2',
                    matchId: widget.matchData.matchId,
                  ),
                  SizedBox(height: 15),
                  EditCard(
                    title: 'Shots taken',
                    homeTeam: widget.matchData.shotsTakenT1,
                    awayTeam: widget.matchData.shotsTakenT2,
                    homeTeamFieldName: 'shotsTakenT1',
                    awayTeamFieldName: 'shotsTakenT2',
                    matchId: widget.matchData.matchId,
                  ),
                  SizedBox(height: 15),
                  EditCard(
                    title: 'Shots on target',
                    homeTeam: widget.matchData.shotsOnTargetT1,
                    awayTeam: widget.matchData.shotsOnTargetT2,
                    homeTeamFieldName: 'shotsOnTargetT1',
                    awayTeamFieldName: 'shotsOnTargetT2',
                    matchId: widget.matchData.matchId,
                  ),
                  SizedBox(height: 30),
                  MyDateTime(matchData: widget.matchData),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text('Confirm delete'),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel')),
                              FlatButton(
                                  onPressed: () async {
                                    //https://firebasestorage.googleapis.com/v0/b/futcrick-f5735.appspot.com/o/post_356e7c64-3761-4e14-bcc4-da62b29d0060.jpg?alt=media&token=fbf5e550-a075-4575-b7fd-fbbcaa923dd2
                                    String filePath = widget.matchData.imageUrl
                                        .replaceAll(
                                            new RegExp(
                                                r'https://firebasestorage.googleapis.com/v0/b/futcrick-f5735.appspot.com/o/'),
                                            '')
                                        .split('?')[0];

                                    await matchesRef
                                        .doc(widget.matchData.matchId)
                                        .delete();
                                    Navigator.pop(context);
                                    await FirebaseStorage.instance
                                        .ref()
                                        .child(filePath)
                                        .delete();
                                  },
                                  child: Text('Delete')),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: secondaryColor)),
                      child: Center(child: Text('Delete match')),
                    ),
                  ),
                  SizedBox(height: 30)
                ],
              )),
            ));
  }
}

class MyDateTime extends StatefulWidget {
  final MatchDataModel matchData;

  const MyDateTime({Key key, this.matchData}) : super(key: key);

  @override
  _MyDateTimeState createState() => _MyDateTimeState();
}

class _MyDateTimeState extends State<MyDateTime> {
  DateTime _dateTime;
  TimeOfDay _startTimeOfDay;
  TimeOfDay _endTimeOfDay;
  DateTime startDateTime;
  DateTime endDateTime;
  String startTimeFormat;
  String endTimeFormat;

  @override
  void initState() {
    _dateTime = DateTime.fromMillisecondsSinceEpoch(
        widget.matchData.date.millisecondsSinceEpoch);
    _startTimeOfDay = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(
            widget.matchData.startTime.millisecondsSinceEpoch));
    _endTimeOfDay = TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(
        widget.matchData.endTime.millisecondsSinceEpoch));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    startDateTime = DateTime(
      _dateTime.year,
      _dateTime.month,
      _dateTime.day,
      _startTimeOfDay.hour,
      _startTimeOfDay.minute,
    );
    endDateTime = DateTime(
      _dateTime.year,
      _dateTime.month,
      _dateTime.day,
      _endTimeOfDay.hour,
      _endTimeOfDay.minute,
    );

    startTimeFormat = DateFormat.jm().format(startDateTime);
    endTimeFormat = DateFormat.jm().format(endDateTime);

    bool isUpdatingDate = false;
    bool isUpdatingStartTime = false;
    bool isUpdatingEndTime = false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                    '${_dateTime.day} - ${_dateTime.month} - ${_dateTime.year}'),
                IconButton(
                    onPressed: () async {
                      DateTime _pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _dateTime,
                          firstDate: DateTime(DateTime.now().year),
                          lastDate: DateTime(DateTime.now().year + 1));
                      if (_pickedDate != null) {
                        setState(() {
                          _dateTime = _pickedDate;
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_today_rounded,
                        color: secondaryColor))
              ],
            ),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () async {
              setState(() {
                isUpdatingDate = true;
              });
              await matchesRef
                  .doc(widget.matchData.matchId)
                  .update({'date': _dateTime});
              setState(() {
                isUpdatingDate = false;
              });
            },
            child: Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              padding: EdgeInsets.all(8),
              child: isUpdatingDate
                  ? Center(
                      child: Container(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator()),
                    )
                  : Center(child: Text('Update')),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(DateFormat.jm().format(startDateTime)),
                IconButton(
                    onPressed: () async {
                      TimeOfDay _pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _startTimeOfDay,
                      );
                      if (_pickedTime != null) {
                        setState(() {
                          _startTimeOfDay = _pickedTime;
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_today_rounded,
                        color: secondaryColor))
              ],
            ),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () async {
              setState(() {
                isUpdatingStartTime = true;
              });
              await matchesRef
                  .doc(widget.matchData.matchId)
                  .update({'startTime': startDateTime});
              setState(() {
                isUpdatingStartTime = false;
              });
            },
            child: Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              padding: EdgeInsets.all(8),
              child: isUpdatingStartTime
                  ? Center(
                      child: Container(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator()),
                    )
                  : Center(child: Text('Update')),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(DateFormat.jm().format(endDateTime)),
                IconButton(
                    onPressed: () async {
                      print('timepicker pressed');
                      print(_endTimeOfDay);
                      TimeOfDay _pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _endTimeOfDay,
                      );
                      print(_pickedTime);
                      if (_pickedTime != null) {
                        print(_pickedTime);
                        setState(() {
                          _endTimeOfDay = _pickedTime;
                          print(_endTimeOfDay);
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_today_rounded,
                        color: secondaryColor))
              ],
            ),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () async {
              setState(() {
                isUpdatingEndTime = true;
              });
              await matchesRef
                  .doc(widget.matchData.matchId)
                  .update({'endTime': endDateTime});
              setState(() {
                isUpdatingEndTime = false;
              });
            },
            child: Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              padding: EdgeInsets.all(8),
              child: isUpdatingEndTime
                  ? Center(
                      child: Container(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator()),
                    )
                  : Center(child: Text('Update')),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class EditCard extends StatefulWidget {
  final String title;
  final int homeTeam;
  final int awayTeam;
  final String matchId;
  final String homeTeamFieldName;
  final String awayTeamFieldName;

  const EditCard(
      {Key key,
      this.title,
      this.homeTeam,
      this.awayTeam,
      this.matchId,
      this.homeTeamFieldName,
      this.awayTeamFieldName})
      : super(key: key);

  @override
  _EditCardState createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  int tempTeamScoreT1;
  int tempTeamScoreT2;
  bool isUpdating;

  @override
  void initState() {
    tempTeamScoreT1 = widget.homeTeam;
    tempTeamScoreT2 = widget.awayTeam;
    isUpdating = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      tempTeamScoreT1 += 1;
                    });
                  },
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4)),
                      ),
                      child: Center(
                        child: Icon(Icons.add, color: Colors.blue),
                      )),
                ),
                Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(color: Colors.white),
                            right: BorderSide(color: Colors.white))),
                    child: Center(
                        child: Text(
                      tempTeamScoreT1.toString(),
                      style: TextStyle(fontSize: 22, fontFamily: 'Ubuntu'),
                    ))),
                InkWell(
                  onTap: () {
                    setState(() {
                      tempTeamScoreT1 -= 1;
                    });
                  },
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(4)),
                      ),
                      child: Center(
                          child: Icon(Icons.remove, color: secondaryColor))),
                ),
              ],
            ),
            SizedBox(width: 10),
            Column(
              children: [
                Container(
                  width: 150,
                  child: Text(
                    widget.title,
                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    setState(() {
                      isUpdating = true;
                    });
                    await matchesRef.doc(widget.matchId).update({
                      widget.homeTeamFieldName: tempTeamScoreT1,
                      widget.awayTeamFieldName: tempTeamScoreT2,
                    });
                    setState(() {
                      isUpdating = false;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    padding: EdgeInsets.all(8),
                    child: isUpdating
                        ? Center(
                            child: Container(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator()),
                          )
                        : Center(child: Text('Update')),
                  ),
                )
              ],
            ),
            SizedBox(width: 10),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      tempTeamScoreT2 += 1;
                    });
                  },
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4)),
                      ),
                      child: Center(
                        child: Icon(Icons.add, color: Colors.blue),
                      )),
                ),
                Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(color: Colors.white),
                            right: BorderSide(color: Colors.white))),
                    child: Center(
                        child: Text(
                      tempTeamScoreT2.toString(),
                      style: TextStyle(fontSize: 22, fontFamily: 'Ubuntu'),
                    ))),
                InkWell(
                  onTap: () {
                    setState(() {
                      tempTeamScoreT2 -= 1;
                    });
                  },
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(4)),
                      ),
                      child: Center(
                          child: Icon(Icons.remove, color: secondaryColor))),
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
