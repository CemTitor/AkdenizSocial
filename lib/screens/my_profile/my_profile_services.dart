import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_project/constants(config)/app_router.dart';
import 'package:senior_design_project/screens/signup/pages/login.dart';
import 'package:senior_design_project/services/auth.dart';

class MyProfileServices with ChangeNotifier {
  //TODO => yerine {} kullanınca calısmıyor neden ?
  Future<bool?> logutdialog(BuildContext context) async => showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
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
                  Navigator.pop(context, true);
                  Provider.of<Authentication>(context, listen: false)
                      .logOutViaEmail()
                      .whenComplete(
                    () {
                      AppRouter.push(
                        LoginPage(),
                      );
                    },
                  );
                },
              )
            ],
          );
        },
      );
}
