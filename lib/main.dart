import 'package:flutter/material.dart';
import 'dart:async';
import 'package:numberpicker/numberpicker.dart';

import 'package:appex/todocard.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ENGROSS',

      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'ENGROSS',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<String> breakStrArr = ['Break', 'Abort'];
  List<String> stopwatchStrArr = ['Stopwatch', 'Abort'];
  List<String> leftStrArr = ['Timer', 'Pause', 'Resume'];
  int _breakflag = 0;
  bool _breakButton= false;
  bool _musicButton= false;
  bool _enableCounter=false;
  int _stopwatchFlag= 0;
  int _leftHandler=0;
  double _height= 20;
  int _currentIntValue = 10;
  int _WORK= 30;
  int _BREAK= 5;
  int _SESSIONS= 1;
  int _REVISE=5;


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  RangeValues _currentRangeValues = const RangeValues(20, 60);
  Timer? countdownTimer;
  Timer? stopwatchTimer;
  Duration myDuration = Duration(days: 5);

  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];
    SharedPreferences prefs;
    prefsData();
  }
  /// ______________________________Timer related methods_____________________________________ ///
  void startTimer() {
    setState(() => myDuration = Duration(days: 1));
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
    _breakflag++;
  }
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }
  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(days: 1));
    _breakflag--;
    _breakButton= false;
  }
  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }
  void controlCountdown() {
    if(_breakflag == 0){
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(
                "I will be back in.. ".toUpperCase(),
                style: TextStyle(fontSize: 14)
            ),
            content: Column(
                children:[
                  RichText(
                    text: TextSpan(
                        text: "Break Duration : ",
                        style: TextStyle(
                            color: Color(0xFF403f3d),
                            fontSize: 25.0
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "$_height cm",
                            style: TextStyle(
                                color: Color(0xFF403f3d),
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold
                            ),)
                        ]
                    ),

                  ),
                  SizedBox(height: 10,),
                  Slider(
                    value: _height,
                    min:0,
                    max: 250,
                    onChanged: (height){
                      setState(() {
                        _height=height;
                      });
                    },
                    divisions: 250,
                    label: "$_height",
                    activeColor:Color(0xFF403f3d),
                    inactiveColor: Colors.grey,
                  ),
                ]
            ),
            actions:[
              TextButton(
                child: Text(
                    "Cancel"
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                  child: Text(
                      "Ok"
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // dismiss dialog
                    startTimer();
                  }
              ),
            ]
        ),
      );
    }
    else{
      stopTimer();
      resetTimer();
    }
  }

  ///_________________________________Stopwatch related methods _________________________///

  void startWatch() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDownWatch());
    _stopwatchFlag=1;
    _leftHandler=1;
    _musicButton= true;
    _breakButton= false;
    _enableCounter= true;
  }
  void pauseWatch() {
    setState(() => countdownTimer!.cancel());
  }
  void resetWatch() {
    pauseWatch();
    setState(() => myDuration = Duration(seconds: 0));
    _stopwatchFlag=0;
    _leftHandler=0;
    _musicButton=false;
    _breakButton= true;
    _enableCounter= false;
    _counter=0; //Counter is reset here

  }

  void setCountDownWatch() {
    final reduceSecondsBy = -1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  void handleRightButton() {
    if(_breakflag==1){
      null;
      return;
    }
    if(_stopwatchFlag==0){
      startWatch();
    }
    else{
      resetWatch();
    }
  }

  void handleLeftButton() {
    if(_breakflag==1){
      null;
      return;
    }
    if(_stopwatchFlag==1){
      if(_leftHandler==1){
        pauseWatch();
        _leftHandler=2;
      }
      else{
        startWatch();
        _leftHandler=1;
      }
    }
    else{
      showModalBottomSheet<void>(

        // context and builder are
        // required properties in this widget
        context: context,
        builder: (BuildContext context) {

          // we set up a container inside which
          // we create center column and display text
          return Container(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "Revise ",
                          style: TextStyle(
                            fontSize: 10 ,
                          )
                      ),
                      NumberPicker(
                        value: _REVISE,
                        minValue: 1,
                        maxValue: 120,
                        axis: Axis.horizontal,
                        onChanged: (value) => setState(() => _REVISE = value),
                      ),
                      Text(
                          "minutes ",
                          style: TextStyle(
                            fontSize: 10 ,
                          )
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "Work",
                          style: TextStyle(
                            fontSize: 10 ,
                          )
                      ),
                      NumberPicker(
                        value: _WORK,
                        minValue: 1,
                        maxValue: 180,
                        axis: Axis.horizontal,
                        onChanged: (value) => setState(() => _WORK = value),
                      ),
                      Text(
                          "minutes ",
                          style: TextStyle(
                            fontSize: 10 ,
                          )
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "Break ",
                          style: TextStyle(
                            fontSize: 10 ,
                          )
                      ),
                      NumberPicker(
                        value: _BREAK,
                        minValue: 1,
                        maxValue: 120,
                        axis: Axis.horizontal,
                        onChanged: (value) => setState(() => _BREAK = value),
                      ),
                      Text(
                          "minutes ",
                          style: TextStyle(
                            fontSize: 10 ,
                          )
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "Sessions ",
                          style: TextStyle(
                            fontSize: 10 ,
                          )
                      ),
                      NumberPicker(
                        value: _SESSIONS,
                        minValue: 1,
                        maxValue: 24,
                        axis: Axis.horizontal,
                        onChanged: (value) => setState(() => _SESSIONS = value),
                      ),
                      Text(
                          "minutes ",
                          style: TextStyle(
                            fontSize: 10 ,
                          )
                      ),
                    ],
                  ),

                ],
              ),
            ),
          );
        },
      );
    }
  }
  CalendarController _controller = CalendarController();
  Map<DateTime, List<dynamic>> _events = {};
  List<dynamic> _selectedEvents = [];
  TextEditingController _eventController = TextEditingController();



  prefsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }
  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final days = strDigits(myDuration.inDays);
    // Step 7
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(120));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));


    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.

            title: Text(widget.title),
          ),

          body:
          TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: PageViewDemo(),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TableCalendar(
                      events: _events,
                      initialCalendarFormat: CalendarFormat.week,
                      calendarStyle: CalendarStyle(
                          canEventMarkersOverflow: true,
                          todayColor: Colors.lightBlue,
                          selectedColor: Theme.of(context).primaryColor,
                          todayStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.white)),
                      headerStyle: HeaderStyle(
                        centerHeaderTitle: true,
                        formatButtonDecoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        formatButtonTextStyle: TextStyle(color: Colors.white),
                        formatButtonShowsNext: false,
                      ),
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      onDaySelected: (date, events,holidays) {
                        setState(() {
                          _selectedEvents = events;
                        });
                      },
                      builders: CalendarBuilders(
                        selectedDayBuilder: (context, date, events) => Container(
                            margin: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(color: Colors.white),
                            )),
                        todayDayBuilder: (context, date, events) => Container(
                            margin: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      calendarController: _controller,
                    ),
                    ..._selectedEvents.map((event) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height/20,
                        width: MediaQuery.of(context).size.width/2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                            border: Border.all(color: Colors.white)
                        ),
                        child: Center(
                            child: Text(event,
                              style: TextStyle(color: Colors.blue,
                                  fontWeight: FontWeight.bold,fontSize: 16),)
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              Center(
                child:Column(
                  // Column is also a layout widget. It takes a list of children and
                  // arranges them vertically. By default, it sizes itself to fit its
                  // children horizontally, and tries to be as tall as its parent.
                  //
                  // Invoke "debug painting" (press "p" in the console, choose the
                  // "Toggle Debug Paint" action from the Flutter Inspector in Android
                  // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                  // to see the wireframe for each widget.
                  //
                  // Column has various properties to control how it sizes itself and
                  // how it positions its children. Here we use mainAxisAlignment to
                  // center the children vertically; the main axis here is the vertical
                  // axis because Columns are vertical (the cross axis would be
                  // horizontal).
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 75),
                    const Text(
                      'Beat Distractions! ',
                    ),
                    Text(
                      '$minutes:$seconds',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(height: 20),
                    Visibility(
                        child:
                        ElevatedButton(
                          child: Text(
                            "$_counter",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          onPressed: _incrementCounter,
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(200, 200),
                            shape: const CircleBorder(),
                          ),
                        ),
                        visible: _enableCounter,
                        replacement: SizedBox(
                          width: 200,
                          height: 200,
                          child:
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 80.0, horizontal: 20),
                            child: Center(
                              child: Text(
                                  "Hit me \n When you are distracted. ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10 ,
                                  )
                              ),
                            ),
                          ),
                        ),
                        maintainSize: _enableCounter,
                        maintainAnimation: _enableCounter,
                        maintainState: _enableCounter,
                        maintainInteractivity: _enableCounter
                    ),
                    SizedBox(height: 100),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            child:
                            TextButton(
                              child: const Icon(Icons.audiotrack),
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.red)
                                      )
                                  )
                              ),
                              onPressed: startTimer,
                            ),
                            visible: _musicButton,
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                          ),
                          SizedBox(width: 10),
                          TextButton(
                            child: Text(
                                "${leftStrArr[_leftHandler]}".toUpperCase(),
                                style: TextStyle(fontSize: 14)
                            ),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)
                                    )
                                )
                            ),
                            onPressed: () {
                              handleLeftButton();
                            },
                          ),
                          TextButton(
                            child: Text(
                                "${stopwatchStrArr[_stopwatchFlag]}".toUpperCase(),
                                style: TextStyle(fontSize: 14)
                            ),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)
                                    )
                                )
                            ),
                            onPressed: () {
                              handleRightButton();
                            },
                          ),
                          Visibility(
                            child:
                            TextButton(
                              child: Text(
                                  "${breakStrArr[_breakflag]}".toUpperCase(),
                                  style: TextStyle(fontSize: 14)
                              ),
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                          side: BorderSide(color: Colors.red)
                                      )
                                  )
                              ),
                              onPressed: () {
                                controlCountdown();
                              },
                            ),
                            visible: _breakButton,
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                          ),
                        ]
                    )
                  ],
                ),
              ),
              Column(
                  children: [
                    Column(
                      children: <Widget>[
                        Row(
                            children: [
                              TextButton(
                                onPressed: () {  },
                                child: Text(
                                  'Today', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ),
                              TextButton(
                                onPressed: () {  },
                                child: Text(
                                  'Tomorrow', style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton(
                                onPressed: () {  },
                                child: Text(
                                  'Today', style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'Today',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 30, left: 40, right: 40),
                          height: 340,
                          child: todocard(),
                        ),

                      ],

                    ),
                  ]
                /*
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
            },
            backgroundColor: Colors.black26,
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Colors.black,),
                  label: ''
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings, color: Colors.black,),
                  label: ''
              )
            ],

          ),
          */
              ),
            ],
          ),
          bottomNavigationBar: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.add)),
                Tab(icon: Icon(IconData(0xf5fe,fontFamily: 'MaterialsIcons'),color:Colors.black)),
                Tab(icon: Icon(IconData(0xe662,fontFamily: 'MaterialsIcons'),color:Colors.black)),
                Tab(icon: Icon(IconData(0xe15b,fontFamily: 'MaterialsIcons'),color:Colors.black)),
              ]
          ),
        ),
      ),
    );

  }
}
class PageViewDemo extends StatefulWidget {
  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {

  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        MyPage1Widget(),
        MyPage2Widget(),
        MyPage3Widget(),
      ],
    );
  }
}

class MyPage1Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        children:[

          Container(
            //padding:EdgeInsets.only(),
            child:
            RichText(text: TextSpan(text: '\n\n\n\n\n\n\n\n\n\n\n\                       Focus Timer ',
              //color:Colors.black,
              style: (
                  TextStyle(
                    color:Colors.white,
                    fontSize: 22,
                    fontWeight:FontWeight.w500,

                  )
              ),
              children: const <TextSpan>[
                TextSpan(text:'\n\n         Improve focus while working,with the focus \n                                        timer.      ',
                    style: TextStyle(
                      fontStyle:FontStyle.italic,
                      fontSize:16,
                      color:Colors.grey,
                    )),



              ],
            ),
            ),

            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              // background-color: #FF8527
              color:Colors.black,
              //borderRadius: BorderRadius.all(Radius.circular(10.0)),

            ),
            height:450,
            width: 500,

          ),

        ]
    );

  }
}

class MyPage2Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        children:[

          Container(
            //padding:EdgeInsets.only(),
            child:
            RichText(text: TextSpan(text: '\n\n\n\n\n\n\n\n\n\n\n                       Todo List ',
              //color:Colors.black,
              style: (
                  TextStyle(
                    color:Colors.white,
                    fontSize: 22,
                    fontWeight:FontWeight.w500,

                  )
              ),
              children: const <TextSpan>[
                TextSpan(text:'\n\n         Manage tasks, track their progress and \n                               organize your work.                                           ',
                    style: TextStyle(
                      fontStyle:FontStyle.italic,
                      fontSize:16,
                      color:Colors.grey,
                    )),



              ],
            ),
            ),

            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              // background-color: #FF8527
              color:Colors.black,
              //borderRadius: BorderRadius.all(Radius.circular(10.0)),

            ),

            width: 500,
            height:450,

          ),

        ]
    );

  }

}

class MyPage3Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        children:[

          Container(
            //padding:EdgeInsets.only(),
            child:
            RichText(text: TextSpan(text: '\n\n\n\n\n\n\n\n\n\n\n                 Events & Schedule ',
              //color:Colors.black,
              style: (
                  TextStyle(
                    color:Colors.white,
                    fontSize: 22,
                    fontWeight:FontWeight.w600,

                  )
              ),
              children: const <TextSpan>[
                TextSpan(text:'\n\n         Maintain a schedule for all your jobs and live\n                                a disciplined life.      ',
                    style: TextStyle(
                      fontStyle:FontStyle.italic,
                      fontSize:16,
                      color:Colors.grey,
                    )),



              ],
            ),
            ),

            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              // background-color: #FF8527
              color:Colors.black,
              //borderRadius: BorderRadius.all(Radius.circular(10.0)),

            ),

            width: 500,
            height:450,

          ),

        ]
    );

  }
}





class MyBox extends StatelessWidget {
  final Color color;
  final double height;
  final String text;

  MyBox(this.color, this.height, this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(10),
        color: color,
        height: (height == null) ? 150 : height,
        child: (text == null)
            ? null
            : Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}