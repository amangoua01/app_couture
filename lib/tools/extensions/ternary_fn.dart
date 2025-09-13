T ternaryFn<T>({
  required bool condition,
  required T ifTrue,
  required T ifFalse,
}) {
  return condition ? ifTrue : ifFalse;
}
