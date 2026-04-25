import 'package:flutter/material.dart';
import '../../utils/download_service.dart';
import 'cafeteria_queue_detail_screen.dart';

class QueueTab extends StatelessWidget {
  const QueueTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy cafeteria list mimicking real criteria
    final List<Map<String, dynamic>> cafeterias = [
      {
        "name": "Engineering Canteen",
        "queue": 4,
        "wait": 16,
        "completed": 45,
        "cancelled": 1
      },
      {
        "name": "Main Building Cafeteria",
        "queue": 12,
        "wait": 25,
        "completed": 120,
        "cancelled": 3
      },
      {
        "name": "Computing Block Cafe",
        "queue": 2,
        "wait": 5,
        "completed": 85,
        "cancelled": 0
      },
      {
        "name": "Business School Kiosk",
        "queue": 8,
        "wait": 20,
        "completed": 64,
        "cancelled": 2
      },
      {
        "name": "Sports Complex Vendor",
        "queue": 0,
        "wait": 0,
        "completed": 15,
        "cancelled": 0
      },
      {
        "name": "Medical Faculty Canteen",
        "queue": 5,
        "wait": 18,
        "completed": 38,
        "cancelled": 1
      },
    ];

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Queue Management", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {
                    DownloadService.downloadQueueReport(context, cafeterias: cafeterias);
                  },
                  icon: const Icon(Icons.download, size: 18, color: Colors.white),
                  label: const Text("Download Report", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9B1C1C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: cafeterias.length,
              itemBuilder: (context, index) {
          final cafe = cafeterias[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CafeteriaQueueDetailScreen(cafeteriaName: cafe['name']),
                ),
              );
            },
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cafe['name'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildMiniStat("Queue", "${cafe['queue']} Orders",
                            const Color(0xFF1565C0)),
                        const SizedBox(width: 8),
                        _buildMiniStat("Est Wait", "${cafe['wait']} Min",
                            const Color(0xFF008080)),
                        const SizedBox(width: 8),
                        _buildMiniStat(
                            "Completed", "${cafe['completed']}", Colors.green),
                        const SizedBox(width: 8),
                        _buildMiniStat(
                            "Cancelled", "${cafe['cancelled']}", Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
          },
        ),
      ),
    ],
  ),
);
  }
  Widget _buildMiniStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 9,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
