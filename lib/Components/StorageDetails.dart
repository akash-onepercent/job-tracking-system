import 'package:flutter/material.dart';
import '../main.dart';
import 'Chart.dart';
import 'StorageInfoCard.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Summary",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          StorageInfoCard(
            svgSrc: "assets/icons/response.svg",
            title: "Microsoft",
            numOfFiles: "Most number of applied Roles",
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/oa.svg",
            title: "Software Engineer",
            numOfFiles: "Most common role",
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/interview.svg",
            title: "Microsoft",
            numOfFiles: "Company with most success",
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/offer.svg",
            title: "Apple",
            numOfFiles: "Unfavourable Company",
          ),
        ],
      ),
    );
  }
}
