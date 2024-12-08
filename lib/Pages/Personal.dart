import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import '../main.dart';
import '../components/Header.dart';
import '../components/StorageDetails.dart';

class PersonalScreen extends StatefulWidget {
  @override
  _PersonalScreenState createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();

  String? selectedGender;
  Country? selectedCountry;

  final box = GetStorage();
  final List<String> genderOptions = ["Male", "Female", "Other", "Decline to answer"];

  @override
  void initState() {
    super.initState();
    _initializeGetStorage();
  }

  Future<void> _initializeGetStorage() async {
    await GetStorage.init();
    loadData();
  }

  void loadData() {
    firstNameController.text = box.read('firstName') ?? '';
    middleNameController.text = box.read('middleName') ?? '';
    lastNameController.text = box.read('lastName') ?? '';
    phoneController.text = box.read('phone') ?? '';
    addressController.text = box.read('address') ?? '';
    pincodeController.text = box.read('pincode') ?? '';
    cityController.text = box.read('city') ?? '';
    summaryController.text = box.read('summary') ?? '';

    selectedGender = box.read('gender');
    selectedCountry = CountryPickerUtils.getCountryByIsoCode(box.read('countryCode') ?? 'US');

    setState(() {});
  }

  void saveData() {
    box.write('firstName', firstNameController.text);
    box.write('middleName', middleNameController.text);
    box.write('lastName', lastNameController.text);
    box.write('phone', phoneController.text);
    box.write('address', addressController.text);
    box.write('pincode', pincodeController.text);
    box.write('city', cityController.text);
    box.write('summary', summaryController.text);

    box.write('gender', selectedGender);
    box.write('countryCode', selectedCountry?.isoCode);

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
            Header("Personal"),
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
                        children: [
                          Expanded(
                            child: TextField(
                              controller: firstNameController,
                              decoration: InputDecoration(
                                labelText: "First Name*",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                            ),
                          ),
                          SizedBox(width: defaultPadding),
                          Expanded(
                            child: TextField(
                              controller: middleNameController,
                              decoration: InputDecoration(
                                labelText: "Middle Name",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                            ),
                          ),
                          SizedBox(width: defaultPadding),
                          Expanded(
                            child: TextField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                labelText: "Last Name*",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: defaultPadding),
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        decoration: InputDecoration(
                          labelText: "Gender*",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        items: genderOptions
                            .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedGender = newValue;
                          });
                        },
                      ),
                      SizedBox(height: defaultPadding),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CountryPickerDropdown(
                              initialValue: 'US', // Default country code
                              onValuePicked: (Country country) {
                                setState(() {
                                  selectedCountry = country;
                                });
                              },
                              itemBuilder: (Country country) {
                                return Row(
                                  children: <Widget>[
                                    SizedBox(width: 15.0),
                                    CountryPickerUtils.getDefaultFlagImage(country),
                                    SizedBox(width: 8.0),
                                    Text('+${country.phoneCode} (${country.isoCode})'),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(width: defaultPadding),
                          Expanded(
                            flex: 8,
                            child: TextField(
                              controller: phoneController,
                              decoration: InputDecoration(
                                labelText: "Phone*",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: defaultPadding),
                      TextField(
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: "Address*",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                      SizedBox(height: defaultPadding),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: pincodeController,
                              decoration: InputDecoration(
                                labelText: "Pincode*",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                            ),
                          ),
                          SizedBox(width: defaultPadding),
                          Expanded(
                            child: TextField(
                              controller: cityController,
                              decoration: InputDecoration(
                                labelText: "City*",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: defaultPadding),
                      TextField(
                        controller: summaryController,
                        maxLines: 10,
                        decoration: InputDecoration(
                          labelText: "Summary*",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                      SizedBox(height: defaultPadding*2),
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
