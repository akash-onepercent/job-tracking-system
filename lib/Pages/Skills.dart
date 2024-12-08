import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../main.dart';
import '../components/Header.dart';
import '../components/StorageDetails.dart';

class SkillsScreen extends StatefulWidget {
  @override
  _SkillsScreenState createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  final box = GetStorage();
  List<TextEditingController> technicalSkillControllers = [];
  List<TextEditingController> interpersonalSkillControllers = [];

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  void loadSavedData() {
    List<String> technicalSkills = List<String>.from(box.read('technicalSkills') ?? []);
    List<String> interpersonalSkills = List<String>.from(box.read('interpersonalSkills') ?? []);
    setState(() {
      technicalSkillControllers = technicalSkills.map((skill) => TextEditingController(text: skill)).toList();
      interpersonalSkillControllers = interpersonalSkills.map((skill) => TextEditingController(text: skill)).toList();
    });
  }

  void saveData() {
    List<String> technicalSkills = technicalSkillControllers.map((controller) => controller.text).toList();
    List<String> interpersonalSkills = interpersonalSkillControllers.map((controller) => controller.text).toList();

    box.write('technicalSkills', technicalSkills);
    box.write('interpersonalSkills', interpersonalSkills);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data saved successfully!")));
  }

  @override
  void dispose() {
    for (var controller in technicalSkillControllers) {
      controller.dispose();
    }
    for (var controller in interpersonalSkillControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header("Skills"),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Technical Skills",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.blue),
                            onPressed: () {
                              setState(() {
                                technicalSkillControllers.add(TextEditingController());
                              });
                              saveData();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: defaultPadding),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: technicalSkillControllers.length,
                        itemBuilder: (context, index) {
                          return SkillRow(
                            controller: technicalSkillControllers[index],
                            onDelete: () {
                              setState(() {
                                technicalSkillControllers.removeAt(index);
                              });
                              saveData();
                            },
                          );
                        },
                      ),
                      SizedBox(height: defaultPadding * 2),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Interpersonal Skills",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.blue),
                            onPressed: () {
                              setState(() {
                                interpersonalSkillControllers.add(TextEditingController());
                              });
                              saveData();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: defaultPadding),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: interpersonalSkillControllers.length,
                        itemBuilder: (context, index) {
                          return SkillRow(
                            controller: interpersonalSkillControllers[index],
                            onDelete: () {
                              setState(() {
                                interpersonalSkillControllers.removeAt(index);
                              });
                              saveData();
                            },
                          );
                        },
                      ),
                      SizedBox(height: defaultPadding * 2),

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

class SkillRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onDelete;

  const SkillRow({
    required this.controller,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Enter skill'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
