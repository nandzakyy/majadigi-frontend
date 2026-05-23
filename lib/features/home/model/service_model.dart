import 'package:flutter/material.dart';

class ServiceModel {
  final String title;
  final IconData icon;
  final String category;
  final List<String> availableRegions;
  final String? assetPath;

  ServiceModel({
    required this.title,
    required this.icon,
    required this.category,
    this.availableRegions = const ["All"],
    this.assetPath,
  });
}
