T ternaryFn<T>({
  required bool condition,
  required T ifTrue,
  required T ifFalse,
}) {
  return condition ? ifTrue : ifFalse;
}

T ternaryBuilder<T>({
  required bool condition,
  required T ifTrue,
  required T Function() ifFalse,
}) {
  return condition ? ifTrue : ifFalse();
}
