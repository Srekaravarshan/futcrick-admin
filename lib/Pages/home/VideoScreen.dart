import 'package:flutter/material.dart';
import 'package:futcrick_admin/Extension.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final String id;

  VideoScreen({this.id});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id == null ? 'x7LktUpBlz0' : widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape
            ? Scaffold(
                body: widget.id == null
                    ? Text('Invalid url').center()
                    : youtubeHierarchy(),
              )
            : Scaffold(
                appBar: AppBar(),
                body: widget.id == null
                    ? Text('Invalid url').center()
                    : youtubeHierarchy(),
              );
      },
    ), onWillPop: () {
      Navigator.pop(context);
      return;
    });
  }

  youtubeHierarchy() {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.fill,
          child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(isExpanded: true),
                  RemainingDuration(),
                  PlaybackSpeedButton(),
                ],
              ),
              builder: (context, widget) {
                return Column(
                  children: [
                    widget,
                  ],
                );
              }),
        ),
      ),
    );
  }
}
