import 'package:feed_flix/core/api/api_exception.dart';
import 'package:feed_flix/core/network/api_services.dart';
import 'package:feed_flix/features/home/data/models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiService apiService;

  CategoryRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await apiService.get('category_list/');

    if (response is List) {
      return response.map((item) => CategoryModel.fromJson(item)).toList();
    }

    throw ServerException('Invalid response format');
  }
}
