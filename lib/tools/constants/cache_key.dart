enum CacheKey {
  user,
  jwt,
  dashboard,
  firstTimeLaunch(deletable: false);

  final bool deletable;

  const CacheKey({this.deletable = true});
}
