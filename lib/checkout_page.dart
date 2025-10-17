import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String address = '';
  String paymentMethod = 'Cash on Delivery';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: cart.items.isEmpty
            ? const Center(
                child: Text(
                  'No items to checkout!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Order Summary',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Image.network(item.imageUrl,
                              height: 50, width: 50, fit: BoxFit.cover),
                          title: Text(item.name),
                          subtitle: Text('₹${item.price.toStringAsFixed(2)}'),
                        );
                      },
                    ),
                    const Divider(thickness: 1),
                    Text(
                      'Total: ₹${cart.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text('Shipping Details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    // --- Form for address & details ---
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Full Name',
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            onSaved: (value) => name = value!,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Shipping Address',
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                            onSaved: (value) => address = value!,
                          ),
                          const SizedBox(height: 20),

                          // --- Payment method ---
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                                labelText: 'Payment Method',
                                border: OutlineInputBorder()),
                            value: paymentMethod,
                            items: const [
                              DropdownMenuItem(
                                value: 'Cash on Delivery',
                                child: Text('Cash on Delivery'),
                              ),
                              DropdownMenuItem(
                                value: 'UPI / Online Payment',
                                child: Text('UPI / Online Payment'),
                              ),
                              DropdownMenuItem(
                                value: 'Credit / Debit Card',
                                child: Text('Credit / Debit Card'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                paymentMethod = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 30),

                          // --- Place Order Button ---
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                _showOrderConfirmation(context, cart);
                              }
                            },
                            child: const Text('Place Order',
                                style: TextStyle(fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _showOrderConfirmation(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Order Confirmed!',
            style: TextStyle(color: Colors.pinkAccent)),
        content: const Text(
          'Thank you for shopping with us! Your order will be delivered soon.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {
              cart.clearCart();
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            child: const Text('Back to Home'),
          )
        ],
      ),
    );
  }
}
