enum CacheKey {
  user,
  jwt,
  dashboard,
  entite,
  oldPrinters,
  nbUnreadNotifs,
  firstTimeLaunch(deletable: false);

  final bool deletable;

  const CacheKey({this.deletable = true});
}
