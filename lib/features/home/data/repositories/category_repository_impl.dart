import 'package:feed_flix/core/api/api_exception.dart';
import 'package:feed_flix/core/network/network_info.dart';
import 'package:feed_flix/features/home/data/datasources/category_remote_data_source.dart';
import 'package:feed_flix/features/home/domain/entities/category_entity.dart';
import 'package:feed_flix/features/home/domain/respositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CategoryRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<List<CategoryEntity>> getCategories() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    try {
      final categories = await remoteDataSource.getCategories();
      return categories;
    } on ServerException {
      rethrow;
    }
  }
}
