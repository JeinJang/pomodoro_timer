import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pomotimer',
      home: MyHomePage(title: 'POMOTIMER'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _maxCycle = 2;
  final int _maxRound = 4;
  Timer _timer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  final List<int> _timerList = [15, 20, 25, 30, 35];
  int _time = 25;
  int _leftTime = 25 * 60;
  bool _isRunning = false;
  bool _isRoundOver = false;
  int _roundCounter = 0;
  int _cycleCounter = 0;

  void _play() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_leftTime == 0) {
        _incrementCycleCounter();
      } else {
        _leftTime--;
      }
      setState(() {});
    });
  }

  void _handleClickPausePlay() {
    if (_isRunning) {
      _timer.cancel();
    } else {
      _play();
    }
    _isRunning = !_isRunning;
    setState(() {});
  }

  void _incrementCycleCounter() {
    if (_cycleCounter + 1 == _maxCycle) {
      _cycleCounter++;
      _timer.cancel();
      Future.delayed(const Duration(seconds: 1), () {
        _cycleCounter = 0;
        _roundCounter++;
        if (_roundCounter == _maxRound) {
          return;
        } else {
          _leftTime = 5 * 60;
          _isRoundOver = true;
          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            if (_leftTime == 0) {
              _isRoundOver = false;
              _timer.cancel();
              _leftTime = _time * 60;
              _play();
            } else {
              _leftTime--;
            }
            setState(() {});
          });
        }
      });
    } else {
      _cycleCounter++;
      _leftTime = _time * 60;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[700],
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.deepOrange[700],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    '${_leftTime ~/ 60}'.padLeft(2, '0'),
                    style: TextStyle(
                      color: Colors.deepOrange[700],
                      fontSize: 80,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -2,
                      height: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                ':',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 80,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                width: 140,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    '${_leftTime % 60}'.padLeft(2, '0'),
                    style: TextStyle(
                      color: Colors.deepOrange[700],
                      fontSize: 80,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -2,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.transparent, Colors.white, Colors.transparent],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstIn,
            child: SizedBox(
              height: 50,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => TextButton(
                  onPressed: () => {
                    setState(() {
                      _isRunning = false;
                      _timer.cancel();
                      _roundCounter = 0;
                      _cycleCounter = 0;
                      _time = _timerList[index];
                      _leftTime = _timerList[index] * 60;
                    })
                  },
                  style: ButtonStyle(
                    backgroundColor: _time == _timerList[index]
                        ? MaterialStateProperty.all(Colors.white)
                        : MaterialStateProperty.all(Colors.deepOrange[700]),
                    splashFactory: NoSplash.splashFactory,
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  child: Text(
                    '${_timerList[index]}',
                    style: TextStyle(
                      color: _time == _timerList[index]
                          ? Colors.deepOrange[700]
                          : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                separatorBuilder: (context, index) => const SizedBox(width: 20),
                itemCount: _timerList.length,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          ..._isRoundOver
              ? [
                  const Text(
                    'REST',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      height: 8 / 3,
                    ),
                  ),
                ]
              : [
                  IconButton(
                    onPressed: _handleClickPausePlay,
                    color: Colors.black54,
                    icon: Icon(
                      _isRunning ? Icons.pause : Icons.play_arrow,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ],
          const SizedBox(
            height: 80,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_roundCounter/$_maxRound',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                    const Text(
                      'ROUND',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              SizedBox(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_cycleCounter/$_maxCycle',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                    const Text(
                      'GOAL',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
