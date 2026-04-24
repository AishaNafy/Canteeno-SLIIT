import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/food_provider.dart';

class MenuTab extends StatefulWidget {
  const MenuTab({super.key});
  @override
  State<MenuTab> createState() => MenuTabState();
}

class MenuTabState extends State<MenuTab> {
  String _selectedCategory = "ALL";
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = [
    "ALL",
    "BREAKFAST",
    "LUNCH",
    "SNACKS",
    "BEVERAGES"
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Public method so FAB in parent can call it
  void openAddItemForm() => _showAddEditDialog();

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodProvider>(
      builder: (context, provider, child) {
        var filtered = provider.foodItems.where((item) {
          bool matchCat = _selectedCategory == "ALL" ||
              item.category.toUpperCase() == _selectedCategory;
          bool matchSearch = item.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
          return matchCat && matchSearch;
        }).toList();

        return Column(
          children: [
            /// Category Tabs
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  String cat = _categories[index];
                  bool sel = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel ? const Color(0xFF008080) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: sel
                                ? const Color(0xFF008080)
                                : Colors.grey[300]!),
                        boxShadow: sel
                            ? [
                                BoxShadow(
                                    color: const Color(0xFF008080)
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2))
                              ]
                            : [],
                      ),
                      child: Text(cat,
                          style: TextStyle(
                              color: sel ? Colors.white : Colors.grey[700],
                              fontWeight:
                                  sel ? FontWeight.bold : FontWeight.w500,
                              fontSize: 13)),
                    ),
                  );
                },
              ),
            ),

            /// Search
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: "Search food items...",
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon:
                      Icon(Icons.search, color: Colors.grey[400], size: 22),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          })
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
              ),
            ),

            /// Items List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.no_food_outlined,
                              size: 60, color: Colors.grey[300]),
                          const SizedBox(height: 12),
                          Text("No food items found",
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          Text("Tap '+ Add Item' to add a new item",
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 13)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) =>
                          _buildFoodCard(filtered[index]),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFoodCard(FoodItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFF9B1C1C).withValues(alpha: 0.08)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(item.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.fastfood,
                            color: Color(0xFF9B1C1C), size: 30)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A2E))),
                      const SizedBox(height: 4),
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(item.category,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        Text("Rs. ${item.price}",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9B1C1C))),
                      ]),
                      if (item.specialOffer != "None") ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: const Color(0xFF008080)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6)),
                          child: Text("🔥 ${item.specialOffer}",
                              style: const TextStyle(
                                  color: Color(0xFF008080),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    StockStatus next;
                    if (item.stockStatus == StockStatus.inStock) {
                      next = StockStatus.limitedStock;
                    } else if (item.stockStatus == StockStatus.limitedStock)
                      next = StockStatus.outOfStock;
                    else
                      next = StockStatus.inStock;
                    Provider.of<FoodProvider>(context, listen: false)
                        .updateStockStatus(item.id, next);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color:
                          _stockColor(item.stockStatus).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: _stockColor(item.stockStatus)
                              .withValues(alpha: 0.3)),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _stockColor(item.stockStatus))),
                      const SizedBox(width: 6),
                      Text(_stockText(item.stockStatus),
                          style: TextStyle(
                              color: _stockColor(item.stockStatus),
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ),
                const Spacer(),
                _actionBtn(Icons.edit_outlined, const Color(0xFF008080),
                    () => _showAddEditDialog(item: item)),
                const SizedBox(width: 8),
                _actionBtn(Icons.delete_outline, Colors.red[400]!,
                    () => _showDeleteDialog(item)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: color)),
    );
  }

  String _stockText(StockStatus s) => s == StockStatus.inStock
      ? "In Stock"
      : s == StockStatus.limitedStock
          ? "Limited"
          : "Out of Stock";
  Color _stockColor(StockStatus s) => s == StockStatus.inStock
      ? Colors.green
      : s == StockStatus.limitedStock
          ? Colors.orange
          : Colors.red;

  void _showDeleteDialog(FoodItem item) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Row(children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                SizedBox(width: 10),
                Text("Delete Item")
              ]),
              content: Text("Delete ${item.name}? This cannot be undone."),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.grey))),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    Provider.of<FoodProvider>(ctx, listen: false)
                        .deleteFood(item.id);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("${item.name} deleted"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ));
                  },
                  child: const Text("Delete",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ));
  }

  /// ─── ADD / EDIT FORM WITH VALIDATIONS ───
  void _showAddEditDialog({FoodItem? item}) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: item?.name ?? "");
    final priceCtrl = TextEditingController(text: item?.price ?? "");
    final offerCtrl = TextEditingController(text: item?.specialOffer ?? "");
    final cafCtrl = TextEditingController(text: item?.cafeteria ?? "");
    String category = item?.category ?? "Lunch";
    StockStatus stock = item?.stockStatus ?? StockStatus.inStock;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) {
          return Container(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.9),
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Handle bar
                      Center(
                          child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2)))),
                      const SizedBox(height: 16),

                      /// Title with icon
                      Row(children: [
                        Icon(
                            item == null
                                ? Icons.add_circle_outline
                                : Icons.edit_outlined,
                            color: const Color(0xFF008080),
                            size: 28),
                        const SizedBox(width: 10),
                        Text(item == null ? "Add New Item" : "Edit Item",
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A2E))),
                      ]),
                      const SizedBox(height: 6),
                      Text(
                          item == null
                              ? "Fill in the details to add a new food item"
                              : "Update the food item details",
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 13)),
                      const SizedBox(height: 24),

                      /// Item Name
                      _formLabel("Item Name *"),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: nameCtrl,
                        decoration: _inputDeco(
                            "e.g. Spicy Chicken Wrap", Icons.fastfood_outlined),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Item name is required";
                          }
                          if (v.trim().length < 2) {
                            return "Name must be at least 2 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      /// Price
                      _formLabel("Price (Rs.) *"),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: priceCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _inputDeco("e.g. 850", Icons.attach_money),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Price is required";
                          }
                          if (double.tryParse(v.trim()) == null) {
                            return "Enter a valid number";
                          }
                          if (double.parse(v.trim()) <= 0) {
                            return "Price must be greater than 0";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      /// Category
                      _formLabel("Category *"),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonFormField<String>(
                          initialValue: category,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: Color(0xFF008080)),
                          items: ["Breakfast", "Lunch", "Snacks", "Beverages"]
                              .map((c) =>
                                  DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => setS(() => category = v!),
                          validator: (v) =>
                              v == null ? "Select a category" : null,
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// Cafeteria
                      _formLabel("Cafeteria *"),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: cafCtrl,
                        decoration: _inputDeco(
                            "e.g. Cafeteria 1", Icons.store_outlined),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Cafeteria name is required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      /// Special Offer (optional)
                      _formLabel("Special Offer (optional)"),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: offerCtrl,
                        decoration: _inputDeco("e.g. Buy 1 Get 1 (Fridays)",
                            Icons.local_offer_outlined),
                      ),
                      const SizedBox(height: 16),

                      /// Availability
                      _formLabel("Availability"),
                      const SizedBox(height: 8),
                      Row(children: [
                        _chip(
                            "In Stock",
                            StockStatus.inStock,
                            stock,
                            Colors.green,
                            () => setS(() => stock = StockStatus.inStock)),
                        const SizedBox(width: 8),
                        _chip(
                            "Limited",
                            StockStatus.limitedStock,
                            stock,
                            Colors.orange,
                            () => setS(() => stock = StockStatus.limitedStock)),
                        const SizedBox(width: 8),
                        _chip(
                            "Out of Stock",
                            StockStatus.outOfStock,
                            stock,
                            Colors.red,
                            () => setS(() => stock = StockStatus.outOfStock)),
                      ]),
                      const SizedBox(height: 28),

                      /// Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          icon: Icon(item == null ? Icons.add : Icons.save,
                              color: Colors.white, size: 20),
                          label: Text(
                            item == null ? "ADD ITEM" : "SAVE CHANGES",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF008080),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;

                            final p =
                                Provider.of<FoodProvider>(ctx, listen: false);
                            String offer = offerCtrl.text.trim().isEmpty
                                ? "None"
                                : offerCtrl.text.trim();

                            if (item == null) {
                              p.addFood(
                                name: nameCtrl.text.trim(),
                                price: priceCtrl.text.trim(),
                                category: category,
                                cafeteria: cafCtrl.text.trim(),
                                specialOffer: offer,
                                stockStatus: stock,
                              );
                            } else {
                              p.updateFood(
                                item.id,
                                name: nameCtrl.text.trim(),
                                price: priceCtrl.text.trim(),
                                category: category,
                                specialOffer: offer,
                              );
                              p.updateStockStatus(item.id, stock);
                            }

                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Row(children: [
                                const Icon(Icons.check_circle,
                                    color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                Text(item == null
                                    ? "${nameCtrl.text} added successfully!"
                                    : "${nameCtrl.text} updated!"),
                              ]),
                              backgroundColor: const Color(0xFF008080),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ));
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                      /// Cancel Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          child: const Text("CANCEL",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1)),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _formLabel(String text) {
    return Text(text,
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF555555)));
  }

  InputDecoration _inputDeco(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF008080), size: 20),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF008080), width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      errorStyle: const TextStyle(fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }

  Widget _chip(String label, StockStatus s, StockStatus cur, Color color,
      VoidCallback onTap) {
    bool sel = cur == s;
    return Expanded(
        child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: sel ? color.withValues(alpha: 0.15) : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: sel ? color : Colors.grey[300]!, width: sel ? 1.5 : 1),
        ),
        child: Center(
            child: Text(label,
                style: TextStyle(
                    color: sel ? color : Colors.grey[500],
                    fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12))),
      ),
    ));
  }
}
