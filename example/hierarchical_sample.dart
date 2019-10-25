import 'package:simple_cluster/src/hierarchical.dart';

void main(){
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
}