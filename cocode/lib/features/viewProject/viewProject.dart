import 'package:cocode/features/addEvents/addEvent.dart';
import 'package:cocode/features/addEvents/listOfEvent.dart';
import 'package:cocode/features/editProject/editProjectForm.dart';
import 'package:cocode/features/posts/channels.dart';
import 'package:cocode/features/posts/posts.dart';
import 'package:cocode/features/acceptReject/Members.dart';
import 'package:cocode/features/userProfile.dart/userProfile.dart';
import 'package:cocode/features/homePage/homePageView.dart';
import 'package:cocode/features/viewProject/skills.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:popup_menu/popup_menu.dart';
import '../../Auth.dart';
import '../addEvent.dart';
import 'teamMembersData.dart';

import 'teamMembers.dart';
import 'skills.dart';
import 'package:cocode/features/editProject/editProjectForm.dart';

class viewProject extends KFDrawerContent {
  var id;

  String tab;
  String previouspage = "";
  viewProject(
      {Key key,
      @required this.id,
      @required this.tab,
      @required this.previouspage});
  @override
  _viewProjectState createState() => _viewProjectState();
}

class _viewProjectState extends State<viewProject> {
  Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('projects');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          data = snapshot.data.data();
          String whatTab =
              data['supervisor'] == "" ? "ideaOwner" : "supervisor";
          List listofmembers = data['teamMembers'];
          String currentSuper = data['supervisor'];
          String currentOwner = data['ideaOwner'];
          String user = Auth.getCurrentUserID();
          bool isSuper = currentSuper.compareTo(user) == 0 ? true : false;
          bool isprojectmember = false;

          if (listofmembers.contains(user) ||
              currentSuper.compareTo(user) == 0 ||
              currentOwner.compareTo(user) == 0) {
            isprojectmember = true;
          }

          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                leading: BackButton(
                  color: Colors.indigo,
                  onPressed: () {
                    if (widget.previouspage.length == 0) {
                      Navigator.pop(context);
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return homePageView();
                      }));
                    }
                  },
                ),
                backgroundColor: Colors.white,
                title: Text(
                  data['projectName'],
                  style: TextStyle(color: Colors.indigo),
                ),
                bottom: TabBar(
                  indicatorColor: Colors.deepOrangeAccent,
                  labelColor: Colors.indigo,
                  tabs: [
                    Tab(
                      text: "project details",
                    ),
                    Tab(
                      text: 'project members',
                    ),
                    Tab(
                      text: 'needed skills',
                    )
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  ProjectDetails(data: data, id: widget.id, tab: whatTab),
                  teamMembersList(
                    projectData: data,
                  ),
                  skills(
                    projectData: data,
                  )
                ],
              ),
            ),
          );
        }

        return Scaffold(
            body: Column(
          children: [
            Center(child: CircularProgressIndicator()),
          ],
        ));
      },
    );
  }
} // there is some missing details , see our class diagram for more info

class ProjectDetails extends StatefulWidget {
  Map<String, dynamic> data;
  var id;

  String tab;
  ProjectDetails({@required this.data, @required this.id, @required this.tab});
  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  String imageURL;

  @override
  Widget build(BuildContext context) {
    String whatTab =
        widget.data['supervisor'] == "" ? "ideaOwner" : "supervisor";
    List listofmembers = widget.data['teamMembers'];
    String currentSuper = widget.data['supervisor'];
    String currentOwner = widget.data['ideaOwner'];
    String user = Auth.getCurrentUserID();
    bool isSuper = currentSuper.compareTo(user) == 0 ? true : false;
    bool isprojectmember = false;

    if (listofmembers.contains(user) ||
        currentSuper.compareTo(user) == 0 ||
        currentOwner.compareTo(user) == 0) {
      isprojectmember = true;
    }
    final ValueNotifier<bool> wantToApply = ValueNotifier<bool>(true);
    final ValueNotifier<bool> show = ValueNotifier<bool>(true);

    String status;
    Future<void> checkApplying() async {
      CollectionReference leaderprofile = FirebaseFirestore.instance
          .collection('User')
          .doc(widget.data[widget.tab])
          .collection('myProjects');

      await leaderprofile.doc(widget.id).get().then((value) {
        List listofapplicants = value.data()['tempList'];
        if (listofapplicants.contains(Auth.getCurrentUserID())) {
          wantToApply.value = false;
        } else
          wantToApply.value = true;
      }).catchError((e) {
        print(e.toString());
      });
    }

    checkApplying();

    void apply() {
      //add the user to the list
      FirebaseFirestore.instance.runTransaction((transaction) async {
        print(widget.tab);
        DocumentSnapshot freshsnap = await transaction.get(FirebaseFirestore
            .instance
            .collection('User')
            .doc(widget.data[widget.tab])
            .collection('myProjects')
            .doc(widget.id));
        List l = [Auth.getCurrentUserID()];
        await transaction.update(
            freshsnap.reference, {'tempList': FieldValue.arrayUnion(l)});
      });

      print("apply");
      //change wantToApply value to false
      wantToApply.value = false;
    }

    void NotApply() {
      //remove the user from the list
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshsnap = await transaction.get(FirebaseFirestore
            .instance
            .collection('User')
            .doc(widget.data[widget.tab])
            .collection('myProjects')
            .doc(widget.id));
        await transaction.update(freshsnap.reference, {
          'tempList': FieldValue.arrayRemove([Auth.getCurrentUserID()])
        });
      });

      //change wantToApply value to true
      wantToApply.value = true;
    }

    imageURL = widget.data['image'];
    String deadline;
    widget.data['deadline'] == ''
        ? deadline = 'not assigned yet'
        : deadline = widget.data['deadline'].toString();
    String startdate;
    widget.data['startdate'] == ''
        ? startdate = 'not assigned yet'
        : startdate = widget.data['startdate'];

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          CircleAvatar(
            backgroundImage: imageURL == null
                ? AssetImage("imeges/logo-2.png")
                : NetworkImage(widget.data['image']),
            radius: 60,
          ), // to be transparent if there is no logo
          SizedBox(
            height: 20,
          ),

          SizedBox(
            width: 350,
            child: Card(
              color: new Color(0xFFdfe7f2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              shadowColor: Colors.grey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          widget.data['projectName'],
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Open Sans',
                              fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          widget.data['projectDescripion'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontFamily: 'Open Sans',
                              fontSize: 15),
                        ),
                      ),
                    ),

                    //here
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 350,
            child: Card(
              color: new Color(0xFFdfe7f2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              shadowColor: Colors.grey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20.0,
                        height: 5.0,
                      ),
                      Icon(
                        Icons.calendar_today,
                        size: 25.0,
                        color: Colors.blueGrey[800],
                      ),
                      SizedBox(
                        width: 20.0,
                        height: 5.0,
                      ),
                      Text(
                        'From:   ' + startdate + '\nTo:      ' + deadline,
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Open Sans',
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 350,
            child: Card(
              color: new Color(0xFFdfe7f2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              shadowColor: Colors.grey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20.0,
                        height: 5.0,
                      ),
                      Icon(
                        Icons.group_add,
                        size: 30.0,
                        color: Colors.blueGrey[800],
                      ),
                      SizedBox(
                        width: 15.0,
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text('Status  :  ' + widget.data['status'],
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          isprojectmember
              ? menu(
                  data: widget.data,
                  id: widget.id,
                  tab: widget.tab,
                )
              : ValueListenableBuilder(
                  builder: (BuildContext context, bool value, Widget child) {
                    return wantToApply.value
                        ? OutlineButton(
                            borderSide: BorderSide(color: Colors.green[300]),
                            child: Text('Join',
                                style: TextStyle(color: Colors.green[300])),
                            onPressed: () {
                              apply();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.green[300])),
                          )
                        : OutlineButton(
                            borderSide:
                                BorderSide(color: Colors.deepOrangeAccent),
                            child: Text('Unjoin',
                                style:
                                    TextStyle(color: Colors.deepOrangeAccent)),
                            onPressed: () {
                              NotApply();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side:
                                    BorderSide(color: Colors.deepOrangeAccent)),
                          );
                  },
                  valueListenable: wantToApply,
                )
        ],
      ),
    );
  }
}

class menu extends StatefulWidget {
  Map<String, dynamic> data;
  var id;

  String tab;
  menu({@required this.id, @required this.data, @required this.tab});
  @override
  _menuState createState() => _menuState();
}

class _menuState extends State<menu> {
  PopupMenu superMenu;
  PopupMenu ownerMenu;
  PopupMenu memberMenu;
  GlobalKey memberKey = GlobalKey();
  GlobalKey ownerKey = GlobalKey();
  GlobalKey superKey = GlobalKey();
  @override
  void initState() {
    super.initState();

    superMenu = PopupMenu(items: [
      MenuItem(
          title: 'channels',
          image: Icon(
            Icons.chat,
            color: Colors.white,
          )),
      MenuItem(
          title: 'applicants',
          image: Icon(
            Icons.inbox,
            color: Colors.white,
          )),
      MenuItem(
          title: 'edit',
          image: Icon(
            Icons.settings,
            color: Colors.white,
          )),
    ], onClickMenu: onClickMenu, onDismiss: onDismiss, maxColumn: 4);
    ownerMenu = PopupMenu(items: [
      MenuItem(
          title: 'channels',
          image: Icon(
            Icons.chat,
            color: Colors.white,
          )),
      MenuItem(
          title: 'applicants',
          image: Icon(
            Icons.inbox,
            color: Colors.white,
          )),
      MenuItem(
          title: 'events',
          image: Icon(
            Icons.calendar_today,
            color: Colors.white,
          )),
    ], onClickMenu: onClickMenu, onDismiss: onDismiss, maxColumn: 4);
    memberMenu = PopupMenu(items: [
      MenuItem(
          title: 'channels',
          image: Icon(
            Icons.chat,
            color: Colors.white,
          )),
      MenuItem(
          title: 'events',
          image: Icon(
            Icons.calendar_today,
            color: Colors.white,
          )),
    ], onClickMenu: onClickMenu, onDismiss: onDismiss, maxColumn: 4);
  }

  void stateChanged(bool isShow) {
    print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  void onClickMenu(MenuItemProvider item) {}

  void onDismiss() {
    print('Menu is dismiss');
  }

  @override
  Widget build(BuildContext context) {
    Future<void> checkApplicants() async {
      CollectionReference leaderprofile = FirebaseFirestore.instance
          .collection('User')
          .doc(widget.data[widget.tab])
          .collection('myProjects');

      await leaderprofile.doc(widget.id).get().then((value) {
        List listofapplicants = value.data()['tempList'];
      }).catchError((e) {
        print(e.toString());
      });
    }

    PopupMenu.context = context;

    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('projects')
            .doc(widget.id)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.data == null) return Container();
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            List listofmembers = data['teamMembers'];
            String currentSuper = data['supervisor'];
            String currentOwner = data['ideaOwner'];
            String user = Auth.getCurrentUserID();

            if (listofmembers.contains(Auth.getCurrentUserID())) {
              return RawMaterialButton(
                  key: memberKey,
                  shape: const StadiumBorder(),
                  splashColor: Color(0xaaf57862),
                  fillColor: Color(0xccf57862),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'more',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    teamMemberMenu();
                  });
            } else if (currentSuper.compareTo(user) == 0) {
              return RawMaterialButton(
                  key: superKey,
                  shape: const StadiumBorder(),
                  splashColor: Color(0xaaf57862),
                  fillColor: Color(0xccf57862),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'more',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    superVisorMenu();
                  });
            } else if (currentOwner.compareTo(user) == 0) {
              return RawMaterialButton(
                  key: ownerKey,
                  shape: const StadiumBorder(),
                  splashColor: Color(0xaaf57862),
                  fillColor: Color(0xccf57862),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'more',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    ideaOwnerMenu();
                  });
            }

            // Center(
            //   child: listofwhat != ""
            //       ? RawMaterialButton(
            //           elevation: 80.0,
            //           fillColor: const Color(0XFF2A4793),
            //                   splashColor: const Color(0xff2980b9),
            //                   child: Padding(
            //                     padding: const EdgeInsets.symmetric(
            //                       vertical: 10.0,
            //                       horizontal: 20.0,
            //                     ),
            //                     child: Text(
            //                       listofwhat,
            //                       style: TextStyle(
            //                           color: Colors.white, fontSize: 20.0),
            //                     ),
            //                   ),
            //                   onPressed: () {
            //                     Navigator.push(context,
            //                         MaterialPageRoute(builder: (_) {
            //                       return Members(
            //                         projectId: widget.id,
            //                         leader: user,
            //                         header: "Applicants in " + project,
            //                       );
            //                     }));
            //                   },
            //                   shape: const StadiumBorder(),
            //                 )
            //               : SizedBox(
            //                   width: 3.0,
            //                   height: 3.0,
            //                 ),
            //         ),
            //       ],
            //     ),
            //   );
            // }
          }
        });
  }

  void teamMemberMenu() {
    memberMenu = PopupMenu(
        backgroundColor: Colors.indigo,
        lineColor: Colors.white,
        // maxColumn: 2,
        items: [
          MenuItem(
              title: 'Channels',
              // textStyle: TextStyle(fontSize: 10.0, color: Colors.tealAccent),
              image: Icon(
                Icons.chat,
                color: Colors.white,
              )),
          MenuItem(
              title: 'events',
              image: Icon(
                Icons.calendar_today,
                color: Colors.white,
              )),
        ],
        onClickMenu: (MenuItemProvider item) {
          switch (item.menuTitle) {
            case 'Channels':
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return channels(
                  projectId: widget.id,
                  isSuper: false,
                ); //update
              }));
              break;
            case 'events':
              return Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ListOfEvents(
                  projectId: widget.id,
                  isSuper: false,
                );
              }));

              break;
          }
        },
        stateChanged: stateChanged,
        onDismiss: onDismiss);

    memberMenu.show(widgetKey: memberKey);
  }

  void ideaOwnerMenu() {
    ownerMenu = PopupMenu(
        backgroundColor: Colors.indigo,
        lineColor: Colors.white,
        // maxColumn: 2,
        items: [
          MenuItem(
              title: 'Channels',
              // textStyle: TextStyle(fontSize: 10.0, color: Colors.tealAccent),
              image: Icon(
                Icons.chat,
                color: Colors.white,
              )),
          MenuItem(
              title: 'applicants',
              image: Icon(
                Icons.inbox,
                color: Colors.white,
              )),
          MenuItem(
              title: 'events',
              image: Icon(
                Icons.calendar_today,
                color: Colors.white,
              )),
        ],
        onClickMenu: (MenuItemProvider item) {
          switch (item.menuTitle) {
            case 'events':
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ListOfEvents(
                  projectId: widget.id,
                  isSuper: false,
                );
              }));

              break;

            case 'Channels':
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return channels(
                  projectId: widget.id,
                  isSuper: false,
                ); //update
              }));
              break;
            case 'applicants':
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Members(
                  projectId: widget.id,
                  leader: Auth.getCurrentUserID(),
                  header: "Applicants in " + widget.data['projectName'],
                );
              }));

              break;
          }
        },
        stateChanged: stateChanged,
        onDismiss: onDismiss);

    ownerMenu.show(widgetKey: ownerKey);
  }

  void superVisorMenu() {
    superMenu = PopupMenu(
        backgroundColor: Colors.indigo,
        lineColor: Colors.white,
        // maxColumn: 2,
        items: [
          MenuItem(
              title: 'Channels',
              // textStyle: TextStyle(fontSize: 10.0, color: Colors.tealAccent),
              image: Icon(
                Icons.chat,
                color: Colors.white,
              )),
          MenuItem(
              title: 'applicants',
              image: Icon(
                Icons.inbox,
                color: Colors.white,
              )),
          MenuItem(
              title: 'edit',
              image: Icon(
                Icons.edit,
                color: Colors.white,
              )),
          MenuItem(
              title: 'events',
              image: Icon(
                Icons.calendar_today,
                color: Colors.white,
              )),
        ],
        onClickMenu: (MenuItemProvider item) {
          switch (item.menuTitle) {
            case 'events':
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ListOfEvents(
                  projectId: widget.id,
                  isSuper: true,
                );
              }));

              break;
            case 'edit':
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new updateProject(id: widget.id)),
              ).then((valeu) {
                setState(() {});
              });
              break;
            case 'Channels':
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return channels(
                  projectId: widget.id,
                  isSuper: true,
                ); //update
              }));
              break;
            case 'applicants':
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Members(
                  projectId: widget.id,
                  leader: Auth.getCurrentUserID(),
                  header: "Applicants in " + widget.data['projectName'],
                );
              }));
              break;
          }
        },
        stateChanged: stateChanged,
        onDismiss: onDismiss);

    superMenu.show(widgetKey: superKey);
  }
}

// there is some missing details , see our class diagram for more info
