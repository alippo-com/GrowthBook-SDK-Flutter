extension MapExtension on Map? {
  bool get isValidJsonElement => this == null
      ? false
      : this!.length > 1
          ? false
          : true;

  bool get isJsonArray => this == null
      ? false
      : this!.length > 2
          ? true
          : false;
}
