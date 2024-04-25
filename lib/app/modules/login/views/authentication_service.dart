class AuthenticationService {
  List<String> registeredUsernames = ['user1', 'user2', 'user3']; // Example list of registered usernames

  Future<bool> login(String username, String password) async {

    return true;
  }

  Future<bool> register(String username, String email, String password) async {
    return true;
  }

  Future<bool> checkRegistration(String username) async {
    bool isRegistered = registeredUsernames.contains(username);
    return isRegistered;
  }
}
