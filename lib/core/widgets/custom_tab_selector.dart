import 'package:flutter/material.dart';

class CustomTabSelector extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const CustomTabSelector({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(tabs.length, (index) {
        final active = index == selectedIndex;
        return GestureDetector(
          onTap: () => onChanged(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: active ? const Color(0xFFE8F2FF) : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              style: TextStyle(
                color: active ? const Color(0xFF0D6EFD) : Colors.black,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
              child: Text(tabs[index]),
            ),
          ),
        );
      }),
    );
  }
}
