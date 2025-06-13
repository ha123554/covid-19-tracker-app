import 'dart:convert';
import 'package:covid_tracker/Services/Utilities/app_url.dart';
import 'package:http/http.dart' as http;
import '../Modal/WorldStatesModel.dart';

class StatesServices {
  Future<WorldStatesModel> fetchWorldStatesRecords() async {
    try {
      final response = await http.get(Uri.parse(AppUrl.worldStatesApi));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return WorldStatesModel.fromJson(data);
      } else {
        print('Failed to load data: ${response.statusCode}');
        throw Exception('Failed to load data with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Error occurred: $e');
    }
  }

  Future<List<dynamic>> countriesListApi() async {
    var data;
    try {
      final response = await http.get(Uri.parse(AppUrl.countriesList));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        print('Failed to load data: ${response.statusCode}');
        throw Exception('Failed to load data with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Error occurred: $e');
    }
  }
}
