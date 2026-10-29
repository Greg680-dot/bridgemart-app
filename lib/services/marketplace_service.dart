import 'package:flutter/foundation.dart';
import '../config/constants.dart';
import '../models/fabric_product_model.dart';
import '../models/pickup_point_model.dart';

class MarketplaceService extends ChangeNotifier {
  List<FabricProduct> _products = [];
  String _selectedCategory = 'Tous';
  String _searchQuery = '';
  
  // Panier
  final List<CartItem> _cart = [];
  
  // Point de retrait sélectionné par défaut à Cotonou
  PickupPointModel _selectedPickupPoint = PickupPointModel.fromMap(AppConstants.pickupPoints[0]);

  MarketplaceService() {
    _products = FabricProduct.getDemoProducts();
  }

  List<FabricProduct> get products {
    return _products.where((item) {
      final matchesCategory = _selectedCategory == 'Tous' || item.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.vendorName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.pattern.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  List<CartItem> get cart => _cart;
  PickupPointModel get selectedPickupPoint => _selectedPickupPoint;

  int get cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  double get cartTotalNgn => _cart.fold(0.0, (sum, item) => sum + item.getTotalPriceNgn());

  double getCartTotalXof(double rateNgnToXof) {
    return _cart.fold(0.0, (sum, item) => sum + item.getTotalPriceXof(rateNgnToXof));
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setPickupPoint(PickupPointModel point) {
    _selectedPickupPoint = point;
    notifyListeners();
  }

  void addToCart(FabricProduct product, {int quantity = 1}) {
    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cart[index].quantity += quantity;
    } else {
      _cart.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void updateCartQuantity(String productId, int delta) {
    final index = _cart.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _cart[index].quantity += delta;
      if (_cart[index].quantity <= 0) {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
