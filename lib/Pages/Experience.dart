import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../main.dart';
import '../components/Header.dart';
import '../components/StorageDetails.dart';

class ExperienceScreen extends StatefulWidget {
  @override
  _ExperienceScreenState createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  final box = GetStorage();

  List<ExperienceField> companyFields = [];

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  void loadSavedData() {
    setState(() {
      List<dynamic> savedData = box.read('companyFields') ?? [];
      companyFields = savedData.map((data) => ExperienceField.fromMap(data)).toList();
    });
  }

  void saveData() {
    List<Map<String, dynamic>> savedData = companyFields.map((field) => field.toMap()).toList();
    box.write('companyFields', savedData);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data saved successfully!")));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header("Experience"),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - 220,
                        child: ListView.builder(
                          itemCount: companyFields.length,
                          itemBuilder: (context, index) {
                            return ExperienceFormSection(
                              experienceField: companyFields[index],
                              onSave: (value) {
                                setState(() {
                                  companyFields[index] = value;
                                });
                                saveData();
                              },
                              onDelete: () {
                                setState(() {
                                  companyFields.removeAt(index);
                                });
                                saveData();
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: defaultPadding),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            companyFields.add(ExperienceField());
                          });
                          saveData();
                        },
                        child: Text(
                          "Add Experience",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 2,
                        ),
                      ),
                      SizedBox(height: defaultPadding),
                      ElevatedButton(
                        onPressed: saveData,
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: defaultPadding),
                  Expanded(
                    flex: 2,
                    child: StorageDetails(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExperienceField {
  String? experienceCompany;
  String? experienceCountry;
  DateTime startDate;
  DateTime endDate;
  String? description;

  ExperienceField({
    this.experienceCompany,
    this.experienceCountry,
    DateTime? startDate,
    DateTime? endDate,
    this.description,
  })  : startDate = startDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'experienceCompany': experienceCompany,
      'experienceCountry': experienceCountry,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'description': description,
    };
  }

  factory ExperienceField.fromMap(Map<String, dynamic> map) {
    return ExperienceField(
      experienceCompany: map['experienceCompany'],
      experienceCountry: map['experienceCountry'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      description: map['description'],
    );
  }
}

class ExperienceFormSection extends StatefulWidget {
  final ExperienceField experienceField;
  final Function(ExperienceField) onSave;
  final VoidCallback onDelete;

  const ExperienceFormSection({
    required this.experienceField,
    required this.onSave,
    required this.onDelete,
  });

  @override
  _ExperienceFormSectionState createState() => _ExperienceFormSectionState();
}

class _ExperienceFormSectionState extends State<ExperienceFormSection> {
  late TextEditingController companyController;
  late TextEditingController countryController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    companyController = TextEditingController(text: widget.experienceField.experienceCompany);
    countryController = TextEditingController(text: widget.experienceField.experienceCountry);
    descriptionController = TextEditingController(text: widget.experienceField.description);
  }

  @override
  void dispose() {
    companyController.dispose();
    countryController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: companyController,
              decoration: InputDecoration(labelText: 'Company Name'),
              onChanged: (value) {
                widget.experienceField.experienceCompany = value;
                widget.onSave(widget.experienceField);
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: countryController,
              decoration: InputDecoration(labelText: 'Country'),
              onChanged: (value) {
                widget.experienceField.experienceCountry = value;
                widget.onSave(widget.experienceField);
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: widget.experienceField.startDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2101),
                      );
                      if (date != null) {
                        setState(() {
                          widget.experienceField.startDate = date;
                          widget.onSave(widget.experienceField);
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: widget.experienceField.startDate.toString().substring(0, 10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: widget.experienceField.endDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2101),
                      );
                      if (date != null) {
                        setState(() {
                          widget.experienceField.endDate = date;
                          widget.onSave(widget.experienceField);
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: widget.experienceField.endDate.toString().substring(0, 10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onChanged: (value) {
                widget.experienceField.description = value;
                widget.onSave(widget.experienceField);
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onDelete,
              child: Text('Delete Experience'),
            ),
          ],
        ),
      ),
    );
  }
}
