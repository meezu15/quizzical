import 'package:flutter/material.dart';

class CategoryModel {
  final int id;
  final String name;

  const CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  String get displayName {
    // Strip prefixes like "Entertainment: " or "Science: " for cleaner Figma card view
    if (name.contains(': ')) {
      return name.split(': ').last;
    }
    return name;
  }

  IconData get icon {
    final lower = name.toLowerCase();
    if (lower.contains('general knowledge')) return Icons.public_rounded;
    if (lower.contains('book')) return Icons.menu_book_rounded;
    if (lower.contains('film')) return Icons.movie_creation_rounded;
    if (lower.contains('music')) return Icons.music_note_rounded;
    if (lower.contains('television')) return Icons.tv_rounded;
    if (lower.contains('video game')) return Icons.sports_esports_rounded;
    if (lower.contains('board game')) return Icons.extension_rounded;
    if (lower.contains('science & nature')) return Icons.biotech_rounded;
    if (lower.contains('computer')) return Icons.computer_rounded;
    if (lower.contains('math')) return Icons.calculate_rounded;
    if (lower.contains('mythology')) return Icons.auto_awesome_rounded;
    if (lower.contains('sport')) return Icons.sports_soccer_rounded;
    if (lower.contains('geography')) return Icons.explore_rounded;
    if (lower.contains('history')) return Icons.history_edu_rounded;
    if (lower.contains('politic')) return Icons.account_balance_rounded;
    if (lower.contains('art')) return Icons.palette_rounded;
    if (lower.contains('celebrities')) return Icons.star_rounded;
    if (lower.contains('animal')) return Icons.pets_rounded;
    if (lower.contains('vehicle')) return Icons.directions_car_rounded;
    if (lower.contains('comic')) return Icons.menu_book_rounded;
    if (lower.contains('gadget')) return Icons.devices_rounded;
    if (lower.contains('anime') || lower.contains('manga')) {
      return Icons.animation_rounded;
    }
    if (lower.contains('cartoon')) return Icons.cruelty_free_rounded;
    return Icons.quiz_rounded;
  }
}
