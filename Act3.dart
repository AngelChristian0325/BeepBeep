class Jeepney {
  // Public Fields (Properties)
  String route;
  String plateNumber;
  int capacity;
  double baseFare;

  int _currentPassengers;
  final List<String> _activityLog = [];

  Jeepney({
    required this.route,
    required this.plateNumber,
    required this.capacity,
    this.baseFare = 13.0,
    int initialPassengers = 0,
  }) : _currentPassengers = initialPassengers;

  int get currentPassengers => _currentPassengers;

  List<String> get activityLog => List.unmodifiable(_activityLog);

  bool boardPassengers(int count, String passengerType) {
    if (_currentPassengers + count > capacity) {
      print('❌ [$plateNumber] Cannot board $count $passengerType passenger(s). Exceeds capacity! (Available: ${capacity - _currentPassengers})');
      return false;
    }

    _currentPassengers += count;
    _activityLog.add('Boarded $count ($passengerType)');
    print('✅ [$plateNumber] $count $passengerType passenger(s) boarded. Occupancy: $_currentPassengers/$capacity');
    return true;
  }

  bool dropOffPassengers(int count) {
    if (count > _currentPassengers) {
      print('❌ [$plateNumber] Cannot drop off $count passengers. Only $_currentPassengers on board.');
      return false;
    }

    _currentPassengers -= count;
    _activityLog.add('Dropped off $count');
    print('🚌 [$plateNumber] $count passenger(s) dropped off. Occupancy: $_currentPassengers/$capacity');
    return true;
  }

  double calculateTotalFare(String passengerType, int passengerCount) {
    // Map storing discount multipliers by passenger type
    final Map<String, double> discountRates = {
      'Regular': 1.0,
      'Student': 0.80, // 20% discount
      'Senior': 0.80,  // 20% discount
      'PWD': 0.80,     // 20% discount
    };

    double multiplier = discountRates[passengerType] ?? 1.0;
    return (baseFare * multiplier) * passengerCount;
  }

  void displayStatus() {
    print('========================================');
    print('Jeepney Route   : $route');
    print('Plate Number    : $plateNumber');
    print('Occupancy       : $_currentPassengers / $capacity seats filled');
    print('Base Fare Rate  : ₱${baseFare.toStringAsFixed(2)}');
    print('Activity Log    : ${activityLog.isEmpty ? "No activity" : activityLog.join(" | ")}');
    print('========================================');
  }
}

void main() {
  print('=== NATIONAL TEACHERS COLLEGE - PC16 OOP LAB (WEEK 9) ===\n');

  // 1. Instantiate two Jeepney objects using constructor
  Jeepney jeepney1 = Jeepney(
    route: 'IKOT - UP Diliman',
    plateNumber: 'NTC-001',
    capacity: 18,
    baseFare: 13.0,
  );

  Jeepney jeepney2 = Jeepney(
    route: 'Quiapo - Fairview',
    plateNumber: 'NTC-002',
    capacity: 22,
    baseFare: 15.0,
  );

  List<Jeepney> jeepneyFleet = [jeepney1, jeepney2];

  Map<String, double> dailyRevenue = {
    jeepney1.plateNumber: 0.0,
    jeepney2.plateNumber: 0.0,
  };

  //Testing Object 1
  print('--- Testing Jeepney 1 (${jeepney1.plateNumber}) ---');
  if (jeepney1.boardPassengers(5, 'Regular')) {
    dailyRevenue[jeepney1.plateNumber] = dailyRevenue[jeepney1.plateNumber]! + 
        jeepney1.calculateTotalFare('Regular', 5);
  }

  if (jeepney1.boardPassengers(4, 'Student')) {
    dailyRevenue[jeepney1.plateNumber] = dailyRevenue[jeepney1.plateNumber]! + 
        jeepney1.calculateTotalFare('Student', 4);
  }

  jeepney1.dropOffPassengers(3);
  print('Getter Verification: Private count for Jeepney 1 is currently ${jeepney1.currentPassengers}\n');

  //Testing Object 2
  print('--- Testing Jeepney 2 (${jeepney2.plateNumber}) ---');
  if (jeepney2.boardPassengers(20, 'Regular')) {
    dailyRevenue[jeepney2.plateNumber] = dailyRevenue[jeepney2.plateNumber]! + 
        jeepney2.calculateTotalFare('Regular', 20);
  }

  jeepney2.boardPassengers(5, 'Senior'); 

  print('\n=== FLEET SUMMARY & REVENUE REPORT ===');
  for (var jeep in jeepneyFleet) {
    jeep.displayStatus();
    double totalEarned = dailyRevenue[jeep.plateNumber] ?? 0.0;
    print('Total Revenue Collected: ₱${totalEarned.toStringAsFixed(2)}\n');
  }
}
