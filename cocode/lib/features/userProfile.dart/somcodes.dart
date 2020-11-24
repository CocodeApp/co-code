//     return FutureBuilder<QuerySnapshot>(
//       future: userProjects.get(),
// // ignore: missing_return
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.data == null) {
//           return DotsIndicator(
//             dotsCount: 5,
//           );
//         }
//         var doc = snapshot.data.docs;

//         if (doc.length == 0) {
//           return Container(
//             child: Text(
//               currentName +
//                   " did not join any projects yet !", // this massage must be static
//               style: TextStyle(
//                   color: Colors.deepOrangeAccent, //// latefa
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//           );
//         }

//         if (snapshot.hasData) {
//           return Container(
//             padding: const EdgeInsets.only(left: 20, right: 20),
//             constraints: BoxConstraints(
//               minHeight: 10.0,
//               maxHeight: 100,
//             ),
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: doc.length,
//               itemBuilder: (context, index) {
//                 Map data = doc[index].data();
//                 String projectImg;
//                 return FutureBuilder(
//                     future: FirebaseFirestore.instance
//                         .collection('projects')
//                         .doc(doc[index].id)
//                         .get(),
//                     builder: (context, snapshot) {
//                       Map<String, dynamic> fromProjectCollection =
//                           snapshot.data();
//                       projectImg = fromProjectCollection['image'];
//                       return Row(
//                         children: [
//                           SizedBox(width: 15),
//                           InkWell(
// //stream list v
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) {
//                                     return new viewProject(
//                                       id: doc[index].id,
//                                       tab: "ideaOwner",
//                                       previouspage: "",
//                                     ); //// latefa     // this must lead to the projects that user in
//                                   },
//                                 ),
//                               );
//                             },
//                             child: Column(
// // list of projects from data base
//                               children: [
//                                 ClipRRect(
//                                     borderRadius: BorderRadius.circular(20.0),
//                                     child: Container(
//                                       height: 70.0,
//                                       width: 80.0,
//                                       decoration: BoxDecoration(
//                                         image: DecorationImage(
//                                           image: projectImg == null
//                                               ? AssetImage('imeges/logo-2.png')
//                                               : NetworkImage(projectImg),
//                                           fit: BoxFit.fill,
//                                         ),
//                                         shape: BoxShape.rectangle,
//                                       ),
//                                     )),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   fromProjectCollection['projectName'],
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 17,
//                                     color: Colors.deepOrangeAccent,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       );
//                     });

//                 // print("this is projectImg "+projectImg);// only first image
//               },
//             ),
//           );
//         }
//       },
//     );
