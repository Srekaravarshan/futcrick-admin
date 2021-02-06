import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futcrick_admin/Constants.dart';
import 'package:futcrick_admin/Extension.dart';
import 'package:futcrick_admin/datamodel/MatchDataModel.dart';
import 'package:futcrick_admin/datamodel/Player.dart';
import 'package:futcrick_admin/main.dart';

class AddYellowCard extends StatefulWidget {
  final MatchDataModel matchData;
  final bool isHomeTeam;

  const AddYellowCard({Key key, this.matchData, this.isHomeTeam})
      : super(key: key);

  @override
  _AddYellowCardState createState() => _AddYellowCardState();
}

class _AddYellowCardState extends State<AddYellowCard> {
  String teamShortName;

  @override
  void initState() {
    teamShortName = widget.isHomeTeam
        ? widget.matchData.homeTeamShortName
        : widget.matchData.awayTeamShortName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add yellow card'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 50),
        itemCount: teamMap[teamShortName].length,
        separatorBuilder: (context, index) {
          return SizedBox(height: 40);
        },
        itemBuilder: (context, index) {
          List<Player> playerList = teamMap[teamShortName];
          return MyPlayerListTile(
            playerList: playerList,
            index: index,
            isHomeTeam: widget.isHomeTeam,
            matchData: widget.matchData,
          );
        },
      ),
    );
  }
}

class MyPlayerListTile extends StatefulWidget {
  final List<Player> playerList;
  final int index;
  final bool isHomeTeam;
  final MatchDataModel matchData;

  const MyPlayerListTile(
      {Key key, this.playerList, this.index, this.isHomeTeam, this.matchData})
      : super(key: key);

  @override
  _MyPlayerListTileState createState() => _MyPlayerListTileState();
}

class _MyPlayerListTileState extends State<MyPlayerListTile> {
  int playerScore;
  int actPlayerScore;
  Map<String, dynamic> playerScores;
  bool isUploading = false;
  int difference = 0;

  @override
  void initState() {
    playerScore = widget.isHomeTeam
        ? widget.matchData
            .yellowCardsT1[(widget.playerList[widget.index].id).toString()]
        : widget.matchData
            .yellowCardsT2[(widget.playerList[widget.index].id).toString()];
    actPlayerScore = widget.isHomeTeam
        ? widget.matchData
            .yellowCardsT1[(widget.playerList[widget.index].id).toString()]
        : widget.matchData
            .yellowCardsT2[(widget.playerList[widget.index].id).toString()];
    playerScores = widget.isHomeTeam
        ? widget.matchData.yellowCardsT1
        : widget.matchData.yellowCardsT2;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: secondaryColor,
                backgroundImage: AssetImage(
                    'assets/images/${widget.playerList[widget.index].id}.jpg'),
              ),
              SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.playerList[widget.index].name,
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Players details',
                    style: TextStyle(
                        fontFamily: 'FiraSans',
                        fontSize: 14,
                        color: Colors.white70,
                        decoration: TextDecoration.underline),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        isUploading = true;
                      });
                      Map<String, dynamic> recentGoals =
                          widget.matchData.recentGoals;
                      if (widget.isHomeTeam) {
                        recentGoals.putIfAbsent(
                            (widget.matchData.recentGoals.length + 1)
                                .toString(),
                            () => {
                                  'goals': difference,
                                  'isHome': true,
                                  'name': widget.playerList[widget.index].name,
                                  'timeStamp': FieldValue.serverTimestamp(),
                                  'type': 'yellow',
                                  'id': widget.playerList[widget.index].id
                                });
                        await matchesRef.doc(widget.matchData.matchId).update({
                          'yellowCardsCountT1':
                              widget.matchData.yellowCardsCountT1 + difference,
                          'yellowCardsT1': playerScores,
                          'recentGoals': recentGoals
                        });
                      } else {
                        recentGoals.putIfAbsent(
                            (widget.matchData.recentGoals.length + 1)
                                .toString(),
                            () => {
                                  'goals': difference,
                                  'isHome': false,
                                  'name': widget.playerList[widget.index].name,
                                  'timeStamp': FieldValue.serverTimestamp(),
                                  'type': 'yellow',
                                  'id': widget.playerList[widget.index].id
                                });
                        await matchesRef.doc(widget.matchData.matchId).update({
                          'yellowCardsCountT2':
                              widget.matchData.yellowCardsCountT2 + difference,
                          'yellowCardsT2': playerScores,
                          'recentGoals': recentGoals
                        });
                      }
                      setState(() {
                        actPlayerScore = actPlayerScore + difference;
                        playerScore = actPlayerScore;
                        difference = 0;
                        print('setState : $actPlayerScore');
                        print('setState : $playerScore');
                        isUploading = false;
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 80,
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      padding: EdgeInsets.all(6),
                      child: isUploading
                          ? Center(
                              child: Container(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Center(child: Text('Update')),
                    ),
                  )
                ],
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                actPlayerScore.toString(),
                style: TextStyle(fontSize: 30, fontFamily: 'Ubuntu'),
              ),
              SizedBox(width: 10),
              Text(
                difference > 0
                    ? '+' + difference.toString()
                    : difference.toString(),
                style: TextStyle(fontFamily: 'Ubuntu'),
              ),
              SizedBox(width: 20),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        difference += 1;
                        playerScore += 1;
                        playerScores.update(
                            (widget.playerList[widget.index].id).toString(),
                            (value) => value + 1);
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              topLeft: Radius.circular(4))),
                      child: Icon(Icons.add, color: Colors.blueAccent).center(),
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        difference -= 1;
                        playerScores.update(
                            (widget.playerList[widget.index].id).toString(),
                            (value) => value - 1);
                        playerScore -= 1;
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(4))),
                      child:
                          Icon(Icons.remove, color: Colors.redAccent).center(),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
