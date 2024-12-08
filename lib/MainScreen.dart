import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import '../controllers/MainController.dart';
import 'Components/SideMenu.dart';
import 'main.dart';

class MainScreen extends StatelessWidget {
  final mainController = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: Obx(() => mainController.screen.value!),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => SearchCompanyDialog(),
          );
        },
        child: Icon(Icons.search),
        tooltip: 'Search Company',
      ),
    );
  }
}


class SearchCompanyDialog extends StatefulWidget {
  @override
  _SearchCompanyDialogState createState() => _SearchCompanyDialogState();
}

class _SearchCompanyDialogState extends State<SearchCompanyDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String _result = "";


  void _runPythonScript() async {
    String companyName = _controller.text.trim();
    if (companyName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a company name")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _result = "";
    });

    try {
      ProcessResult result = await Process.run(
        'C:/Users/qc_wo/AppData/Local/Programs/Python/Python312/python.exe',
        ["C:/Users/qc_wo/OneDrive/Desktop/job-tracking-system/lib/linkedin_scraping.py", companyName,],
        runInShell: true,
      );

      if (result.exitCode == 0) {
        setState(() {
          _result = "Output: ${result.stdout}";
          GetStorage().write('JOB_DESCRIPTION', _result);
        });
      } else {
        setState(() {
          _result = "Error: ${result.stderr}";
        });
      }
    } catch (e) {
      setState(() {
        _result = "Exception: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Search Company"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: "Company Name",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          _isLoading
              ? CircularProgressIndicator()
              : _result.isNotEmpty
              ? Text(_result)
              : Container(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _runPythonScript,
          child: Text("Search"),
        ),
      ],
    );
  }
}