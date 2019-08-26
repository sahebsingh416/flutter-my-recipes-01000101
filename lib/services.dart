import 'package:http/http.dart' as http;
import './recipe.dart';
import 'dart:convert';
import 'dart:io';

class APICall{
  Future loadAddress() async {
    final res = await http.get("http://35.160.197.175:3006/api/v1/recipe/feeds", headers: {HttpHeaders.authorizationHeader : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6Mn0.MGBf-reNrHdQuwQzRDDNPMo5oWv4GlZKlDShFAAe16s"});
  final jsonResponse = jsonDecode(res.body);
  RecipesModel address = new RecipesModel.fromJson(jsonResponse);
}
}