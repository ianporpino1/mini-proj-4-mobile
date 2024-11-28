import 'dart:convert';
import 'package:f08_eshop_app/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  static const _baseUrl =
      'https://miniproj4-9a218-default-rtdb.firebaseio.com/';
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<List<User>> _fetchAllUsers() async {
    final url = Uri.parse('$_baseUrl/users.json');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar usuários');
    }

    final data = json.decode(response.body) as Map<String, dynamic>?;

    if (data == null) return [];

    return data.entries.map((e) {
      final userData = e.value as Map<String, dynamic>;

      return User(
        id: e.key,
        name: userData['name'],
        email: userData['email'],
        password: userData['password'],
      );
    }).toList();
  }

  Future<String> login(String email, String password) async {
    final users = await _fetchAllUsers();
    try {
      final User user = users.firstWhere(
        (u) => u.email == email,
        orElse: () => throw Exception('Usuário não encontrado'),
      );

      if (user.password != password) {
        return 'Senha incorreta.';
      }

      _currentUser = user;
      notifyListeners();
      return 'Login realizado com sucesso.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> register(String name, String email, String password) async {
    final users = await _fetchAllUsers();

    if (users.any((u) => u.email == email)) {
      return 'Já existe um usuário cadastrado com este email.';
    }

    final url = Uri.parse('$_baseUrl/users.json');
    final newUser = User(
      id: '',
      name: name,
      email: email,
      password: password,
    );

    final response = await http.post(
      url,
      body: json.encode(newUser.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      return 'Erro ao cadastrar usuário.';
    }

    notifyListeners();
    return 'Cadastro realizado com sucesso.';
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
