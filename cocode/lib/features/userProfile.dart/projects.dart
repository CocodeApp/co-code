Material(
// this part will be showing for each project
color: Colors.white70,
child: StreamBuilder<QuerySnapshot>(
stream: userProjects.snapshots(),
// ignore: missing_return
builder: (BuildContext context,
    AsyncSnapshot<QuerySnapshot>
snapshot) {
if (snapshot.data == null)
return indicator();
if (snapshot.hasData) {
var doc = snapshot.data.docs;
return ListView.builder(
itemCount: doc.length,
itemBuilder: (context, index) {
Map data = doc[index].data();
return InkWell(
//stream list v
onTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) {
return new viewProject(
id: ""); // this must lead to the projects that user in
},
),
);
},
child: Column(
// list of projects from data base
children: [
Container(
//project logo from database
height: 0.12 *
MediaQuery.of(
context)
    .size
    .height,
width: 0.350 *
MediaQuery.of(
context)
    .size
    .width,
child: ClipRRect(
borderRadius:
BorderRadius
    .circular(
20.0),
child: Image.asset(
'imeges/logo-2.png', //project logo
),
),
),
Text(
data['projectName'],
style: TextStyle(
fontWeight:
FontWeight.bold,
fontSize: 17,
color: Colors
    .deepOrangeAccent,
),
)
],
),
);
},
);
}
;
},
),
),