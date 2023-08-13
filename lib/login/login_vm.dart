class LoginViewModel {
  Future<bool> checkCredentials(String username, String password) async {
    // Here you can implement your logic to check if the credentials are correct
    // For demonstration purposes, let's assume correct credentials for 'user' and 'password'
    if (username == 'user' && password == 'password') {
      return true;
    }
    return false;
  }
}

