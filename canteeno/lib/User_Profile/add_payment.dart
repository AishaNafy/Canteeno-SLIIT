import 'package:flutter/material.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  _AddPaymentScreenState createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  String paymentType = 'Card';
  String cardNumber = '';
  String cardHolder = '';
  String expiry = '';
  String cvv = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Payment Method"),
        backgroundColor: Colors.red.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: paymentType,
                items: ['Card', 'Wallet', 'Bank']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    paymentType = val!;
                  });
                },
                decoration: const InputDecoration(labelText: "Payment Type"),
              ),
              const SizedBox(height: 10),
              if (paymentType == 'Card') ...[
                TextFormField(
                  decoration: const InputDecoration(labelText: "Card Number"),
                  onSaved: (val) => cardNumber = val ?? '',
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Card Holder Name"),
                  onSaved: (val) => cardHolder = val ?? '',
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "Expiry MM/YY"),
                        onSaved: (val) => expiry = val ?? '',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "CVV"),
                        onSaved: (val) => cvv = val ?? '',
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState?.save();
                  // TODO: connect backend
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Payment method added!")),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade900,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Add Payment Method"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
