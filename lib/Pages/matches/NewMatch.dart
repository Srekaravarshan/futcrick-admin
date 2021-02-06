import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futcrick_admin/Constants.dart';
import 'package:futcrick_admin/Extension.dart';
import 'package:futcrick_admin/datamodel/MatchCard.dart';
import 'package:futcrick_admin/datamodel/MatchDataModel.dart';
import 'package:futcrick_admin/datamodel/Player.dart';
import 'package:futcrick_admin/datamodel/Team.dart';
import 'package:futcrick_admin/main.dart';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class NewMatch extends StatefulWidget {
  @override
  _NewMatchState createState() => _NewMatchState();
}

class _NewMatchState extends State<NewMatch> {
  String stateValue = 'Live';
  List teamList = [];
  String team1;
  String team2;
  TextEditingController _placeController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime _dateTime = DateTime.now();
  TimeOfDay _startTimeOfDay = TimeOfDay.now();
  TimeOfDay _endTimeOfDay = TimeOfDay.now();
  File file;
  String postId = Uuid().v4();
  String _fileError = '';
  String _descriptionError = '';
  String _placeError = '';
  bool _isUploading = false;
  SnackBar _snackBar = SnackBar(
    content: Text('Successfully updated'),
    duration: Duration(seconds: 2),
  );
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      teamShortName.forEach((k, v) {
        teamList.add(k);
      });
      team1 = teamList.elementAt(0);
      team2 = teamList.elementAt(0);
    });
  }

  Future<String> uploadImage(File imageFile) async {
    final Reference storageRef =
        FirebaseStorage.instance.ref().child("post_$postId.jpg");
    Task uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final startDateTime = DateTime(
      _dateTime.year,
      _dateTime.month,
      _dateTime.day,
      _startTimeOfDay.hour,
      _startTimeOfDay.minute,
    );
    final endDateTime = DateTime(
      _dateTime.year,
      _dateTime.month,
      _dateTime.day,
      _endTimeOfDay.hour,
      _endTimeOfDay.minute,
    );

    final startTimeFormat = DateFormat.jm().format(startDateTime);
    final endTimeFormat = DateFormat.jm().format(endDateTime);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('New match'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // image
              SizedBox(height: 10),
              Text('Background image'),
              _fileError == ''
                  ? Container()
                  : Text(_fileError, style: TextStyle(color: Colors.red)),
              SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white12,
                          border: Border.all(color: Colors.white)),
                      height: 200,
                      width: double.infinity,
                      child: file != null
                          ? Image.file(file)
                          : GestureDetector(
                              onTap: () async {
                                // ignore: deprecated_member_use
                                File file = await ImagePicker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {
                                  this.file = file;
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))
                                    // border: Border.all(color: secondaryColor, width: 1)
                                    ),
                                child: Text('Upload image').center(),
                              )).center()),
                  file != null ? SizedBox(height: 10) : Container(),
                  file != null
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              this.file = null;
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))
                                // border: Border.all(color: secondaryColor, width: 1)
                                ),
                            child: Text('Clear image').center(),
                          ),
                        )
                      : Container()
                ],
              ),
              SizedBox(height: 30),

              // state
              Text('State of match'),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
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
                  items: <String>['Live', 'Upcoming', 'Finished']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 30),

              // team 1
              Text('Home team'),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: DropdownButton<String>(
                  value: team1,
                  style: TextStyle(color: Colors.white),
                  underline: Container(
                    height: 0,
                  ),
                  isExpanded: true,
                  onChanged: (String newValue) {
                    setState(() {
                      team1 = newValue;
                    });
                  },
                  items: teamShortName.keys
                      .toList()
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 15),

              // team 2
              Text('Away team'),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: DropdownButton<String>(
                  value: team2,
                  style: TextStyle(color: Colors.white),
                  underline: Container(
                    height: 0,
                  ),
                  isExpanded: true,
                  onChanged: (String newValue) {
                    setState(() {
                      team2 = newValue;
                    });
                  },
                  items: teamShortName.keys
                      .toList()
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 30),

              // place
              _placeError == ''
                  ? Container()
                  : Text(_placeError, style: TextStyle(color: Colors.red)),
              _placeError == '' ? Container() : SizedBox(height: 3),
              TextField(
                controller: _placeController,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'place',
                ),
              ),
              SizedBox(height: 30),

              // description
              _descriptionError == ''
                  ? Container()
                  : Text(_descriptionError,
                      style: TextStyle(color: Colors.red)),
              _descriptionError == '' ? Container() : SizedBox(height: 3),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'description',
                ),
                maxLines: null,
                minLines: 5,
              ),
              SizedBox(height: 30),

              // date
              Text('Date'),
              SizedBox(height: 5),

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

              // time
              Text('Start time'),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(startTimeFormat),
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

              // time
              Text('End time'),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(endTimeFormat),
                    IconButton(
                        onPressed: () async {
                          TimeOfDay _pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _endTimeOfDay,
                          );
                          if (_pickedTime != null) {
                            setState(() {
                              _endTimeOfDay = _pickedTime;
                            });
                          }
                        },
                        icon: Icon(Icons.calendar_today_rounded,
                            color: secondaryColor))
                  ],
                ),
              ),
              SizedBox(height: 30),

              // preview and upload button
              Row(
                children: [
                  // preview
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      if (_placeController.text.trim() != '') {
                        if (file != null) {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 30),
                                  MatchCard(
                                    file: file,
                                    isPreview: true,
                                    matchData: MatchDataModel(
                                        '',
                                        stateValue,
                                        team1,
                                        team2,
                                        teamShortName[team1],
                                        teamShortName[team2],
                                        _placeController.text.trim(),
                                        Timestamp.fromDate(_dateTime),
                                        Timestamp.fromDate(startDateTime),
                                        Timestamp.fromDate(endDateTime),
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0,
                                        Map<String, dynamic>(),
                                        Map<String, dynamic>(),
                                        Map<String, dynamic>(),
                                        Map<String, dynamic>(),
                                        '',
                                        'hi this is the very very very very very very very very very very very very very very very very very very very very loooooooooooooooooooooooooooooooooonnnnnnnnnnnnng description',
                                        postId,
                                        Map<String, dynamic>(),
                                        Map<String, dynamic>(),
                                        0,
                                        0,
                                        0,
                                        0,
                                        Map<String, dynamic>()),
                                  ),
                                  SizedBox(height: 30)
                                ],
                              );
                            },
                          );

                          setState(() {
                            _fileError = '';
                          });
                        } else {
                          setState(() {
                            _fileError = 'Image cannot be null';
                          });
                        }
                        setState(() {
                          _placeError = '';
                        });
                      } else {
                        setState(() {
                          _placeError = 'Place cannot be null';
                        });
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: secondaryColor, width: 1)),
                      child: Text('Preview').center(),
                    ),
                  )),
                  SizedBox(width: 10),

                  // upload
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (_placeController.text.trim() != '') {
                          if (file != null) {
                            setState(() {
                              _fileError = '';
                              _isUploading = true;
                            });

                            Map<String, int> playerScoresT1 =
                                getPlayerScores(teamShortName[team1]);
                            Map<String, int> playerScoresT2 =
                                getPlayerScores(teamShortName[team2]);

                            await compressImage();

                            String url = await uploadImage(file);

                            await matchesRef.doc(postId).set({
                              'imageUrl': url,
                              'stateOfMatch': stateValue,
                              'homeTeamName': team1,
                              'awayTeamName': team2,
                              'homeTeamShortName': teamShortName[team1],
                              'awayTeamShortName': teamShortName[team2],
                              'place': _placeController.text.trim(),
                              'date': _dateTime,
                              'startTime': startDateTime,
                              'endTime': endDateTime,
                              'goalT1': 0,
                              'goalT2': 0,
                              'freeKickT1': 0,
                              'freeKickT2': 0,
                              'cornerKickT1': 0,
                              'cornerKickT2': 0,
                              'possessionT1': 0,
                              'possessionT2': 0,
                              'shotsTakenT1': 0,
                              'shotsTakenT2': 0,
                              'shotsOnTargetT1': 0,
                              'shotsOnTargetT2': 0,
                              'yellowCardsT1': playerScoresT1,
                              'yellowCardsT2': playerScoresT2,
                              'yellowCardsCountT1': 0,
                              'yellowCardsCountT2': 0,
                              'redCardsT1': playerScoresT1,
                              'redCardsT2': playerScoresT2,
                              'redCardsCountT1': 0,
                              'redCardsCountT2': 0,
                              'winner': '',
                              'description': _descriptionController.text.trim(),
                              'matchId': postId,
                              'playerScoresT1': playerScoresT1,
                              'playerScoresT2': playerScoresT2,
                              'recentGoals': Map<String, dynamic>()
                            });

                            setState(() {
                              postId = Uuid().v4();
                              _isUploading = false;
                            });
                            // ignore: deprecated_member_use
                            _scaffoldKey.currentState.showSnackBar(_snackBar);
                            Timer(Duration(seconds: 2), () {
                              Navigator.pop(context);
                            });
                          } else {
                            setState(() {
                              _fileError = 'Image cannot be null';
                            });
                          }
                          setState(() {
                            _placeError = '';
                          });
                        } else {
                          setState(() {
                            _placeError = 'Place cannot be null';
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: _isUploading
                            ? Center(
                                child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator()),
                              )
                            : Text('Upload').center(),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        )));
  }

  Map<String, int> getPlayerScores(String teamShortName) {
    List<Player> teamList = teamMap[teamShortName];
    Map<String, int> playerScores = {};
    for (Player player in teamList) {
      playerScores.putIfAbsent(player.id.toString(), () => 0);
    }
    return playerScores;
  }
}
