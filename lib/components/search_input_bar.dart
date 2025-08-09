import 'package:flutter/material.dart';

class SearchInputBar extends StatelessWidget {
  final VoidCallback onTap;
  final String hintText;

  const SearchInputBar({
    super.key,
    required this.onTap,
    this.hintText = 'Buscar...',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          elevation: 4,
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(hintText, style: const TextStyle(fontSize: 16)),
                ),
              ),
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
