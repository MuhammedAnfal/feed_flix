import 'package:feed_flix/features/home/domain/entities/category_entity.dart';
import 'package:feed_flix/features/home/domain/respositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> call() async {
    return await repository.getCategories();
  }
}
