extension JoinAndRemoveEmpty on List<String> {
  String joinAndRemoveEmpty(String separator) {
    return where((element) => element.isNotEmpty).join(separator);
  }
}
