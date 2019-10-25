import 'dart:math';

///Simple euclidean distance measurement
double euclideanDistance(List<double> point1, List<double> point2) {
  double sum = 0;
  int loop = min(point1.length, point2.length);

  for (int i = 0; i < loop; i++) {
    sum += (point1[i] - point2[i]) * (point1[i] - point2[i]);
  }

  return sqrt(sum);
}
