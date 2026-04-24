import 'package:flutter/material.dart';

enum StockStatus { inStock, limitedStock, outOfStock }

class FoodItem {
  final String id;
  final String name;
  final String price;
  final String category;
  final StockStatus stockStatus;
  final String specialOffer;
  final String cafeteria;
  final String imagePath;

  FoodItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.stockStatus = StockStatus.inStock,
    this.specialOffer = "None",
    required this.cafeteria,
    this.imagePath = 'assets/logoHome.png',
  });

  FoodItem copyWith({
    String? name,
    String? price,
    String? category,
    StockStatus? stockStatus,
    String? specialOffer,
    String? cafeteria,
    String? imagePath,
  }) {
    return FoodItem(
      id: id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      stockStatus: stockStatus ?? this.stockStatus,
      specialOffer: specialOffer ?? this.specialOffer,
      cafeteria: cafeteria ?? this.cafeteria,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

class FoodProvider with ChangeNotifier {
  final List<FoodItem> _foodItems = [
    FoodItem(id: '1', name: 'Creamy Sausage Pasta', price: '850', category: 'Lunch', cafeteria: 'Cafeteria 1', specialOffer: 'None', imagePath: 'assets/food/sausage_pasta.jpeg'),
    FoodItem(id: '2', name: 'Spaghetti Meatballs', price: '700', category: 'Dinner', cafeteria: 'Cafeteria 2', specialOffer: 'Combo Deal', imagePath: 'assets/food/meatballs.jpeg'),
    FoodItem(id: '3', name: 'Shrimp Pasta', price: '950', category: 'Dinner', cafeteria: 'Cafeteria 1', specialOffer: 'None', imagePath: 'assets/food/shrimp_pasta.jpeg'),
    FoodItem(id: '4', name: 'Mutton Curry', price: '1200', category: 'Lunch', cafeteria: 'Cafeteria 2', specialOffer: 'Spicy Delight', imagePath: 'assets/food/curry.jpeg'),
    FoodItem(id: '5', name: 'Egg Fried Rice', price: '600', category: 'Lunch', cafeteria: 'Cafeteria 1', specialOffer: 'None', imagePath: 'assets/food/fried_rice.jpeg'),
    FoodItem(id: '6', name: 'Spicy Koththu', price: '650', category: 'Dinner', cafeteria: 'Cafeteria 2', specialOffer: 'Customer Favorite', imagePath: 'assets/food/koththu.jpeg'),
    FoodItem(id: '7', name: 'Chicken & Rice', price: '800', category: 'Lunch', cafeteria: 'Cafeteria 1', specialOffer: 'None', imagePath: 'assets/food/chicken_rice.jpeg'),
    FoodItem(id: '8', name: 'Dum Biryani', price: '1100', category: 'Halal', cafeteria: 'Cafeteria 2', specialOffer: 'Hot', imagePath: 'assets/food/dum_biryani.jpeg'),
    FoodItem(id: '9', name: 'Garlic Naan & Tofu', price: '450', category: 'Halal', cafeteria: 'Cafeteria 1', specialOffer: 'Vegan', imagePath: 'assets/food/garlic_naan.jpeg'),
    FoodItem(id: '10', name: 'The Royal Thali', price: '1500', category: 'Halal', cafeteria: 'Cafeteria 2', specialOffer: 'Feast', imagePath: 'assets/food/royal_thali.jpeg'),
    FoodItem(id: '11', name: 'Paneer Curry', price: '750', category: 'Halal', cafeteria: 'Cafeteria 1', specialOffer: 'None', imagePath: 'assets/food/paneer_curry.jpeg'),
    FoodItem(id: '12', name: 'Masala Dosa', price: '300', category: 'Veg', cafeteria: 'Cafeteria 1', specialOffer: 'Breakfast Deal', imagePath: 'assets/food/dosa.jpeg'),
    FoodItem(id: '13', name: 'Rajma Chawal', price: '600', category: 'Veg', cafeteria: 'Cafeteria 2', specialOffer: 'Healthy', imagePath: 'assets/food/rajma_chawal_white.jpeg'),
    FoodItem(id: '14', name: 'Kidney Bean Curry', price: '750', category: 'Veg', cafeteria: 'Cafeteria 1', specialOffer: 'None', imagePath: 'assets/food/rajma_chawal_bowl.jpeg'),
    FoodItem(id: '15', name: 'Moong Sprout Salad', price: '250', category: 'Veg', cafeteria: 'Cafeteria 2', specialOffer: 'Fresh', imagePath: 'assets/food/sprout_salad.jpeg'),
    FoodItem(id: '16', name: 'Pancakes with Syrup', price: '450', category: 'Breakfast', cafeteria: 'Cafeteria 1', specialOffer: 'Morning Deal'),
    FoodItem(id: '17', name: 'Egg Sandwich', price: '250', category: 'Breakfast', cafeteria: 'Cafeteria 2'),
    FoodItem(id: '18', name: 'Vegetable Samosa', price: '80', category: 'Snacks', cafeteria: 'Cafeteria 1'),
    FoodItem(id: '19', name: 'Chicken Patty', price: '120', category: 'Snacks', cafeteria: 'Cafeteria 2', specialOffer: 'Hot'),
    FoodItem(id: '20', name: 'Iced Coffee', price: '300', category: 'Beverages', cafeteria: 'Cafeteria 1', specialOffer: 'Cooler'),
    FoodItem(id: '21', name: 'Fresh Orange Juice', price: '250', category: 'Beverages', cafeteria: 'Cafeteria 2'),
  ];

  List<FoodItem> get foodItems => [..._foodItems];
  List<FoodItem> get availableFoodItems => _foodItems.where((item) => item.stockStatus != StockStatus.outOfStock).toList();

  void addFood({
    required String name,
    required String price,
    required String category,
    required String cafeteria,
    String specialOffer = "None",
    StockStatus stockStatus = StockStatus.inStock,
    String imagePath = 'assets/logoHome.png',
  }) {
    final newItem = FoodItem(
      id: DateTime.now().toString(),
      name: name,
      price: price,
      category: category,
      cafeteria: cafeteria,
      specialOffer: specialOffer,
      stockStatus: stockStatus,
      imagePath: imagePath,
    );
    _foodItems.add(newItem);
    notifyListeners();
  }

  void updateFood(String id, {
    String? name,
    String? price,
    String? category,
    StockStatus? stockStatus,
    String? specialOffer,
    String? imagePath,
  }) {
    final index = _foodItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _foodItems[index] = _foodItems[index].copyWith(
        name: name,
        price: price,
        category: category,
        stockStatus: stockStatus,
        specialOffer: specialOffer,
        imagePath: imagePath,
      );
      notifyListeners();
    }
  }

  void deleteFood(String id) {
    _foodItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateStockStatus(String id, StockStatus status) {
    final index = _foodItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _foodItems[index] = _foodItems[index].copyWith(stockStatus: status);
      notifyListeners();
    }
  }
}

