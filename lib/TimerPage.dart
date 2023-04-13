import 'dart:async';
import 'package:crud_task/StopWatchPage.dart';
import 'package:crud_task/TimerProvider.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AlarmPage.dart';
import 'AlarmProvider.dart';
import 'ClockPage.dart';
import 'Productspage.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final auth = Provider.of<TimerProvider>(context, listen: false);
      auth.getListData("timerList");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(builder: (context, object, child) {
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 153, 109, 230),
          onPressed: () {
            showTimePickerDialog(context);
          },
          child: const Icon(Icons.add),
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
              case 3:
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StopwatchApp()));
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
        body: ListView(
          children: [
            Center(
              child: Container(
                  width: 300.0,
                  height: 100.0,
                  margin: const EdgeInsets.only(top: 50),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          object.hours.toString().padLeft(2, '0'),
                          style: const TextStyle(
                            fontSize: 28.0,
                            color: Color.fromARGB(255, 153, 109, 230),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'H  ',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Color.fromARGB(255, 117, 111, 111)),
                          ),
                        ),
                        Text(
                          object.minutes.toString().padLeft(2, '0'),
                          style: const TextStyle(
                            fontSize: 28.0,
                            color: Color.fromARGB(255, 153, 109, 230),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'M  ',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Color.fromARGB(255, 117, 111, 111)),
                          ),
                        ),
                        Text(
                          object.seconds.toString().padLeft(2, '0'),
                          style: const TextStyle(
                            fontSize: 28.0,
                            color: Color.fromARGB(255, 153, 109, 230),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'S  ',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Color.fromARGB(255, 117, 111, 111)),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Recent Items",
                style: TextStyle(
                    fontSize: 20.0, color: Color.fromARGB(255, 117, 111, 111)),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.2,
              child: ListView.builder(
                itemCount: object.timerList.length,
                itemBuilder: (context, index) => object.timerList.isNotEmpty
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: ListTile(
                                // title: Text("06:30 AM"),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      object.timerList[index].hours
                                          .toString()
                                          .padLeft(2, '0'),
                                      style: const TextStyle(
                                        fontSize: 28.0,
                                        color:
                                            Color.fromARGB(255, 153, 109, 230),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'H  ',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Color.fromARGB(
                                                255, 117, 111, 111)),
                                      ),
                                    ),
                                    Text(
                                      object.timerList[index].minutes
                                          .toString()
                                          .padLeft(2, '0'),
                                      style: const TextStyle(
                                        fontSize: 28.0,
                                        color:
                                            Color.fromARGB(255, 153, 109, 230),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'M  ',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Color.fromARGB(
                                                255, 117, 111, 111)),
                                      ),
                                    ),
                                    Text(
                                      object.timerList[index].seconds
                                          .toString()
                                          .padLeft(2, '0'),
                                      style: const TextStyle(
                                        fontSize: 28.0,
                                        color:
                                            Color.fromARGB(255, 153, 109, 230),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'S  ',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Color.fromARGB(
                                                255, 117, 111, 111)),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      object.timerList[index].isRunning!
                                          ? object.stopTimer(
                                              object.timerList, index)
                                          : object.startTimer(
                                              object.timerList[index].hours!,
                                              object.timerList[index].minutes!,
                                              object.timerList[index].seconds!,
                                              object.timerList,
                                              index);
                                    });
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 153, 109, 230),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(
                                      object.timerList[index].isRunning!
                                          ? Icons.pause_outlined
                                          : Icons.play_arrow_outlined,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Divider(
                              color: Color.fromARGB(255, 194, 188, 188),
                              height: 1,
                              thickness: 0.5,
                            ),
                          ),
                        ],
                      )
                    : const Center(child: Text("No Timers List found")),
              ),
            ),
          ],
        ),
      );
    });
  }

  void showTimePickerDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<TimerProvider>(builder: (context, object, child) {
            return AlertDialog(
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                title: const Text('Select Time'),
                content:
                    StatefulBuilder(builder: (context, StateSetter innerState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NumberPicker(
                            itemHeight: 30,
                            itemWidth: 40,
                            value: object.hours,
                            zeroPad: false,
                            textStyle: const TextStyle(
                                color: Color.fromARGB(255, 116, 29, 131)),
                            minValue: 0,
                            maxValue: 24,
                            onChanged: (value) {
                              innerState(() {
                                object.hours = value;
                              });
                            },
                          ),
                          const Text('H',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 116, 29, 131))),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NumberPicker(
                            itemHeight: 30,
                            itemWidth: 40,
                            value: object.minutes,
                            zeroPad: false,
                            textStyle: const TextStyle(
                                color: Color.fromARGB(255, 116, 29, 131)),
                            minValue: 0,
                            maxValue: 59,
                            onChanged: (value) {
                              innerState(() {
                                object.minutes = value;
                              });
                            },
                          ),
                          const Text('M'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NumberPicker(
                            itemHeight: 30,
                            itemWidth: 40,
                            value: object.seconds,
                            zeroPad: false,
                            textStyle: const TextStyle(
                                color: Color.fromARGB(255, 116, 29, 131)),
                            minValue: 0,
                            maxValue: 59,
                            onChanged: (value) {
                              innerState(() {
                                object.seconds = value;
                              });
                            },
                          ),
                          const Text('S'),
                        ],
                      ),
                    ],
                  );
                }),
                actions: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Color.fromARGB(255, 136, 91, 212),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        object.timerList.add(TimerClassModel(
                            hours: object.hours,
                            minutes: object.minutes,
                            seconds: object.seconds));
                        object.storeListData("timerList", object.timerList);
                        Navigator.pop(context);
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Ok",
                        style: TextStyle(
                          color: Color.fromARGB(255, 136, 91, 212),
                        ),
                      ),
                    ),
                  ),
                ]);
          });
        });
  }
}
