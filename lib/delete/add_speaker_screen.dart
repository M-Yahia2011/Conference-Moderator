// import 'package:conf_moderator/providers/conf_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AddSpeakerScreen extends StatefulWidget {
//   static const routeName = "/add_speaker";

//   const AddSpeakerScreen({Key? key}) : super(key: key);

//   @override
//   State<AddSpeakerScreen> createState() => _AddSpeakerScreenState();
// }

// class _AddSpeakerScreenState extends State<AddSpeakerScreen> {
//   TimeOfDay? startTime;
//   TimeOfDay? endTime;
//   late TextEditingController _textController;
//   @override
//   void initState() {
//     super.initState();
//     _textController = TextEditingController();
//   }

//   Future<void> addSpeaker(
//       String sessionID, Map<String, String> speakerInfo) async {
//     try {
//       Provider.of<ConferenceProvider>(context, listen: false)
//           .addSpeaker(sessionID, speakerInfo);
//     } catch (e) {
//       print("Speaker send Error");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String sessionID = ModalRoute.of(context)?.settings.arguments as String;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Add a Speaker"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(50.0),
//         child: Column(
//           children: [
//             Container(
//               height: 60,
//               width: 700,
//               padding: const EdgeInsets.all(4),
//               margin: const EdgeInsets.symmetric(vertical: 15),
//               decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(15)),
//               child: TextField(
//                 controller: _textController,
//                 decoration: const InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(horizontal: 8),
//                     labelText: "Speaker's Name",
//                     labelStyle: TextStyle(color: Colors.black),
//                     border: InputBorder.none),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Row(
//                   children: [
//                     const Text("From"),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         final picked = await showTimePicker(
//                             context: context, initialTime: TimeOfDay.now());
//                         setState(() {
//                           startTime = picked;
//                         });
//                       },
//                       child: startTime != null
//                           ? Text(startTime!.format(context))
//                           : const Text(
//                               "Time",
//                               style: TextStyle(fontSize: 20),
//                             ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     const Text("To"),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         final picked = await showTimePicker(
//                             context: context, initialTime: TimeOfDay.now());
//                         setState(() {
//                           endTime = picked;
//                         });
//                       },
//                       child: endTime != null
//                           ? Text(endTime!.format(context))
//                           : const Text(
//                               "Time",
//                               style: TextStyle(fontSize: 20),
//                             ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 300,
//               width: 400,
//               child: Card(
//                 elevation: 10,
//                 child: Column(
//                   children: [
//                     const Text("Drag and Drop the file"),
//                     ElevatedButton.icon(
//                       onPressed: () {},
//                       label: const Text("Choose the file"),
//                       icon: const Icon(Icons.upload_file),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 40,
//               width: 200,
//               child: ElevatedButton.icon(
//                 onPressed: () async {
//                   Map<String, String> speakerInfo = {
//                     "speakerName": _textController.text,
//                     "startTime": startTime!.format(context),
//                     "endTime": endTime!.format(context),
//                     "filePath": ""
//                   };
//                   await addSpeaker(sessionID, speakerInfo);
//                 },
//                 icon: const Icon(Icons.save),
//                 label: const Text("Save"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
