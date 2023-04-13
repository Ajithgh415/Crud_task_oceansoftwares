import 'dart:convert';

import 'package:crud_task/ClockPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class AlarmProvider extends ChangeNotifier {
  String? time = '';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<Alarm> alarms = [];

  final TextEditingController _timeController = TextEditingController();

  TextEditingController? get timeController => _timeController;

  final TextEditingController _textEditingController = TextEditingController();

  TextEditingController? get textEditingController => _textEditingController;
  TimeOfDay? time1 = TimeOfDay.now();

  final List<AlarmItem> alarmList = [];

  // Initialize shared preferences
  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Schedule an alarm
  Future<void> scheduleAlarm({
    required int id,
    required String title,
    required DateTime dateTime,
  }) async {
    final prefs = await _getPrefs();
    final notificationsPlugin = FlutterLocalNotificationsPlugin();
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );
    await notificationsPlugin.initialize(initializationSettings);
    // Convert DateTime to TZDateTime

    // Ensure the provided DateTime is in the future
    if (dateTime.isBefore(DateTime.now())) {
      throw Exception("Invalid date: Must be a date in the future");
    }
    // Convert DateTime to TZDateTime
    tz.initializeTimeZones();
    tz.setLocalLocation(
        tz.getLocation('Asia/Kolkata')); // Replace with your desired timezone
    tz.TZDateTime tzDateTime = tz.TZDateTime.from(
        dateTime, tz.local); // assuming you have a valid time zone

    // Schedule the alarm
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      'This is the alarm message',
      tzDateTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel', // channel id
          'Alarm Channel', // channel name
          importance: Importance.high, // notification importance
          priority: Priority.high, // notification priority
          playSound: true, // play notification sound
          enableVibration: true, // enable vibration
          vibrationPattern:
              Int64List.fromList([0, 1000, 500, 1000]), // vibration pattern
        ),
      ),
      androidAllowWhileIdle: true, // allow to run while app is idle
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'Alarm notification',
    );

    // Save the alarm time in shared preferences
    await prefs.setString('alarm_$id', dateTime.toString());
  }

  // Cancel an alarm
  Future<void> cancelAlarm(int id) async {
    final prefs = await _getPrefs();
    await flutterLocalNotificationsPlugin.cancel(id);
    await prefs.remove('alarm_$id');
  }

// Load alarms from shared preferences
  void loadAlarms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? alarmList = prefs.getStringList('alarms');
    if (alarmList != null) {
      alarms =
          alarmList.map((json) => Alarm.fromJson(jsonDecode(json))).toList();
      notifyListeners();
    }
    notifyListeners();
  }

  initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings =
        const InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  tz.TZDateTime convertToTZDateTime(DateTime dateTime, tz.Location timeZone) {
    return tz.TZDateTime.from(
      dateTime,
      timeZone,
    );
  }

  // Save alarms to shared preferences
  void saveAlarms(Alarm alarm) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convert the Alarm object to a JSON string
    String alarmJson = jsonEncode(alarm.toJson());

    // Get the existing list of alarms from shared preferences
    List<String> alarmList = prefs.getStringList('alarms') ?? [];

    // Add the new alarm JSON string to the list
    alarmList.add(alarmJson);
    // Save the updated list of alarms in shared preferences
    await prefs.setStringList('alarms', alarmList);

    // Schedule the alarm using your logic
    DateTime now = DateTime.now(); // Example current date
    DateTime dateTime = DateTime(
        now.year, now.month, now.day, alarm.time.hour, alarm.time.minute);
    scheduleAlarm(
      dateTime: dateTime,
      id: alarm.id,
      title: alarm.title,
    );

    // Clear the alarms list and textEditingController, and notify listeners
    alarms.clear();
    textEditingController!.clear();
    notifyListeners();

    // Load the updated list of alarms
    loadAlarms();
  }

  // Delete alarm
  deleteAlarm(
    Alarm alarm,
  ) {
    alarms.remove(alarm);
    loadAlarms();
  }

  // Update an existing alarm
  updateAlarm(Alarm alarm) async {
  int index = alarms.indexWhere((a) => a.id == alarm.id); // Find index of the alarm to update
  if (index != -1) {
    alarms[index] = alarm; // Update alarm object in the list

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alarmList = alarms.map((alarm) => jsonEncode(alarm.toJson())).toList();
    prefs.setStringList('alarms', alarmList); // Save updated list of alarms to shared preferences
  }
}

  String getTimePeriod(TimeOfDay time) {
    String timePeriod;
    if (time.hour < 12) {
      timePeriod = 'AM';
    } else {
      timePeriod = 'PM';
    }
    return timePeriod;
  }
}

class Alarm {
  int id;
  TimeOfDay time;
  String title;
  bool isActive;

  Alarm(
      {required this.id,
      required this.time,
      required this.title,
      required this.isActive});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': '${time.hour}:${time.minute}',
      'title': title,
      'isActive': isActive,
    };
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'],
      time: TimeOfDay(
        hour: int.parse(json['time'].split(':')[0]),
        minute: int.parse(json['time'].split(':')[1]),
      ),
      title: json['title'],
      isActive: json['isActive'],
    );
  }
}
