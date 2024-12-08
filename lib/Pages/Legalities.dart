import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../main.dart';
import '../components/Header.dart';
import '../components/StorageDetails.dart';

class LegalitiesScreen extends StatefulWidget {
  @override
  _CitizenshipScreenState createState() => _CitizenshipScreenState();
}

class _CitizenshipScreenState extends State<LegalitiesScreen> {
  final box = GetStorage();

  String isUSCitizen = "No";
  String isCitizenOfRestrictedCountry = "No";
  String countryOfCitizenship = "";
  String isAuthorizedToWorkInUS = "No";
  String requiresSponsorship = "No";

  TextEditingController countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSavedData();
    countryController.text = countryOfCitizenship;
  }

  void loadSavedData() {
    setState(() {
      isUSCitizen = box.read('isUSCitizen') ?? "No";
      isCitizenOfRestrictedCountry = box.read('isCitizenOfRestrictedCountry') ?? "No";
      countryOfCitizenship = box.read('countryOfCitizenship') ?? "";
      isAuthorizedToWorkInUS = box.read('isAuthorizedToWorkInUS') ?? "No";
      requiresSponsorship = box.read('requiresSponsorship') ?? "No";
    });
  }

  void saveData() {
    box.write('isUSCitizen', isUSCitizen);
    box.write('isCitizenOfRestrictedCountry', isCitizenOfRestrictedCountry);
    box.write('countryOfCitizenship', countryController.text);
    box.write('isAuthorizedToWorkInUS', isAuthorizedToWorkInUS);
    box.write('requiresSponsorship', requiresSponsorship);

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
            Header("Legal status"),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDropdownField(
                        label: "Are you a US Citizen?",
                        value: isUSCitizen,
                        onChanged: (value) {
                          setState(() {
                            isUSCitizen = value!;
                          });
                          saveData();
                        },
                      ),
                      SizedBox(height: defaultPadding),
                      if (isUSCitizen == "No")
                        Column(
                          children: [
                            buildDropdownField(
                              label: "Are you a citizen/resident of Cuba, Iran, or Crimea?",
                              value: isCitizenOfRestrictedCountry,
                              onChanged: (value) {
                                setState(() {
                                  isCitizenOfRestrictedCountry = value!;
                                });
                                saveData();
                              },
                            ),
                            SizedBox(height: defaultPadding),
                            TextField(
                              controller: countryController,
                              decoration: InputDecoration(
                                labelText: "Country of Citizenship",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  countryOfCitizenship = value;
                                });
                                saveData();
                              },
                            ),
                            SizedBox(height: defaultPadding),
                            buildDropdownField(
                              label: "Are you authorized to work in the US?",
                              value: isAuthorizedToWorkInUS,
                              onChanged: (value) {
                                setState(() {
                                  isAuthorizedToWorkInUS = value!;
                                });
                                saveData();
                              },
                            ),
                            SizedBox(height: defaultPadding),
                            buildDropdownField(
                              label: "Do you require sponsorship in the future?",
                              value: requiresSponsorship,
                              onChanged: (value) {
                                setState(() {
                                  requiresSponsorship = value!;
                                });
                                saveData();
                              },
                            ),
                            SizedBox(height: defaultPadding),
                          ],
                        ),
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

  Widget buildDropdownField({
    required String label,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: ["Yes", "No"]
              .map((option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
