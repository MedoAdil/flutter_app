import 'package:flutter/material.dart';
import 'package:flutter_app/myadds.dart';

class home extends StatefulWidget {

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
     return Scaffold(
      appBar: AppBar(
        title: Text('Gmail Clone'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                "Mohamed Adel",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text("mohamedadel@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/28203059?v=4'),
              ),
            ),
            ListTile(
              title: Text("Sent"),
              leading: Icon(Icons.send),
            ),
            Divider(
              thickness: 1,
            ),
            ListTile(
              title: Text("Inbox"),
              leading: Icon(Icons.inbox),
            ),
            ListTile(
              title: Text("Stared"),
              leading: Icon(Icons.star),
            ),
            Divider(
              thickness: 1,
            ),
            ListTile(
              title: Text("Archive"),
              leading: Icon(Icons.archive),
            ),
            ListTile(
              title: Text("Chat"),
              leading: Icon(Icons.chat),
            ),
            Divider(
              thickness: 1,
            ),
            ListTile(
              title: Text("Log out"),
              leading: Icon(Icons.logout),
            ),
          ],
        ),
      ),

      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.grey,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.chat)),
            label: 'News Feed',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.note_add),
            ),
            label: 'My Ads',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          )
        ],
      ),
      body: <Widget>[

        /// Home page
         Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    FloatingActionButton.extended(
                      heroTag: "btn1",
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                  label: const Text('Service Available'),
                  icon: const Icon(Icons.volunteer_activism),
                ),
                const SizedBox(width: 16),
                    FloatingActionButton.extended(
                      heroTag: "btn2",
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                  label: const Text('Service Required'),
                  icon: const Icon(Icons.handshake),
                ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    FloatingActionButton.extended(
                      heroTag: "btn3",
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                  label: const Text(' Missing  Person '),
                  icon: const Icon(Icons.person_search),
                ),
                const SizedBox(width: 16),
                    FloatingActionButton.extended(
                      heroTag: "btn4",
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                  label: const Text(' Missing   Items '),
                  icon: const Icon(Icons.category),
                ),
              ],
              ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    FloatingActionButton.extended(
                      heroTag: "btn5",
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                  label: const Text('  Lost  Vehicles  '),
                  icon: const Icon(Icons.car_crash),
                ),
                const SizedBox(width: 16),
                    FloatingActionButton.extended(
                      heroTag: "btn6",
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                  label: const Text('Report Violation'),
                  icon: const Icon(Icons.warning),
                ),
              ],),
              ],
            ),
          ),
        ),
        

        /// Notifications page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 1'),
                  subtitle: Text('This is a notification'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 2'),
                  subtitle: Text('This is a notification'),
                ),
              ),
            ],
          ),
        ),

        /// Messages page
        ListView.builder(
          reverse: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Hello',
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Hi!',
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
            );
          },
        ),

      ///Bookmark Page
            const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 1'),
                  subtitle: Text('This is a notification'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 2'),
                  subtitle: Text('This is a notification'),
                ),
              ),
            ],
          ),
        ),


      ][currentPageIndex],
      
      
      floatingActionButton: FloatingActionButton(
        heroTag: "btn7",
      child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => MyAdds(),
                          ));
        }
      )
    );
  }
}