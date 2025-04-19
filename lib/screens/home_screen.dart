import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> allSchedules = [];
  Map<int, String> classTypeMap = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final classSnapshot =
        await FirebaseFirestore.instance.collection('YogaClasses').get();
    final scheduleSnapshot =
        await FirebaseFirestore.instance.collection('YogaSchedules').get();

    classTypeMap = {
      for (var doc in classSnapshot.docs)
        (doc.data()['id'] as int): (doc.data()['classType']).toString(),
    };

    final schedules =
        scheduleSnapshot.docs.map((doc) {
          final data = doc.data();
          final yogaClassID = (data['yogaClassID'] as int?) ?? 0;

          return {
            'id': data['id'] ?? '',
            'teacher': data['teacher']?.toString() ?? '',
            'date': data['date']?.toString() ?? '',
            'description': data['description']?.toString() ?? '',
            'classType': classTypeMap[yogaClassID] ?? 'Unknown',
            'price': data['price'] ?? '',
          };
        }).toList();

    setState(() {
      allSchedules = schedules;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Current Yoga Schedules")),
      body:
          allSchedules.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: allSchedules.length,
                itemBuilder: (context, index) {
                  final yogaSchedule = allSchedules[index];
                  return ListTile(
                    title: Text(yogaSchedule['date']),
                    subtitle: Text(
                      "Class: ${yogaSchedule['classType']} - Teacher: ${(yogaSchedule["teacher"])}"
                      "\n${yogaSchedule["description"]}",
                    ),
                  );
                },
              ),
    );
  }
}
