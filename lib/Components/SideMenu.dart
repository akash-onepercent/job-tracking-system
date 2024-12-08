import 'package:admin/Pages/Links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controllers/MainController.dart';
import '../Pages/Dashboard.dart';
import '../Pages/Diversity.dart';
import '../Pages/Education.dart';
import '../Pages/Experience.dart';
import '../Pages/Legalities.dart';
import '../Pages/Personal.dart';
import '../Pages/Project.dart';
import '../Pages/Research.dart';
import '../Pages/Skills.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<SideMenu> {
  final mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png", cacheHeight: 90, cacheWidth: 90,),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              setState(() {
                mainController.screen.value = DashboardScreen();
              });
            },
          ),
          Divider(),
          DrawerListTile(
            title: "Personal Information",
            svgSrc: "assets/icons/personal.svg",
            press: () {
              setState(() {
                mainController.screen.value = PersonalScreen();
              });
            },
          ),
          DrawerListTile(
            title: "Education",
            svgSrc: "assets/icons/education.svg",
            press: () {
              setState(() {
                mainController.screen.value = EducationScreen();
              });
            },
          ),
          DrawerListTile(
            title: "Experience",
            svgSrc: "assets/icons/experience.svg",
            press: () {
              setState(() {
                mainController.screen.value = ExperienceScreen();
              });
            },
          ),
          DrawerListTile(
            title: "Projects",
            svgSrc: "assets/icons/projects.svg",
            press: () {
              setState(() {
                mainController.screen.value = ProjectScreen();
              });
            },
          ),
          DrawerListTile(
            title: "Research",
            svgSrc: "assets/icons/research.svg",
            press: () {
              setState(() {
                mainController.screen.value = ResearchScreen();
              });
            },
          ),
          DrawerListTile(
            title: "Skills",
            svgSrc: "assets/icons/skills.svg",
            press: () {
              setState(() {
                mainController.screen.value = SkillsScreen();
              });
            },
          ),
          DrawerListTile(
            title: "Legalities",
            svgSrc: "assets/icons/legalities.svg",
            press: () {
              setState(() {
                mainController.screen.value = LegalitiesScreen();
              });
            },
          ),
          DrawerListTile(
            title: "Diversity",
            svgSrc: "assets/icons/diversity.svg",
            press: () {
              setState(() {
                mainController.screen.value = DiversityScreen();
              });
            },
          ),
          DrawerListTile(
            title: "Links",
            svgSrc: "assets/icons/links.svg",
            press: () {
              setState(() {
                mainController.screen.value = LinksScreen();
              });
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
