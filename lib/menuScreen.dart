import 'package:beemy/BeemCalculator.dart';
import 'package:beemy/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:beemy/beemAbout.dart';


class MenuScreen extends StatelessWidget {
    // const MenuScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
            Positioned.fill(
              child: Image.asset("assets/backgroundMain.png", 
              fit: BoxFit.fill,)
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.all(10.0),
                    child: ElevatedButton(
                              child: const Text('BMI Calculator', style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                              ),),
                          onPressed: () {
                            _disableDebugPrint();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BeemyAboutCalculator()),
                                );
                              },
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 53, 8, 66),
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                            ),
                  ),
                  Padding(padding: EdgeInsets.all(15.0),
                    child: ElevatedButton(
                              child: const Text('Calculator Guideline', style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                              ),),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BeemyAbout()),
                                );
                              },
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 136, 177, 35),
                              padding: EdgeInsets.symmetric(horizontal: 43, vertical: 15),
                          ),
                            ),
                  ),

                ],
              ),
            ),
          ],
        );
  }
}

void _disableDebugPrint() {
  bool debug = false;
  assert(() {
    debug = true;
    return true;
  }());
  if (!debug) {
    debugPrint = (message, {wrapWidth}) {
      //disable log print when not in debug mode
    };
  }
}