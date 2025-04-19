import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../cart_data.dart';

class ScheduleDetailsItem extends StatelessWidget {
  final Map<String, dynamic> yogaSchedule;

  const ScheduleDetailsItem({super.key, required this.yogaSchedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yoga Schedule Details')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Class Type: ${yogaSchedule['classType']}"),
            Text("Teacher: ${yogaSchedule['teacher']}"),
            Text("Date: ${yogaSchedule['date']}"),
            Text("Description: ${yogaSchedule['description']}"),
            Text("Price: ${yogaSchedule['price']} £"),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text('Confirmation'),
                        content: Text(
                          'Are you sure you want to add this class to your cart?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Close'),
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<CartModel>(
                                context,
                                listen: false,
                              ).addToCart(yogaSchedule);
                              Navigator.pop(context);
                            },
                            child: Text('Confirm'),
                          ),
                        ],
                      ),
                );
              },
              child: Text('Add to cart'),
            ),
          ],
        ),
      ),
    );
  }
}
