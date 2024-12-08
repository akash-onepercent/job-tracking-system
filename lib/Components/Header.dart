import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import '../main.dart';

class Header extends StatelessWidget {
  late String heading;

  Header(String text) {
    heading = text;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(heading, style: Theme.of(context).textTheme.titleLarge),
        Spacer(flex: 2),
        ProfileCard(),
      ],
    );
  }
}

class ProfileCard extends StatefulWidget {
  @override
  _ExperienceScreenState createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ProfileCard> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
          child: IconButton(
              color: Colors.white,
              onPressed: () async {
                final box = GetStorage();
                final storedKeys = box.getKeys();
                Map<String, dynamic> keyValuePairs = {for (var key in storedKeys) key: box.read(key)};
                bool _isLoading = true;

                String jsonString = jsonEncode(keyValuePairs);
                late String output;

                print(jsonString);
                print(await GetStorage().read('JOB_DESCRIPTION'));
                print("-----");

                try {
                  ProcessResult result = await Process.run(
                    'C:/Users/qc_wo/AppData/Local/Programs/Python/Python312/python.exe',
                    ["C:/Users/qc_wo/OneDrive/Desktop/job-tracking-system/lib/generate_cover.py", jsonString, GetStorage().read('JOB_DESCRIPTION').toString()],
                    runInShell: true,
                  );

                  if (result.exitCode == 0) {
                    setState(() {
                      output = "Output: ${result.stdout}";
                    });
                  } else {
                    setState(() {
                      output = "Error: ${result.stderr}";
                    });
                  }
                  _isLoading = false;
                } catch (e) {
                  setState(() {
                    output = "Exception: $e";
                  });
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }

                print(output);



                Directory directory = await getApplicationDocumentsDirectory();
                File file = File('${directory.path}/resume.json');
                await file.writeAsString(jsonString);

                print('Data successfully exported to: ${file.path}');

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("JSON File Exported!")));
              },
              icon: Icon(Icons.import_export)),
        ),
        Container(
          margin: EdgeInsets.only(left: defaultPadding),
          padding: EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Image.asset(
                "assets/images/profile_pic.jpg",
                height: 38,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: Text("Akash"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}