import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cart_data.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body:
          cart.cartItems.isEmpty
              ? const Center(child: Text("Your cart is empty"))
              : ListView.builder(
                itemCount: cart.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cart.cartItems[index];
                  return ListTile(
                    title: Text("${item['classType']}"),
                    subtitle: Text(
                      "${item['teacher']} - ${item['date']} - ${item['price']} £",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        cart.removeFromCart(item);
                      },
                    ),
                  );
                },
              ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  cart.clearCart();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Cart cleared')));
                },
                child: const Text('Clear Cart'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  showInputEmail(context, context.read<CartModel>());
                },
                child: const Text('Confirm Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showInputEmail(BuildContext context, CartModel cart) {
  TextEditingController inputController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Enter your email"),
        content: TextField(controller: inputController),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              String input = inputController.text;
              if (input.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please enter your email")),
                );
              } else {
                final bookingData = {
                  'email': input,
                  'date': DateTime.now().toString(),
                  'cartItems': cart.cartItems,
                };
                FirebaseFirestore.instance
                    .collection('bookings')
                    .add(bookingData);
                cart.clearCart();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Cart booked')));
                Navigator.pop(context);
              }
            },
            child: Text("Confirm"),
          ),
        ],
      );
    },
  );
}
