import 'package:flutter/material.dart';
import 'package:flutter_app/myadds.dart';
import 'package:flutter_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching Google Maps
import 'package:firebase_auth/firebase_auth.dart';

class home extends StatefulWidget {

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int currentPageIndex = 0;
final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  /// Fetch user details from Firestore
  void fetchUserDetails() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();

    if (userSnapshot.exists) {
      setState(() {
        userName = userSnapshot['firstName'] + " " + userSnapshot['secondName'];
        userEmail = userSnapshot['email'];
      });
    }
  }

/// Get the user_ads collection from firestore
Stream<QuerySnapshot> _fetchData({bool isMyAds = false}) {
  if (isMyAds) {
    // Fetch only the current user's ads
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('user_ads')
        .where('uid', isEqualTo: currentUserId) // Filter by UID
        .orderBy('timestamp', descending: true) // Order by timestamp
        .snapshots();
  } else {
    // Fetch all ads (for News Feed)
    return FirebaseFirestore.instance
        .collection('user_ads')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

/// Function to go direct to the location selected in Incident
  void _openGoogleMaps(double latitude, double longitude) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open Google Maps';
    }
  }
  
/// The Navigation Drawer List
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
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
                userName ?? "Loading...",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(userEmail ?? "Loading..."),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://th.bing.com/th/id/OIP.Ii15573m21uyos5SZQTdrAHaHa?rs=1&pid=ImgDetMain'),
              ),
            ),
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

/// Bottom Navigation Drawer
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

        Center(
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // First Row of Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150, // Fixed width for all buttons
              height: 50,  // Fixed height for all buttons
              child: FloatingActionButton.extended(
                heroTag: "btn1",
                onPressed: () {
                  // Add your onPressed code here!
                },
                label: const Text(
                  'Service Available',
                  textAlign: TextAlign.center, // Center-align text
                ),
                icon: const Icon(Icons.volunteer_activism),
              ),
            ),
            const SizedBox(width: 16), // Spacing between buttons
            SizedBox(
              width: 150, // Fixed width for all buttons
              height: 50,  // Fixed height for all buttons
              child: FloatingActionButton.extended(
                heroTag: "btn2",
                onPressed: () {
                  // Add your onPressed code here!
                },
                label: const Text(
                  'Service Required',
                  textAlign: TextAlign.center, // Center-align text
                ),
                icon: const Icon(Icons.handshake),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16), // Spacing between rows
        // Second Row of Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150, // Fixed width for all buttons
              height: 50,  // Fixed height for all buttons
              child: FloatingActionButton.extended(
                heroTag: "btn3",
                onPressed: () {
                  // Add your onPressed code here!
                },
                label: const Text(
                  'Missing Person',
                  textAlign: TextAlign.center, // Center-align text
                ),
                icon: const Icon(Icons.person_search),
              ),
            ),
            const SizedBox(width: 16), // Spacing between buttons
            SizedBox(
              width: 150, // Fixed width for all buttons
              height: 50,  // Fixed height for all buttons
              child: FloatingActionButton.extended(
                heroTag: "btn4",
                onPressed: () {
                  // Add your onPressed code here!
                },
                label: const Text(
                  'Missing Items',
                  textAlign: TextAlign.center, // Center-align text
                ),
                icon: const Icon(Icons.category),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16), // Spacing between rows
        // Third Row of Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150, // Fixed width for all buttons
              height: 50,  // Fixed height for all buttons
              child: FloatingActionButton.extended(
                heroTag: "btn5",
                onPressed: () {
                  // Add your onPressed code here!
                },
                label: const Text(
                  'Lost Vehicles',
                  textAlign: TextAlign.center, // Center-align text
                ),
                icon: const Icon(Icons.car_crash),
              ),
            ),
            const SizedBox(width: 16), // Spacing between buttons
            SizedBox(
              width: 150, // Fixed width for all buttons
              height: 50,  // Fixed height for all buttons
              child: FloatingActionButton.extended(
                heroTag: "btn6",
                onPressed: () {
                  // Add your onPressed code here!
                },
                label: const Text(
                  'Report Violation',
                  textAlign: TextAlign.center, // Center-align text
                ),
                icon: const Icon(Icons.warning),
              ),
            ),
          ],
        ),
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
                'state': doc['state'],
                'address': doc['address'],
                'mobileNumber': doc['mobileNumber'],
                'imageUrl': doc['imageUrl'],
                'latitude': doc['location']['latitude'],  // Get latitude
                'longitude': doc['location']['longitude'], // Get longitude
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
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['category'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              item['description'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${item['state']} · ${item['address']}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${item['mobileNumber']} · ${item['postedOn']}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => _openGoogleMaps(item['latitude'], item['longitude']),
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(Icons.location_on, size: 18, color: Colors.blue),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(Icons.bookmark_border_rounded, size: 16),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(Icons.share, size: 16),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(Icons.more_vert, size: 16),
                                  ),
                                ),
                              ],
                            ),
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
                        ),
                      ),
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
          Center(
  child: Container(
    constraints: const BoxConstraints(maxWidth: 400),
    child: StreamBuilder<QuerySnapshot>(
      stream: _fetchData(isMyAds: true),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      print('Error fetching data: ${snapshot.error}');
      return Center(child: Text('Error loading data'));
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Center(child: Text('No ads found'));
    }

    print('Fetched ${snapshot.data!.docs.length} documents'); // Debug log
 
        var _articles = snapshot.data!.docs.map((doc) {
          return {
            'description': doc['description'],
            'category': doc['category'],
            'state': doc['state'],
            'address': doc['address'],
            'mobileNumber': doc['mobileNumber'],
            'imageUrl': doc['imageUrl'],
            'latitude': doc['location']['latitude'],
            'longitude': doc['location']['longitude'],
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
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['category'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item['description'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${item['state']} · ${item['address']}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${item['mobileNumber']} · ${item['postedOn']}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () => _openGoogleMaps(item['latitude'], item['longitude']),
                              child: const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.location_on, size: 18, color: Colors.blue),
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.bookmark_border_rounded, size: 16),
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.share, size: 16),
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.more_vert, size: 16),
                              ),
                            ),
                          ],
                        ),
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
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ),
  ),
),

      ///Bookmark Page
            


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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'At Humanitarian Response App, we are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '1. Information We Collect',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'We may collect personal information such as your name, email address, and location when you register or report incidents.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '2. How We Use Your Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Your information is used to provide you with real-time updates, improve our services, and ensure the security of the app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '3. Data Security',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'We use Firebase Authentication and Firestore to securely store your data. All data is encrypted in transit and at rest.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class Terms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terms and Conditions')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'By using the Humanitarian Response App, you agree to the following terms and conditions:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '1. User Responsibilities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'You are responsible for providing accurate information and using the app for lawful purposes only.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '2. Prohibited Activities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'You may not use the app to spread false information, harass others, or engage in illegal activities.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '3. Intellectual Property',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'All content and features of the app are the property of Humanitarian Response App and are protected by intellectual property laws.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class Aboutus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About Us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Us',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to the Humanitarian Response App!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Our Mission',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'We aim to provide a unified platform for real-time communication, incident reporting, and resource allocation during humanitarian crises.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Our Vision',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'To create a world where technology empowers communities to respond effectively to emergencies and save lives.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Our Team',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'We are a team of developers, designers, and humanitarian experts dedicated to making a difference.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class Contactus extends StatelessWidget {
  // Function to open URLs
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Us')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Get in touch with us!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.phone_android, size: 40, color: Colors.green),
                  onPressed: () => _launchURL('https://wa.me/yourwhatsappnumber'),
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.facebook, size: 40, color: Colors.blue),
                  onPressed: () => _launchURL('https://facebook.com/yourfacebookpage'),
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.phone_callback_outlined, size: 40, color: Colors.blue),
                  onPressed: () => _launchURL('https://twitter.com/yourtwitterhandle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}