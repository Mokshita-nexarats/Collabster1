import 'package:flutter/material.dart';

class CareerSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onFilterTap;
  final bool hasActiveFilter;
  final bool showFilterButton;
  final EdgeInsetsGeometry padding;

  const CareerSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search jobs, internships, freelance...',
    this.onChanged,
    this.onClear,
    this.onFilterTap,
    this.hasActiveFilter = false,
    this.showFilterButton = true,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<CareerSearchBar> createState() => _CareerSearchBarState();
}

class _CareerSearchBarState extends State<CareerSearchBar> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    widget.controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleTextChange);
    widget.controller.removeListener(_handleTextChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.isNotEmpty;

    return Padding(
      padding: widget.padding,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 21),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                onChanged: widget.onChanged,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
            if (hasText)
              GestureDetector(
                onTap: () {
                  widget.controller.clear();
                  if (widget.onChanged != null) {
                    widget.onChanged!('');
                  }
                  if (widget.onClear != null) {
                    widget.onClear!();
                  }
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.only(right: 6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF64748B),
                    size: 14,
                  ),
                ),
              ),
            if (widget.showFilterButton) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: widget.onFilterTap,
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.hasActiveFilter
                        ? const Color(0xFFE8F4FB)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: widget.hasActiveFilter
                        ? const Color(0xFF0088CC)
                        : const Color(0xFF475569),
                    size: 17,
                  ),
                ),
              ),
            ] else
              const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
