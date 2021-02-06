import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:futcrick_admin/AuthService.dart';
import 'package:futcrick_admin/Constants.dart';
import 'package:futcrick_admin/Extension.dart';
import 'package:futcrick_admin/Pages/SignIn.dart';
import 'package:futcrick_admin/Pages/team/team.dart';
import 'package:provider/provider.dart';

import 'Pages/blogpost/BlogPost.dart';
import 'Pages/home/Home.dart';
import 'Pages/matches/Matches.dart';
import 'Pages/profile/Profile.dart';

final CollectionReference postRef =
    FirebaseFirestore.instance.collection('posts');

// final CollectionReference likedRef =
//     FirebaseFirestore.instance.collection('liked');

final CollectionReference commentsRef =
    FirebaseFirestore.instance.collection('comments');

final CollectionReference matchesRef =
    FirebaseFirestore.instance.collection('matches');

final CollectionReference usersRef =
    FirebaseFirestore.instance.collection('users');

final CollectionReference trophiesRef =
    FirebaseFirestore.instance.collection('trophies');

final Timestamp timeStamp = Timestamp.now();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
            create: (_) => AuthService(FirebaseAuth.instance)),
        StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges)
      ],
      child: MaterialApp(
        title: 'Futcrick',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
        ),
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User _firebaseUser = context.watch<User>();

    if (_firebaseUser != null) {
      print(_firebaseUser.displayName);
      print(_firebaseUser.email);
      print(_firebaseUser.photoURL);
      print(_firebaseUser.uid);
      return MainScreen(user: _firebaseUser);
    }
    return SignIn();
  }
}

class MainScreen extends StatefulWidget {
  final User user;

  MainScreen({Key key, title, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentPageIndex = 2;
  final List<Widget> pages = [];
  PageController _pageController;

  @override
  void initState() {
    pages.add(MyHomePage(user: widget.user));
    pages.add(Matches());
    pages.add(Team());
    pages.add(BlogPost());
    pages.add(Profile());
    _pageController = PageController(initialPage: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: PageView(
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: pages,
      )), //pages[_currentPageIndex]),
      bottomNavigationBar: Container(
        height: 60,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  color: backgroundColor,
                  offset: Offset(0, 0),
                  blurRadius: 20,
                  spreadRadius: 3)
            ]),
        child: Row(
          children: [
            navBarItem(Icons.home, Icons.home_outlined, 0, 'Home'),
            navBarItem(Icons.group_rounded, Icons.group_outlined, 2, 'Teams'),
            navBarItem(Icons.sports_soccer_rounded, Icons.sports_soccer_rounded,
                1, 'Matches'),
            navBarItem(Icons.whatshot, Icons.whatshot_outlined, 3, 'News'),
            navBarItem(Icons.account_circle, Icons.account_circle_outlined, 4,
                'Profile'),
          ],
        ),
      ),
    );
  }

  GestureDetector navBarItem(
      IconData selectedIcon, IconData unSelectedIcon, int index, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentPageIndex = index;
          _pageController.jumpToPage(index);
        });
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 30) / 5,
        child: Stack(
          children: [
            Center(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPageIndex == index
                        ? Colors.blue
                        : Colors.blue.withOpacity(0)),
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      index == _currentPageIndex
                          ? selectedIcon
                          : unSelectedIcon,
                      color: index == _currentPageIndex
                          ? Colors.white
                          : secondaryDark.withOpacity(0.6)),
                  AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 500),
                    style: index == _currentPageIndex
                        ? TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 12,
                            color: Colors.white)
                        : TextStyle(
                            fontFamily: 'Ubuntu',
                            fontSize: 12,
                            color: _currentPageIndex == index
                                ? Colors.white
                                : secondaryDark.withOpacity(0.6)),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 12,
                          color: _currentPageIndex == index
                              ? Colors.white
                              : secondaryDark.withOpacity(0.6)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ).center(),
    );
  }
}
