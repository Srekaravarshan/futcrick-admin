import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futcrick_admin/AuthService.dart';
import 'package:futcrick_admin/Constants.dart';
import 'package:futcrick_admin/Extension.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User _user = context.watch<User>();

    return Scaffold(
      body: Column(
        children: [
          Center(
              child: CircleAvatar(
            backgroundImage: _user.photoURL == null
                ? Icon(
                    Icons.person,
                    color: secondaryDark,
                  )
                : NetworkImage(_user.photoURL),
            backgroundColor: secondaryColor,
            radius: 70.0,
          ).padding(top: 50, bottom: 20)),
          Text(_user.displayName == null ? 'Anonymous' : _user.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 28, fontFamily: 'Ubuntu'))
              .padding(left: 30, right: 30),
          SizedBox(height: 8),
          Text(_user.email,
              style: TextStyle(fontSize: 13, fontFamily: 'FiraSans')),
          SizedBox(height: 35),
          listItem(
              icon: Icons.favorite,
              title: 'Liked',
              onPressed: () {
                //TODO: create liked activicity
              }),
          SizedBox(height: 40),
          listItem(
              icon: Icons.person,
              title: 'About Futcrick',
              onPressed: () {
                //TODO: create about section
              }),
          Divider(color: Colors.white.withOpacity(0.6), height: 10)
              .padding(left: 30, right: 30),
          listItem(
              icon: Icons.privacy_tip_rounded,
              title: 'Privacy policy',
              onPressed: () {
                //TODO: create privacy policy section
              }),
          SizedBox(height: 40),
          listItem(
              icon: Icons.exit_to_app_rounded,
              title: 'Log out',
              onPressed: () {
                context.read<AuthService>().signOut();
              })
        ],
      ),
    );
  }
}
