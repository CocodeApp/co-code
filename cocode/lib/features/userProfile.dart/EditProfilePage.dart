import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  EditProfile createState() => EditProfile();
}

class EditProfile extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(
          color: Colors.deepOrangeAccent,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xff2A4793)),
        ),
      ),
    );
  }
}

/*
* Container(
* Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: AlignmentDirectional.centerStart,
                      margin: EdgeInsets.only(left: 4),
                      child: Text("City"),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Card(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                                    child: DirectSelectList<String>(
                                                     values: _cities,
                                                     defaultItemIndex: 3,
                                                     itemBuilder: (String value) => getDropDownMenuItem(value),
                                                     focusedItemDecoration: _getDslDecoration(),
                                                     onItemSelectedListener: (item, index, context) {
                                                       Scaffold.of(context).showSnackBar(SnackBar(content: Text(item)));
                                                     }),
                                    padding: EdgeInsets.only(left: 12))),
                            Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.unfold_more,
                                color: Colors.black38,
                              ),
                            )
                          ],
                        ),
                         ),
                    ),
* )*/
