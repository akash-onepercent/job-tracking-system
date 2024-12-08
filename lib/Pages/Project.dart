import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../main.dart';
import '../components/Header.dart';
import '../components/StorageDetails.dart';

class ProjectScreen extends StatefulWidget {
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final box = GetStorage();
  List<ProjectField> projectFields = [];

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  void loadSavedData() {
    setState(() {
      List<dynamic> savedData = box.read('projectFields') ?? [];
      projectFields = savedData.map((data) => ProjectField.fromMap(data)).toList();
    });
  }

  void saveData() {
    List<Map<String, dynamic>> savedData = projectFields.map((field) => field.toMap()).toList();
    box.write('projectFields', savedData);

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
            Header("Projects"),
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
                          itemCount: projectFields.length,
                          itemBuilder: (context, index) {
                            return ProjectFormSection(
                              projectField: projectFields[index],
                              onSave: (value) {
                                setState(() {
                                  projectFields[index] = value;
                                });
                                saveData();
                              },
                              onDelete: () {
                                setState(() {
                                  projectFields.removeAt(index);
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
                            projectFields.add(ProjectField());
                          });
                          saveData();
                        },
                        child: Text(
                          "Add Project",
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

class ProjectField {
  String? projectName;
  String? projectLink;
  String? projectDescription;
  DateTime startDate;
  DateTime endDate;

  ProjectField({
    this.projectName,
    this.projectLink,
    this.projectDescription,
    DateTime? startDate,
    DateTime? endDate,
  })  : startDate = startDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'projectName': projectName,
      'projectLink': projectLink,
      'projectDescription': projectDescription,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  factory ProjectField.fromMap(Map<String, dynamic> map) {
    return ProjectField(
      projectName: map['projectName'],
      projectLink: map['projectLink'],
      projectDescription: map['projectDescription'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
    );
  }
}

class ProjectFormSection extends StatefulWidget {
  final ProjectField projectField;
  final Function(ProjectField) onSave;
  final VoidCallback onDelete;

  const ProjectFormSection({
    required this.projectField,
    required this.onSave,
    required this.onDelete,
  });

  @override
  _ProjectFormSectionState createState() => _ProjectFormSectionState();
}

class _ProjectFormSectionState extends State<ProjectFormSection> {
  late TextEditingController nameController;
  late TextEditingController linkController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.projectField.projectName);
    linkController = TextEditingController(text: widget.projectField.projectLink);
    descriptionController = TextEditingController(text: widget.projectField.projectDescription);
  }

  @override
  void dispose() {
    nameController.dispose();
    linkController.dispose();
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
              controller: nameController,
              decoration: InputDecoration(labelText: 'Project Name'),
              onChanged: (value) {
                widget.projectField.projectName = value;
                widget.onSave(widget.projectField);
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: linkController,
              decoration: InputDecoration(labelText: 'Project Link'),
              onChanged: (value) {
                widget.projectField.projectLink = value;
                widget.onSave(widget.projectField);
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Project Description'),
              maxLines: 3,
              onChanged: (value) {
                widget.projectField.projectDescription = value;
                widget.onSave(widget.projectField);
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
                        initialDate: widget.projectField.startDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2101),
                      );
                      if (date != null) {
                        setState(() {
                          widget.projectField.startDate = date;
                          widget.onSave(widget.projectField);
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: widget.projectField.startDate.toString().substring(0, 10),
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
                        initialDate: widget.projectField.endDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2101),
                      );
                      if (date != null) {
                        setState(() {
                          widget.projectField.endDate = date;
                          widget.onSave(widget.projectField);
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: widget.projectField.endDate.toString().substring(0, 10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onDelete,
              child: Text('Delete Project'),
            ),
          ],
        ),
      ),
    );
  }
}
