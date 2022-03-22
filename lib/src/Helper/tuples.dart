/// ```dart
/// const t1 = const Tuple2<String, int>('a', 10);
/// final t2 = t1.withItem1('c');
/// // t2 is a new [Tuple2] object with item1 is 'c' and item2 is 10.
/// ```

/// Represents a 2-tuple, or pair.
class Tuple2<T1, T2> {
  /// Returns the first item of the tuple
  final T1 item1;

  /// Returns the second item of the tuple
  final T2 item2;

  /// Creates a new tuple value with the specified items.
  const Tuple2(this.item1, this.item2);

  /// Create a new tuple value with the specified list [items].
  factory Tuple2.fromList(List items) {
    if (items.length != 2) {
      throw ArgumentError('items must have length 2');
    }

    return Tuple2<T1, T2>(items[0] as T1, items[1] as T2);
  }

  /// Returns a tuple with the first item set to the specified value.
  Tuple2<T1, T2> withItem1(T1 v) => Tuple2<T1, T2>(v, item2);

  /// Returns a tuple with the second item set to the specified value.
  Tuple2<T1, T2> withItem2(T2 v) => Tuple2<T1, T2>(item1, v);

  /// Creates a [List] containing the items of this [Tuple2].
  ///
  /// The elements are in item order. The list is variable-length
  /// if [growable] is true.
  List toList({bool growable = false}) =>
      List.from([item1, item2], growable: growable);

  @override
  String toString() => '[$item1, $item2]';

  @override
  bool operator ==(Object other) =>
      other is Tuple2 && other.item1 == item1 && other.item2 == item2;

  @override
  int get hashCode => item1.hashCode + item2.hashCode;
}

/// Represents a 3-tuple, or triple.
class Tuple3<T1, T2, T3> {
  /// Returns the first item of the tuple
  final T1 item1;

  /// Returns the second item of the tuple
  final T2 item2;

  /// Returns the third item of the tuple
  final T3 item3;

  /// Creates a new tuple value with the specified items.
  const Tuple3(this.item1, this.item2, this.item3);

  /// Create a new tuple value with the specified list [items].
  factory Tuple3.fromList(List items) {
    if (items.length != 3) {
      throw ArgumentError('items must have length 3');
    }

    return Tuple3<T1, T2, T3>(items[0] as T1, items[1] as T2, items[2] as T3);
  }

  /// Returns a tuple with the first item set to the specified value.
  Tuple3<T1, T2, T3> withItem1(T1 v) => Tuple3<T1, T2, T3>(v, item2, item3);

  /// Returns a tuple with the second item set to the specified value.
  Tuple3<T1, T2, T3> withItem2(T2 v) => Tuple3<T1, T2, T3>(item1, v, item3);

  /// Returns a tuple with the third item set to the specified value.
  Tuple3<T1, T2, T3> withItem3(T3 v) => Tuple3<T1, T2, T3>(item1, item2, v);

  /// Creates a [List] containing the items of this [Tuple3].
  ///
  /// The elements are in item order. The list is variable-length
  /// if [growable] is true.
  List toList({bool growable = false}) =>
      List.from([item1, item2, item3], growable: growable);

  @override
  String toString() => '[$item1, $item2, $item3]';

  @override
  bool operator ==(Object other) =>
      other is Tuple3 &&
      other.item1 == item1 &&
      other.item2 == item2 &&
      other.item3 == item3;

  @override
  int get hashCode => item1.hashCode + item2.hashCode + item3.hashCode;
}
