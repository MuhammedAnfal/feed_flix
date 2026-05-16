class AppValidators {
  String? emptyText({required String field, required String value}) {
    if (value == null || value.isEmpty) {
      return 'Please Enter $field';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter phone number';
    }
    if (value.length != 10) {
      return 'Please enter 10-digit phone number';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter numbers only';
    }
    return null;
  }
}
