import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _sellProductId;
  bool _isLoading = false;
}

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return List.from(
          _products.where((Product product) => product.isFavorite).toList());
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product prod) {
      return prod.id == _sellProductId;
    });
  }

  String get selectedProductId {
    return _sellProductId;
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return _products.firstWhere((Product prod) {
      return prod.id == _sellProductId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://img.bleacherreport.net/img/images/photos/002/318/574/macho-man-randy-savage-1_crop_exact.jpg?w=1200&h=1200&q=75',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    try {
      final http.Response response = await http.post(
          'https://my-flutter-products-fbbbc.firebaseio.com/products.json',
          body: json.encode(productData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      _isLoading = false;
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':
          'https://img.bleacherreport.net/img/images/photos/002/318/574/macho-man-randy-savage-1_crop_exact.jpg?w=1200&h=1200&q=75',
      'price': price,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId
    };

    return http
        .put(
            'https://my-flutter-products-fbbbc.firebaseio.com/products/${selectedProduct.id}.json',
            body: jsonEncode(updateData))
        .then((http.Response response) {
      _isLoading = false;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _sellProductId = null;
    notifyListeners();
    return http
        .delete(
            'https://my-flutter-products-fbbbc.firebaseio.com/products/${deletedProductId}.json')
        .then((http.Response response) {
      _isLoading = false;

      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://my-flutter-products-fbbbc.firebaseio.com/products.json')
        .then<Null>((http.Response response) {
      _isLoading = false;
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);

      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            image: productData['image'],
            price: productData['price'],
            userEmail: productData['userEmail'],
            userId: productData['userId']);
        fetchedProductList.add(product);
      });
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
      _sellProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void toggleProductFavorite() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        isFavorite: newFavoriteStatus,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void selectProduct(String productId) {
    _sellProductId = productId;
    if (productId != null) {
      notifyListeners();
    }
  }

  void toggleDisplayFavorites() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UserModel on ConnectedProductsModel {
  void login(String email, String password) {
    _authenticatedUser = User(id: '1', email: email, password: password);
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
