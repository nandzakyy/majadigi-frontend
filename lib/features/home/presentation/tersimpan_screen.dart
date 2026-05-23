import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:majadigi/core/theme/app_colors.dart';
import 'package:majadigi/features/home/presentation/dynamic_loader_provider.dart';

class TersimpanScreen extends StatefulWidget {
  const TersimpanScreen({Key? key}) : super(key: key);

  @override
  State<TersimpanScreen> createState() => _TersimpanScreenState();
}

class _TersimpanScreenState extends State<TersimpanScreen> {
  String _query = '';
  late List<dynamic> _items;

  @override
  void initState() {
    super.initState();
    final loader = Provider.of<DynamicLoaderProvider>(context, listen: false);
    _items = loader.personalizedServices.toList();
  }

  void _removeAt(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Layanan', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah Anda yakin menghapus layanan yang sudah disimpan?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(onPressed: () { setState(() { _items.removeAt(index); }); Navigator.pop(ctx); }, child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _items.where((s) => s.title.toLowerCase().contains(_query.toLowerCase())).toList();

    // ensure status bar color matches header so the top area is fully blue
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: AppColors.primary, statusBarIconBrightness: Brightness.light));
    return Scaffold(
      body: Column(
        children: [
          // Full-bleed header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
            ),
            child: Row(
              children: [
                GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
                const SizedBox(width: 12),
                const Expanded(child: Text('Layanan Tersimpan', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                      child: TextField(
                        onChanged: (v) => setState(() => _query = v),
                        decoration: const InputDecoration(hintText: 'Cari Layanan', prefixIcon: Icon(Icons.search), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3, mainAxisSpacing: 12, crossAxisSpacing: 12),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final s = filtered[index];
                          return Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: s.assetPath != null
                                      ? (s.assetPath.toLowerCase().endsWith('.svg') ? SvgPicture.asset(s.assetPath, width: 40, height: 40) : Image.asset(s.assetPath, width: 40, height: 40))
                                      : Icon(s.icon, color: AppColors.primary),
                                ),
                                Expanded(child: Text(s.title, style: const TextStyle(fontWeight: FontWeight.w600))),
                                IconButton(onPressed: () => _removeAt(index), icon: const Icon(Icons.more_vert)),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
