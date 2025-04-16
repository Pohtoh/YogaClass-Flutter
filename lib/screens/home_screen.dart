import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return YogaScheduleList();
  }
}

class YogaSchedule{
  final int id;
  final String date;
  final String teacher;
  final String description;
  final int classId;

  YogaSchedule({required this.id,required this.date,required this.teacher,required this.description,required this.classId});

  factory YogaSchedule.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return YogaSchedule(
      id: int.tryParse(data['id'].toString()) ?? 0,
      date: data['date'] ?? '',
      teacher: data['teacher'] ?? '',
      description: data['description'] ?? '',
      classId: int.tryParse(data['classId'].toString()) ?? 0,
    );
  }
}
class YogaScheduleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yoga Current Schedule')),
      body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('YogaSchedules').snapshots(),
      builder: (context, snapshot){
    if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
    if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

    final data = snapshot.data!.docs.map((doc) => YogaSchedule.fromFirestore(doc)).toList();

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final yogaSchedule = data[index];
        return ListTile(
          title: Text(yogaSchedule.date),
          subtitle: Text(yogaSchedule.teacher),
          );
        }
      );
    },
    )
    );
  }
}