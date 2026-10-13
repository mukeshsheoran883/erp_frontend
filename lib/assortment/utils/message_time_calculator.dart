
Duration calculateMessageDuration(String message) {
  const int baseDurationMilliseconds = 1000;
  const int extraDurationPerCharacter = 60;
  int calculatedDuration = baseDurationMilliseconds + (message.length * extraDurationPerCharacter);

  const int maxDurationMilliseconds = 6000;
  if (calculatedDuration > maxDurationMilliseconds) {
    calculatedDuration = maxDurationMilliseconds;
  }

  return Duration(milliseconds: calculatedDuration);
}
