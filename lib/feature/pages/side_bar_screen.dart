import 'package:flutter/material.dart';

class SidebarLink extends StatelessWidget {
  final String label;
  final Color? color;

  const SidebarLink(this.label, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color ?? Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final Color? color;

  const SidebarItem({
    super.key,
    required this.label,
    required this.count,
    this.selected = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: selected
            ? Theme.of(context).colorScheme.primary.withAlpha(31)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (color != null)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              if (color != null) const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color ?? Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('$count', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
