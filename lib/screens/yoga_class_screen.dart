import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YogaClassScreen extends StatelessWidget {
  const YogaClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return YogaClassList();
  }
}
class YogaClass{
  final String classType;
  final String day;
  final String description;
  final int duration;
  final int id;
  final int numberOfPeople;
  final int price;
  final String time;

  YogaClass({required this.classType,required this.day,required this.description,required this.duration,required this.id,
    required this.numberOfPeople,required this.price,required this.time});

  factory YogaClass.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return YogaClass(
      id: int.tryParse(data['id'].toString()) ?? 0,
      day: data['day'] ?? '',
      time: data['time'] ?? '',
      duration: int.tryParse(data['duration'].toString()) ?? 0,
      numberOfPeople: int.tryParse(data['numberOfPeople'].toString()) ?? 0,
      price: int.tryParse(data['price'].toString()) ?? 0,
      classType: data['classType'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
class YogaClassList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yoga Classes')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('YogaClasses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text('No classes found'));
          }

          final yogaClasses = docs.map((doc) => YogaClass.fromFirestore(doc)).toList();

          return ListView.builder(
            itemCount: yogaClasses.length,
            itemBuilder: (context, index) {
              final yogaClass = yogaClasses[index];
              return ListTile(
                title: Text(yogaClass.classType),
                subtitle: Text('${yogaClass.time} - ${yogaClass.day}\n${yogaClass.price}£ - ${yogaClass.duration} Minute\n${yogaClass.description}'),
              );
            },
          );
        },
      ),
    );
  }
}