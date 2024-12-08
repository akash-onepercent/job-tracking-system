import 'package:flutter/material.dart';
import '../main.dart';

class RecentFile {
  final String? icon, title, date, size;

  RecentFile({this.icon, this.title, this.date, this.size});
}

List demoRecentFiles = [
  RecentFile(
    title: "Microsoft",
    date: "01-03-2021",
    size: "Online Assessment",
  ),
  RecentFile(
    title: "QualComm",
    date: "27-02-2021",
    size: "Interview",
  ),
  RecentFile(
    title: "Apple",
    date: "23-02-2021",
    size: "Rejected",
  ),
  RecentFile(
    title: "Amazon",
    date: "21-02-2021",
    size: "Ghosted",
  ),
  RecentFile(
    title: "Meta",
    date: "23-02-2021",
    size: "HR Interview",
  ),
  RecentFile(
    title: "NVIDIA",
    date: "25-02-2021",
    size: "Offer",
  ),
  RecentFile(
    title: "Google",
    date: "25-02-2021",
    size: "Interview",
  ),
];


class RecentFiles extends StatelessWidget {
  const RecentFiles({
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
            "Recent Applications",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              // minWidth: 600,
              columns: [
                DataColumn(
                  label: Text("Company Name"),
                ),
                DataColumn(
                  label: Text("Date"),
                ),
                DataColumn(
                  label: Text("Application Status"),
                ),
              ],
              rows: List.generate(
                demoRecentFiles.length,
                (index) => recentFileDataRow(demoRecentFiles[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentFileDataRow(RecentFile fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Text(fileInfo.title!),
      ),
      DataCell(Text(fileInfo.date!)),
      DataCell(Text(fileInfo.size!)),
    ],
  );
}
