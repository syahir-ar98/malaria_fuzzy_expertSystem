import 'package:flutter/material.dart';
import 'package:malaria_fuzzy_expert_system/symptoms_preview.dart';

class SymptomsPage extends StatefulWidget {
  @override
  _SymptomsPageState createState() => _SymptomsPageState();
}

class _SymptomsPageState extends State<SymptomsPage> {
  List<String> symptomList = [
    'Body Temperature',
    'Chills',
    'Fatigue',
    'Fever',
    'Headache',
    'Diarrhea',
    'Malaise',
    'Muscular Pain',
    'Nausea',
    'Sweating',
    'Vomiting'
  ];

  List<bool> symptomOptionStatus = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  List<String> severityOfSymptoms = [
    'Select Severity',
    'Select Severity',
    'Select Severity',
    'Select Severity',
    'Select Severity',
    'Select Severity',
    'Select Severity',
    'Select Severity',
    'Select Severity',
    'Select Severity',
    'Select Severity'
  ];

  //Lists below will be used for fuzzification
  List<int> selectedDaysOfSymptoms = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int> selectedSeverityOfSymptoms = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  //List dropdownValue
  List<String> dropdownValueMild = [for (int i = 0; i < 11; i++) null];
  List<String> dropdownValueModerate = [for (int i = 0; i < 11; i++) null];
  List<String> dropdownValueSevere = [for (int i = 0; i < 11; i++) null];
  List<String> dropdownValueVerySevere = [for (int i = 0; i < 11; i++) null];

  //Build List of symptoms options dynamically
  ListView _buildSymptomsList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: symptomList.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            //Create Checkbox
            CheckboxListTile(
              title: Text(symptomList[index]),
              value: symptomOptionStatus[index],
              activeColor: Theme.of(context).primaryColor,
              onChanged: (newValue) {
                setState(() {
                  symptomOptionStatus[index] = newValue;
                  if (!newValue) {
                    selectedSeverityOfSymptoms[index] = 0;
                    severityOfSymptoms[index] = 'Select Severity';
                    selectedDaysOfSymptoms[index] = 0;
                    dropdownValueMild[index] = null;
                    dropdownValueModerate[index] = null;
                    dropdownValueSevere[index] = null;
                    dropdownValueVerySevere[index] = null;
                  }
                  debugPrint('Symptoms[$index]: $newValue');
                  debugPrint('Days selected[$index]: ' +
                      selectedDaysOfSymptoms[index].toString());
                  debugPrint('Severity selected[$index]: ' +
                      selectedSeverityOfSymptoms[index].toString());
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            //Create Severity and Days of Symptom Options

            symptomOptionStatus[index]
                ? Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text('Severity of Symptom'),
                              SizedBox(height: 5.0),
                              Container(
                                height: 50,
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color(0xFFE7E7E7),
                                ),
                                //Create Dropdown
                                child: DropdownButton<String>(
                                  value: severityOfSymptoms[index],
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  iconSize: 24,
                                  elevation: 16,
                                  underline: SizedBox(),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16.0),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      severityOfSymptoms[index] = newValue;
                                      //Set severity values for fuzzification
                                      if (symptomOptionStatus[index]) {
                                        selectedSeverityOfSymptoms[index] =
                                            _setSelectedSeveritySymptoms(
                                                severityOfSymptoms[index]);
                                      } else {
                                        selectedSeverityOfSymptoms[index] = 0;
                                      }
                                    });
                                  },
                                  items: <String>[
                                    'Select Severity',
                                    'Mild',
                                    'Moderate',
                                    'Severe',
                                    'Very Severe'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Age of Symptom (Days)'),
                              SizedBox(height: 5.0),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFE7E7E7),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                height: 50.0,
                                child: selectedSeverityOfSymptoms[index] == 0
                                    ? Center(
                                        child: Text(
                                        'Select Severity First :)',
                                        style:
                                            TextStyle(color: Color(0xFF607D8B)),
                                      ))
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 8.0),
                                        child: _buildDropdownDays(
                                            selectedSeverityOfSymptoms[index],
                                            index),
                                      ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : Container(),
            SizedBox(height: 5.0),
            Divider(height: 10.0, color: Colors.blueGrey),
            SizedBox(height: 5.0),
          ],
        );
      },
    );
  }

  //Build Dropdownlist for Days
  Widget _buildDropdownDays(int severity, int index) {
    Widget dropdown;
    switch (severity) {
      case 1:
        dropdown = DropdownButton<String>(
          value: dropdownValueMild[index],
          icon: Icon(Icons.keyboard_arrow_down),
          isExpanded: true,
          iconSize: 24,
          elevation: 16,
          underline: SizedBox(),
          hint: Text(
            'Select Days',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0),
          onChanged: (String newValue) {
            setState(() {
              dropdownValueMild[index] = newValue;
              selectedDaysOfSymptoms[index] =
                  int.parse(dropdownValueMild[index]);
              debugPrint(newValue);
              debugPrint(dropdownValueMild[index]);
              debugPrint(selectedDaysOfSymptoms[index].toString());
            });
          },
          items: <String>[for (int i = 1; i <= 20; i++) i.toString()]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
        break;
      case 2:
        dropdown = DropdownButton<String>(
          value: dropdownValueModerate[index],
          icon: Icon(Icons.keyboard_arrow_down),
          isExpanded: true,
          iconSize: 24,
          elevation: 16,
          underline: SizedBox(),
          hint: Text(
            'Select Days',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0),
          onChanged: (String newValue) {
            setState(() {
              dropdownValueModerate[index] = newValue;
              selectedDaysOfSymptoms[index] =
                  int.parse(dropdownValueModerate[index]);
            });
          },
          items: <String>[for (int i = 15; i <= 27; i++) i.toString()]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
        break;
      case 3:
        dropdown = DropdownButton<String>(
          value: dropdownValueSevere[index],
          icon: Icon(Icons.keyboard_arrow_down),
          isExpanded: true,
          iconSize: 24,
          elevation: 16,
          underline: SizedBox(),
          hint: Text(
            'Select Days',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0),
          onChanged: (String newValue) {
            setState(() {
              dropdownValueSevere[index] = newValue;
              selectedDaysOfSymptoms[index] =
                  int.parse(dropdownValueSevere[index]);
            });
          },
          items: <String>[for (int i = 22; i <= 34; i++) i.toString()]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
        break;
      case 4:
        dropdown = DropdownButton<String>(
          value: dropdownValueVerySevere[index],
          icon: Icon(Icons.keyboard_arrow_down),
          isExpanded: true,
          iconSize: 24,
          elevation: 16,
          underline: SizedBox(),
          hint: Text(
            'Select Days',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0),
          onChanged: (String newValue) {
            setState(() {
              if (newValue == 'More than 35') {
                dropdownValueVerySevere[index] = newValue;
                selectedDaysOfSymptoms[index] = 35;
                debugPrint(newValue);
                debugPrint(selectedDaysOfSymptoms[index].toString());
              } else {
                dropdownValueVerySevere[index] = newValue;
                selectedDaysOfSymptoms[index] =
                    int.parse(dropdownValueVerySevere[index]);
              }
            });
          },
          items: <String>[
            for (int i = 29; i <= 35; i++) i.toString(),
            'More than 35'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
        break;
      default:
        dropdown = Container();
    }
    return dropdown;
  }

  //Build Next Button
  Widget _buildNextButton() {
    return Container(
      height: 56.0,
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      child: FlatButton(
        textColor: Colors.white,
        child: Text(
          'PROCEED',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          //Validation
          int numberOfEmptyEntriesSeverity = 0;
          int numberOfEmptyEntriesDays = 0;
          bool idiotDetector1 = false;
          bool idiotDetector2 = false;
          bool idiotDetector3 = false;
          for (int i = 0; i < selectedSeverityOfSymptoms.length; i++) {
            if (selectedSeverityOfSymptoms[i] == 0) {
              numberOfEmptyEntriesSeverity++;
            }
            if (selectedDaysOfSymptoms[i] == 0) {
              numberOfEmptyEntriesDays++;
            }
          }

          if (numberOfEmptyEntriesSeverity == 11 &&
              numberOfEmptyEntriesDays == 11) {
            idiotDetector1 = true;
          }

          for (int i = 0; i < selectedDaysOfSymptoms.length; i++) {
            if (selectedSeverityOfSymptoms[i] != 0 &&
                selectedDaysOfSymptoms[i] == 0) {
              idiotDetector2 = true;
            }
          }

          for (int i = 0; i < symptomOptionStatus.length; i++) {
            if (symptomOptionStatus[i] && selectedSeverityOfSymptoms[i] == 0) {
              idiotDetector3 = true;
            }
          }

          if (idiotDetector2) {
            showDialog(context: context, builder: (_) => _buildAlertDialog2());
          } else if (idiotDetector3) {
            showDialog(context: context, builder: (_) => _buildAlertDialog3());
          } else if (idiotDetector1) {
            showDialog(context: context, builder: (_) => _buildAlertDialog());
          } else {
            //Store symptoms data including their respective days in a variable symptomsData
            var symptomsData = new SymptomsData(
                selectedSeverityOfSymptoms, selectedDaysOfSymptoms);

            //Pass the lists to the next screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SymptomsPreviewPage(symptomsData: symptomsData)));
          }

          //Debugging
          for (int i = 0; i < 11; i++) {
            int valueDays;
            int valueSeverity;
            valueDays = selectedDaysOfSymptoms[i];
            valueSeverity = selectedSeverityOfSymptoms[i];
            debugPrint('Final Days[$i]: $valueDays');
            debugPrint('Final Severity[$i]: $valueSeverity');
          }
          debugPrint('Next Button is Tapped!');
        },
      ),
    );
  }

  //Create instruction
  Widget _buildInstruction() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Text(
        'Choose the following symptom(s) that are related:',
        style: TextStyle(
            color: Colors.blueGrey,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.normal,
            fontSize: 16.0),
      ),
    );
  }

  //Build Alert Dialog for Empty Entry (Not A Single Entry Selected)
  Widget _buildAlertDialog() {
    return AlertDialog(
      title: Text('Empty Entries Detected!'),
      content: Text('Please select symptoms to proceed.'),
      actions: <Widget>[
        FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
    );
  }

  //Build Alert Dialog for Empty Entry (Severity Select, Days Not Selected)
  Widget _buildAlertDialog2() {
    return AlertDialog(
      title: Text('Empty Entries Detected!'),
      content: Text(
          'Please select the Age of Symptoms after you have selected Severity.'),
      actions: <Widget>[
        FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
    );
  }

  //Build Alert Dialog for Empty Entry (Symptoms Selected But Severity and Days Not Selected)
  Widget _buildAlertDialog3() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 200.0),
      child: AlertDialog(
        title: Text('Empty Entries Detected!'),
        content: Text(
            'Please select Severity of Symptoms and Age of Symptoms after you have selected a symptom.'),
        actions: <Widget>[
          FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptoms'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildInstruction(),
              Divider(height: 20.0, color: Colors.blueGrey),
              _buildSymptomsList(),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }
}

//Convert symptom names into int
int _setSelectedSeveritySymptoms(String selectedSeveritySymptom) {
  String value = selectedSeveritySymptom;
  int finalSeveritySymptom;
  switch (value) {
    case 'Mild':
      finalSeveritySymptom = 1;
      break;
    case 'Moderate':
      finalSeveritySymptom = 2;
      break;
    case 'Severe':
      finalSeveritySymptom = 3;
      break;
    case 'Very Severe':
      finalSeveritySymptom = 4;
      break;
    default:
      finalSeveritySymptom = 0;
  }
  return finalSeveritySymptom;
}

//Store the List for fuzzification on the next screen
class SymptomsData {
  List<int> symptomsSeverity;
  List<int> symptomsDays;

  SymptomsData(this.symptomsSeverity, this.symptomsDays);
}
