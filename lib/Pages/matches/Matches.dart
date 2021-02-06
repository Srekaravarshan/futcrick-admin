import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futcrick_admin/Constants.dart';
import 'package:futcrick_admin/Extension.dart';
import 'package:futcrick_admin/Pages/matches/NewMatch.dart';
import 'package:futcrick_admin/datamodel/MatchCard.dart';
import 'package:futcrick_admin/datamodel/MatchDataModel.dart';
import 'package:futcrick_admin/main.dart';

class Matches extends StatefulWidget {
  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  List<Padding> liveMatches = [];
  List<Padding> upcomingMatches = [];
  List<Padding> finishedMatches = [];

  Map<int, Widget> map = new Map();
  List<Widget> childWidgets;
  int selectedIndex = 0;

  @override
  void initState() {
    loadCupertinoTabs();
    super.initState();
  }

  loadCupertinoTabs() {
    map = new Map();
    map.putIfAbsent(0, () => loadTab("All"));
    map.putIfAbsent(1, () => loadTab("Live"));
    map.putIfAbsent(2, () => loadTab("Upcoming"));
    map.putIfAbsent(3, () => loadTab("Finished"));
  }

  Widget loadTab(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  Widget childWidget(String text) {
    return Center(child: Text(text));
  }

  loadChildWidgets() {
    childWidgets = [];
    childWidgets.add(childWidget("All"));
    childWidgets.add(childWidget("Live"));
    childWidgets.add(childWidget("Upcoming"));
    childWidgets.add(childWidget("Finished"));
    Widget getChildWidget() => childWidgets[selectedIndex];
  }

  Widget headingText(String text) {
    return Text(
      text,
      style:
          TextStyle(fontSize: 20, fontFamily: 'Ubuntu', color: Colors.white70),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                      TextSpan(text: 'I'),
                      TextSpan(
                          text: 'SL ', style: TextStyle(color: secondaryColor)),
                      TextSpan(text: 'Matches', style: TextStyle(fontSize: 20)),
                    ]),
              ).center(),
            ),
            CupertinoSegmentedControl(
              children: map,
              onValueChanged: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              selectedColor: secondaryColor,
              borderColor: secondaryColor,
              groupValue: selectedIndex,
              unselectedColor: backgroundColor,
            ),

            SizedBox(height: 30),

            StreamBuilder<QuerySnapshot>(
              stream: matchesRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: circularProgressIndicator(),
                  );
                }
                liveMatches.clear();
                upcomingMatches.clear();
                finishedMatches.clear();
                snapshot.data.docs.forEach((doc) {
                  MatchDataModel matchData = MatchDataModel.fromDocument(doc);
                  switch (matchData.stateOfMatch) {
                    case 'Live':
                      liveMatches.add(Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: MatchCard(matchData: matchData, isLive: true),
                      ));
                      break;
                    case 'Upcoming':
                      upcomingMatches.add(Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: MatchCard(
                          matchData: matchData,
                          isUpcoming: true,
                        ),
                      ));
                      break;
                    case 'Finished':
                      finishedMatches.add(Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child:
                            MatchCard(matchData: matchData, isFinished: true),
                      ));
                      break;
                  }
                });

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (selectedIndex == 1 ||
                            selectedIndex == 2 ||
                            selectedIndex == 3)
                        ? Container()
                        : headingText('Live matches').padding(left: 40),
                    (selectedIndex == 2 || selectedIndex == 3)
                        ? Container()
                        : SizedBox(height: 15),
                    (selectedIndex == 2 || selectedIndex == 3)
                        ? Container()
                        : liveMatches.length == 0
                            ? Container(
                                child: Center(
                                  child: Text('No live matches'),
                                ),
                              )
                            : ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return liveMatches.elementAt(index);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(height: 20);
                                },
                                itemCount: liveMatches.length,
                              ),
                    (selectedIndex == 2 || selectedIndex == 3)
                        ? Container()
                        : SizedBox(height: 50),

                    // upcoming
                    (selectedIndex == 2 ||
                            selectedIndex == 1 ||
                            selectedIndex == 3)
                        ? Container()
                        : headingText('Upcoming matches').padding(left: 40),
                    (selectedIndex == 1 || selectedIndex == 3)
                        ? Container()
                        : SizedBox(height: 15),
                    (selectedIndex == 1 || selectedIndex == 3)
                        ? Container()
                        : upcomingMatches.length == 0
                            ? Container(
                                child: Center(
                                  child:
                                      Text('Upcoming matches are not updated'),
                                ),
                              )
                            : ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return upcomingMatches.elementAt(index);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(height: 20);
                                },
                                itemCount: upcomingMatches.length,
                              ),
                    (selectedIndex == 1 || selectedIndex == 3)
                        ? Container()
                        : SizedBox(height: 50),

                    // finished
                    (selectedIndex == 3 ||
                            selectedIndex == 1 ||
                            selectedIndex == 2)
                        ? Container()
                        : headingText('Finished matches').padding(left: 40),
                    (selectedIndex == 1 || selectedIndex == 2)
                        ? Container()
                        : SizedBox(height: 15),
                    (selectedIndex == 1 || selectedIndex == 2)
                        ? Container()
                        : finishedMatches.length == 0
                            ? Container(
                                child: Center(
                                  child:
                                      Text('No finished matches in this year'),
                                ),
                              )
                            : ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return finishedMatches.elementAt(index);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(height: 20);
                                },
                                itemCount: finishedMatches.length,
                              ),
                    (selectedIndex == 1 || selectedIndex == 2)
                        ? Container()
                        : SizedBox(height: 50),
                  ],
                );
              },
            )

            // Expanded(
            //   child: getChildWidget(),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'matches',
        backgroundColor: secondaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewMatch()));
        },
      ),
    );
  }
}
