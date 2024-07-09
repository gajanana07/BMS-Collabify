import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final List<String> selectedCategories;

  const FilterScreen({Key? key, required this.selectedCategories})
      : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late final List<String> categories;
  late final List<bool> _selectedCategories;

  @override
  void initState() {
    super.initState();
    categories = [
      'UX/UI Design',
      'Web Development',
      'Mobile Development',
      'Graphic Design',
      'Content Writing',
      'Data Science',
      'Machine Learning',
      'Game Development',
      'Video Editing',
      'Photography',
    ];
    _selectedCategories = List.generate(categories.length, (index) {
      return widget.selectedCategories.contains(categories[index]);
    });
  }

  void _toggleCategory(int index) {
    setState(() {
      _selectedCategories[index] = !_selectedCategories[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            leading: Checkbox(
              value: _selectedCategories[index],
              onChanged: (value) {
                _toggleCategory(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final selectedCategories = categories
              .asMap()
              .entries
              .where((entry) => _selectedCategories[entry.key])
              .map((entry) => entry.value)
              .toList();
          Navigator.pop(context, selectedCategories);
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
