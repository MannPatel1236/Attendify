void main() {
  // 1. Inputs: Replace these numbers to test different scenarios
  int attended = 5; 
  int total = 9;
  double target = 0.75; 

  double currentPercentage = (attended / total) * 100;
  print("Current Attendance: ${currentPercentage.toStringAsFixed(2)}%");

  // 2. Scenario: You are BELOW 75%
  if (currentPercentage < 75) {
    int required = ((0.75 * total - attended) / 0.25).ceil();

    // int tempAttended = attended;
    // int tempTotal = total;
    // while ((tempAttended / tempTotal) < target) {
    //   tempAttended++;
    //   tempTotal++;
    //   required++;
    // }

    print("⚠️ Danger! You need to attend the next $required lectures consecutively.");
  } 
  
  // 3. Scenario: You are ABOVE 75%
  else {
    int canSkip = 0;
    int tempTotal = total;

    // Logic: If I add a total class but don't add an attended one, what happens?
    while ((attended / (tempTotal + 1)) >= target) {
      tempTotal++;
      canSkip++;
    }
    
    if (canSkip == 0) {
      print("✅ You are exactly on the line. Don't skip the next one!");
    } else {
      print("✅ Safe! You can skip the next $canSkip lectures.");
    }
  }
}