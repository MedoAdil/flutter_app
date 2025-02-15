import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Adds")),
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
      formFields.add(buildDropdown('Type of Help', helpTypes, Icons.help));
    } else if (selectedCategory == 'Missing Person') {
      formFields.add(buildTextField('Person Name', Icons.person));
    } else if (selectedCategory == 'Missing Items') {
      formFields.add(buildTextField('Type of Item', Icons.inventory));
    } else if (selectedCategory == 'Lost Vehicle') {
      formFields.add(buildTextField('Type of Vehicle', Icons.directions_car));
    } else if (selectedCategory == 'Report A Violation') {
      formFields.add(buildTextField('Type of Violation', Icons.report));
    }

    formFields.add(buildTextField('Description', Icons.description));
    formFields.add(buildDropdown('Choose State', states, Icons.location_on));
    formFields.add(buildTextField('Address', Icons.home));
    formFields.add(buildTextField('Mobile Number', Icons.phone));
    formFields.add(buildLocationPicker());
    formFields.add(buildImagePicker());
    formFields.add(SizedBox(height: 20));
    formFields.add(buildSaveButton());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: formFields,
    );
  }
// A helper function to create text fields with labels
  Widget buildTextField(String label, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

// A helper function to create dropdowm menu with labels
  Widget buildDropdown(String label, List<String> items, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
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

// A helper function for location picker bottom
  Widget buildLocationPicker() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: () {},
        child: Text('Pick Location'),
      ),
    );
  }

// A helper function for upload picture bottom
  Widget buildImagePicker() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: () {},
        child: Text('Upload Picture'),
      ),
    );
  }

// A helper function for save data bottom
  Widget buildSaveButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
        child: Text('Save Data'),
        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5)),
      ),
    );
  }
}
