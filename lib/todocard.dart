import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class todocard extends StatefulWidget {
  const todocard({Key? key}) : super(key: key);

  @override
  _todocardState createState() => _todocardState();
}

class _todocardState extends State<todocard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        body: ListView(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 500,
                    child: Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (value){
                            setState(() {

                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          activeColor: Colors.black26,
                          checkColor: Colors.black,
                        ),
                        Text('Tap to open/edit the task', style: TextStyle(color: Colors.black),)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    child: Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (value){
                            setState(() {

                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          activeColor: Colors.black26,
                          checkColor: Colors.black,
                        ),
                        Text('Drag for progress', style: TextStyle(color: Colors.black),)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    child: Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (value){
                            setState(() {

                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          activeColor: Colors.black26,
                          checkColor: Colors.black,
                        ),
                        Text('Swipe left to change the date', style: TextStyle(color: Colors.black),)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    child: Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (value){
                            setState(() {

                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          activeColor: Colors.black26,
                          checkColor: Colors.black,
                        ),
                        Text('Swipe right to mark complete', style: TextStyle(color: Colors.black),)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    child: Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (value){
                            setState(() {

                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          activeColor: Colors.black26,
                          checkColor: Colors.black,
                        ),
                        Text('Long press to drag and arrange', style: TextStyle(color: Colors.black),)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    child: Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (value){
                            setState(() {

                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          activeColor: Colors.black26,
                          checkColor: Colors.black,
                        ),
                        Text('Click on checkbox to complete', style: TextStyle(color: Colors.black),)
                      ],
                    ),
                  ),
                ],
              ),
            ]
        )
    );
  }
}