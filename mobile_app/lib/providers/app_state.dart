import 'dart:math';
import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../data/mock_data.dart';

class AppState extends ChangeNotifier {
  final List<VehicleModel> _allVehicles = MockData.vehicles;
  final Set<String> _favoriteIds = {};

  String _condition = 'all';
  String _category = 'all';
  String _brand = 'all';
  String _searchQuery = '';
  double _maxPrice = double.infinity;
  String _sort = 'featured';

  double _simCarPrice = 180000;
  double _simDownPayment = 54000;
  int _simMonths = 48;
  final double _interestRateMonth = 0.0139;

  List<VehicleModel> get allVehicles => _allVehicles;
  Set<String> get favoriteIds => _favoriteIds;
  int get favoritesCount => _favoriteIds.length;

  String get condition => _condition;
  String get category => _category;
  String get brand => _brand;
  String get searchQuery => _searchQuery;
  double get maxPrice => _maxPrice;
  String get sort => _sort;

  double get simCarPrice => _simCarPrice;
  double get simDownPayment => _simDownPayment;
  int get simMonths => _simMonths;

  List<String> get availableBrands {
    final brands = _allVehicles.map((v) => v.brand).toSet().toList();
    brands.sort();
    return ['all', ...brands];
  }

  List<VehicleModel> get filteredVehicles {
    List<VehicleModel> list = List.from(_allVehicles);

    if (_condition != 'all') {
      list = list.where((v) => v.condition == _condition).toList();
    }

    if (_category != 'all') {
      list = list.where((v) => v.category == _category).toList();
    }

    if (_brand != 'all') {
      list = list.where((v) => v.brand.toLowerCase() == _brand.toLowerCase()).toList();
    }

    if (_maxPrice != double.infinity) {
      list = list.where((v) => v.price <= _maxPrice).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((v) {
        return v.name.toLowerCase().contains(q) ||
            v.brand.toLowerCase().contains(q) ||
            v.model.toLowerCase().contains(q) ||
            v.features.any((f) => f.toLowerCase().contains(q));
      }).toList();
    }

    switch (_sort) {
      case 'price-asc':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price-desc':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'year-desc':
        list.sort((a, b) => b.year.compareTo(a.year));
        break;
      case 'featured':
      default:
        list.sort((a, b) => (b.featured ? 1 : 0).compareTo(a.featured ? 1 : 0));
        break;
    }

    return list;
  }

  List<VehicleModel> get favoriteVehicles {
    return _allVehicles.where((v) => _favoriteIds.contains(v.id)).toList();
  }

  List<VehicleModel> get featuredVehicles {
    return _allVehicles.where((v) => v.featured).toList();
  }

  void setCondition(String val) {
    _condition = val;
    notifyListeners();
  }

  void setCategory(String val) {
    _category = val;
    notifyListeners();
  }

  void setBrand(String val) {
    _brand = val;
    notifyListeners();
  }

  void setSearchQuery(String val) {
    _searchQuery = val;
    notifyListeners();
  }

  void setMaxPrice(double val) {
    _maxPrice = val;
    notifyListeners();
  }

  void setSort(String val) {
    _sort = val;
    notifyListeners();
  }

  void resetFilters() {
    _condition = 'all';
    _category = 'all';
    _brand = 'all';
    _searchQuery = '';
    _maxPrice = double.infinity;
    _sort = 'featured';
    notifyListeners();
  }

  bool isFavorite(String vehicleId) => _favoriteIds.contains(vehicleId);

  void toggleFavorite(String vehicleId) {
    if (_favoriteIds.contains(vehicleId)) {
      _favoriteIds.remove(vehicleId);
    } else {
      _favoriteIds.add(vehicleId);
    }
    notifyListeners();
  }

  void setSimCarPrice(double price) {
    _simCarPrice = price;
    if (_simDownPayment > price * 0.8) {
      _simDownPayment = price * 0.3;
    }
    notifyListeners();
  }

  void setSimDownPayment(double down) {
    _simDownPayment = down;
    notifyListeners();
  }

  void setSimMonths(int months) {
    _simMonths = months;
    notifyListeners();
  }

  double get simFinancedAmount => max(0, _simCarPrice - _simDownPayment);

  double get simDownPercent => (_simDownPayment / _simCarPrice) * 100;

  double get simMonthlyInstallment {
    final pv = simFinancedAmount;
    if (pv <= 0) return 0;
    final i = _interestRateMonth;
    final n = _simMonths;
    return pv * (i * pow(1 + i, n)) / (pow(1 + i, n) - 1);
  }
}
