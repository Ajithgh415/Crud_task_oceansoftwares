import 'package:crud_task/AlarmProvider.dart';
import 'package:crud_task/StopWatchPage.dart';
import 'package:crud_task/TimerPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'ClockPage.dart';
import 'Productspage.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final auth = Provider.of<AlarmProvider>(context, listen: false);
      auth.loadAlarms();
    });
  }

  addAlarmDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        // useRootNavigator: false,
        context: context,
        builder: (context) {
          return Consumer<AlarmProvider>(builder: (context, object, child) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10.0,
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.all(8),
              titlePadding: const EdgeInsets.all(0),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(Icons.close_outlined)),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "SET ALARM",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Color.fromARGB(255, 136, 91, 212),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              content:
                  StatefulBuilder(builder: (context, StateSetter innerState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Select Time',
                            style: TextStyle(
                                color: Color.fromARGB(255, 136, 91, 212),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InkWell(
                            onTap: () async {
                              object.time1 = TimeOfDay.now();
                              TimeOfDay? newTime = await showTimePicker(
                                context: context,
                                initialTime: object.time1!,
                              );
                              innerState(() {
                                object.time1 = newTime!;
                              });
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    object.time1 != null
                                        ? "${object.time1!.hourOfPeriod}:${object.time1!.minute} ${object.getTimePeriod(object.time1!)}"
                                        : "",
                                  ),
                                  const Icon(
                                    Icons.calendar_month,
                                    color: Color.fromARGB(255, 136, 91, 212),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Remarks',
                            style: TextStyle(
                                color: Color.fromARGB(255, 136, 91, 212),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                            height: 78,
                            padding: const EdgeInsets.all(6.0),
                            child: TextField(
                              controller: object.textEditingController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.only(top: 12, left: 12),
                                  hintText: 'Add remarks',
                                  hintStyle: TextStyle(color: Colors.grey)),
                              keyboardType: TextInputType.multiline,
                              maxLines: 10,
                              maxLength: 500,
                              onTap: () {
                                innerState(() {});
                              },
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          padding: const EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Alarm at = Alarm(
                                  id: object.alarms.length,
                                  time: object.time1!,
                                  title: object.textEditingController!.text
                                      .toString(),
                                  isActive: true);

                              if (object.alarms.isNotEmpty) {
                                object.saveAlarms(at);
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 136, 91, 212),
                            ),
                            child: const Text(
                              "SET",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlarmProvider>(builder: (context, object, child) {
      return Scaffold(
         appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 163, 60, 182),
            title: const Text('Products'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductsPage()));
                  },
                  icon: Icon(Icons.logout))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 153, 109, 230),
            onPressed: () {
              addAlarmDialog(context);
            },
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color.fromARGB(255, 153, 109, 230),
            currentIndex: _selectedIndex,
            onTap: (i) => setState(() {
              _selectedIndex = i;
              switch (_selectedIndex) {
                case 0:
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ClockPage()));
                  break;

                case 2:
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TimerPage()));
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
          body: ListView.builder(
              itemCount: object.alarms.length,
              itemBuilder: (context, index) {
                Alarm alarm = object.alarms[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ListTile(
                        // title: Text("06:30 AM"),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${alarm.time.hourOfPeriod.toString().padLeft(2, '0')}:${alarm.time.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                  fontSize: 25.0, color: Colors.grey),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                object.getTimePeriod(alarm.time),
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                    fontSize: 12.0, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(alarm.title.toString()),
                        trailing: Switch(
                          value: alarm.isActive,
                          onChanged: (newValue) {
                            setState(() {
                              alarm.isActive = newValue;
                              object.updateAlarm(alarm);
                            });
                          },
                        ),
                      ),
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
                );
              }));
    });
  }
}
