import 'package:crud_task/AlarmPage.dart';
import 'package:crud_task/ClockPage.dart';
import 'package:crud_task/TimerPage.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:get/get.dart';

import 'Productspage.dart';

class StopwatchApp extends StatefulWidget {
  const StopwatchApp({super.key});

  @override
  _StopwatchAppState createState() => _StopwatchAppState();
}

class _StopwatchAppState extends State<StopwatchApp> {
  int _selectedIndex = 3;
  bool _isRunning = false;
  Stopwatch _stopwatch = Stopwatch();

  String? stopminutes = '';
  String? stopsecs = '';
  String? stopmilsecs = '';
  Timer? _timer;

  String formattedTime() {
    // Format the stopwatch time as a string in HH:mm:ss.milliseconds format
    int milliseconds = _stopwatch.elapsedMilliseconds;
    int seconds = (milliseconds / 1000).floor();
    int minutes = (seconds / 60).floor();
    int hours = (minutes / 60).floor();
    milliseconds = milliseconds % 1000;
    seconds = seconds % 60;
    minutes = minutes % 60;
    setState(() {
      stopminutes = minutes.toString().padLeft(2, '0');
      stopsecs = seconds.toString().padLeft(2, '0');
      stopmilsecs = milliseconds.toString().padLeft(2, '0');
    });
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}:${(milliseconds / 10).floor().toString().padLeft(2, '0')}';
  }

  void _startStopwatch() {
    setState(() {
      _isRunning = true;
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {});
      });
    });
  }

  void _stopStopwatch() {
    setState(() {
      _isRunning = false;
      _stopwatch.stop();
      _timer?.cancel();
    });
  }

  void _resetStopwatch() {
    setState(() {
      _isRunning = false;
      _stopwatch.stop();
      _stopwatch.reset();
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 163, 60, 182),
        title: const Text('Products'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProductsPage()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Visibility(
              visible: _isRunning,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _resetStopwatch();
                  });
                },
                child: const Text(
                  "Reset",
                  style: TextStyle(
                      fontSize: 15.0, color: Color.fromARGB(255, 136, 91, 212)),
                ),
              )),
          FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 153, 109, 230),
            onPressed: () {
              _isRunning ? _stopStopwatch() : _startStopwatch();
            },
            child: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
          ),
          Visibility(
              visible: _isRunning,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isRunning = false;
                    _resetStopwatch();
                  });
                },
                child: const Text(
                  "Exit",
                  style: TextStyle(
                      fontSize: 15.0, color: Color.fromARGB(255, 136, 91, 212)),
                ),
              )),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 153, 109, 230),
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() {
          _selectedIndex = i;
          switch (_selectedIndex) {
            case 0:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const ClockPage()));
              break;
            case 1:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const AlarmPage()));
              break;
            case 2:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const TimerPage()));
              break;
          }
        }),
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_outlined),
            activeIcon: Icon(
              Icons.access_time,
            ),
            label: 'Clock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm_outlined),
            activeIcon: Icon(
              Icons.access_alarm,
            ),
            label: 'Alarm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            activeIcon: Icon(
              Icons.timer,
            ),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_off_outlined),
            activeIcon: Icon(
              Icons.timer_off,
            ),
            label: 'Stopwatch',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: 200.0,
                height: 200.0,
                margin: const EdgeInsets.only(top: 100),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Center(
                  child: Text(
                    formattedTime(),
                    style: const TextStyle(
                        fontSize: 44.0,
                        color: Color.fromARGB(255, 117, 111, 111)),
                  ),
                )),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
}
