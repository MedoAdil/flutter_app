// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class Home extends StatefulWidget {
//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   int currentPageIndex = 0;
//   final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

//   Stream<QuerySnapshot> _fetchData({bool isMyAds = false}) {
//     if (isMyAds) {
//       return FirebaseFirestore.instance
//           .collection('user_ads')
//           .where('uid', isEqualTo: currentUserId)
//           .orderBy('timestamp', descending: true)
//           .snapshots();
//     } else {
//       return FirebaseFirestore.instance
//           .collection('user_ads')
//           .orderBy('timestamp', descending: true)
//           .snapshots();
//     }
//   }

//   Future<void> _toggleBookmark(String adId) async {
//     final userBookmarkRef = FirebaseFirestore.instance
//         .collection('user_bookmarks')
//         .doc(currentUserId)
//         .collection('bookmarks')
//         .doc(adId);

//     final doc = await userBookmarkRef.get();
//     if (doc.exists) {
//       await userBookmarkRef.delete();
//     } else {
//       await userBookmarkRef.set({'adId': adId, 'timestamp': DateTime.now()});
//     }
//   }

//   Stream<QuerySnapshot> _fetchBookmarks() {
//     return FirebaseFirestore.instance
//         .collection('user_bookmarks')
//         .doc(currentUserId)
//         .collection('bookmarks')
//         .orderBy('timestamp', descending: true)
//         .snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Welcome'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.settings),
//             onPressed: () {},
//           )
//         ],
//       ),
//       bottomNavigationBar: NavigationBar(
//         onDestinationSelected: (int index) {
//           setState(() {
//             currentPageIndex = index;
//           });
//         },
//         indicatorColor: Colors.grey,
//         selectedIndex: currentPageIndex,
//         destinations: const <Widget>[
//           NavigationDestination(
//             selectedIcon: Icon(Icons.home),
//             icon: Icon(Icons.home_outlined),
//             label: 'Home',
//           ),
//           NavigationDestination(
//             icon: Badge(child: Icon(Icons.chat)),
//             label: 'News Feed',
//           ),
//           NavigationDestination(
//             icon: Badge(
//               label: Text('2'),
//               child: Icon(Icons.note_add),
//             ),
//             label: 'My Ads',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.bookmark),
//             label: 'Bookmarks',
//           )
//         ],
//       ),
//       body: <Widget>[
//         // Home Page
//         Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Home page content
//               ],
//             ),
//           ),
//         ),

//         // News Feed Page
//         Center(
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 400),
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _fetchData(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 var _articles = snapshot.data!.docs.map((doc) {
//                   return {
//                     'id': doc.id,
//                     'description': doc['description'],
//                     'category': doc['category'],
//                     'state': doc['state'],
//                     'address': doc['address'],
//                     'mobileNumber': doc['mobileNumber'],
//                     'imageUrl': doc['imageUrl'],
//                     'latitude': doc['location']['latitude'],
//                     'longitude': doc['location']['longitude'],
//                     'postedOn': (doc['timestamp'] as Timestamp).toDate(),
//                   };
//                 }).toList();

//                 return ListView.builder(
//                   itemCount: _articles.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     final item = _articles[index];
//                     return FutureBuilder<DocumentSnapshot>(
//                       future: FirebaseFirestore.instance
//                           .collection('user_bookmarks')
//                           .doc(currentUserId)
//                           .collection('bookmarks')
//                           .doc(item['id'])
//                           .get(),
//                       builder: (context, bookmarkSnapshot) {
//                         final isBookmarked = bookmarkSnapshot.data?.exists ?? false;
//                         return Container(
//                           height: 136,
//                           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: const Color(0xFFE0E0E0)),
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           padding: const EdgeInsets.all(8),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       item['category'],
//                                       style: const TextStyle(fontWeight: FontWeight.bold),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     Text(
//                                       item['description'],
//                                       style: const TextStyle(fontWeight: FontWeight.bold),
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       "${item['state']} · ${item['address']}",
//                                       style: Theme.of(context).textTheme.bodySmall,
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       "${item['mobileNumber']} · ${item['postedOn']}",
//                                       style: Theme.of(context).textTheme.bodySmall,
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         InkWell(
//                                           onTap: () => _openGoogleMaps(item['latitude'], item['longitude']),
//                                           child: const Padding(
//                                             padding: EdgeInsets.only(right: 8.0),
//                                             child: Icon(Icons.location_on, size: 18, color: Colors.blue),
//                                           ),
//                                         ),
//                                         InkWell(
//                                           onTap: () => _toggleBookmark(item['id']),
//                                           child: Padding(
//                                             padding: EdgeInsets.only(right: 8.0),
//                                             child: Icon(
//                                               isBookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
//                                               size: 16,
//                                               color: isBookmarked ? Colors.blue : null,
//                                             ),
//                                           ),
//                                         ),
//                                         InkWell(
//                                           onTap: () {},
//                                           child: const Padding(
//                                             padding: EdgeInsets.only(right: 8.0),
//                                             child: Icon(Icons.share, size: 16),
//                                           ),
//                                         ),
//                                         InkWell(
//                                           onTap: () {},
//                                           child: const Padding(
//                                             padding: EdgeInsets.only(right: 8.0),
//                                             child: Icon(Icons.more_vert, size: 16),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 width: 100,
//                                 height: 100,
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey,
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   image: DecorationImage(
//                                     fit: BoxFit.cover,
//                                     image: NetworkImage(item['imageUrl']),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ),

//         // My Ads Page
//         Center(
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 400),
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _fetchData(isMyAds: true),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error loading data'));
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Center(child: Text('No ads found'));
//                 }

//                 var _articles = snapshot.data!.docs.map((doc) {
//                   return {
//                     'id': doc.id,
//                     'description': doc['description'],
//                     'category': doc['category'],
//                     'state': doc['state'],
//                     'address': doc['address'],
//                     'mobileNumber': doc['mobileNumber'],
//                     'imageUrl': doc['imageUrl'],
//                     'latitude': doc['location']['latitude'],
//                     'longitude': doc['location']['longitude'],
//                     'postedOn': (doc['timestamp'] as Timestamp).toDate(),
//                   };
//                 }).toList();

//                 return ListView.builder(
//                   itemCount: _articles.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     final item = _articles[index];
//                     return FutureBuilder<DocumentSnapshot>(
//                       future: FirebaseFirestore.instance
//                           .collection('user_bookmarks')
//                           .doc(currentUserId)
//                           .collection('bookmarks')
//                           .doc(item['id'])
//                           .get(),
//                       builder: (context, bookmarkSnapshot) {
//                         final isBookmarked = bookmarkSnapshot.data?.exists ?? false;
//                         return Container(
//                           height: 136,
//                           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: const Color(0xFFE0E0E0)),
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           padding: const EdgeInsets.all(8),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       item['category'],
//                                       style: const TextStyle(fontWeight: FontWeight.bold),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     Text(
//                                       item['description'],
//                                       style: const TextStyle(fontWeight: FontWeight.bold),
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       "${item['state']} · ${item['address']}",
//                                       style: Theme.of(context).textTheme.bodySmall,
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       "${item['mobileNumber']} · ${item['postedOn']}",
//                                       style: Theme.of(context).textTheme.bodySmall,
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         InkWell(
//                                           onTap: () => _openGoogleMaps(item['latitude'], item['longitude']),
//                                           child: const Padding(
//                                             padding: EdgeInsets.only(right: 8.0),
//                                             child: Icon(Icons.location_on, size: 18, color: Colors.blue),
//                                           ),
//                                         ),
//                                         InkWell(
//                                           onTap: () => _toggleBookmark(item['id']),
//                                           child: Padding(
//                                             padding: EdgeInsets.only(right: 8.0),
//                                             child: Icon(
//                                               isBookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
//                                               size: 16,
//                                               color: isBookmarked ? Colors.blue : null,
//                                             ),
//                                           ),
//                                         ),
//                                         InkWell(
//                                           onTap: () {},
//                                           child: const Padding(
//                                             padding: EdgeInsets.only(right: 8.0),
//                                             child: Icon(Icons.share, size: 16),
//                                           ),
//                                         ),
//                                         InkWell(
//                                           onTap: () {},
//                                           child: const Padding(
//                                             padding: EdgeInsets.only(right: 8.0),
//                                             child: Icon(Icons.more_vert, size: 16),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 width: 100,
//                                 height: 100,
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey,
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   image: DecorationImage(
//                                     fit: BoxFit.cover,
//                                     image: NetworkImage(item['imageUrl']),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ),

//         // Bookmarks Page
//         Center(
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 400),
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _fetchBookmarks(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 var _bookmarks = snapshot.data!.docs.map((doc) {
//                   return {
//                     'adId': doc['adId'],
//                     'timestamp': (doc['timestamp'] as Timestamp).toDate(),
//                   };
//                 }).toList();

//                 return ListView.builder(
//                   itemCount: _bookmarks.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     final bookmark = _bookmarks[index];
//                     return FutureBuilder<DocumentSnapshot>(
//                       future: FirebaseFirestore.instance
//                           .collection('user_ads')
//                           .doc(bookmark['adId'])
//                           .get(),
//                       builder: (context, adSnapshot) {
//                         if (!adSnapshot.hasData) {
//                           return Container();
//                         }

//                         final ad = adSnapshot.data!;
//                         final item = {
//                           'id': ad.id,
//                           'description': ad['description'],
//                           'category': ad['category'],
//                           'state': ad['state'],
//                           'address': ad['address'],
//                           'mobileNumber': ad['mobileNumber'],
//                           'imageUrl': ad['imageUrl'],
//                           'latitude': ad['location']['latitude'],
//                           'longitude': ad['location']['longitude'],
//                           'postedOn': (ad['timestamp'] as Timestamp).toDate(),
//                         };

//                         return Container(
//                           height: 136,
//                           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: const Color(0xFFE0E0E0)),
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           padding: const EdgeInsets.all(8),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       item['category'],
//                                       style: const TextStyle(fontWeight: FontWeight.bold),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     Text(
//                                       item['description'],
//                                       style: const TextStyle(fontWeight: FontWeight.bold),
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       "${item['state']} · ${item['address']}",
//                                       style: Theme.of(context).textTheme.bodySmall,
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       "${item['mobileNumber']} · ${item['postedOn']}",
//                                       style: Theme.of(context).textTheme.bodySmall,
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         InkWell(
//                                           onTap: () => _openGoogleMaps(item['latitude'], item['longitude']),
//                                           child: const Padding(
//                                             padding: EdgeInsets.only(right: 8.0),
//                                             child: Icon(Icons.location_on, size: 18, color: Colors.blue),
//                                           ),
//                                         ),
//                                         InkWell(
//                                           onTap: () => _toggleBookmark(item['id']),
//                                           child: const Padding(
//                                             padding: EdgeInsets.only(right: 8.0),
//                                             child: Icon(Icons.bookmark, size: 16, color: Colors.blue),
//                                           ),
//                                         ),
//                                         InkWell(
//                                           onTap: () {},
//                                           child: const Padding(
//                                             padding: EdgeInsets.only(right: 8.0),
//                                             child: Icon(Icons.share, size: 16),
//                                           ),
//                                         ),
//                                         InkWell(
//                                           onTap: () {},
//                                           child: const Padding(
//                                             padding: EdgeInsets.only(right: 8.0),
//                                             child: Icon(Icons.more_vert, size: 16),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 width: 100,
//                                 height: 100,
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey,
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   image: DecorationImage(
//                                     fit: BoxFit.cover,
//                                     image: NetworkImage(item['imageUrl']),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ),
//       ][currentPageIndex],
//     );
//   }
// }


