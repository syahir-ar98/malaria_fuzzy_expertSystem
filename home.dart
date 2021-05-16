import 'package:flutter/material.dart';
import 'package:malaria_fuzzy_expert_system/symptoms.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'MALARIA FUZZY EXPERT SYSTEM (MFES)',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0)
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'This app assists doctors on indentifying the severity of Malaria.\n\nClick the START button below to begin.',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.blueGrey
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0)
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SizedBox(
                width: double.infinity,
                height: 60.0,
                child: FlatButton(
                  color: Color(0xFF4527a0),
                  textColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'START',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),

                  onPressed:() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SymptomsPage()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}