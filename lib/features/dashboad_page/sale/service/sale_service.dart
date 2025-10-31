import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_url.dart';
import '../model/sale_model.dart';

class SaleService {
  Future<List<SaleModel>> fetchSales({String type = 'all'}) async {
    final String url = type == 'order' ? AppUrl.getSaleOrder : AppUrl.getSale;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'api-key': AppUrl.apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((e) => SaleModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch sales');
      }
    } on SocketException {
      throw SocketException('No Internet connection');
    } catch (e) {
      throw Exception('Error Sale: $e');
    }
  }
}
