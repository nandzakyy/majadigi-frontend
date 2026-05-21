import 'package:flutter/material.dart';
import '../../../core/widgets/custom_wave_header.dart';
import 'ticket_detail_screen.dart';

class TicketListScreen extends StatelessWidget {
  const TicketListScreen({super.key});

  static final List<Map<String, String>> tickets = [
    {
      "name": "Hapuna Beach",
      "image": "assets/images/wisata_beach.png",
    },
    {
      "name": "Makena Beach",
      "image": "assets/images/wisata_bromo.png",
    },
  ];

  static void addTicket(String wisataName) {
    final alreadyExists = tickets.any((t) => t["name"] == wisataName);
    if (!alreadyExists) {
      tickets.insert(0, {
        "name": wisataName,
        "image": wisataName.contains("Bromo") || wisataName.contains("Makena")
            ? "assets/images/wisata_bromo.png"
            : "assets/images/wisata_beach.png",
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: "Tiket Saya",
            rightWidget: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bookmark_border, color: Colors.white, size: 20),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: tickets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return _buildTiketCard(context, ticket["name"]!, ticket["image"]!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTiketCard(BuildContext context, String name, String imagePath) {
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
                        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Icon(Icons.bookmark, color: Colors.grey, size: 20),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Jl. Lorem Ipsum Dolor Sit Amet Bandung No. 123",
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text("4.1 km", style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              const Text("7.8", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 2),
                              Icon(Icons.star, color: Colors.orange.shade400, size: 10),
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
                  MaterialPageRoute(builder: (_) => TicketDetailScreen(eventName: name)),
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
