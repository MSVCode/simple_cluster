import 'dart:math';

import 'package:simple_cluster/src/common.dart';

enum LINKAGE { SINGLE, COMPLETE, AVERAGE }

class Level {
  ///linkage between clusters
  double linkage;

  ///clusters in current level
  List<List<int>> cluster;

  ///In this level, cluster index 'joinFrom' are joined into 'joinTo'
  int joinFrom;

  ///In this level, cluster index 'joinFrom' are joined into 'joinTo'
  int joinTo;

  Level({this.linkage = 0, this.cluster, this.joinFrom, this.joinTo});
}

class MinLinkage {
  ///Linkage value
  double linkage;

  ///MinLinkage is between cluster index i & j
  int i;

  ///MinLinkage is between cluster index i & j
  int j;

  MinLinkage({this.i, this.j, this.linkage});
}

class Hierarchical {
  ///Complete list of points (in vector form)
  List<List<double>> dataset;

  ///Resulting level
  List<Level> _level;

  ///Index of points considered as noise
  List<int> _noise = [];

  ///Cluster label, if prefer sklearn structure of output
  List<int> _label = [];

  ///Terminate clustering process based on linkage
  final double maxLinkage;

  ///Terminate clustering process based number of cluster
  final int minCluster;

  ///Distance measurement between two points.
  ///Default is Euclidean
  double Function(List<double>, List<double>) distanceMeasure;

  ///Linkage type
  LINKAGE linkage;

  ///Linkage measurement
  double Function(List<double> distanceList) linkageMeasure;

  ///Distance matrix between input
  List<List<double>> _distanceMatrix;

  ///Current level's cluster
  List<List<int>> _cluster = [];
  Map<String, double> _cache = {};

  ///Resulting level
  List<Level> get level {
    return _level;
  }

  ///Index of points considered as noise
  List<int> get noise {
    return _noise;
  }

  ///Cluster label, if prefer sklearn structure of output
  List<int> get label {
    return _label;
  }

  ///Cluster of final level
  List<List<int>> get cluster {
    return _level[_level.length - 1].cluster;
  }

  Hierarchical({
    this.maxLinkage = double.infinity,
    this.minCluster = 1,
    this.distanceMeasure = euclideanDistance,
    this.linkage = LINKAGE.COMPLETE,
    this.linkageMeasure,
  }) {
    //if linkageMeasure is not overriden
    if (linkageMeasure == null) {
      switch (linkage) {
        case LINKAGE.AVERAGE:
          this.linkageMeasure = averageLink;
          break;
        case LINKAGE.COMPLETE:
          this.linkageMeasure = completeLink;
          break;
        case LINKAGE.SINGLE:
          this.linkageMeasure = singleLink;
          break;
      }
    }
  }

  ///Run clustering process and returns list of cluster
  List<List<int>> run(List<List<double>> dataset) {
    this.dataset = dataset;

    ///Initial configuration before running process
    buildDistanceMatrix();
    _cache = {};

    _cluster = [];
    //for every dataset, add it into their own cluster
    for (int i = 0; i < dataset.length; i++) {
      _cluster.add([i]);
    }

    //add first level
    Level currentLevel = Level(cluster: _cluster);
    _level = [currentLevel];

    while (_cluster.length > minCluster && currentLevel.linkage < maxLinkage) {
      currentLevel = mergeCluster();
    }

    //add other info
    _label = List.generate(dataset.length, (_) => -1);
    _noise = [];
    for (int i = 0; i < _cluster.length; i++) {
      for (int j = 0; j < _cluster[i].length; j++) {
        if (_cluster[i].length > 1) {
          //if a cluster contain one member, consider it as noise
          _label[_cluster[i][j]] = i;
        } else {
          _noise.add(_cluster[i][j]);
        }
      }
    }

    return _cluster;
  }

  ///Merging two clusters.
  ///
  ///This is a process done for every hierarchical clustering level.
  Level mergeCluster() {
    MinLinkage min;
    for (int i = 0; i < _cluster.length; i++) {
      for (int j = 0; j < i; j++) {
        double linkage = getLinkage(_cluster[i], _cluster[j]);

        if (min == null || linkage < min.linkage) {
          min = MinLinkage(i: i, j: j, linkage: linkage);
        }
      }
    }

    //create new cluster from old cluster (deep copy)
    List<List<int>> cluster = _cluster
        .map((oneClus) => oneClus.map((index) => index).toList())
        .toList();
    //join cluster index j into i
    cluster[min.i].addAll(cluster[min.j]);
    //and remove cluster index j
    cluster.removeAt(min.j);
    Level currentLevel = Level(
        linkage: min.linkage, cluster: cluster, joinFrom: min.j, joinTo: min.i);

    _level.add(currentLevel);
    _cluster = cluster;

    return currentLevel;
  }

  ///Calculate linkage between 2 clusters
  ///
  ///Clusters contains index of dataset
  double getLinkage(List<int> cluster1, List<int> cluster2) {
    String hash = cluster1.length > cluster2.length
        ? "$cluster1-$cluster2"
        : "$cluster2-$cluster1";

    if (_cache.containsKey(hash)) return _cache[hash];

    List<double> distanceList = [];

    for (int i = 0; i < cluster1.length; i++) {
      for (int j = 0; j < cluster2.length; j++) {
        //get dataset index from the cluster
        distanceList.add(getDistance(cluster1[i], cluster2[j]));
      }
    }

    return _cache[hash] = linkageMeasure(distanceList);
  }

  ///Get distance between 2 point in dataset
  ///
  ///i & j is the dataset's index
  double getDistance(int i, int j) {
    if (i > j) return _distanceMatrix[i][j];
    return _distanceMatrix[j][i];
  }

  ///Build distance matrix (only 1/2 filled)
  void buildDistanceMatrix() {
    List<List<double>> matrix2d = [];

    for (int i = 0; i < dataset.length; i++) {
      List<double> vector = [];
      for (int j = 0; j < i; j++) {
        vector.add(distanceMeasure(dataset[i], dataset[j]));
      }
      matrix2d.add(vector);
    }

    _distanceMatrix = matrix2d;
  }

  double singleLink(List<double> distanceList) {
    return distanceList.reduce(min);
  }

  double completeLink(List<double> distanceList) {
    return distanceList.reduce(max);
  }

  double averageLink(List<double> distanceList) {
    double sum = distanceList.reduce((a, b) => a + b);
    return sum / distanceList.length;
  }
}
