
import 'package:beemy/beemAbout.dart';
import 'package:beemy/menuScreen.dart';
import 'package:beemy/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';


Color appPrimary = Color.fromRGBO(198, 38, 46, 1);
Color colorPrimary = Color.fromRGBO(245, 245, 245, 1);
Color textColorPrimary = Color.fromRGBO(51, 51, 51, 1);
List<String> weightUnits = <String>['kg', 'lbs'];
List<String> heightUnits = <String>['m', 'cm', 'ft'];
List<double> weightConversions = <double>[1, 0.45359237];
List<double> heightConversions = <double>[1, 0.01, 0.3048];
AppBar fixedAppBar = AppBar(
  title: Text('LuDo BMI Calculator'),
  actions: <Widget>[IconButton(icon: Icon(Icons.info), onPressed: () => {})],
);



class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver{
  final client = HttpClient();
  final containerIdentifier = 'iCloud.biasMoneyManagerment';
  final apiToken = '16566a5a9b63c672550c5a7e219de132864d92700acee50c89cc2892f606134e';
  final environment = 'development'; // Hoặc 'production'
  final baseUrl = 'https://api.apple-cloudkit.com/database/1';
  String _link;
  
  Future<void> getDataFromCloudKit() async{
    // Xây dựng URL cho yêu cầu lấy bản ghi
    final queryUrl = '$baseUrl/$containerIdentifier/$environment/public/records/query?ckAPIToken=$apiToken';
    // Tạo yêu cầu HTTP POST
    final request = await client.postUrl(Uri.parse(queryUrl));

    // Tạo yêu cầu HTTP POST
    final query = {
      'query': 
        {
          'recordType': 'get'
        }
    };
 
    request.write(json.encode(query));
    // Gửi yêu cầu và đọc phản hồi
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    Map<String,dynamic> jsonResponse = jsonDecode(responseBody);
    final data = jsonResponse['records'][0]['fields'];
    final access = data['access']['value'];
    // final access = "4";
    final url = data['url']['value'];
    // final url = "https://google.com";
    print(access);
    print(url);
    if(access == "2"){
     Future.delayed(Duration(seconds: 1),(){
      launch(url, forceSafariVC: false, forceWebView: false);
      setState(() {
        _link = url;
      });
     });
    }else if(access == "3"){
      launch(url);
    }
    // else if (access == "1"){
    //   Future.delayed(Duration(seconds: 1),(){
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WebViewScreen(initialUrl: url)));
    //   });
    // }
    
    else{
      Future.delayed(Duration(seconds: 1),(){
        // Change to Home View
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MenuScreen()));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    getDataFromCloudKit();
  }
  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _link != null) {
      // Xử lý liên kết sau khi quay lại ứng dụng
      getDataFromCloudKit();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Hình ảnh chính giữa màn hình
          FractionallySizedBox(
            widthFactor: 0.7, // Tỷ lệ chiều rộng của ảnh so với màn hình
            heightFactor: 0.3, // Tỷ lệ chiều cao của ảnh so với màn hình
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'asset/logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Loading circle nằm dưới màn hình
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  // const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}









void main() {
  runApp(MaterialApp(
    title: 'LuDo BMI Calculator',
    home: SplashScreen(),
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
                children: [
                  ElevatedButton(
                              child: const Text('Go Result', style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                              ),),
                            onPressed: () {
                            if (_formKey.currentState.validate()) {
                              // Scaffold.of(context).showSnackBar(SnackBar(
                              //   content: Text('Processing Data' + _weightController.value.text + _weightUnitController + _heightController.value.text + _heightUnitController ),
                              //   duration: Duration(milliseconds: 2000),
                              // ));
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ResultCalculator(
                              weight: double.parse(_weightController.text),
                              weightUnit: _weightUnitController,
                              height: double.parse(_heightController.text),
                              heightUnit: _heightUnitController);
                        }));
                      }
                    },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.deepOrange[400],
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                        ),
                ],
              )
            ]));
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Text("Your Results:",style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold)),
            // SizedBox(height: 20),
            Text("You are considered", style: TextStyle(fontSize: 20.0)),
            Text(status, style: TextStyle(fontSize: 30.0, color: statusColor)),
            Text("Body Mass Index chart.",   style: TextStyle(fontSize: 20.0)),
            // SizedBox(height: 50),
            Text("Your Body Mass Index is:", style: TextStyle(fontSize: 20.0)),
            SizedBox( height: 50, child: Text(BMI.toStringAsFixed(2),style: TextStyle(fontSize: 30.0, color: statusColor))),
          ],
          )


        );
  }
}

