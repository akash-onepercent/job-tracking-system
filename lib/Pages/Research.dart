import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../main.dart';
import '../components/Header.dart';
import '../components/StorageDetails.dart';

class ResearchScreen extends StatefulWidget {
  @override
  _ResearchScreenState createState() => _ResearchScreenState();
}

class _ResearchScreenState extends State<ResearchScreen> {
  final box = GetStorage();

  List<ResearchField> researchFields = [];

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  void loadSavedData() {
    setState(() {
      List<dynamic> savedData = box.read('researchFields') ?? [];
      researchFields = savedData.map((data) => ResearchField.fromMap(data)).toList();
    });
  }

  void saveData() {
    List<Map<String, dynamic>> savedData = researchFields.map((field) => field.toMap()).toList();
    box.write('researchFields', savedData);

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
            Header("Research"),
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
                          itemCount: researchFields.length,
                          itemBuilder: (context, index) {
                            return ResearchFormSection(
                              researchField: researchFields[index],
                              onSave: (value) {
                                setState(() {
                                  researchFields[index] = value;
                                });
                                saveData();
                              },
                              onDelete: () {
                                setState(() {
                                  researchFields.removeAt(index);
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
                            researchFields.add(ResearchField());
                          });
                          saveData();
                        },
                        child: Text(
                          "Add Research",
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

class ResearchField {
  String? researchTitle;
  String? publicationName;
  DateTime dateOfPublication;
  String? abstractInfo;

  ResearchField({
    this.researchTitle,
    this.publicationName,
    DateTime? dateOfPublication,
    this.abstractInfo,
  }) : dateOfPublication = dateOfPublication ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'researchTitle': researchTitle,
      'publicationName': publicationName,
      'dateOfPublication': dateOfPublication.toIso8601String(),
      'abstractInfo': abstractInfo,
    };
  }

  factory ResearchField.fromMap(Map<String, dynamic> map) {
    return ResearchField(
      researchTitle: map['researchTitle'],
      publicationName: map['publicationName'],
      dateOfPublication: DateTime.parse(map['dateOfPublication']),
      abstractInfo: map['abstractInfo'],
    );
  }
}

class ResearchFormSection extends StatefulWidget {
  final ResearchField researchField;
  final Function(ResearchField) onSave;
  final VoidCallback onDelete;

  const ResearchFormSection({
    required this.researchField,
    required this.onSave,
    required this.onDelete,
  });

  @override
  _ResearchFormSectionState createState() => _ResearchFormSectionState();
}

class _ResearchFormSectionState extends State<ResearchFormSection> {
  late TextEditingController titleController;
  late TextEditingController publicationController;
  late TextEditingController abstractController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.researchField.researchTitle);
    publicationController = TextEditingController(text: widget.researchField.publicationName);
    abstractController = TextEditingController(text: widget.researchField.abstractInfo);
  }

  @override
  void dispose() {
    titleController.dispose();
    publicationController.dispose();
    abstractController.dispose();
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
              controller: titleController,
              decoration: InputDecoration(labelText: 'Research Title'),
              onChanged: (value) {
                widget.researchField.researchTitle = value;
                widget.onSave(widget.researchField);
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: publicationController,
              decoration: InputDecoration(labelText: 'Publication Journal/Conference Name'),
              onChanged: (value) {
                widget.researchField.publicationName = value;
                widget.onSave(widget.researchField);
              },
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: widget.researchField.dateOfPublication,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2101),
                );
                if (date != null) {
                  setState(() {
                    widget.researchField.dateOfPublication = date;
                    widget.onSave(widget.researchField);
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: widget.researchField.dateOfPublication.toString().substring(0, 10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: abstractController,
              decoration: InputDecoration(labelText: 'Abstract/Information'),
              maxLines: 3,
              onChanged: (value) {
                widget.researchField.abstractInfo = value;
                widget.onSave(widget.researchField);
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onDelete,
              child: Text('Delete Research'),
            ),
          ],
        ),
      ),
    );
  }
}
