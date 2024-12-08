import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../main.dart';
import '../components/Header.dart';
import '../components/StorageDetails.dart';

class DiversityScreen extends StatefulWidget {
  @override
  _DiversityScreenState createState() => _DiversityScreenState();
}

class _DiversityScreenState extends State<DiversityScreen> {
  String? selectedGender;
  String? selectedRace;
  String? selectedSex;
  String? selectedVeteranStatus;
  String? selectedDisabilityStatus;
  String? selectedSexualPreference;
  String? selectedHispanicStatus;

  final List<String> genderOptions = ["Male", "Female", "Other", "Decline to answer"];
  final List<String> races = ["Asian", "Black", "Caucasian", "Hispanic", "Other", "Decline to answer"];
  final List<String> sexOptions = ["Male", "Female", "Other", "Decline to answer"];
  final List<String> veteranStatusOptions = ["Yes", "No", "Decline to answer"];
  final List<String> disabilityStatusOptions = ["Yes", "No", "Decline to answer"];
  final List<String> sexualPreferenceOptions = ["Heterosexual", "Homosexual", "Bisexual", "Decline to answer"];
  final List<String> hispanicStatusOptions = ["Yes", "No", "Decline to answer"];

  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    selectedGender = box.read('gender');
    selectedRace = box.read('race');
    selectedSex = box.read('sex');
    selectedVeteranStatus = box.read('veteranStatus');
    selectedDisabilityStatus = box.read('disabilityStatus');
    selectedSexualPreference = box.read('sexualPreference');
    selectedHispanicStatus = box.read('hispanicStatus');

  }

  void saveData() {
    box.write('gender', selectedGender);
    box.write('race', selectedRace);
    box.write('sex', selectedSex);
    box.write('veteranStatus', selectedVeteranStatus);
    box.write('disabilityStatus', selectedDisabilityStatus);
    box.write('sexualPreference', selectedSexualPreference);
    box.write('hispanicStatus', selectedHispanicStatus);

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
            Header("Diversity"),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Race Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedRace,
                        decoration: InputDecoration(
                          labelText: "Race*",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        items: races
                            .map((race) => DropdownMenuItem(
                                  value: race,
                                  child: Text(race),
                                ))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedRace = newValue;
                          });
                        },
                      ),
                      SizedBox(height: defaultPadding),

                      DropdownButtonFormField<String>(
                        value: selectedSex,
                        decoration: InputDecoration(
                          labelText: "Sex*",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        items: sexOptions
                            .map((sex) => DropdownMenuItem(
                                  value: sex,
                                  child: Text(sex),
                                ))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedSex = newValue;
                          });
                        },
                      ),
                      SizedBox(height: defaultPadding),

                      DropdownButtonFormField<String>(
                        value: selectedVeteranStatus,
                        decoration: InputDecoration(
                          labelText: "Are you a Veteran?*",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        items: veteranStatusOptions
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedVeteranStatus = newValue;
                          });
                        },
                      ),
                      SizedBox(height: defaultPadding),

                      DropdownButtonFormField<String>(
                        value: selectedDisabilityStatus,
                        decoration: InputDecoration(
                          labelText: "Are you Disabled?*",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        items: disabilityStatusOptions
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedDisabilityStatus = newValue;
                          });
                        },
                      ),
                      SizedBox(height: defaultPadding),

                      DropdownButtonFormField<String>(
                        value: selectedSexualPreference,
                        decoration: InputDecoration(
                          labelText: "Sexual Preference*",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        items: sexualPreferenceOptions
                            .map((preference) => DropdownMenuItem(
                                  value: preference,
                                  child: Text(preference),
                                ))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedSexualPreference = newValue;
                          });
                        },
                      ),
                      SizedBox(height: defaultPadding),

                      DropdownButtonFormField<String>(
                        value: selectedHispanicStatus,
                        decoration: InputDecoration(
                          labelText: "Hispanic*",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        items: hispanicStatusOptions
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedHispanicStatus = newValue;
                          });
                        },
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
          ],
        ),
      ),
    );
  }
}
