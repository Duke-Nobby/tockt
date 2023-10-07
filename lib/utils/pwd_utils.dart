bool isPasswordValid(String password) {
  // 正则表达式，用于匹配包含至少一个字母和一个数字的6到16位密码
  final pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,16}$';
  final regExp = RegExp(pattern);
  return regExp.hasMatch(password);
}
