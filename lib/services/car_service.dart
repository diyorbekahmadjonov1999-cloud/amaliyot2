import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/car_brand.dart';
import '../models/car_model.dart';

class CarService {
  static Future<List<CarBrand>> getBrands() async {
    final response = await http.get(Uri.parse(ApiConfig.carBrands));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CarBrand.fromJson(json)).toList();
    } else {
      throw Exception('Brendlarni yuklashda xatolik: ${response.statusCode}');
    }
  }

  static Future<List<CarModel>> getModels(int brandId) async {
    final response =
    await http.get(Uri.parse(ApiConfig.carModels(brandId)));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CarModel.fromJson(json)).toList();
    } else {
      throw Exception('Modellarni yuklashda xatolik: ${response.statusCode}');
    }
  }
}