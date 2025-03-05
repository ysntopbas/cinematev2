class ValidationHelper {
  static String? isEmailValid(String? email) {
    if (email == null || email.isEmpty) {
      return 'Bu alan boş bırakılamaz';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Geçerli bir e-posta adresi girin';
    }
    return null;
  }

  static String? isPasswordValid(String? password) {
    if (password == null || password.isEmpty) {
      return 'Bu alan boş bırakılamaz';
    }
    if (password.length < 6) {
      return 'Şifre en az 6 karakter olmalıdır';
    }
    return null;
  }
}
