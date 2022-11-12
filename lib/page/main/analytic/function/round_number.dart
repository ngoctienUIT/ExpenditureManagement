import 'dart:math';

double roundNumber({required double number}) {
  String num = number.toString();
  if (int.parse(num[1]) < 5) {
    return double.parse("${num[0]}5") * pow(10, num.length - 4);
  } else {
    return (double.parse(num[0]) + 1) * pow(10, num.length - 3);
  }
}
