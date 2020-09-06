import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:shake/shake.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: EightBallPage(),
      ),
    );

class EightBall extends StatefulWidget {
  @override
  _EightBallPageState createState() => _EightBallPageState();
}

class _EightBallPageState extends State<EightBall> {
  bool isRefreshing = false;
  bool isSoundOn = true;
  int ballNumber = 1;
  AudioPlayer audioPlayer;

  Timer _timer;
  int _start = 3;

  @override
  void initState() {
    super.initState();
    ShakeDetector detector = ShakeDetector.autoStart(
        shakeThresholdGravity: 1.5,
        onPhoneShake: () {
          setState(() {
            changeNumber();
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Text('Instructions'),
                subtitle: Text(
                    'Ask the Magic 8 Ball your question and then either tap the ball or shake your device.'),
              ),
              ButtonBar(
                children: <Widget>[
                  Text('Play sound?'),
                  Switch(
                    value: isSoundOn,
                    onChanged: (value) {
                      setState(() {
                        isSoundOn = value;
                      });
                    },
                    activeColor: Colors.blue[800],
                  ),
                ],
              ),
            ],
          ),
        ),
        Center(
          child: FlatButton(
            child: Image.asset('assets/images/ball$ballNumber.png'),
            onPressed: () {
              setState(() {
                changeNumber();
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future playSound() async {
    audioPlayer = await AudioCache().play("sounds/shake.mp3");
  }

  void changeNumber() {
    if (!isRefreshing) {
      startTimer();
      ballNumber = Random().nextInt(5) + 1;
      if (isSoundOn) {
        playSound();
      }
    }
  }

  void startTimer() {
    isRefreshing = true;
    const duration = const Duration(seconds: 1); // how often the timer runs
    _timer = new Timer.periodic(
      duration,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            isRefreshing = false;
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }
}

class EightBallPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text('Magic 8 Ball'),
      ),
      body: EightBall(),
    );
  }
}
