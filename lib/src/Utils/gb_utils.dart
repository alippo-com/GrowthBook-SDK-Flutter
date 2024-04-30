import 'package:growthbook_sdk_flutter/src/Utils/utils.dart';

/// Fowler-Noll-Vo hash - 32 bit
class FNV {
  final BigInt _int32 = BigInt.from(0x811c9dc5);
  final BigInt _prime32 = BigInt.from(0x01000193);
  final BigInt _mode32 = BigInt.from(2).pow(32);

  BigInt fnv1a_32(String data) {
    var hash = _int32;
    for (var b in data.split('')) {
      hash = hash ^ BigInt.from(b.codeUnitAt(0) & 0xff);
      hash = (hash * _prime32).modPow(BigInt.one, _mode32);
    }
    return hash;
  }
}

/// GrowthBook Utils Class
/// Contains Methods for
/// - hash
/// - inNameSpace
/// - getEqualWeights
/// - getBucketRanges
/// - chooseVariation
/// - getGBNameSpace
class GBUtils {
  const GBUtils();

  /// Hashes a string to a float between 0 and 1
  /// fnv32a returns an integer, so we convert that to a float using a modulus:

  static double hash(String data) {
    final hash = FNV().fnv1a_32(data);
    final remainder = hash.remainder(BigInt.from(1000));
    final value = remainder.toDouble() / 1000.0;
    return value;
  }

  /// This checks if a userId is within an experiment namespace or not.
  static bool inNamespace(String userId, GBNameSpace namespace) {
    final hashValue = hash(userId + "__" + namespace.item1);
    return hashValue >= namespace.item2 && hashValue < namespace.item3;
  }

  /// Returns an array of double with numVariations items that are all equal and
  /// sum to 1. For example, getEqualWeights(2) would return [0.5, 0.5].
  static List<double> getEqualWeights(int numVariations) {
    List<double> weights = <double>[];

    if (numVariations >= 1) {
      weights = List.filled(numVariations, 1 / numVariations);
    }

    return weights;
  }

  ///This converts and experiment's coverage and variation weights into an array
  /// of bucket ranges.
  static List<GBBucketRange> getBucketRanges(
      int numVariations, double coverage, List<double> weights) {
    List<GBBucketRange> bucketRange;

    // Clamp the value of coverage to between 0 and 1 inclusive.
    double targetCoverage = coverage.clamp(0, 1);

    // Default to equal weights if the weights don't match the number of variations.
    var targetWeights = weights;
    if (weights.length != numVariations) {
      targetWeights = getEqualWeights(numVariations);
    }
    // Default to equal weights if the sum is not equal 1 (or close enough when
    // rounding errors are factored in):
    final weightsSum = targetWeights.fold<double>(
        0, (previousValue, element) => previousValue + element);
    if (weightsSum < 0.99 || weightsSum > 1.01) {
      targetWeights = getEqualWeights(numVariations);
    }

    // Convert weights to ranges and return
    var cumulative = 0.0;
    bucketRange = targetWeights.map((weight) {
      var start = cumulative;
      cumulative += weight;
      return GBBucketRange(
        start.roundTo(4),
        (start.roundTo(4) + (targetCoverage * weight).roundTo(4)),
      );
    }).toList();
    return bucketRange;
  }

  //Choose Variation from List of ranges which matches particular number
  int chooseVariation(double n, List<GBBucketRange> ranges) {
    var counter = 0;
    for (final range in ranges) {
      if (n >= range.item1 && n < range.item2) {
        return counter;
      }
      counter++;
    }
    return -1;
  }

  ///Convert JsonArray to GBNameSpace
  static GBNameSpace? getGBNameSpace(List namespace) {
    if (namespace.length >= 3) {
      final title = namespace[0];
      final start = namespace[1];
      final end = namespace[2];

      if (start != null && end != null) {
        return GBNameSpace(title, double.parse(start.toString()),
            double.parse(end.toString()));
      }
    }

    return null;
  }

  static String paddedVersionString(String input) {
    // Remove build info and leading `v` if any
    // Split version into parts (both core version numbers and pre-release tags)
    // "v1.2.3-rc.1+build123" -> ["1","2","3","rc","1"]
    final parts = input
        .replaceAll(
          RegExp(r"(^v|\+.*$)"),
          "",
        )
        .split(RegExp(r"[-.]"));

    // If it's SemVer without a pre-release, add `~` to the end
    // ["1","0","0"] -> ["1","0","0","~"]
    // "~" is the largest ASCII character, so this will make "1.0.0" greater than "1.0.0-beta" for example
    if (parts.length == 3) {
      parts.add("~");
    }

    // Left pad each numeric part with spaces so string comparisons will work ("9">"10", but " 9"<"10")
    // Then, join back together into a single string
    final digits = RegExp(r"^[0-9]+$");
    return parts
        .map((v) => digits.hasMatch(v) ? v.padLeft(5, " ") : v)
        .join("-");
  }
}
