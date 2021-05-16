import 'package:flutter/material.dart';
import 'package:malaria_fuzzy_expert_system/result.dart';
import 'symptoms.dart';

class SymptomsPreviewPage extends StatefulWidget {
  final SymptomsData symptomsData;

  SymptomsPreviewPage({this.symptomsData});

  @override
  _SymptomsPreviewPageState createState() => _SymptomsPreviewPageState();
}

class _SymptomsPreviewPageState extends State<SymptomsPreviewPage> {
  //List to be used on the next screen for Inference Engine
  List<int> selectedSeveritySymptom = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<double> selectedFuzzyValueSymptom = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  //Build instruction
  Widget _buildTitle() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'The symptoms that you have chosen is shown below. Tap the PROCEED button to confirm.',
            style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.normal,
                fontSize: 16.0),
          ),
        ),
        Divider(
          height: 20.0,
          color: Colors.blueGrey,
        )
      ],
    );
  }

  //Build a list of symptoms chosen by the user
  Widget _buildSymptomsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
          child: Text(
            'Symptoms:',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Padding(
          padding:
              EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.symptomsData.symptomsSeverity.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              getSeverityList(widget.symptomsData.symptomsSeverity);
              if (widget.symptomsData.symptomsSeverity[index] != 0) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    color: _colorSymptoms(
                        widget.symptomsData.symptomsSeverity[index]),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(
                          _symptomsName(index),
                          style: TextStyle(color: Colors.black, fontSize: 16.0),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          _fuzzification(
                                  widget.symptomsData.symptomsSeverity[index],
                                  widget.symptomsData.symptomsDays[index],
                                  index)
                              .toString(),
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.black, fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                selectedFuzzyValueSymptom[index] = 0;
                return Container();
              }
            },
          ),
        )
      ],
    );
  }

  //Build proceed button
  Widget _buildProceedButton() {
    return Container(
      height: 56.0,
      color: Theme.of(context).primaryColor,
      child: FlatButton(
        textColor: Colors.white,
        child: Text(
          'PROCEED',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          var data =
              FuzzyData(selectedSeveritySymptom, selectedFuzzyValueSymptom);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResultPage(fuzzyData: data)));
          for (int i = 0; i < 11; i++) {
            debugPrint('PROCEED Button is tapped!');
            debugPrint(
                'Severity[$i]: ' + selectedSeveritySymptom[i].toString());
            debugPrint('Fuzzy[$i]: ' + selectedFuzzyValueSymptom[i].toString());
          }
        },
      ),
    );
  }

  //Build level of severity guide
  Widget _buildLevelOfSeverityGuide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
          child: Text(
            'Level of Severity Reference:',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 20.0,
                      width: 20.0,
                      decoration: BoxDecoration(
                          color: Color(0xFFDCE775),
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    SizedBox(width: 5.0),
                    Text(': Mild')
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 20.0,
                      width: 20.0,
                      decoration: BoxDecoration(
                          color: Color(0xFFFFF176),
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    SizedBox(width: 5.0),
                    Text(': Moderate')
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 20.0,
                      width: 20.0,
                      decoration: BoxDecoration(
                          color: Color(0xFFFFB74D),
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    SizedBox(width: 5.0),
                    Text(': Severe')
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 20.0,
                      width: 20.0,
                      decoration: BoxDecoration(
                          color: Color(0xFFE57373),
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    SizedBox(width: 5.0),
                    Text(': '),
                    Text(
                      'Very Severe',
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          height: 10.0,
          color: Colors.blueGrey,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Symptoms Preview')),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTitle(),
              _buildLevelOfSeverityGuide(),
              _buildSymptomsList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildProceedButton(),
    );
  }

  //Convert severity int into String for display
  String _symptomsName(int symptoms) {
    String symptomName;
    switch (symptoms) {
      case 0:
        symptomName = 'Body Temperature';
        break;
      case 1:
        symptomName = 'Chills';
        break;
      case 2:
        symptomName = 'Fatigue';
        break;
      case 3:
        symptomName = 'Fever';
        break;
      case 4:
        symptomName = 'Headache';
        break;
      case 5:
        symptomName = 'Diarrhea';
        break;
      case 6:
        symptomName = 'Malaise';
        break;
      case 7:
        symptomName = 'Muscular Pain';
        break;
      case 8:
        symptomName = 'Nausea';
        break;
      case 9:
        symptomName = 'Sweating';
        break;
      case 10:
        symptomName = 'Vomiting';
        break;
      default:
        symptomName = 'Null';
    }
    return symptomName;
  }

  //Select the color based on the severity
  Color _colorSymptoms(int severityLevel) {
    Color color;
    switch (severityLevel) {
      case 1:
        color = Color(0xFFDCE775);
        break;
      case 2:
        color = Color(0xFFFFF176);
        break;
      case 3:
        color = Color(0xFFFFB74D);
        break;
      case 4:
        color = Color(0xFFE57373);
        break;
      default:
        color = Colors.blueGrey;
    }
    return color;
  }

  //Perform fuzzification and store the fuzzy value into a List variable named selectedFuzzyValueSymptom
  double _fuzzification(int severity, int days, int index) {
    double fuzzyValue;
    switch (severity) {
      case 1:
        if (days > 0 && days <= 14) {
          fuzzyValue = double.parse(((days / 14).toStringAsFixed(1)));
          selectedFuzzyValueSymptom[index] = fuzzyValue;
        } else if (days > 14 && days < 21) {
          fuzzyValue = double.parse((((21 - days) / 7).toStringAsFixed(1)));
          selectedFuzzyValueSymptom[index] = fuzzyValue;
        }
        break;
      case 2:
        if (days > 14 && days <= 21) {
          fuzzyValue = double.parse((((days - 14) / 7).toStringAsFixed(1)));
          selectedFuzzyValueSymptom[index] = fuzzyValue;
        } else if (days > 21 && days < 28) {
          fuzzyValue = double.parse((((28 - days) / 7).toStringAsFixed(1)));
          selectedFuzzyValueSymptom[index] = fuzzyValue;
        }
        break;
      case 3:
        if (days > 21 && days <= 28) {
          fuzzyValue = double.parse((((days - 21) / 7).toStringAsFixed(1)));
          selectedFuzzyValueSymptom[index] = fuzzyValue;
        } else if (days > 28 && days < 35) {
          fuzzyValue = double.parse((((35 - days) / 7).toStringAsFixed(1)));
          selectedFuzzyValueSymptom[index] = fuzzyValue;
        }
        break;
      case 4:
        if (days > 28 && days <= 41) {
          fuzzyValue = double.parse((((days - 28) / 7).toStringAsFixed(1)));
          selectedFuzzyValueSymptom[index] = fuzzyValue;
        }
        break;
      default:
    }
    return fuzzyValue;
  }

  //Store list data from SymptomsPage into a variable named selectedSeveritySymtom
  void getSeverityList(List<int> symptomSeverity) {
    for (int i = 0; i < 11; i++) {
      selectedSeveritySymptom[i] = symptomSeverity[i];
    }
  }
}

class FuzzyData {
  List<int> symptomsSeverity;
  List<double> symptomsFuzzyValue;

  FuzzyData(this.symptomsSeverity, this.symptomsFuzzyValue);
}
