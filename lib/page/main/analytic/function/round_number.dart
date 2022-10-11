double roundNumber({required double number, required Function(double) get}) {
  double div = 10;
  while (number / div >= 10) {
    div *= 10;
  }
  int y =
      int.tryParse((number / div).toString().split('.')[0].substring(0, 1))!;
  get(div);
  return (y + 1) * div;
}
