enum CacheKey {
  user,
  jwt,
  dashboard,
  entite,
  firstTimeLaunch(deletable: false);

  final bool deletable;

  const CacheKey({this.deletable = true});
}
