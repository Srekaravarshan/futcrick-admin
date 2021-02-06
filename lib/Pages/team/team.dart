import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:futcrick_admin/Constants.dart';
import 'package:futcrick_admin/Extension.dart';
import 'package:futcrick_admin/datamodel/Player.dart';
import 'package:futcrick_admin/datamodel/Team.dart';

class Team extends StatefulWidget {
  @override
  _TeamDetailsState createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<Team> {
  Map<int, Widget> map = new Map();
  List<Widget> childWidgets;
  String selectedTeam;

  @override
  void initState() {
    selectedTeam = 'CSK';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
          child: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          color: backgroundColor.withOpacity(0.5),
          child: RichText(
            text: TextSpan(
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Ubuntu'),
                children: [
                  TextSpan(text: 'Team'),
                  TextSpan(
                      text: ' details ',
                      style: TextStyle(color: secondaryColor)),
                ]),
          ).center(),
        ),
        SizedBox(
          height: 35,
        ),
        Column(
          children: [
            Container(
              height: 160,
              child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    bool isSelected =
                        teamShortName.values.elementAt(index) == selectedTeam;
                    return Center(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: isSelected ? 160 : 150,
                        height: isSelected ? 160 : 150,
                        decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.85),
                            borderRadius: index == 0
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8))
                                : index == teamShortName.length - 1
                                    ? BorderRadius.only(
                                        bottomRight: Radius.circular(8),
                                        topRight: Radius.circular(8))
                                    : BorderRadius.all(Radius.circular(0))),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedTeam =
                                  teamShortName.values.elementAt(index);
                            });
                          },
                          child: Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 50,
                              backgroundImage: AssetImage(
                                  'assets/images/${teamShortName.values.elementAt(index)}.png'),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 10);
                  },
                  itemCount: teamShortName.length),
            ),
            SizedBox(height: 40),
            ListView.separated(
              itemCount: teamMap[selectedTeam].length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return SizedBox(height: 20);
              },
              itemBuilder: (context, index) {
                List<Player> playerList = teamMap[selectedTeam];
                return InkWell(
                  onTap: () {
                    showPlayerDetails(playerList, index);
                  },
                  child: myPlayerListTile(playerList, index),
                );
              },
            ),
          ],
        )
      ])),
    ));
  }

  myPlayerListTile(List<Player> playerList, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
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
                    playerList[index].position,
                    style: TextStyle(
                      fontFamily: 'FiraSans',
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  )
                ],
              ),
            ],
          ),
          Icon(Icons.navigate_next_rounded, color: secondaryDark)
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
                  SizedBox(height: 2),
                  Text(
                    'Age: ${playerList[index].age}',
                    style: TextStyle(
                        fontFamily: 'FiraSans',
                        color: Colors.white54,
                        fontSize: 14),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      playerList[index].bio,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'FiraSans', fontSize: 16, height: 2),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              )),
            ));
  }
}
