class UserSendDto {
  late String email;
  late String password; // Match the name with the backend
  late String first_name;
  late String last_name;
  late String factory;

  UserSendDto.fromJson(Map<String, dynamic> data) {
    try {
      email = data['email'];
      password = data['password_hash']; // Match the name with the backend
      first_name = data['first_name'];
      last_name = data['last_name'];
      factory = data['factory'];
    } catch (e) {
      print('Error parsing JSON: $data');
      print('Exception: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password_hash': password , // Match the name with the backend
      'first_name': first_name,
      'last_name': last_name,
      'factory':factory
    };
  }
}
