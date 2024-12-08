import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Pages/Dashboard.dart';

class MainController extends GetxController {

  var screen = Rxn<Widget>();

  @override
  void onInit() {
    super.onInit();
    screen.value = DashboardScreen();
  }
}