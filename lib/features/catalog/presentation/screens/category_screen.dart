import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'products_list_screen.dart';

class CategoryScreen extends ConsumerWidget {
  final String categorySlug;
  final String categoryName;

  const CategoryScreen({
    super.key,
    required this.categorySlug,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProductsListScreen(
      categorySlug: categorySlug,
      title: categoryName,
    );
  }
}
