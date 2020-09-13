import 'package:flutter/material.dart';

/// This Widget is the main application widget.
class homePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Appbar(),
    );
  }
}

//taps that will be displayed in the app bar
final List<Tab> tabs = <Tab>[
  Tab(text: 'need team member'),
  Tab(text: 'need supervisor'),
];

/// This is the stateless widget that the main application instantiates.
class Appbar extends StatelessWidget {
  Appbar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            // Your code goes here.
            // To get index of current tab use tabController.index
          }
        });
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff2A4793),
            title: Text('Explore ideas'),
            bottom: TabBar(
              tabs: tabs,
            ),
          ),
          body: TabBarView(
            children: [IdeaCard(), IdeaCard()],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
            },
            child: Icon(Icons.add),
            backgroundColor: Color(0xffF57862),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Color(0xff2A4793),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.work),
                title: Text('my projects'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('profile'),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class IdeaCard extends StatelessWidget {
  IdeaCard({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 10.5,
        child: Card(
          child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                //VIEW PROJECT DETAILS GOES HERE
              },
              child: const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(0xffF57862),
                  radius: 30,
                ),
                title: Text("title"),
                subtitle: Text("description goes here"),
              )),
        ));
  }
}
