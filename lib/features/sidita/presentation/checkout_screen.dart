import 'package:flutter/material.dart';
import 'ticket_list_screen.dart';
import '../models/wisata_model.dart';
import '../../../core/widgets/custom_wave_header.dart';

class CheckoutScreen extends StatefulWidget {
  final WisataModel wisata;
  const CheckoutScreen({super.key, required this.wisata});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int quantity = 1;
  DateTime? selectedDate = DateTime.now();
  String? selectedTime;
  bool isVoucherApplied = false;

  @override
  void initState() {
    super.initState();
    final slots = _getTimeSlots(widget.wisata.namaWisata);
    if (slots.isNotEmpty) {
      selectedTime = slots.first;
    }
  }

  List<String> _getTimeSlots(String wisataName) {
    if (wisataName.contains("Karanggongso")) {
      return ["07.00", "09.00", "11.00", "13.00", "15.00", "17.00"];
    } else if (wisataName.contains("Mutiara")) {
      return ["06.00", "08.00", "10.00", "12.00", "14.00", "16.00"];
    } else if (wisataName.contains("Dolo")) {
      return ["07.00", "09.00", "11.00", "13.00", "15.00", "17.00"];
    } else if (wisataName.contains("Angkut")) {
      return ["12.00", "14.00", "16.00", "18.00", "20.00"];
    } else if (wisataName.contains("Pelangi")) {
      return ["08.00", "10.00", "12.00", "14.00", "16.00"];
    } else if (wisataName.contains("Bromo")) {
      return ["00.00", "04.00", "08.00", "12.00", "16.00", "20.00"];
    }
    return ["08.00", "10.00", "12.00", "14.00", "16.00"];
  }

  String _formatDate(DateTime date) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "Mei", "Jun",
      "Jul", "Agt", "Sep", "Okt", "Nov", "Des"
    ];
    const days = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"];
    return "${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}";
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return buffer.toString().split('').reversed.join('');
  }

  void _showVoucherDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.local_offer, color: Color(0xFF0065FF), size: 28),
                    SizedBox(width: 12),
                    Text(
                      "Pilih Voucher",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Voucher User Baru",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0044B2),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Diskon 5% untuk pembelian tiket semua wisata bagi pengguna baru.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Diskon 5%",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0065FF),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isVoucherApplied = true;
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0065FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            child: const Text(
                              "Gunakan",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (isVoucherApplied)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          isVoucherApplied = false;
                        });
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Batalkan Voucher",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int subtotal = widget.wisata.hargaTiket * quantity;
    final int discount = isVoucherApplied ? (subtotal * 0.05).round() : 0;
    final int totalPayment = subtotal - discount;

    final timeSlots = _getTimeSlots(widget.wisata.namaWisata);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomWaveHeader(
            title: "Checkout",
            onSavePressed: () {},
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
                          image: DecorationImage(
                            image: AssetImage(widget.wisata.image),
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
                              widget.wisata.namaWisata,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.wisata.alamat,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    widget.wisata.status,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "•  ${widget.wisata.jamOperasional}",
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
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
                          "Anda tidak dapat mengembalikan pembayaran tiket setelah pemesanan dikonfirmasi.",
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
                  GestureDetector(
                    onTap: _showVoucherDialog,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade300),
                        borderRadius: BorderRadius.circular(12),
                        color: isVoucherApplied ? Colors.blue.shade50 : Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_offer,
                                color: isVoucherApplied ? const Color(0xFF0065FF) : Colors.black87,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isVoucherApplied ? "1 voucher digunakan" : "Pilih voucher diskon",
                                style: TextStyle(
                                  color: isVoucherApplied ? const Color(0xFF0065FF) : Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            isVoucherApplied ? Icons.check_circle : Icons.chevron_right,
                            color: const Color(0xFF0065FF),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Ringkasan Pembayaran
                  const Text(
                    "Ringkasan Pembayaran",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _summaryRow("Subtotal", "Rp. ${_formatPrice(subtotal)}"),
                  const SizedBox(height: 12),
                  _summaryRow("Total Diskon", "- Rp. ${_formatPrice(discount)}"),
                  const SizedBox(height: 12),
                  _summaryRow(
                    "Total Pembayaran",
                    "Rp. ${_formatPrice(totalPayment)}",
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
                  TicketListScreen.addTicket(
                    name: widget.wisata.namaWisata,
                    image: widget.wisata.image,
                    date: selectedDate != null ? _formatDate(selectedDate!) : "Hari ini",
                    time: selectedTime ?? "08.00",
                    quantity: quantity.toString(),
                    totalPayment: _formatPrice(totalPayment),
                    alamat: widget.wisata.alamat,
                    rating: widget.wisata.rating.toString(),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TicketListScreen(),
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
