# simple_cluster

Simple clustering library implemented in Dart.

## Getting Started
In your Dart (or Flutter) project `pubspec.yaml` add the dependency:
```yaml
dependencies:
  ...
  simple_cluster: ^0.1.0
```

## Usage
### DBSCAN
Density-based spatial clustering of applications with noise (DBSCAN) [Check Wiki](https://en.wikipedia.org/wiki/DBSCAN).

Example in dart.
```dart
import 'package:simple_cluster/src/dbscan.dart';

void main() {
  List<List<double>> dataset = [
    [1, 2], [2, 2], [2, 3], [8, 7], [8, 8], [25, 80]
  ];

  List<List<double>> dataset2 = [
    [1,1],[0,1],[1,0],
    [10,10],[10,13],[13,13],
    [54,54],[55,55],[89,89],[57,55]
  ];

  DBSCAN dbscan = DBSCAN(
    epsilon: 3,
    minPoints: 2,
  );

  List<List<int>> clusterOutput = dbscan.run(dataset);
  print("===== 1 =====");
  print("Clusters output");
  print(clusterOutput);//or dbscan.cluster
  print("Noise");
  print(dbscan.noise);
  print("Cluster label for points");
  print(dbscan.label);

  List<List<int>> clusterOutput2 = dbscan.run(dataset2);
  print("===== 2 =====");
  print("Clusters output");
  print(clusterOutput2);//or dbscan.cluster
  print("Noise");
  print(dbscan.noise);
  print("Cluster label for points");
  print(dbscan.label);
}

// Output
// ===== 1 =====
// Clusters output
// [[0, 1, 2], [3, 4]]
// Noise
// [5]
// Cluster label for points
// [0, 0, 0, 1, 1, -1]
// ===== 2 =====
// Clusters output
// [[0, 1, 2], [3, 4, 5], [6, 7, 9]]
// Noise
// [8]
// Cluster label for points
// [0, 0, 0, 1, 1, 1, 2, 2, -1, 2]
```

# Remarks
Inspired by:
- https://github.com/uhho/density-clustering