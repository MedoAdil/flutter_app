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
        onPressed: () {},
        child: Text('Pick Location'),
      ),
    );
  }

  Widget buildImagePicker() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: () {},
        child: Text('Upload Picture'),
      ),
    );
  }

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
