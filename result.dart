import 'package:flutter/material.dart';
import 'symptoms_preview.dart';
import 'dart:math';

class ResultPage extends StatefulWidget {
  final FuzzyData fuzzyData;
  ResultPage({this.fuzzyData});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  //Fuzzy Rule Base for Malaria
  static List<int> rule1 = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
  static List<int> rule2 = [1, 2, 2, 1, 2, 1, 2, 1, 1, 1, 2, 1];
  static List<int> rule3 = [3, 1, 3, 3, 1, 2, 3, 1, 1, 1, 1, 2];
  static List<int> rule4 = [3, 2, 2, 3, 1, 1, 1, 1, 2, 1, 1, 1];
  static List<int> rule5 = [1, 3, 3, 2, 1, 1, 2, 2, 2, 1, 1, 1];
  static List<int> rule6 = [1, 3, 1, 1, 3, 1, 3, 3, 1, 3, 2, 2];
  static List<int> rule7 = [1, 3, 3, 1, 2, 3, 2, 1, 3, 1, 3, 2];
  static List<int> rule8 = [0, 3, 4, 2, 2, 3, 4, 4, 4, 3, 0, 4];
  static List<int> rule9 = [0, 1, 0, 1, 1, 2, 2, 1, 2, 0, 1, 1];
  static List<int> rule10 = [1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1];
  static List<int> rule11 = [1, 2, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1];
  static List<int> rule12 = [0, 2, 2, 1, 2, 2, 2, 3, 3, 2, 1, 3];
  static List<int> rule13 = [1, 1, 1, 4, 3, 1, 0, 4, 0, 4, 0, 4];
  static List<int> rule14 = [1, 1, 4, 1, 4, 3, 1, 3, 3, 1, 0, 3];
  static List<int> rule15 = [0, 0, 4, 4, 3, 0, 2, 0, 3, 0, 2, 4];
  static List<int> rule16 = [0, 0, 0, 0, 0, 0, 3, 3, 1, 0, 3, 3];
  static List<int> rule17 = [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
  static List<int> rule18 = [0, 1, 1, 1, 4, 1, 4, 3, 0, 0, 0, 4];
  static List<int> rule19 = [1, 0, 0, 0, 0, 0, 1, 3, 0, 3, 3, 3];
  static List<int> rule20 = [0, 3, 2, 3, 4, 3, 2, 3, 4, 3, 3, 4];

  List<List<int>> listOfRule = [
    rule1,
    rule2,
    rule3,
    rule4,
    rule5,
    rule6,
    rule7,
    rule8,
    rule9,
    rule10,
    rule11,
    rule12,
    rule13,
    rule14,
    rule15,
    rule16,
    rule17,
    rule18,
    rule19,
    rule20
  ];

  //R Chosen with R Value
  List<int> rChosen = [];
  List<double> rValue = [];

  //R Value for each severity
  double rMild = 0;
  double rModerate = 0;
  double rSevere = 0;
  double rVerySevere = 0;

  //Centre of Gravity
  double centreOfGravity;

  //Result
  String resultOfDiagnosis;

  //Build Subtitle
  Widget _buildSubtitle() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Based on the symptoms that has been selected, below is the result of diagnosis.',
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.normal,
              fontSize: 16.0,
            ),
          ),
        ),
        Divider(height: 10.0, color: Colors.blueGrey)
      ],
    );
  }

  //Build Result
  Widget _buildResult() {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: _severityColor(),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Text('Severity of Malaria', style: TextStyle(color: Colors.black)),
          SizedBox(height: 10.0),
          Text(
            resultOfDiagnosis == null
                ? resultOfDiagnosis = 'No Result Obtained :('
                : resultOfDiagnosis,
            style: TextStyle(
                fontSize: 28.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          Divider(height: 20.0, color: Colors.black54),
          Text(
            'Centre of Gravity (COG)',
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            centreOfGravity.toString() == 'NaN'
                ? 'Not Data Available\n\nIt is because the symptoms selected do not match with our fuzzy rule database.\n\nBut hey, look on the bright side, this means that you are not associated with Malaria disease :D'
                : centreOfGravity.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  //Build Special Result
  Widget _buildSpecialResult() {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: _severityColor(),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Text(
            'We have detected a perfect Rule Match in our database!\n\nSeverity of Malaria',
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.0),
          Text(
            resultOfDiagnosis == null
                ? resultOfDiagnosis = 'No Result Obtained :('
                : resultOfDiagnosis,
            style: TextStyle(
                fontSize: 28.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          Divider(height: 20.0, color: Colors.black54),
          Text(
            'Degree of Membership',
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            centreOfGravity.toString() == 'NaN'
                ? 'Not Data Available\n\nIt is because the symptoms selected do not match with our fuzzy rule database.\n\nBut hey, look on the bright side, this means that you are not associated with Malaria disease :D'
                : centreOfGravity.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
        ],
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
      ],
    );
  }

  //Build Reset Button
  Widget _buildFinalInstruction() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
      child: Text(
        'Would you like to start over?\nTap the "REEVALUATE" button start over with new entries.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.blueGrey, fontSize: 16.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Inference Engine
    int specialValidator;
    for (int i = 0; i < 20; i++) {
      specialValidator = _specialCheckRule(widget.fuzzyData.symptomsSeverity,
          widget.fuzzyData.symptomsFuzzyValue, listOfRule[i]);
      debugPrint('specialValidator ' + specialValidator.toString());
      debugPrint('centreOfGravity ' + centreOfGravity.toString());
      if (specialValidator == 1) {
        break;
      } else {
        continue;
      }
    }

    if (specialValidator == 0) {
      for (int i = 0; i < 20; i++) {
        _ruleEvaluation(widget.fuzzyData.symptomsSeverity,
            widget.fuzzyData.symptomsFuzzyValue, listOfRule[i]);
      }
      _aggregationOfRuleOutputs(rChosen, rValue);
      _defuzzification(rMild, rModerate, rSevere, rVerySevere);
    }

    // //Debugging
    // for (int i = 0; i < rChosen.length; i++) {
    //   debugPrint('R Chosen[$i]: ' + rChosen[i].toString());
    //   debugPrint('R Value[$i]: ' + rValue[i].toString());
    // }
    // debugPrint('Result: $resultOfDiagnosis');
    // debugPrint('COG: $centreOfGravity');

    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnosis Result'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(children: <Widget>[
          Column(
            children: <Widget>[
              _buildSubtitle(),
              _buildLevelOfSeverityGuide(),
              specialValidator == 1
                  ? _buildSpecialResult()
                  : specialValidator == 0 ? _buildResult() : null,
            ],
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildFinalInstruction(),
            ),
          )
        ]),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).primaryColor,
        height: 56.0,
        width: double.infinity,
        child: FlatButton(
          child: Text(
            'REEVALUATE',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.popUntil(
                context, ModalRoute.withName(Navigator.defaultRouteName));
          },
        ),
      ),
    );
  }

  int _specialCheckRule(List severity, List fuzzyValue, List rule) {
    double minimumValue = 2.0;
    int finalValue = 0;
    int validator = 0;
    int finalResult;
    for (int i = 0; i < rule.length - 1; i++) {
      if (severity[i] == rule[i]) {
        validator++;
        if (severity[i] != 0) {
          if (fuzzyValue[i] < minimumValue) {
            minimumValue = fuzzyValue[i];
          }
        }
      }
      if (validator == 11) {
        finalResult = rule[11];
        if (finalResult == 1) {
          resultOfDiagnosis = "MILD";
        } else if (finalResult == 2) {
          resultOfDiagnosis = "MODERATE";
        } else if (finalResult == 3) {
          resultOfDiagnosis = "SEVERE";
        } else if (finalResult == 4) {
          resultOfDiagnosis = "VERY SEVERE";
        }
        centreOfGravity = minimumValue;
        finalValue = 1;
        break;
      } else {
        continue;
      }
    }
    return finalValue;
  }

  //Rule Evaluation Process
  void _ruleEvaluation(List severity, List fuzzyValue, List rule) {
    double minimumValue = 2.0;
    int r;
    for (int i = 0; i < rule.length - 1; i++) {
      if (severity[i] == rule[i]) {
        if (fuzzyValue[i] < minimumValue) {
          minimumValue = fuzzyValue[i];
        }
        r = rule[11];
      }
    }
    if (r != null) {
      rChosen.add(r);
    }
    if (minimumValue != 2.0) {
      rValue.add(minimumValue);
    }
  }

  //Aggregation Of Rule Outputs
  _aggregationOfRuleOutputs(List r, List rValue) {
    for (int i = 0; i < r.length; i++) {
      if (r[i] == 1) {
        rMild += pow(rValue[i], 2);
      } else if (r[i] == 2) {
        rModerate += pow(rValue[i], 2);
      } else if (r[i] == 3) {
        rSevere += pow(rValue[i], 2);
      } else if (r[i] == 4) {
        rVerySevere += pow(rValue[i], 2);
      }
    }

    rMild = double.parse((sqrt(rMild).toStringAsFixed(4)));
    rModerate = double.parse((sqrt(rModerate).toStringAsFixed(4)));
    rSevere = double.parse((sqrt(rSevere).toStringAsFixed(4)));
    rVerySevere = double.parse((sqrt(rVerySevere).toStringAsFixed(4)));
    debugPrint('Mild: $rMild');
    debugPrint('Moderate: $rModerate');
    debugPrint('Severe: $rSevere');
    debugPrint('Very Severe: $rVerySevere');
  }

  //Defuzzification
  void _defuzzification(
      double rMild, double rModerate, double rSevere, double rVerySevere) {
    centreOfGravity = (rMild * 0.15) +
        (rModerate * 0.45) +
        (rSevere * 0.7) +
        (rVerySevere * 0.9);
    centreOfGravity /= (rMild + rModerate + rSevere + rVerySevere);
    centreOfGravity = double.parse((centreOfGravity.toStringAsFixed(2)));

    if (centreOfGravity >= 0 && centreOfGravity < 0.3) {
      resultOfDiagnosis = 'MILD';
    } else if (centreOfGravity >= 0.3 && centreOfGravity < 0.6) {
      resultOfDiagnosis = 'MODERATE';
    } else if (centreOfGravity >= 0.6 && centreOfGravity < 0.8) {
      resultOfDiagnosis = 'SEVERE';
    } else if (centreOfGravity >= 0.8 && centreOfGravity < 1.0) {
      resultOfDiagnosis = 'VERY SEVERE';
    }
  }

  //Get color according to its severity
  Color _severityColor() {
    Color color;
    if (resultOfDiagnosis == 'MILD') {
      color = Color(0xFFDCE775);
    } else if (resultOfDiagnosis == 'MODERATE') {
      color = Color(0xFFFFF176);
    } else if (resultOfDiagnosis == 'SEVERE') {
      color = Color(0xFFFFB74D);
    } else if (resultOfDiagnosis == 'VERY SEVERE') {
      color = Color(0xFFE57373);
    } else if (resultOfDiagnosis == null) {
      color = Colors.blueGrey;
    }
    return color;
  }
}
