import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerProvider extends ChangeNotifier {
  int hours = 00;
  int minutes = 00;
  int seconds = 00;
  Timer? _timer;

  List<TimerClassModel> timerList = [];

  startTimer(int sethours, int setminutes, int setseconds,
      List<TimerClassModel> timerlist, int index) {
    hours = sethours;
    minutes = setminutes;
    seconds = setseconds;
    notifyListeners();
    if (!timerlist[index].isRunning!) {
      timerlist[index].isRunning = true;
      notifyListeners();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (seconds > 0) {
          seconds--;
          notifyListeners();
        } else {
          if (minutes > 0) {
            minutes--;
            seconds = 59;
            notifyListeners();
          } else {
            if (hours > 0) {
              hours--;
              minutes = 59;
              seconds = 59;
              notifyListeners();
            } else {
              stopTimer(timerlist, index);
              resetTimer();
              notifyListeners();
            }
          }
        }
      });
    }
  }

  void stopTimer(List<TimerClassModel> timerlist, int index) {
    if (timerlist[index].isRunning!) {
      timerList[index].isRunning = false;
      timerlist[index].isRunning = false;
      _timer!.cancel();
    }
  }

  resetTimer() {
    hours = 0;
    minutes = 0;
    seconds = 0;
    notifyListeners();
  }

  Future<void> storeListData(String key, List<TimerClassModel> persons) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> timersMapList =
        persons.map((timermap) => timermap.toMap()).toList();
    await prefs.setStringList(
        key, timersMapList.map((personMap) => jsonEncode(personMap)).toList());
    resetTimer();
    getListData("timerList");
    notifyListeners();
  }

// Retrieving list data from shared preferences
  Future<List<TimerClassModel>> getListData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> timerStringList = prefs.getStringList(key) ?? [];
    List timerMapList = timerStringList
        .map((personString) => jsonDecode(personString))
        .toList();
    timerList.clear();
    timerList.addAll(timerMapList
        .map((timermap) => TimerClassModel.fromMap(timermap))
        .toList());
    notifyListeners();
    print("TimerList${timerList.length}");
    return timerMapList
        .map((timermap) => TimerClassModel.fromMap(timermap))
        .toList();
  }

  @override
  void dispose() {
    stopTimer([], 0);
    super.dispose();
  }
}

class TimerClassModel {
  int? hours;
  int? minutes;
  int? seconds;
  int? milliseconds;
  bool? isRunning = false;

  TimerClassModel(
      {this.hours,
      this.milliseconds,
      this.minutes,
      this.seconds,
      this.isRunning});

  // Convert AlarmItem object to a map
  Map<String, dynamic> toMap() {
    return {
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
      "isRunning": isRunning ?? false
    };
  }

  // Create a AlarmItem object from a map
  factory TimerClassModel.fromMap(Map<String, dynamic> map) {
    return TimerClassModel(
        hours: map['hours'],
        minutes: map['minutes'],
        seconds: map['seconds'],
        isRunning: map['isRunning'] ?? false);
  }
}
