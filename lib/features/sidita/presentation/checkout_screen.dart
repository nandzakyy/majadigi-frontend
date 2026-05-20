import 'package:flutter/material.dart';
import 'daftar_tiket_screen.dart';
import '../../../core/widgets/custom_wave_header.dart';

class CheckoutScreen extends StatefulWidget {
  final String wisataName;
  const CheckoutScreen({super.key, required this.wisataName});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int quantity = 4;
  DateTime? selectedDate;
  String? selectedTime = "15.00";

  final List<String> timeSlots = ["08.00", "10.00", "13.00", "15.00", "17.00"];

  String _formatDate(DateTime date) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "Mei",
      "Jun",
      "Jul",
      "Agt",
      "Sep",
      "Okt",
      "Nov",
      "Des",
    ];
    const days = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"];
    return "${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: "Checkout",
            rightWidget: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bookmark_border,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Wisata Card
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/wisata_beach.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.wisataName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Jl. Lorem Ipsum Dolor Sit Amet Bandung No. 123",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Info Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tidak Dapat Dikembalikan",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Anda tidak dapat mengembalikan pembayaran...",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Dropdowns
                  Row(
                    children: [
                      // DATE PICKER
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (picked != null) {
                              setState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedDate != null
                                        ? _formatDate(selectedDate!)
                                        : "Pilih Tanggal",
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.blue,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // TIME DROPDOWN
                      Expanded(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedTime,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.blue,
                                size: 20,
                              ),
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              items: timeSlots.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedTime = val;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total pengunjung",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (quantity > 1) setState(() => quantity--);
                            },
                            child: const Icon(
                              Icons.remove_circle,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "$quantity",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => setState(() => quantity++),
                            child: const Icon(
                              Icons.add_circle,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Voucher Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.local_offer,
                              color: Colors.black,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "3 voucher digunakan",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.chevron_right, color: Colors.blue),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Ringkasan Pembayaran
                  const Text(
                    "Ringkasan Pembayaran",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _summaryRow("Subtotal", "\Rp. 260.000"),
                  const SizedBox(height: 12),
                  _summaryRow("Total Diskon", "- \Rp. 10.000"),
                  const SizedBox(height: 12),
                  _summaryRow(
                    "Total Pembayaran",
                    "\Rp. 250.000",
                    isTotal: true,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Sticky Bottom Button
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DaftarTiketScreen(wisataName: widget.wisataName),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005FF0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Beli Tiket",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.blue : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
