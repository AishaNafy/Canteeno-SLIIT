import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;
  final List<String> referenceData;
  final Function(String)? onItemSelected;
  final IconData prefixIcon;

  const SearchWidget({
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search...',
    this.referenceData = const [],
    this.onItemSelected,
    this.prefixIcon = Icons.search,
    super.key,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  List<String> _filteredData = [];
  bool _showDropdown = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_filterData);
  }

  void _filterData() {
    setState(() {
      if (widget.controller.text.isEmpty) {
        _filteredData = [];
        _showDropdown = false;
      } else {
        _filteredData = widget.referenceData
            .where((item) => item
                .toLowerCase()
                .contains(widget.controller.text.toLowerCase()))
            .toList();
        _showDropdown = _filteredData.isNotEmpty;
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_filterData);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          onChanged: (value) {
            widget.onChanged(value);
            _filterData();
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon:
                Icon(widget.prefixIcon, color: Colors.grey[400], size: 22),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      widget.controller.clear();
                      widget.onChanged('');
                      setState(() => _showDropdown = false);
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          ),
        ),
        if (_showDropdown)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _filteredData[index],
                    style: const TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    widget.controller.text = _filteredData[index];
                    widget.onItemSelected?.call(_filteredData[index]);
                    setState(() => _showDropdown = false);
                  },
                  trailing: const Icon(Icons.arrow_forward, size: 16),
                );
              },
            ),
          ),
      ],
    );
  }
}

