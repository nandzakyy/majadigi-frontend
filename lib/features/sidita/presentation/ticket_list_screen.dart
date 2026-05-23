import 'package:flutter/material.dart';
import '../../../core/widgets/custom_wave_header.dart';
import 'ticket_detail_screen.dart';

class TicketListScreen extends StatelessWidget {
  const TicketListScreen({super.key});

  static final List<Map<String, String>> tickets = [
    {
      "name": "Pantai Pasir Putih Karanggongso",
      "image": "assets/images/pasir_putih.jpg",
      "date": "Sab, 15 Jun 2026",
      "time": "08.00",
      "quantity": "3",
      "totalPayment": "45.000",
      "alamat": "Jl. Raya Karanggongso, Tasikmadu, Watulimo, Trenggalek",
      "rating": "8.7",
    },
  ];

  static void addTicket({
    required String name,
    required String image,
    required String date,
    required String time,
    required String quantity,
    required String totalPayment,
    required String alamat,
    required String rating,
  }) {
    tickets.insert(0, {
      "name": name,
      "image": image,
      "date": date,
      "time": time,
      "quantity": quantity,
      "totalPayment": totalPayment,
      "alamat": alamat,
      "rating": rating,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: "Tiket Saya",
            onSavePressed: () {},
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: tickets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _buildTiketCard(context, ticket);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTiketCard(BuildContext context, Map<String, String> ticket) {
    final name = ticket["name"] ?? "";
    final imagePath = ticket["image"] ?? "";
    final alamat = ticket["alamat"] ?? "";
    final rating = ticket["rating"] ?? "8.5";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.bookmark, color: Colors.grey, size: 20),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alamat,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              Text(rating, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 2),
                              const Icon(Icons.star, color: Colors.orange, size: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TicketDetailScreen(ticket: ticket)),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.green),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.green.shade50,
              ),
              child: const Text("Cek Tiket Saya", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
