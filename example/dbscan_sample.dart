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
