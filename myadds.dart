import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';


class MyAdds extends StatefulWidget {
  @override
  _MyAddsState createState() => _MyAddsState();
}

class _MyAddsState extends State<MyAdds> {
  final _formKey = GlobalKey<FormState>();
  String selectedCategory = 'Services Available';
  String? selectedHelpType;
  String? selectedState;
  String? description;
  String? address;
  String? mobileNumber;
  LatLng? selectedLocation;
  File? image;
  final String defaultImageUrl = 'https://avatars.githubusercontent.com/u/28203059?v=4';

  final List<String> categories = [
    'Services Available',
    'Services Required',
    'Missing Person',
    'Missing Items',
    'Lost Vehicle',
    'Report A Violation'
  ];
  final List<String> helpTypes = ['Doctor', 'Blood', 'Home'];
  final List<String> states = ['Khartoum State', 'Kassala State', 'River Nile State'];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('ads_images/$fileName.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Image upload error: $e");
      return null;
    }
  }

  void _saveData() async {
    if (_formKey.currentState!.validate() && selectedLocation != null) {
      _formKey.currentState!.save();
      String? imageUrl;
      
      if (image != null) {
        imageUrl = await _uploadImage(image!);
      } else {
        imageUrl = defaultImageUrl;
      }

      await FirebaseFirestore.instance.collection('user_ads').add({
        'category': selectedCategory,
        'helpType': selectedHelpType,
        'state': selectedState,
        'description': description,
        'address': address,
        'mobileNumber': mobileNumber,
        'location': {
          'latitude': selectedLocation!.latitude,
          'longitude': selectedLocation!.longitude
        },
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'uid': FirebaseAuth.instance.currentUser!.uid, // Add the user's UID
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data saved successfully!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields and select a location!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MyAdds")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(labelText: 'Select Category', border: OutlineInputBorder()),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(value: category, child: Text(category));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
              SizedBox(height: 10),
              if (selectedCategory == 'Services Available' || selectedCategory == 'Services Required')
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Type of Help', border: OutlineInputBorder()),
                  items: helpTypes.map((String item) {
                    return DropdownMenuItem<String>(value: item, child: Text(item));
                  }).toList(),
                  validator: (value) => value == null ? 'Please select a type' : null,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedHelpType = newValue!;
                    });
                  },
                ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Required field' : null,
                onSaved: (value) => description = value!,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Choose State', border: OutlineInputBorder()),
                items: states.map((String item) {
                  return DropdownMenuItem<String>(value: item, child: Text(item));
                }).toList(),
                validator: (value) => value == null ? 'Required field' : null,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedState = newValue!;
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Required field' : null,
                onSaved: (value) => address = value!,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mobile Number', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Required field' : null,
                onSaved: (value) => mobileNumber = value!,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  LatLng? pickedLocation = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LocationPickerScreen()),
                  );
                  if (pickedLocation != null) {
                    setState(() {
                      selectedLocation = pickedLocation;
                    });
                  }
                },
                child: Text(selectedLocation == null ? 'Pick Location' : 'Location Selected'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Upload Picture'),
              ),
              if (image != null) Image.file(image!, height: 100),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveData,
                  child: Text('Save Data'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Location Picker Screen
class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng _currentPosition = LatLng(15.5007, 32.5599); // Default location (Khartoum)

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Location")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 14),
        markers: {Marker(markerId: MarkerId("selected"), position: _currentPosition)},
        onTap: (LatLng location) {
          setState(() {
            _currentPosition = location;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _currentPosition);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
