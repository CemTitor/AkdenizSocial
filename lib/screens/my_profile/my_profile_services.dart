import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/services/auth.dart';
import 'package:senior_design_project/theme.dart';

class MyProfileServices with ChangeNotifier {
  Future<bool?> logutdialog(BuildContext context) async {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CustomTheme.black,
          title: Text(
            "Log Out?",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            MaterialButton(
                child: Text(
                  "No",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context, false);
                }),
            MaterialButton(
              color: Colors.red,
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              onPressed: () {
                Provider.of<Authentication>(context, listen: false)
                    .logOutViaEmail()
                    .whenComplete(
                  () {
                    Navigator.pop(context, true);
                    //TODO bottom to top geçis olayını ögren
                    // Navigator.pushReplacement(
                    //   context,
                    //   PageTransition(
                    //       child: WelcomePage(),
                    //       type: PageTransitionType.bottomToTop),
                    // );
                  },
                );
              },
            )
          ],
        );
      },
    );
  }
}
