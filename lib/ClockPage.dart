import 'package:crud_task/AlarmPage.dart';
import 'package:crud_task/AlarmProvider.dart';
import 'package:crud_task/Productspage.dart';
import 'package:crud_task/StopWatchPage.dart';
import 'package:crud_task/TimerPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AlarmItem {
  String? setTime;
  bool? isActive;
  String? title;
  AlarmItem({this.isActive, this.setTime, this.title});

  // Convert AlarmItem object to a map
  Map<String, dynamic> toMap() {
    return {'setTime': setTime, 'title': title, 'isActive': isActive};
  }

  // Create a AlarmItem object from a map
  factory AlarmItem.fromMap(Map<String, dynamic> map) {
    return AlarmItem(
        setTime: map['setTime'],
        title: map['title'],
        isActive: map['isActive']);
  }
}

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  int _selectedIndex = 0;

  Stream<String>? _dateTimeStream;
  String? _CurrentDtae = "";
  String? _CurrentTime = "";

  @override
  void initState() {
    super.initState();
    _dateTimeStream = Stream<String>.periodic(const Duration(seconds: 1), (_) {
      _CurrentDtae = DateFormat("EEE, dd MMM ").format(DateTime.now());
      return _CurrentTime = DateFormat('hh:mm a').format(DateTime.now());
    });
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final auth = Provider.of<AlarmProvider>(context, listen: false);
      auth.loadAlarms();
    });
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final auth = Provider.of<AlarmProvider>(context, listen: false);
      auth.initialize();
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
                case 1:
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AlarmPage()));
                  break;
                case 2:
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => TimerPage()));
                  break;
                case 3:
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StopwatchApp()));
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
          body: ListView(children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Center(
                child: StreamBuilder<String>(
                  stream: _dateTimeStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data.toString().substring(
                                    0, snapshot.data.toString().length - 2),
                                style: const TextStyle(
                                    fontSize: 32.0,
                                    color: Color.fromARGB(255, 153, 109, 230)),
                              ),
                              Text(
                                snapshot.data.toString().substring(
                                    snapshot.data.toString().length - 2),
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    color: Color.fromARGB(255, 136, 91, 212)),
                              ),
                            ],
                          ),
                          Text(
                            _CurrentDtae!,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 18.0,
                                color: Color.fromARGB(255, 153, 109, 230)),
                          ),
                        ],
                      );
                    } else {
                      return const Text(
                        'Loading...',
                        style: TextStyle(fontSize: 18.0),
                      );
                    }
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Divider(
                color: Color.fromARGB(255, 194, 188, 188),
                height: 1,
                thickness: 0.5,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.2,
              child: ListView.builder(
                itemCount: object.alarms.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ListTile(
                        // title: Text("06:30 AM"),
                        title: Text(
                          object.alarms[index].title.toString(),
                          style: const TextStyle(
                              fontSize: 15.0, color: Colors.grey),
                        ),

                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${object.alarms[index].time.hourOfPeriod.toString().padLeft(2, '0')}:${object.alarms[index].time.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                    fontSize: 25.0, color: Colors.grey),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  object
                                      .getTimePeriod(object.alarms[index].time),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      fontSize: 12.0, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
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
                ),
              ),
            ),
          ]));
    });
  }

  addAlarmDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        // useRootNavigator: false,
        context: context,
        builder: (context) {
          return Consumer<AlarmProvider>(builder: (context, object, child) {
            object.time1 = TimeOfDay.now();
            object.textEditingController!.text = '';
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
                                        ? "${object.time1!.hourOfPeriod.toString().padLeft(2, '0')}:${object.time1!.minute.toString().padLeft(2, '0')} ${object.getTimePeriod(object.time1!)}"
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
                              setState(() {
                                Alarm at = Alarm(
                                    id: object.alarms.length,
                                    time: object.time1!,
                                    title: object.textEditingController!.text
                                        .toString(),
                                    isActive: true);
                                object.saveAlarms(at);
                                Navigator.pop(context);
                              });
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
}
