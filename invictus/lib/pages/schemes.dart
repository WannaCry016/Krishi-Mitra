// import 'package:flutter/material.dart';
// import 'package:invictus/components/post.dart';

// class SchemeData {
//   final String Scheme_Name; // e.g., "14-02-2025"
//   final String Scheme_Category;
//   final String State_Applicability;
//   final String Launching_Authority;
//   final String Eligibility_Cirteria;
//   final String Key_Benefits;
//   final String Application_Process;
//   final String Documents_Required;

//   SchemeData(
//       this.Scheme_Name,
//       this.Scheme_Category,
//       this.State_Applicability,
//       this.Launching_Authority,
//       this.Eligibility_Cirteria,
//       this.Key_Benefits,
//       this.Application_Process,
//       this.Documents_Required);
// }

// class SchemesPage extends StatefulWidget {
//   const SchemesPage({super.key});

//   @override
//   State<SchemesPage> createState() => _SchemesPageState();
// }

// class _SchemesPageState extends State<SchemesPage> {
//   List<SchemeData> data = [
//     SchemeData(
//         "Pradhan Mantri Fasal Bima Yojana (PMFBY) / प्रधानमंत्री फसल बीमा योजना",
//         "Crop Insurance",
//         "All India",
//         "\"Ministry of Agriculture & Farmers Welfare, Government of India Implemented in collaboration with state governments and empanelled insurance companies.\"",
//         "\"All farmers, including: -Loanee farmers (compulsory enrollment if taking crop loans). -Non-loanee farmers (voluntary enrollment). -Farmers growing notified crops in notified areas. Sharecroppers and tenant farmers (if state government recognizes them).\"",
//         "Key_Benefits",
//         "Application_Process",
//         "Documents_Required"
//     ),
//     SchemeData(
//         "Pradhan Mantri Fasal Bima Yojana (PMFBY) / प्रधानमंत्री फसल बीमा योजना",
//         "Crop Insurance",
//         "All India",
//         "\"Ministry of Agriculture & Farmers Welfare, Government of India Implemented in collaboration with state governments and empanelled insurance companies.\"",
//         "\"All farmers, including: -Loanee farmers (compulsory enrollment if taking crop loans). -Non-loanee farmers (voluntary enrollment). -Farmers growing notified crops in notified areas. Sharecroppers and tenant farmers (if state government recognizes them).\"",
//         "Key_Benefits",
//         "Application_Process",
//         "Documents_Required"
//     )
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Schemes"),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: ListView(
//           children: data.map((e) => 
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Material(
//               elevation: 2.0,
//               child: Container(
//                 child: Text(e.Scheme_Name),
//               ),
//             ),
//           )
          
//           ).toList()
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class SchemesPage extends StatelessWidget {
  final Map<String, Map<String, dynamic>> governmentSchemes = {
    "Pradhan Mantri Fasal Bima Yojana (PMFBY)": {
      "Category": "Crop Insurance",
      "Coverage": "All India",
    },
    "Pradhan Mantri Kisan MaanDhan Yojana (PM-KMY)": {
      "Category": "Pension Scheme for Farmers",
      "Coverage": "All India",
    },
    "Kisan Credit Card (KCC) Scheme": {
      "Category": "Agricultural Credit",
      "Coverage": "All India",
    },
    "Rashtriya Krishi Vikas Yojana (RKVY)": {
      "Category": "Agricultural Development & Modernization",
      "Coverage": "All India",
    },
    "Mukhyamantri Krishak Durghatna Kalyan Yojana": {
      "Category": "Farmers’ Accident Insurance",
      "Coverage": "Uttar Pradesh",
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Government Schemes')),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: governmentSchemes.length,
        itemBuilder: (context, index) {
          String schemeName = governmentSchemes.keys.elementAt(index);
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 3,
            child: ListTile(
              title: Text(schemeName, style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SchemeDetailScreen(
                      schemeName: schemeName,
                      schemeDetails: governmentSchemes[schemeName]!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class SchemeDetailScreen extends StatelessWidget {
  final String schemeName;
  final Map<String, dynamic> schemeDetails;

  SchemeDetailScreen({required this.schemeName, required this.schemeDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(schemeName)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var entry in schemeDetails.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "${entry.key}: ${entry.value}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
