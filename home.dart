import 'package:flutter/material.dart';
import 'package:flutter_app/myadds.dart';
import 'package:flutter_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class home extends StatefulWidget {

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int currentPageIndex = 0;
Stream<QuerySnapshot> _fetchData() {
    return FirebaseFirestore.instance
        .collection('user_ads')
        .orderBy('timestamp', descending: true) // Order by timestamp
        .snapshots();
  }
  
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
              title: Text("Settings"),
              leading: Icon(Icons.settings),
              onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Settings(),));
                  }
            ),
            Divider(thickness: 1),
            ListTile(
              title: Text("Privacy Policy"),
              leading: Icon(Icons.inbox),
              onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Privacy(),));
                  }
            ),
            Divider(thickness: 1),
            ListTile(
              title: Text("Terms and Conditions"),
              leading: Icon(Icons.star),
              onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Terms(),));
                  }
            ),
            Divider(thickness: 1),
            ListTile(
              title: Text("About Us"),
              leading: Icon(Icons.archive),
              onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Aboutus(),));
                  }
            ),
            Divider(thickness: 1),
            ListTile(
              title: Text("Contact Us"),
              leading: Icon(Icons.chat),
              onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Contactus(),));
                  }
            ),
            Divider(thickness: 1),
            ListTile(
              title: Text("Log out"),
              leading: Icon(Icons.logout),
              onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                                builder: (context) => MyApp(),));
                  }
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
        

        /// News Feed page
             Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: StreamBuilder<QuerySnapshot>(
          stream: _fetchData(), // Real-time stream of Firebase data
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

             var _articles = snapshot.data!.docs.map((doc) {
              return {
                'description': doc['description'],
                'category': doc['category'],
                'imageUrl': doc['imageUrl'],
                'postedOn': (doc['timestamp'] as Timestamp).toDate(),
              };
            }).toList();

            return ListView.builder(
              itemCount: _articles.length,
              itemBuilder: (BuildContext context, int index) {
                final item = _articles[index];
                return Container(
                  height: 136,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(8.0)),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['description'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${item['category']} · ${item['postedOn']}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icons.bookmark_border_rounded,
                                Icons.share,
                                Icons.more_vert
                              ].map((e) {
                                return InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(e, size: 16),
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                      Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(item['imageUrl']),
                            ),
                          )),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    ),

        /// My Ads page
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

class Settings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text("Welcome to page")),
    );
  }
}

class Privacy extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policy')),
      body: Center(child: Text("Welcome to page")),
    );
  }
}

class Terms extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terms and Conditions')),
      body: Center(child: Text("Welcome to page")),
    );
  }
}

class Aboutus extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About Us')),
      body: Center(child: Text("Welcome to page")),
    );
  }
}

class Contactus extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Us')),
      body: Center(child: Text("Welcome to page")),
    );
  }
}