class AppValidators {
  String? emptyText({required String field, required String value}) {
    if (value == null || value.isEmpty) {
      return 'Please Enter $field';
    }
    return null;
  }
}
