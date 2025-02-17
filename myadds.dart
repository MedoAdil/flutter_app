import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyAdds extends StatefulWidget {
  @override
  _MyAddsState createState() => _MyAddsState();
}

class _MyAddsState extends State<MyAdds> {
  String selectedCategory = 'Services Available';
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
  
  LatLng? selectedLocation;
  File? image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MyAdds")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(labelText: 'Select Category'),
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: buildDynamicContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDynamicContent() {
    List<Widget> formFields = [];

    if (selectedCategory == 'Services Available' || selectedCategory == 'Services Required') {
      formFields.add(buildDropdown('Type of Help', helpTypes));
    } else if (selectedCategory == 'Missing Person') {
      formFields.add(buildTextField('Person Name'));
    } else if (selectedCategory == 'Missing Items') {
      formFields.add(buildTextField('Type of Item'));
    } else if (selectedCategory == 'Lost Vehicle') {
      formFields.add(buildTextField('Type of Vehicle'));
    } else if (selectedCategory == 'Report A Violation') {
      formFields.add(buildTextField('Type of Violation'));
    }

    formFields.add(buildTextField('Description'));
    formFields.add(buildDropdown('Choose State', states));
    formFields.add(buildTextField('Address'));
    formFields.add(buildTextField('Mobile Number'));
    formFields.add(buildLocationPicker());
    formFields.add(buildImagePicker());
    formFields.add(SizedBox(height: 20));
    formFields.add(buildSaveButton());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: formFields,
    );
  }

  Widget buildTextField(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }

  Widget buildDropdown(String label, List<String> items) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (String? newValue) {},
      ),
    );
  }

  Widget buildLocationPicker() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
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
        child: Text(selectedLocation == null
            ? 'Pick Location'
            : 'Location Selected: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}'),
      ),
    );
  }

  Widget buildImagePicker() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Upload Picture'),
          ),
          if (image != null) Image.file(image!, height: 100),
        ],
      ),
    );
  }

  Widget buildSaveButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
        child: Text('Save Data'),
        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
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
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
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
