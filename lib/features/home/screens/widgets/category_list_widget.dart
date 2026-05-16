import 'package:feed_flix/features/home/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';

class CategoryListWidget extends StatelessWidget {
  final List<CategoryEntity> categories;

  const CategoryListWidget({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue),
            ),
            child: Center(
              child: Text(
                category.name,
                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
              ),
            ),
          );
        },
      ),
    );
  }
}
