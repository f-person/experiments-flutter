import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(TimerApp());

class TimerApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimerAppState();
  }
}

class _TimerAppState extends State<TimerApp>
    with SingleTickerProviderStateMixin {
  static const duration = const Duration(seconds: 1);

  int secondsPassed = 0;
  bool isActive = false;

  Timer timer;

  AnimationController _controller;

  void handleTick() {
    if (isActive) {
      setState(() {
        secondsPassed += 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(duration, (Timer t) {
      handleTick();
    });

    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), value: 0.0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    int seconds = secondsPassed % 60;
    int minutes = secondsPassed ~/ 60;
    int hours = secondsPassed ~/ (60 * 60);

    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Timer',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Timer'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomTextContainer(
                      label: 'HRS',
                      value: hours > 10
                          ? hours.toString()
                          : '0' + hours.toString()),
                  CustomTextContainer(
                      label: 'MIN',
                      value: minutes > 10
                          ? minutes.toString()
                          : '0' + minutes.toString()),
                  CustomTextContainer(
                      label: 'SEC',
                      value: seconds > 0
                          ? seconds.toString()
                          : '0' + seconds.toString()),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isActive = !isActive;
              isActive ? _controller.forward() : _controller.reverse();
            });
          },
          child: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: _controller,
          ),
        ),
      ),
    );
  }
}

class CustomTextContainer extends StatelessWidget {
  final String label;
  final String value;

  CustomTextContainer({this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 44,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
            ),
          )
        ],
      ),
    );
  }
}
