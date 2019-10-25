# simple_cluster

Simple clustering library implemented in Dart.

## Getting Started
In your Dart (or Flutter) project `pubspec.yaml` add the dependency:
```yaml
dependencies:
  ...
  simple_cluster: ^0.2.0
```

## Usage
### DBSCAN
Density-based spatial clustering of applications with noise (DBSCAN) [Check Wiki](https://en.wikipedia.org/wiki/DBSCAN).

Parameter:
- `epsilon`: Minimum distance for two point to be considered as cluster
- `minPoints`: Minimum points in a single cluster
- `distanceMeasure`: Distance masure between 2 points

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

## Hierarchical
Hierarchical clustering [Check Wiki](https://en.wikipedia.org/wiki/Hierarchical_clustering).

Parameter:
- `maxLinkage`: Terminate clustering process based on linkage
- `minCluster`: Terminate clustering process based number of cluster
- `distanceMeasure`: Distance masure between 2 points
- `linkage`: Use existing linkage method
- `linkageMeasure`: Use custom linkage method

Example in dart.
```dart
  List<List<double>> colors = [
    [20, 20, 80],
    [22, 22, 90],
    [250, 255, 253],
    [100, 54, 255]
  ];

  List<List<double>> singles = [[7], [10], [20], [28], [35]];

  Hierarchical hierarchical = Hierarchical(
    minCluster: 2, //stop at 2 cluster
    linkage: LINKAGE.SINGLE
  );

  List<List<int>> clusterList = hierarchical.run(colors);

  print("===== 1 =====");
  print("Clusters output");
  print(clusterList);//or hierarchical.cluster
  print("Noise");
  print(hierarchical.noise);
  print("Cluster label for points");
  print(hierarchical.label);

  List<List<int>> clusterList2 = hierarchical.run(singles);

  print("===== 2 =====");
  print("Clusters output");
  print(clusterList2);//or hierarchical.cluster
  print("Noise");
  print(hierarchical.noise);
  print("Cluster label for points");
  print(hierarchical.label);

  // Output:
  // ===== 1 =====
  // Clusters output
  // [[2], [3, 1, 0]]
  // Noise
  // [2]
  // Cluster label for points
  // [0, 0, -1, 0]
  // ===== 2 =====
  // Clusters output
  // [[1, 0], [4, 3, 2]]
  // Noise
  // []
  // Cluster label for points
  // [0, 0, 1, 1, 1]
```
# Remarks
This library is inspired by:
- https://github.com/uhho/density-clustering
- https://github.com/math-utils/hierarchical-clustering