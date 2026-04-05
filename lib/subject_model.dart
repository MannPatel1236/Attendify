class Subject {
  String name;
  int attended;
  int total;

  // The 'required' keyword ensures a subject always has a name. 
  // Attended and total start at 0 if not provided.
  Subject({required this.name, this.attended = 0, this.total = 0});

  // Calculates percentage automatically
  double get percentage => (total == 0) ? 0.0 : (attended / total) * 100;

  // Logic for the "75% Recovery" formula
  int get classesToAttend {
    if (percentage >= 75) return 0;
    return ((0.75 * total - attended) / 0.25).ceil();
  }

  // Logic for "Safe to Skip"
  int get canSkip {
    if (percentage < 75) return 0;
    int skip = 0;
    while ((attended / (total + skip + 1)) >= 0.75) {
      skip++;
    }
    return skip;
  }
}