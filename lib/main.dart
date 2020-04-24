import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

Color appPrimary = Color.fromRGBO(198, 38, 46, 1);
Color colorPrimary = Color.fromRGBO(245, 245, 245, 1);
Color textColorPrimary = Color.fromRGBO(51, 51, 51, 1);
List<String> weightUnits = <String>['kg', 'lbs'];
List<String> heightUnits = <String>['m', 'cm', 'ft'];
List<double> weightConversions = <double>[1, 0.45359237];
List<double> heightConversions = <double>[1, 0.01, 0.3048];
AppBar fixedAppBar = AppBar(
  title: Text('Beemy - A Cute Little BMI Calculator'),
  actions: <Widget>[IconButton(icon: Icon(Icons.info), onPressed: () => {})],
);
void main() {
  runApp(MaterialApp(
    title: 'Beemy - A Cute Little BMI Calculator',
    home: BeemyHome(),
    theme: ThemeData(primaryColor: appPrimary),
  ));
}

class BMIForm extends StatefulWidget {
  @override
  BMIFormState createState() {
    return BMIFormState();
  }
}

class BMIFormState extends State<BMIForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<BMIFormState>.
  final _formKey = GlobalKey<FormState>();
  var _weightController = TextEditingController();
  var _heightController = TextEditingController();
  String _weightUnitController = "kg";
  String _heightUnitController = "cm";

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return Form(
        key: _formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Text(
                "Calculate your Body Mass Index:",
                style: TextStyle(color: textColorPrimary, fontSize: 20.0),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 30),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      inputFormatters: [
                        BlacklistingTextInputFormatter(new RegExp('[ \\-,]'))
                      ],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your weight.';
                        } else if (RegExp(r"^\d+([\.]\d+)?$")
                                .allMatches(value)
                                .length !=
                            1) {
                          return 'Please input a valid number.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true, signed: false),
                      decoration: InputDecoration(
                          labelText: 'Enter weight',
                          suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () => _weightController.clear())),
                    ),
                    flex: 3,
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _weightUnitController,
                      items: weightUnits
                          .map((label) => DropdownMenuItem(
                                child: Text(label.toString()),
                                value: label,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _weightUnitController = value;
                        });
                      },
                      isDense: true,
                    ),
                  ),
                  SizedBox(width: 30)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 30),
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your height';
                        } else if (RegExp(r"^\d+([\.]\d+)?$")
                                .allMatches(value)
                                .length !=
                            1) {
                          return 'Please input a valid number.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true, signed: false),
                      inputFormatters: [
                        BlacklistingTextInputFormatter(new RegExp('[ \\-,]'))
                      ],
                      decoration: InputDecoration(
                          labelText: 'Enter height',
                          suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () => _heightController.clear())),
                    ),
                    flex: 3,
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _heightUnitController,
                      items: heightUnits
                          .map((label) => DropdownMenuItem(
                                child: Text(label.toString()),
                                value: label,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _heightUnitController = value;
                        });
                      },
                      isDense: true,
                    ),
                  ),
                  SizedBox(width: 30)
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    shape: CircleBorder(),
                    color: appPrimary,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        // Scaffold.of(context).showSnackBar(SnackBar(
                        //   content: Text('Processing Data' + _weightController.value.text + _weightUnitController + _heightController.value.text + _heightUnitController ),
                        //   duration: Duration(milliseconds: 2000),
                        // ));
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BeemyResult(
                              weight: double.parse(_weightController.text),
                              weightUnit: _weightUnitController,
                              height: double.parse(_heightController.text),
                              heightUnit: _heightUnitController);
                        }));
                      }
                    },
                    child: Icon(Icons.arrow_forward,
                        size: 64, color: Colors.white),
                  )
                ],
              )
            ]));
  }
}

class BeemyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beemy - A Cute Little BMI Calculator'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BeemyAbout())))
        ],
      ),
      body: BMIForm(),
    );
  }
}

class BeemyResult extends StatelessWidget {
  final double weight;
  final String weightUnit;
  final double height;
  final String heightUnit;

  BeemyResult(
      {@required this.weight,
      @required this.weightUnit,
      @required this.height,
      @required this.heightUnit});
  @override
  Widget build(BuildContext context) {
    final double convertedWeight =
        weight * weightConversions[weightUnits.indexOf(this.weightUnit)];
    final double convertedHeight =
        height * heightConversions[heightUnits.indexOf(this.heightUnit)];
    final double BMI = convertedWeight / (convertedHeight * convertedHeight);
    String status;
    Color statusColor;
    if (BMI < 18.7) {
      status = "Underweight";
      statusColor = Colors.red;
    } else if (BMI <= 24.0) {
      status = "Healthy";
      statusColor = Colors.green;
    } else if (BMI <= 30.0) {
      status = "Overweight";
      statusColor = Colors.orange;
    } else if (BMI > 30.0) {
      status = "Obese";
      statusColor = Colors.red;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Beemy - A Cute Little BMI Calculator'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.info),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BeemyAbout())))
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Text("Your Results:",
                    style: TextStyle(
                        fontSize: 40.0, fontWeight: FontWeight.bold))),
            SizedBox(height: 20),
            Text("You are considered", style: TextStyle(fontSize: 20.0)),
            Text(status, style: TextStyle(fontSize: 30.0, color: statusColor)),
            Text("in the official Body Mass Index chart.",
                style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 50),
            Text("Your Body Mass Index is:", style: TextStyle(fontSize: 20.0)),
            SizedBox(
                height: 50,
                child: Text(BMI.toStringAsFixed(2),
                    style: TextStyle(fontSize: 30.0, color: statusColor))),
          ],
        ));
  }
}

class BeemyAbout extends StatelessWidget {
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
    // No Exception to be thrown
    /*else {
      throw 'Could not launch $url';
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Beemy - A Cute Little BMI Calculator'),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(2.0),
            child: Html(
              data: """
    <div>
      <p>Beemy is a cute and small BMI Calculator. It is based on ElemantaryOS app of same name.</p>
      <h2>Usage</h2>
      <p>Follow the following steps to calculate your BMI:</p>
      <ul>
      <li>Enter you weight in  kg or lb</li>
      <li>Select appropriate weight unit from dropdown list (Default: kg)</li>
      <li>Enter your height in cm, m or ft</li>
      <li>Select appropriate height unit from dropdown list (Default: cm)</li>
      <li>Press "Go" to view the results</li>
      </ul>
      <h2>Developers</h2>
      <ul>
      <li>This app is developed by <a href="https://cstayyab.com">Muhammad Tayyab Sheikh</a></li>
      <li>The original Elementary OS version of this app is developed by <a href="https://github.com/lainsce">Lains</a></li>
      </ul>
      <h2>Source Code</h2>
      <p>You can view source of this app <a href="https://github.com/cstayyab/beeny-flutter">here</a></p>
      <p>The source code of this app is Licensed under GNU GPL-v3.</p>
      <h2>Acknowledgement</h2>
      <ul>
      <li>Icon of this app was taken from <a href="https://github.com/lainsce/beemy">Beemy for Elementary OS</a></li>
      </ul>
      <br />
      <br />
      <br />
    </div>
  """,
              //Optional parameters:
              padding: EdgeInsets.all(3.0),
              backgroundColor: Colors.white,
              defaultTextStyle: TextStyle(fontFamily: 'serif'),
              linkStyle: const TextStyle(
                color: Color.fromRGBO(198, 38, 46, 1),
              ),
              onLinkTap: _launchURL,
            )));
  }
}
