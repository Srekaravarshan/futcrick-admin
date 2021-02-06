import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futcrick_admin/Constants.dart';
import 'package:futcrick_admin/Extension.dart';
import 'package:futcrick_admin/Pages/matches/AddGoal.dart';
import 'package:futcrick_admin/Pages/matches/AddRedCard.dart';
import 'package:futcrick_admin/Pages/matches/AddYellowCard.dart';
import 'package:futcrick_admin/datamodel/MatchCard.dart';
import 'package:futcrick_admin/datamodel/MatchDataModel.dart';
import 'package:futcrick_admin/datamodel/Player.dart';
import 'package:futcrick_admin/main.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class TeamDetails extends StatefulWidget {
  final String matchId;
  final String homeTeamShortName;
  final String awayTeamShortName;
  final Map<String, dynamic> playerScoresT1;
  final Map<String, dynamic> playerScoresT2;
  final MatchDataModel matchData;

  const TeamDetails(
      {Key key,
      this.matchId,
      this.homeTeamShortName,
      this.awayTeamShortName,
      this.playerScoresT1,
      this.playerScoresT2,
      this.matchData})
      : super(key: key);

  @override
  _TeamDetailsState createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
            '${widget.homeTeamShortName} vs ${widget.awayTeamShortName}',
            style: TextStyle(fontFamily: 'Ubuntu')),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
            stream: matchesRef.doc(widget.matchId).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return circularProgressIndicator().center();
              }
              MatchDataModel matchData =
                  MatchDataModel.fromDocument(snapshot.data);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  MatchCard(
                    matchData: matchData,
                    isLive: matchData.stateOfMatch == 'Live',
                    isUpcoming: matchData.stateOfMatch == 'Upcoming',
                    isFinished: matchData.stateOfMatch == 'Finished',
                    isClickable: false,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddGoal(
                                        matchData: matchData,
                                        isHomeTeam: true,
                                      )));
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: (MediaQuery.of(context).size.width - 5) / 4,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              color: secondaryColor),
                          child: Text('Add Goals\nTeam 1',
                                  textAlign: TextAlign.end)
                              .center(),
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddGoal(
                                      matchData: matchData,
                                      isHomeTeam: false)));
                        },
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: (MediaQuery.of(context).size.width - 5) / 4,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                color: secondaryColor),
                            child: Text('Add Goals\nTeam 2',
                                    textAlign: TextAlign.start)
                                .center(),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddYellowCard(
                                        matchData: matchData,
                                        isHomeTeam: true,
                                      )));
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: (MediaQuery.of(context).size.width - 5) / 4,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              color: Colors.yellow[700]),
                          child: Text('Add Yellow\ncard',
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.end)
                              .center(),
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddYellowCard(
                                      matchData: matchData,
                                      isHomeTeam: false)));
                        },
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: (MediaQuery.of(context).size.width - 5) / 4,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                color: Colors.yellow[700]),
                            child: Text('Add Yellow\ncard',
                                    style: TextStyle(color: Colors.black),
                                    textAlign: TextAlign.start)
                                .center(),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddRedCard(
                                        matchData: matchData,
                                        isHomeTeam: true,
                                      )));
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: (MediaQuery.of(context).size.width - 5) / 4,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              color: Colors.red),
                          child: Text('Add Red\ncard', textAlign: TextAlign.end)
                              .center(),
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddRedCard(
                                      matchData: matchData,
                                      isHomeTeam: false)));
                        },
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: (MediaQuery.of(context).size.width - 5) / 4,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                color: Colors.red),
                            child: Text('Add Red\ncard',
                                    textAlign: TextAlign.start)
                                .center(),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    constraints: BoxConstraints(maxWidth: 300),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: matchData.recentGoals.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map = matchData.recentGoals;
                          List<String> sortedKey = map.keys
                              .toList(growable: false)
                                ..sort((k2, k1) => map[k1]['timeStamp']
                                    .compareTo(map[k2]['timeStamp']));
                          DateTime date = DateTime.parse(
                              map[sortedKey.elementAt(index)]['timeStamp']
                                  .toDate()
                                  .toString());
                          return Container(
                              child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/images/${map[sortedKey.elementAt(index)]['id']}.jpg'),
                            ),
                            title:
                                Text(map[sortedKey.elementAt(index)]['name']),
                            trailing: map[sortedKey.elementAt(index)]['type'] ==
                                    'goal'
                                ? Text((map[sortedKey.elementAt(index)]
                                        ['goals'])
                                    .toString())
                                : map[sortedKey.elementAt(index)]['type'] ==
                                        'red'
                                    ? Container(
                                        height: 20,
                                        width: 15,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2)),
                                        ),
                                      )
                                    : Container(
                                        height: 20,
                                        width: 15,
                                        decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2)),
                                        ),
                                      ),
                            subtitle: Text(
                              '${DateFormat.jm().format(date)} (${timeago.format(date)})',
                              style: TextStyle(fontSize: 13),
                            ),
                          ));
                        }),
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ScoreBoard(matchData: matchData),
                        ),
                      );
                    },
                    child: Container(
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Text('View score board',
                                style: TextStyle(fontFamily: 'Ubuntu'))
                            .center()),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          matchData.homeTeamName,
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
                          matchData.awayTeamName,
                          style: TextStyle(fontFamily: 'Ubuntu', fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  myCompareWidget(
                      title: 'Possession',
                      homeTeam: matchData.possessionT1,
                      awayTeam: matchData.possessionT2),
                  SizedBox(height: 12),
                  myCompareWidget(
                      title: 'Shots taken',
                      homeTeam: matchData.shotsTakenT1,
                      awayTeam: matchData.shotsTakenT2),
                  SizedBox(height: 12),
                  myCompareWidget(
                      title: 'Shots on target',
                      homeTeam: matchData.shotsOnTargetT1,
                      awayTeam: matchData.shotsOnTargetT2),
                  SizedBox(height: 12),
                  myCompareWidget(
                      title: 'Free kick',
                      homeTeam: matchData.freeKickT1,
                      awayTeam: matchData.freeKickT2),
                  SizedBox(height: 12),
                  myCompareWidget(
                      title: 'Corner kick',
                      homeTeam: matchData.cornerKickT1,
                      awayTeam: matchData.cornerKickT2),
                  SizedBox(height: 12),
                  myCompareWidget(
                      title: 'Yellow cards',
                      homeTeam: matchData.yellowCardsCountT1,
                      awayTeam: matchData.yellowCardsCountT2),
                  SizedBox(height: 12),
                  myCompareWidget(
                      title: 'Red cards',
                      homeTeam: matchData.redCardsCountT1,
                      awayTeam: matchData.redCardsCountT2),
                  SizedBox(height: 40),
                  myTeamDetailButton(
                      teamShortName: matchData.homeTeamShortName,
                      teamName: matchData.homeTeamName,
                      isHomeTeam: true,
                      playerScores: matchData.playerScoresT1),
                  SizedBox(height: 15),
                  myTeamDetailButton(
                      teamShortName: matchData.awayTeamShortName,
                      teamName: matchData.awayTeamName,
                      isHomeTeam: false,
                      playerScores: matchData.playerScoresT2),
                  SizedBox(height: 50),
                ],
              );
            }),
      ),
    );
  }

  Widget myCompareWidget({String title, int homeTeam, int awayTeam}) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        homeTeam.toString(),
        style: TextStyle(fontFamily: 'FiraSans', fontSize: 22),
      ),
      SizedBox(width: 10),
      SizedBox(
        width: 150,
        child: Text(
          title,
          style: TextStyle(
              color: secondaryColor, fontSize: 16, fontFamily: 'Ubuntu'),
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(width: 10),
      Text(
        awayTeam.toString(),
        style: TextStyle(fontFamily: 'FiraSans', fontSize: 22),
      ),
    ]);
  }

  Widget myTeamDetailButton(
      {String teamShortName,
      String teamName,
      bool isHomeTeam,
      Map<String, dynamic> playerScores}) {
    return InkWell(
      onTap: () {
        showTeamDetails(teamShortName, teamName, isHomeTeam, playerScores);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 28.0,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.asset('assets/images/$teamShortName.png'),
            ),
          ),
          SizedBox(width: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                teamShortName,
                style: TextStyle(fontFamily: 'Ubuntu', fontSize: 22),
              ),
              SizedBox(height: 2),
              Text(
                'Team details',
                style: TextStyle(
                    fontFamily: 'FiraSans',
                    fontSize: 14,
                    color: Colors.white70,
                    decoration: TextDecoration.underline),
              )
            ],
          )
        ],
      ),
    );
  }

  showTeamDetails(String teamShortName, String teamName, bool isHomeTeam,
      Map<String, dynamic> playerScores) {
    return showModalBottomSheet(
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
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    child: Image.asset('assets/images/$teamShortName.png'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    teamName,
                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 22),
                  ),
                  SizedBox(height: 30),
                  ListView.separated(
                    itemCount: teamMap[teamShortName].length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 20);
                    },
                    itemBuilder: (context, index) {
                      List<Player> playerList = teamMap[teamShortName];
                      return InkWell(
                        onTap: () {
                          showPlayerDetails(playerList, index);
                        },
                        child: myPlayerListTile(
                            playerList, index, isHomeTeam, playerScores),
                      );
                    },
                  )
                ],
              )),
            ));
  }

  myPlayerListTile(List<Player> playerList, int index, bool isHomeTeam,
      Map<String, dynamic> playerScores) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: secondaryColor,
                backgroundImage:
                    AssetImage('assets/images/${playerList[index].id}.jpg'),
              ),
              SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playerList[index].name,
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    'Players details',
                    style: TextStyle(
                        fontFamily: 'FiraSans',
                        fontSize: 14,
                        color: Colors.white70,
                        decoration: TextDecoration.underline),
                  )
                ],
              )
            ],
          ),
          Text(
            playerScores[(playerList[index].id).toString()].toString(),
            style: TextStyle(fontSize: 22, fontFamily: 'Ubuntu'),
          )
        ],
      ),
    );
  }

  showPlayerDetails(List<Player> playerList, int index) {
    return showModalBottomSheet(
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
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        AssetImage('assets/images/${playerList[index].id}.jpg'),
                    // child: Image.asset(
                    //   'assets/images/${playerList[index].id}.jpg',
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    playerList[index].name,
                    style: TextStyle(fontFamily: 'Ubuntu', fontSize: 22),
                  ),
                  Text(
                    'Age: ${playerList[index].age}',
                    style: TextStyle(
                        fontFamily: 'FiraSans',
                        color: Colors.white54,
                        fontSize: 14),
                  ),
                  SizedBox(height: 30),
                  Text(
                    playerList[index].bio,
                    style: TextStyle(
                        fontFamily: 'FiraSans', fontSize: 22, height: 2),
                  ),
                ],
              )),
            ));
  }
}

class ScoreBoard extends StatefulWidget {
  final MatchDataModel matchData;

  const ScoreBoard({Key key, this.matchData}) : super(key: key);

  @override
  _ScoreBoardState createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  Map<int, Widget> map = new Map();
  Map<int, Widget> mapSubItems = new Map();
  int selectedIndex = 0;
  int selectedSubItemIndex = 0;
  String shortName;

  @override
  void initState() {
    loadCupertinoTabs();
    shortName = widget.matchData.homeTeamShortName;
    super.initState();
  }

  loadCupertinoTabs() {
    map = new Map();
    mapSubItems = new Map();
    map.putIfAbsent(0, () => loadTab(widget.matchData.homeTeamShortName));
    map.putIfAbsent(1, () => loadTab(widget.matchData.awayTeamShortName));
    mapSubItems.putIfAbsent(0, () => loadTab('Goals'));
    mapSubItems.putIfAbsent(1, () => loadTab('Yellow'));
    mapSubItems.putIfAbsent(2, () => loadTab('Red'));
  }

  Widget loadTab(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Text(text,
          style: TextStyle(color: Colors.black, fontFamily: 'Ubuntu')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8)),
                      color: Colors.grey[100],
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(2, 0),
                            blurRadius: 10)
                      ]),
                  child: Center(
                    child: CupertinoSegmentedControl(
                      children: map,
                      onValueChanged: (value) {
                        setState(() {
                          selectedIndex = value;
                          shortName = value == 0
                              ? widget.matchData.homeTeamShortName
                              : widget.matchData.awayTeamShortName;
                        });
                      },
                      selectedColor: secondaryColor,
                      borderColor: secondaryColor,
                      groupValue: selectedIndex,
                      unselectedColor: Colors.grey[200],
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      'Score board',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 22,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: CupertinoSegmentedControl(
                        children: mapSubItems,
                        onValueChanged: (value) {
                          setState(() {
                            selectedSubItemIndex = value;
                          });
                        },
                        selectedColor: secondaryColor,
                        borderColor: secondaryColor,
                        groupValue: selectedSubItemIndex,
                        unselectedColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(height: 20),
                    myTableWidget(
                        'Player name',
                        selectedSubItemIndex == 0
                            ? 'Goal'
                            : selectedSubItemIndex == 1
                                ? 'Yellow'
                                : 'Red'),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: teamMap[shortName].length,
                      itemBuilder: (context, index) {
                        List<Player> playerList = teamMap[shortName];
                        return shortName == widget.matchData.homeTeamShortName
                            ? myTableWidget(
                                playerList.elementAt(index).name,
                                selectedSubItemIndex == 0
                                    ? (widget.matchData.playerScoresT1[(playerList.elementAt(index).id).toString()])
                                        .toString()
                                    : selectedSubItemIndex == 1
                                        ? (widget.matchData.yellowCardsT1[
                                                (playerList.elementAt(index).id)
                                                    .toString()])
                                            .toString()
                                        : (widget.matchData.redCardsT1[(playerList.elementAt(index).id).toString()])
                                            .toString())
                            : myTableWidget(
                                playerList.elementAt(index).name,
                                selectedSubItemIndex == 0
                                    ? (widget.matchData.playerScoresT2[
                                            (playerList.elementAt(index).id)
                                                .toString()])
                                        .toString()
                                    : selectedSubItemIndex == 1
                                        ? (widget.matchData.yellowCardsT2[
                                                (playerList.elementAt(index).id)
                                                    .toString()])
                                            .toString()
                                        : (widget.matchData
                                                .redCardsT2[(playerList.elementAt(index).id).toString()])
                                            .toString());
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  myTableWidget(String title, String data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontFamily: 'Ubuntu', fontSize: 16, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            data,
            style: TextStyle(
              fontFamily: 'FiraSans',
              fontSize: 18,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
