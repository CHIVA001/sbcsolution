
import 'package:cyspharama_app/routes/app_routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
class StorageService {

  final  _storage = FlutterSecureStorage();

  // read data from storage
  Future<String?> readData(String key) async {
    return await _storage.read(key: key);
  }

  // write data to storage
  Future<void> writeData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // delete data from storage
  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final id = await _storage.read(key: 'user_id');

    if(id !=null){
      Get.offAndToNamed(AppRoutes.navBar);
    } else {
      Get.offAndToNamed(AppRoutes.login);
    }
    return id != null && id.isNotEmpty;
  }

  Future<String> getEmpId() async {
    final empId = await _storage.read(key: 'emp_id');
    return empId ?? '';
  }
  Future<String> getUserId() async {
    final userId = await _storage.read(key: 'user_id');
    return userId ?? '';
  }
  
}