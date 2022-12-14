import 'package:badam/apiReqeust/constants.dart';
import 'package:badam/strings.dart';
import 'package:badam/style/style.dart';
import 'package:flutter/material.dart';

class FeatureProperty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            welcomeText(TITLE_TEXT_FEATURE_PRPERTY,context),
            
              SizedBox(height: 50,),
              Container(
               margin: EdgeInsets.only(bottom: 10),
               
              decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor, width: 3.0),
                    // color: Colors.indigo[900],
                    borderRadius: BorderRadius.all(Radius.circular(15))

                  ),
              child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                Navigator.of(context).pop(StatusProperty.forsale);
              },
                child: Container(
                  alignment: Alignment.center,
                  width: 200,
                  child: Text(TEXT_BUY,style: feature_style(context)),
                ),
              ),
            ),
         
           Container(
               margin: EdgeInsets.only(bottom: 10),
               
              decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor, width: 3.0),
                    // color: Colors.indigo[900],
                    borderRadius: BorderRadius.all(Radius.circular(15))

                  ),
              child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                Navigator.of(context).pop(StatusProperty.forrent);
              },
                child: Container(
                  alignment: Alignment.center,
                  width: 200,
                  child: Text(TEXT_RENT,style: feature_style(context)),
                ),
              ),
            ),
         
          Container(
               margin: EdgeInsets.only(bottom: 10),
               
              decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor, width: 3.0),
                    // color: Colors.indigo[900],
                    borderRadius: BorderRadius.all(Radius.circular(15))

                  ),
              child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                Navigator.of(context).pop(StatusProperty.formortage);
              },
                child: Container(
                  alignment: Alignment.center,
                  width: 200,
                  child: Text("??????",style: feature_style(context)),
                ),
              ),
            ),
          Container(
               margin: EdgeInsets.only(bottom: 10),
               
              decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor, width: 3.0),
                    // color: Colors.indigo[900],
                    borderRadius: BorderRadius.all(Radius.circular(15))

                  ),
              child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                Navigator.of(context).pop(StatusProperty.forexchange);
              },
                child: Container(
                  alignment: Alignment.center,
                  width: 200,
                  child: Text("????????????",style: feature_style(context)),
                ),
              ),
            ),
         
            Container(
              decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor, width: 3.0),
                    // color: Colors.indigo[900],
                    borderRadius: BorderRadius.all(Radius.circular(15))

                  ),
              child: FlatButton(
                 padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.of(context).pop("close");
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 200,
                  child: Text(TEXT_CLOSE,style: feature_style(context)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
