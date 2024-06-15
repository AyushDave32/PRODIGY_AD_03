import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State createState() => _HomepageState();
}

class _HomepageState extends State {
  int s = 0, m = 0, h = 0;
  String digSec = "00", digMin = "00", digHr = "00";
  Timer? timer;
  bool started = false;

  List<String> laps = [];

  void stop() {
    timer?.cancel();
    setState(() {
      started = false;
    });
  }

  void reset() {
    timer?.cancel();
    setState(() {
      s = 0;
      m = 0;
      h = 0;
      digSec = "00";
      digMin = "00";
      digHr = "00";
      laps.clear();
      started = false;
    });
    start();
  }

  void addLap() {
    String lap = "$digHr:$digMin:$digSec";
    setState(() {
      laps.add(lap);
    });
  }

  void start() {
    setState(() {
      started = true;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int localsec = s + 1;
      int localmin = m;
      int localhours = h;
      if (localsec > 59) {
        localsec = 0;
        localmin++;
        if (localmin > 59) {
          localmin = 0;
          localhours++;
        }
      }

      setState(() {
        s = localsec;
        m = localmin;
        h = localhours;

        digSec = (s >= 10) ? "$s" : "0$s";
        digMin = (m >= 10) ? "$m" : "0$m";
        digHr = (h >= 10) ? "$h" : "0$h";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21), // Dark Blue background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'StopWatch',
                  style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Expanded(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                      color: Color(0xFFFFD700), // Yellow circle
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        )
                      ]),
                  child: Center(
                    child: Text(
                      '$digHr:$digMin:$digSec',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 60.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 400.0,
                  child: ListView.builder(
                      itemCount: laps.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lap ${index + 1}",
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                              Text(
                                "${laps[index]}",
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        (!started) ? start() : stop();
                      },
                      fillColor:
                          (!started) ? Colors.greenAccent : Colors.redAccent,
                      shape: StadiumBorder(),
                      child: Text(
                        (!started) ? "Start" : "Stop",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  IconButton(
                    onPressed: () {
                      addLap();
                    },
                    icon: Icon(
                      Icons.flag,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        reset();
                      },
                      fillColor: Colors.blue,
                      shape: StadiumBorder(),
                      child: Text(
                        'Restart',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
