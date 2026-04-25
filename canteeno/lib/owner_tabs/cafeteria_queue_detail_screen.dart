import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum OrderStatus { inProgress, waiting, readyForPickup, cancelled }

class OrderItem {
  final String id;
  final String customer;
  OrderStatus status;
  final int waitTime;

  OrderItem({required this.id, required this.customer, required this.status, required this.waitTime});
}

class PickupSlot {
  final String time;
  final String customer;
  PickupSlot({required this.time, required this.customer});
}

class CafeteriaQueueDetailScreen extends StatefulWidget {
  final String cafeteriaName;
  const CafeteriaQueueDetailScreen({super.key, required this.cafeteriaName});

  @override
  State<CafeteriaQueueDetailScreen> createState() => _CafeteriaQueueDetailScreenState();
}

class _CafeteriaQueueDetailScreenState extends State<CafeteriaQueueDetailScreen> {
  final List<OrderItem> _orders = [
    OrderItem(id: '101', customer: 'John Smith', status: OrderStatus.inProgress, waitTime: 12),
    OrderItem(id: '102', customer: 'Emily Clark', status: OrderStatus.waiting, waitTime: 20),
    OrderItem(id: '103', customer: 'Mike Johnson', status: OrderStatus.readyForPickup, waitTime: 0),
    OrderItem(id: '104', customer: 'Sara Lee', status: OrderStatus.inProgress, waitTime: 15),
    OrderItem(id: '105', customer: 'David Brown', status: OrderStatus.cancelled, waitTime: 0),
  ];

  final List<PickupSlot> _pickups = [
    PickupSlot(time: '11:00 AM', customer: 'Michael W.'),
    PickupSlot(time: '11:30 AM', customer: 'Lisa K.'),
    PickupSlot(time: '12:00 PM', customer: 'Brian T.'),
    PickupSlot(time: '12:30 PM', customer: 'Anna G.'),
    PickupSlot(time: '1:00 PM', customer: 'Mark R.'),
  ];

  int _nextOrderId = 106;

  int get _activeOrders => _orders.where((o) => o.status != OrderStatus.cancelled).length;
  int get _completedToday => 45;
  int get _cancelledToday => _orders.where((o) => o.status == OrderStatus.cancelled).length;
  int get _avgWait {
    final active = _orders.where((o) => o.waitTime > 0).toList();
    if (active.isEmpty) return 0;
    return (active.map((e) => e.waitTime).reduce((a, b) => a + b) / active.length).round();
  }

  void _showAddOrderDialog() {
    final formKey = GlobalKey<FormState>();
    String customer = '';
    int waitTime = 15;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Order"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Customer Name"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return "Name required";
                    if (!RegExp(r'^[a-zA-Z\s\.]+$').hasMatch(value.trim())) return "Name must be letters only";
                    return null;
                  },
                  onSaved: (value) => customer = value!.trim(),
                ),
                TextFormField(
                  initialValue: "15",
                  decoration: const InputDecoration(labelText: "Est. Wait Time (min)"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return "Wait time required";
                    if (int.tryParse(value.trim()) == null) return "No letters allowed, numbers only";
                    return null;
                  },
                  onSaved: (value) => waitTime = int.parse(value ?? "0"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9B1C1C)),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  setState(() {
                    _orders.add(OrderItem(
                      id: _nextOrderId.toString(),
                      customer: customer,
                      status: OrderStatus.inProgress,
                      waitTime: waitTime,
                    ));
                    _nextOrderId++;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add Order", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAddPickupDialog() {
    final formKey = GlobalKey<FormState>();
    String customer = '';
    String time = '2:00 PM';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Schedule Pickup"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Customer Name"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return "Name required";
                    if (!RegExp(r'^[a-zA-Z\s\.]+$').hasMatch(value.trim())) return "Name must be letters only";
                    return null;
                  },
                  onSaved: (value) => customer = value!.trim(),
                ),
                TextFormField(
                  initialValue: "2:00 PM",
                  decoration: const InputDecoration(labelText: "Pickup Time", hintText: "e.g., 2:00 PM"),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return "Time required";
                    final timeRegex = RegExp(r'^(0?[1-9]|1[0-2]):[0-5][0-9]\s?(AM|PM|am|pm)$');
                    if (!timeRegex.hasMatch(value.trim())) return "Do not enter words, use format 2:00 PM";
                    return null;
                  },
                  onSaved: (value) => time = value!.trim(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1565C0)),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  setState(() {
                    _pickups.add(PickupSlot(time: time, customer: customer));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Schedule", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${widget.cafeteriaName} Queue', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF9B1C1C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Stats Row
            _buildStatsRow(),
            const SizedBox(height: 20),

            /// Live Order Queue
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle("Live Order Queue", Icons.list_alt),
                TextButton.icon(
                  onPressed: _showAddOrderDialog,
                  icon: const Icon(Icons.add, size: 18, color: Color(0xFF9B1C1C)),
                  label: const Text("Add Order", style: TextStyle(color: Color(0xFF9B1C1C), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildOrderTable(),
            const SizedBox(height: 8),
            _buildQueueSummary(),
            const SizedBox(height: 24),

            /// Pickup Scheduling
            _buildSectionTitle("Pickup Scheduling", Icons.schedule),
            const SizedBox(height: 12),
            ..._pickups.map((p) => _buildPickupCard(p)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showAddPickupDialog,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Schedule New Pickup", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _statBox("Current Queue", "$_activeOrders Orders", const Color(0xFF1565C0)),
        const SizedBox(width: 8),
        _statBox("Est. Wait", "$_avgWait Min", const Color(0xFF008080)),
        const SizedBox(width: 8),
        _statBox("Completed", "$_completedToday Today", Colors.green),
        const SizedBox(width: 8),
        _statBox("Cancelled", "$_cancelledToday Today", Colors.red),
      ],
    );
  }

  Widget _statBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF9B1C1C), size: 22),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
      ],
    );
  }

  Widget _buildOrderTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Row(
              children: [
                SizedBox(width: 30, child: Text("#", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                Expanded(flex: 3, child: Text("Customer", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                Expanded(flex: 2, child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                Expanded(flex: 1, child: Text("Wait", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                SizedBox(width: 60, child: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
              ],
            ),
          ),
          ...List.generate(_orders.length, (i) => _buildOrderRow(_orders[i], i)),
        ],
      ),
    );
  }

  Widget _buildOrderRow(OrderItem order, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          SizedBox(width: 30, child: Text(order.id, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
          Expanded(flex: 3, child: Text(order.customer, style: const TextStyle(fontSize: 13))),
          Expanded(flex: 2, child: _statusBadge(order.status)),
          Expanded(flex: 1, child: Text(order.status == OrderStatus.cancelled ? "—" : "${order.waitTime} min", style: const TextStyle(fontSize: 12))),
          SizedBox(
            width: 60,
            child: order.status == OrderStatus.cancelled
                ? TextButton(onPressed: () => setState(() => _orders.removeAt(index)), child: const Text("Delete", style: TextStyle(color: Colors.red, fontSize: 11)))
                : Row(
                    children: [
                      InkWell(
                        onTap: () => setState(() => order.status = OrderStatus.readyForPickup),
                        child: Container(padding: const EdgeInsets.all(4), child: const Icon(Icons.check, color: Colors.green, size: 16)),
                      ),
                      InkWell(
                        onTap: () => setState(() => order.status = OrderStatus.cancelled),
                        child: Container(padding: const EdgeInsets.all(4), child: const Icon(Icons.close, color: Colors.red, size: 16)),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(OrderStatus status) {
    String text;
    Color color;
    switch (status) {
      case OrderStatus.inProgress: text = "In Progress"; color = const Color(0xFF1565C0);
      case OrderStatus.waiting: text = "Waiting"; color = Colors.orange;
      case OrderStatus.readyForPickup: text = "Ready"; color = Colors.green;
      case OrderStatus.cancelled: text = "Cancelled"; color = Colors.red;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildQueueSummary() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Queue Length: $_activeOrders Orders", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Text("Avg. Wait Time: $_avgWait Minutes", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildPickupCard(PickupSlot pickup) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFF1565C0).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(pickup.time, style: const TextStyle(color: Color(0xFF1565C0), fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          const SizedBox(width: 16),
          Text(pickup.customer, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}

