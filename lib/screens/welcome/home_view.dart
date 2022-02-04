// import 'package:flutter/material.dart';
// import 'package:senior_design_project/constants(config)/padding_constant.dart';
// import 'home_model.dart';
// class HomeView extends StatefulWidget {
//   const HomeView({Key? key}) : super(key: key);
//
//   @override
//   _HomeViewState createState() => _HomeViewState();
// }
//
// class _HomeViewState extends State<HomeView> {
//   late HomeModel model;
//   final _HomeStringValues values = _HomeStringValues();
//
//   int value = 0;
//
//   void _changeValue() {
//     setState(() {
//       value += 1;
//     });
//   }
//
//   @override
//   void initState() {
//     //model objesi ekran açıldığında doğar
//     super.initState();
//     model = HomeModel('adı', 'descriptin');
//     model._data;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: _changeValue,
//         child: Text('$value'),
//       ),
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           Text(
//             values.title,
//             style: Theme.of(context).textTheme.headline2,
//           ),
//           Expanded(
//               child: Padding(
//             padding: PaddingConstants.instance.paddingAllNormal,
//             child: Container(),
//           )),
//           Expanded(flex: 3, child: Container()),
//         ],
//       ),
//     );
//   }
// }
