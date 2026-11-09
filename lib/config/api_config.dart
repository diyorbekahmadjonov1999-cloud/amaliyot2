class ApiConfig {
  static const String baseUrl =
      'https://backendhouseengine-production-e284.up.railway.app';

  static const String register = '$baseUrl/api/auth/register';
  static const String verifyRegister = '$baseUrl/api/auth/verify-register';
  static const String login = '$baseUrl/api/auth/login';
  static const String verifyLogin = '$baseUrl/api/auth/verify-login';

  static const String carBrands = '$baseUrl/api/cars/brands';
  static String carModels(int brandId) => '$baseUrl/api/cars/models/$brandId';
}