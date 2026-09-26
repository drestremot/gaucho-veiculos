import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/theme.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Buscar por modelo, marca ou opcional...',
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 16,
                    color: AppTheme.textMuted,
                  ),
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          controller.clear();
                          onChanged('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primarySubtle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primary),
            ),
            child: IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.sliders,
                size: 16,
                color: AppTheme.primary,
              ),
              onPressed: onFilterTap,
              tooltip: 'Filtros Avançados',
            ),
          ),
        ],
      ),
    );
  }
}
