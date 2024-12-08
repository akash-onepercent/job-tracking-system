import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../main.dart';
import '../components/Header.dart';
import '../components/StorageDetails.dart';

class EducationScreen extends StatefulWidget {
  @override
  _EducationScreenState createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final box = GetStorage();

  List<String> educationLevels = ['High School', 'Associate Degree', 'Bachelor\'s Degree', 'Master\'s Degree', 'PhD'];
  List<String> educationStatus = ['Completed', 'On going', 'Dropped'];
  List<EducationField> educationFields = [];

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  void loadSavedData() {
    setState(() {
      List<dynamic> savedData = box.read('educationFields') ?? [];
      educationFields = savedData.map((data) => EducationField.fromMap(data)).toList();
    });
  }

  void saveData() {
    List<Map<String, dynamic>> savedData = educationFields.map((field) => field.toMap()).toList();
    box.write('educationFields', savedData);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data saved successfully!")));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(children: [
          Header("Education"),
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
                        itemCount: educationFields.length,
                        itemBuilder: (context, index) {
                          return EducationFormSection(
                            educationField: educationFields[index],
                            onSave: (value) {
                              setState(() {
                                educationFields[index] = value;
                              });
                              saveData();
                            },
                            onDelete: () {
                              setState(() {
                                educationFields.removeAt(index);
                              });
                              saveData(); // Save after removing
                            },
                            educationLevels: educationLevels,
                            educationStatus: educationStatus,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: defaultPadding),
                    ElevatedButton(
                      onPressed: (){
                        setState(() {
                          educationFields.add(EducationField());
                        });
                      },
                      child: Text(
                        "Add Education",
                        style: TextStyle(
                          color: Colors.black,
                        ),
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
                        style: TextStyle(
                          color: Colors.black,
                        ),
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
        ]),
      ),
    );
  }
}

class EducationField {
  String? educationLevel;
  String? educationStatus;
  String? institution;
  String? degree;
  DateTime startDate;
  DateTime endDate;
  String gpa;
  String gpaMax;

  EducationField({
    this.educationLevel,
    this.educationStatus,
    this.institution,
    this.degree,
    DateTime? startDate,
    DateTime? endDate,
    this.gpa = '',
    this.gpaMax = '',
  })  : startDate = startDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now();


  Map<String, dynamic> toMap() {
    return {
      'educationLevel': educationLevel,
      'educationStatus': educationStatus,
      'institution': institution,
      'degree': degree,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'gpa': gpa,
      'gpaMax': gpaMax,
    };
  }


  factory EducationField.fromMap(Map<String, dynamic> map) {
    return EducationField(
      educationLevel: map['educationLevel'],
      educationStatus: map['educationStatus'],
      institution: map['institution'],
      degree: map['degree'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      gpa: map['gpa'],
      gpaMax: map['gpaMax'],
    );
  }
}

class EducationFormSection extends StatefulWidget {
  final EducationField educationField;
  final Function(EducationField) onSave;
  final VoidCallback onDelete;
  final List<String> educationLevels;
  final List<String> educationStatus;

  EducationFormSection({
    required this.educationField,
    required this.onSave,
    required this.onDelete,
    required this.educationLevels,
    required this.educationStatus,
  });

  @override
  _EducationFormSectionState createState() => _EducationFormSectionState();
}

class _EducationFormSectionState extends State<EducationFormSection> {
  late TextEditingController gpaController;
  late TextEditingController gpaMaxController;
  late TextEditingController institutionController;
  late TextEditingController degreeController;

  @override
  void initState() {
    super.initState();
    gpaController = TextEditingController(text: widget.educationField.gpa);
    gpaMaxController = TextEditingController(text: widget.educationField.gpaMax);
    institutionController = TextEditingController(text: widget.educationField.institution);
    degreeController = TextEditingController(text: widget.educationField.degree);
  }

  @override
  void dispose() {
    gpaController.dispose();
    gpaMaxController.dispose();
    institutionController.dispose();
    degreeController.dispose();
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
            EducationFormField(
              onSaved: (value) {
                widget.educationField.educationLevel = value;
                widget.onSave(widget.educationField);
              },
              educationLevels: widget.educationLevels,
              initialValue: widget.educationField.educationLevel,
              heading: "Education Level",
            ),
            SizedBox(height: 16),
            TextField(
              controller: institutionController,
              decoration: InputDecoration(labelText: 'Institution'),
              onChanged: (value) {
                widget.educationField.institution = value;
                widget.onSave(widget.educationField);
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: degreeController,
              decoration: InputDecoration(labelText: 'Degree'),
              onChanged: (value) {
                widget.educationField.degree = value;
                widget.onSave(widget.educationField);
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: gpaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'GPA'),
                    onChanged: (value) {
                      widget.educationField.gpa = value;
                      widget.onSave(widget.educationField);
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: gpaMaxController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Scale'),
                    onChanged: (value) {
                      widget.educationField.gpaMax = value;
                      widget.onSave(widget.educationField);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: widget.educationField.startDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2101),
                      );
                      if (date != null) {
                        setState(() {
                          widget.educationField.startDate = date;
                          widget.onSave(widget.educationField);
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: widget.educationField.startDate.toString().substring(0, 10),
                          border: OutlineInputBorder(),
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
                        initialDate: widget.educationField.endDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2101),
                      );
                      if (date != null) {
                        setState(() {
                          widget.educationField.endDate = date;
                          widget.onSave(widget.educationField);
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: widget.educationField.endDate.toString().substring(0, 10),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            EducationFormField(
              onSaved: (value) {
                widget.educationField.educationStatus = value;
                widget.onSave(widget.educationField);
              },
              educationLevels: widget.educationStatus,
              initialValue: widget.educationField.educationStatus,
              heading: "Education Status",
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onDelete,
              child: Text('Delete Education'),
            ),
          ],
        ),
      ),
    );
  }
}

class EducationFormField extends StatefulWidget {
  final Function(String?) onSaved;
  final List<String> educationLevels;
  final String? initialValue;
  final String heading;

  const EducationFormField({
    Key? key,
    required this.onSaved,
    required this.educationLevels,
    this.initialValue,
    required this.heading,
  }) : super(key: key);

  @override
  _EducationFormFieldState createState() => _EducationFormFieldState();
}

class _EducationFormFieldState extends State<EducationFormField> {
  String? selectedEducation;

  @override
  void initState() {
    super.initState();
    selectedEducation = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedEducation,
      items: widget.educationLevels.map((String level) {
        return DropdownMenuItem<String>(
          value: level,
          child: Text(level),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedEducation = newValue;
        });
        widget.onSaved(newValue);
      },
      decoration: InputDecoration(
        labelText: widget.heading,
        border: OutlineInputBorder(),
      ),
    );
  }
}
