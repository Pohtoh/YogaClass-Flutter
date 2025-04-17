import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> allSchedules = [];
  List<Map<String, dynamic>> filteredSchedules = [];
  Map<int, String> classTypeMap = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final classSnapshot = await FirebaseFirestore.instance.collection('YogaClasses').get();
    final scheduleSnapshot = await FirebaseFirestore.instance.collection('YogaSchedules').get();


    classTypeMap = {
      for (var doc in classSnapshot.docs)
        (doc.data()['id'] as int): (doc.data()['classType']).toString()
    };

    // Combine schedule with classType
    allSchedules = scheduleSnapshot.docs.map((doc) {
      final data = doc.data();
      final yogaClassID = data['yogaClassID'] as int? ?? 0;
      return {
        ...data,
        'classType': classTypeMap[yogaClassID] ?? 'Unknown'
      };
    }).toList();

    setState(() {
      filteredSchedules = List.from(allSchedules);
    });
  }

  void filterSearch(String keyword) {
    final lowerKeyword = keyword.toLowerCase();
    setState(() {
      filteredSchedules = allSchedules.where((schedule) {
        final teacher = schedule['teacher']?.toString().toLowerCase() ?? '';
        final classType = schedule['classType']?.toString().toLowerCase() ?? '';
        final date = schedule['date']?.toString().toLowerCase() ?? '';
        return teacher.contains(lowerKeyword) ||
            classType.contains(lowerKeyword) ||
            date.contains(lowerKeyword);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Yoga Schedules")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: filterSearch,
              decoration: const InputDecoration(
                hintText: "Search teacher, class type, date...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filteredSchedules.isEmpty
                ? const Center(child: Text("No results found."))
                : ListView.builder(
              itemCount: filteredSchedules.length,
              itemBuilder: (context, index) {
                final item = filteredSchedules[index];
                return ListTile(
                  title: Text("${item['id']}. ${item['classType']}"),
                  subtitle: Text("${item['teacher']} - ${item['date']}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
