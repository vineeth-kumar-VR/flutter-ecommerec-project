// import 'package:flutter/material.dart';
//
// class FilterPage extends StatefulWidget {
//   const FilterPage({super.key});
//
//   @override
//   State<FilterPage> createState() => _FilterPageState();
// }
//
// class _FilterPageState extends State<FilterPage> {
//   RangeValues range = RangeValues(100, 500);
//   int selectedIndex = 0; // No chip selected initially
//   int selectedIndex1 = 0;
//   // int selectedIndex2 = 0;
//   int selectedIndex3 = 0;
//
//   int selectedIndex4 = 0;
//
//   final List<String> chipLabels = ['Nike', 'Yeezy', 'Supreme'];
//   final List<String> chipgender = ['All', 'Male', 'Female'];
//   final List<String> chipadi = ['Adidas', 'Puma', 'Cr7'];
//   final List<String> chipwhite = ['White', 'Black', 'Grey'];
//
//   final List<String> chipyellow = ['Yellow', 'Red', 'Green'];
//
//   Widget color() {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: List.generate(chipwhite.length, (index) {
//             final bool isSelected = selectedIndex3 == index;
//             return GestureDetector(
//               onTap: () {
//                 setState(() {
//                   selectedIndex3 = index;
//                 });
//               },
//               child: Container(
//                 height: 50,
//                 width: 110,
//                 child: Chip(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     side: BorderSide(color: Colors.white),
//                   ),
//                   backgroundColor: isSelected ? Colors.teal : Color(0xFFF6F6F6),
//                   label: Text(
//                     chipwhite[index],
//                     style: TextStyle(
//                       color:
//                           isSelected
//                               ? Colors.white
//                               : Colors.black.withOpacity(0.6),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//         SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: List.generate(chipyellow.length, (index) {
//             final bool isSelected = selectedIndex4 == index;
//             return GestureDetector(
//               onTap: () {
//                 setState(() {
//                   selectedIndex4 = index;
//                 });
//               },
//               child: Container(
//                 height: 50,
//                 width: 110,
//                 child: Chip(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     side: BorderSide(color: Colors.white),
//                   ),
//                   backgroundColor: isSelected ? Colors.teal : Color(0xFFF6F6F6),
//                   label: Text(
//                     chipyellow[index],
//                     style: TextStyle(
//                       color:
//                           isSelected
//                               ? Colors.white
//                               : Colors.black.withOpacity(0.6),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           "Filter",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 30),
//               child: Text(
//                 "Gender",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//
//             Align(
//               alignment: Alignment.topLeft,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(chipgender.length, (index) {
//                   final bool isSelected = selectedIndex == index;
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedIndex = index;
//                       });
//                     },
//                     child: Container(
//                       height: 50,
//                       width: 110,
//                       child: Chip(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           side: BorderSide(color: Colors.white),
//                         ),
//                         backgroundColor:
//                             isSelected ? Colors.teal : Color(0xFFF6F6F6),
//                         label: Text(
//                           chipgender[index],
//                           style: TextStyle(
//                             color:
//                                 isSelected
//                                     ? Colors.white
//                                     : Colors.black.withOpacity(0.6),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//             SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.only(left: 30),
//               child: Text(
//                 "Brand",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Align(
//               alignment: Alignment.topLeft,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(chipLabels.length, (index) {
//                   final bool isSelected = selectedIndex1 == index;
//
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedIndex1 = index;
//                       });
//                     },
//                     child: Container(
//                       height: 50,
//                       width: 110,
//                       child: Chip(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           side: BorderSide(color: Colors.white),
//                         ),
//                         backgroundColor:
//                             isSelected ? Colors.teal : Color(0xFFF6F6F6),
//                         label: Text(
//                           chipLabels[index],
//                           style: TextStyle(
//                             color:
//                                 isSelected
//                                     ? Colors.white
//                                     : Colors.black.withOpacity(0.6),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//             SizedBox(height: 10),
//             Align(
//               alignment: Alignment.topLeft,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(chipadi.length, (index) {
//                   final bool isSelected = selectedIndex2 == index;
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedIndex2 = index;
//                       });
//                     },
//                     child: Container(
//                       height: 50,
//                       width: 110,
//                       child: Chip(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           side: BorderSide(color: Colors.white),
//                         ),
//                         backgroundColor:
//                             isSelected ? Colors.teal : Color(0xFFF6F6F6),
//                         label: Text(
//                           chipadi[index],
//                           style: TextStyle(
//                             color:
//                                 isSelected
//                                     ? Colors.white
//                                     : Colors.black.withOpacity(0.6),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//             SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.only(left: 30),
//               child: Text(
//                 "Price Range",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20),
//                   child: Text("\$${range.start.round()}"),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 20),
//                   child: Text("\$${range.end.round()}"),
//                 ),
//               ],
//             ),
//
//             RangeSlider(
//               values: range,
//               min: 0,
//               max: 1000,
//               activeColor: Colors.teal,
//               inactiveColor: Colors.grey.shade200,
//               labels: RangeLabels(
//                 "\₹{range.start.round()}",
//                 "\₹{range.end.round()}",
//               ),
//               onChanged: (RangeValues values) {
//                 setState(() {
//                   range = values;
//                 });
//               },
//             ),
//             SizedBox(height: 10),
//             color(),
//             SizedBox(height: 10),
//             option(),
//             SizedBox(height: 30),
//             applyfilter(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Widget option() {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Container(
//       height: 40,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: Colors.grey.shade200,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 16),
//             child: Text(
//               "Another Option",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//           IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward)),
//         ],
//       ),
//     ),
//   );
// }
//
// Widget applyfilter() {
//   return Padding(
//     padding: EdgeInsets.all(8),
//     child: Container(
//       height: 50,
//       width: double.infinity,
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//         onPressed: () {},
//         child: Text(
//           "Apply Filter",
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     ),
//   );
// }
