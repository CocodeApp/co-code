// import 'package:flutter/material.dart';

// class changeSkills extends StatefulWidget {
//   @override
//   _changeSkillsState createState() => _changeSkillsState();
// }

// class _changeSkillsState extends State<changeSkills> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:  ValueListenableBuilder(
//                         valueListenable: skillsNotifier,
//                         builder: (BuildContext context, List<String> nums,
//                             Widget child) {
//                           return Material(
//                             elevation: 10.0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(8.0),
//                               ),
//                             ),
//                             color: Color(0XAA2A4793),
//                             child: Padding(
//                               padding: EdgeInsets.all(10.0),
//                               child: Wrap(
//                                 children: [
//                                   ListView.builder(
//                                     shrinkWrap: true,
//                                     physics: ScrollPhysics(),
//                                     itemCount: skillsNotifier.value.length,
//                                     itemBuilder: (context, Index) {
//                                       return Card(
//                                         elevation: 15.0,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: const BorderRadius.all(
//                                             Radius.circular(8.0),
//                                           ),
//                                         ),
//                                         child: ListTile(
//                                           leading: Icon(Icons.assignment),
//                                           title:
//                                           Text(skillsNotifier.value[Index]),
//                                           trailing: IconButton(
//                                               icon: Icon(Icons.delete),
//                                               color: Color(0XAAF57862),
//                                               onPressed: () {
//                                                 skillsNotifier.value
//                                                     .removeAt(Index);
//                                                 skillsNotifier
//                                                     .notifyListeners();
//                                               }),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   Theme(
//                                     data: ThemeData(
//                                       primaryColor: Colors.black,
//                                     ),
//                                     child: Padding(
//                                       padding: EdgeInsets.all(15.0),
//                                       child: TextFormField(
//                                         decoration: InputDecoration(
//                                           suffixIcon: IconButton(
//                                               focusColor: Color(0XCC2A4793),
//                                               hoverColor: Color(0XFF2A4793),
//                                               icon: Icon(Icons.add),
//                                               onPressed: () {
//                                                 if (eCtrl.text != "") {
//                                                   skillsNotifier.value
//                                                       .add(eCtrl.text);
//                                                   eCtrl.clear();
//                                                   skillsNotifier
//                                                       .notifyListeners();
//                                                 }
//                                               }),
//                                           hintText: "Add a New Skill",
//                                           contentPadding: EdgeInsets.all(13.0),
//                                           border: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color: Colors.black,
//                                               width: 10.0,
//                                             ),
//                                             borderRadius: BorderRadius.all(
//                                               Radius.circular(50.0),
//                                             ),
//                                           ),
//                                           filled: true,
//                                           fillColor: Colors.white,
//                                         ),
//                                         controller: eCtrl,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//     );
//   }
// }
