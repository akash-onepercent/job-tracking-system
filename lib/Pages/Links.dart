import 'package:admin/main.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../Components/Header.dart';
import '../Components/StorageDetails.dart';

class LinksScreen extends StatefulWidget {
  @override
  _LinksScreenState createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  final box = GetStorage();

  List<TextEditingController> nameControllers = [];
  List<TextEditingController> linkControllers = [];

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  void loadSavedData() {
    var savedLinks = List<Map<String, dynamic>>.from(box.read('links') ?? []);
    setState(() {
      nameControllers = savedLinks.map((link) => TextEditingController(text: link['name'])).toList();
      linkControllers = savedLinks.map((link) => TextEditingController(text: link['link'])).toList();
    });
  }

  void saveData() {
    List<Map<String, String>> links = List.generate(
      nameControllers.length,
      (index) => {
        'name': nameControllers[index].text,
        'link': linkControllers[index].text,
      },
    );
    box.write('links', links);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data saved successfully!")));
  }

  @override
  void dispose() {
    for (var controller in nameControllers) {
      controller.dispose();
    }
    for (var controller in linkControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
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
                    Container(
                      height: MediaQuery.of(context).size.height - 230,
                      child: ListView.builder(
                        itemCount: nameControllers.length,
                        itemBuilder: (context, index) {
                          return LinkRow(
                            nameController: nameControllers[index],
                            linkController: linkControllers[index],
                            onDelete: () {
                              setState(() {
                                nameControllers.removeAt(index);
                                linkControllers.removeAt(index);
                              });
                              saveData();
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          nameControllers.add(TextEditingController());
                          linkControllers.add(TextEditingController());
                        });
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
        ]),
      ),
    );
  }
}

class LinkRow extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController linkController;
  final VoidCallback onDelete;

  const LinkRow({
    required this.nameController,
    required this.linkController,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: TextField(
              controller: linkController,
              decoration: InputDecoration(labelText: 'Link'),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
