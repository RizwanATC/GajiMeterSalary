import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
  runApp(const GajiMeterApp());
}

class GajiMeterApp extends StatelessWidget {
  const GajiMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GajiMeter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10B981),
          primary: const Color(0xFF10B981),
          secondary: const Color(0xFF3B82F6),
          surface: Colors.white,
          onSurface: const Color(0xFF0F172A),
        ),
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF34D399),
          brightness: Brightness.dark,
          primary: const Color(0xFF34D399),
          secondary: const Color(0xFF60A5FA),
          surface: const Color(0xFF0F172A),
          onSurface: const Color(0xFFF8FAFC),
        ),
        fontFamily: 'Inter',
      ),
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  bool _isInitialized = false;
  bool _adFlowComplete = false;
  RewardedInterstitialAd? _rewardedInterstitialAd;

  final TextEditingController _salaryController = TextEditingController(text: "4300");
  final TextEditingController _daysController = TextEditingController(text: "20");
  final TextEditingController _hoursController = TextEditingController(text: "8");
  
  int _savedElapsedMillis = 0;
  int _sessionStartMillis = 0;
  bool _isTracking = false;
  List<WorkSession> _history = [];
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedInterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-5978067529669035/5766780268'
          : 'ca-app-pub-3940256099942544/5354046379',
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AdMob: Rewarded Interstitial Ad loaded.');
          _rewardedInterstitialAd = ad;
          
          _rewardedInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              setState(() => _adFlowComplete = true);
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              setState(() => _adFlowComplete = true);
            },
          );
          
          _showRewardedAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('AdMob: Rewarded Interstitial failed to load: $error');
          setState(() => _adFlowComplete = true);
        },
      ),
    );

    // Safety timeout: proceed after 8s if ad isn't ready
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted && !_adFlowComplete) {
        setState(() => _adFlowComplete = true);
      }
    });
  }

  void _showRewardedAd() {
    if (_rewardedInterstitialAd != null) {
      _rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          debugPrint('AdMob: User earned reward: ${reward.amount} ${reward.type}');
        },
      );
    }
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSalary = prefs.getString('salary');
    final savedDays = prefs.getString('days');
    final savedHours = prefs.getString('hours');
    final savedEarnings = prefs.getInt('savedElapsedMillis');
    final savedSessionStart = prefs.getInt('sessionStartMillis');
    final savedIsTracking = prefs.getBool('isTracking') ?? false;
    final savedHistoryJson = prefs.getString('history');
    final savedExpensesJson = prefs.getString('expenses');

    if (mounted) {
      setState(() {
        if (savedSalary != null) _salaryController.text = savedSalary;
        if (savedDays != null) _daysController.text = savedDays;
        if (savedHours != null) _hoursController.text = savedHours;
        if (savedEarnings != null) _savedElapsedMillis = savedEarnings;
        if (savedSessionStart != null) _sessionStartMillis = savedSessionStart;
        _isTracking = savedIsTracking;
        
        if (savedHistoryJson != null) {
          try {
            final List<dynamic> decoded = jsonDecode(savedHistoryJson);
            _history = decoded.map((item) => WorkSession.fromJson(item)).toList();
          } catch (_) {}
        }

        if (savedExpensesJson != null) {
          try {
            final List<dynamic> decoded = jsonDecode(savedExpensesJson);
            _expenses = decoded.map((item) => Expense.fromJson(item)).toList();
          } catch (_) {}
        }
        
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _rewardedInterstitialAd?.dispose();
    super.dispose();
  }

  Future<void> _saveGlobalData({
    int? currentElapsed,
    bool? isTracking,
    int? sessionStart,
    List<WorkSession>? history,
    List<Expense>? expenses,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('salary', _salaryController.text);
    await prefs.setString('days', _daysController.text);
    await prefs.setString('hours', _hoursController.text);
    
    if (currentElapsed != null) await prefs.setInt('savedElapsedMillis', currentElapsed);
    if (sessionStart != null) await prefs.setInt('sessionStartMillis', sessionStart);
    if (isTracking != null) await prefs.setBool('isTracking', isTracking);
    
    if (history != null) {
      await prefs.setString('history', jsonEncode(history.map((e) => e.toJson()).toList()));
      setState(() => _history = history);
    }

    if (expenses != null) {
      await prefs.setString('expenses', jsonEncode(expenses.map((e) => e.toJson()).toList()));
      setState(() => _expenses = expenses);
    }

    setState(() {
      if (currentElapsed != null) _savedElapsedMillis = currentElapsed;
      if (isTracking != null) _isTracking = isTracking;
      if (sessionStart != null) _sessionStartMillis = sessionStart;
    });
  }

  void _addToHistory(double amount, int durationMillis) {
    if (amount <= 0) return;
    final newSession = WorkSession(
      date: DateTime.now(),
      amount: amount,
      durationMillis: durationMillis,
    );
    final updatedHistory = [newSession, ..._history];
    _saveGlobalData(history: updatedHistory);
  }

  void _addExpense(Expense expense) {
    final updatedExpenses = [expense, ..._expenses];
    _saveGlobalData(expenses: updatedExpenses);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // SHOW SPLASH SCREEN AS A LOADING GUARD
    if (!_isInitialized || !_adFlowComplete) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.analytics_rounded, size: 64, color: Color(0xFF10B981)),
              ),
              const SizedBox(height: 24),
              const Text(
                "GajiMeter",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1),
              ),
              const SizedBox(height: 48),
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: Color(0xFF10B981),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Loading your workspace...",
                style: TextStyle(
                  color: Colors.grey.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final List<Widget> screens = [
      SalaryTrackerScreen(
        salaryController: _salaryController,
        daysController: _daysController,
        hoursController: _hoursController,
        initialSavedMillis: _savedElapsedMillis,
        initialSessionStart: _sessionStartMillis,
        initialIsTracking: _isTracking,
        totalExpenses: _expenses.fold(0.0, (sum, item) => sum + item.amount),
        onSave: (elapsed, isTracking, start) => _saveGlobalData(
          currentElapsed: elapsed,
          isTracking: isTracking,
          sessionStart: start,
        ),
        onSessionEnd: _addToHistory,
      ),
      ExpenseScreen(
        expenses: _expenses,
        onAdd: _addExpense,
        onClear: () => _saveGlobalData(expenses: []),
      ),
      HistoryScreen(history: _history, onClear: () => _saveGlobalData(history: [])),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: GlassBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class GlassBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const GlassBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      height: 72,
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.08 : 0.05),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavBarItem(
                    icon: Icons.analytics_rounded,
                    label: "Tracker",
                    isSelected: selectedIndex == 0,
                    onTap: () => onItemSelected(0),
                  ),
                  _NavBarItem(
                    icon: Icons.receipt_long_rounded,
                    label: "Expenses",
                    isSelected: selectedIndex == 1,
                    onTap: () => onItemSelected(1),
                  ),
                  _NavBarItem(
                    icon: Icons.history_rounded,
                    label: "History",
                    isSelected: selectedIndex == 2,
                    onTap: () => onItemSelected(2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExpenseScreen extends StatelessWidget {
  final List<Expense> expenses;
  final Function(Expense) onAdd;
  final VoidCallback onClear;

  const ExpenseScreen({super.key, required this.expenses, required this.onAdd, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final currencyFormat = NumberFormat.currency(symbol: "RM ", decimalDigits: 2);

    double totalExpenses = expenses.fold(0, (sum, item) => sum + item.amount);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: RepaintBoundary(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3B82F6).withValues(alpha: isDark ? 0.08 : 0.05),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Expenses", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.5)),
                          Text("Track your spending", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      if (expenses.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.delete_sweep_rounded),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Clear Expenses?"),
                                content: const Text("This will permanently delete all expense records."),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                  TextButton(
                                    onPressed: () {
                                      onClear();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Clear", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                
                // Total Expenses Summary Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 32),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "TOTAL SPENDING",
                            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 10, letterSpacing: 1.2),
                          ),
                          Text(
                            currencyFormat.format(totalExpenses),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: expenses.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long_rounded, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text("No expenses yet", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            final expense = expenses[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.05)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF3B82F6)),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          expense.description,
                                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                        ),
                                        Text(
                                          "${expense.category} • ${DateFormat('MMM dd').format(expense.date)}",
                                          style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    currencyFormat.format(expense.amount),
                                    style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFEF4444)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 110,
            right: 24,
            child: FloatingActionButton.extended(
              onPressed: () => _showAddExpenseDialog(context, onAdd),
              backgroundColor: const Color(0xFF3B82F6),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text("ADD EXPENSE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context, Function(Expense) onAdd) {
    final descController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = "Food";
    final categories = ["Food", "Transport", "Rent", "Utilities", "Leisure", "Other"];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "New Expense",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  labelText: "Description",
                  filled: true,
                  fillColor: Colors.grey.withValues(alpha: 0.1),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount (RM)",
                  filled: true,
                  fillColor: Colors.grey.withValues(alpha: 0.1),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Category", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: categories.map((cat) => ChoiceChip(
                  label: Text(cat),
                  selected: selectedCategory == cat,
                  onSelected: (selected) {
                    if (selected) setModalState(() => selectedCategory = cat);
                  },
                )).toList(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    final desc = descController.text;
                    final amount = double.tryParse(amountController.text) ?? 0.0;
                    if (desc.isNotEmpty && amount > 0) {
                      onAdd(Expense(
                        date: DateTime.now(),
                        category: selectedCategory,
                        description: desc,
                        amount: amount,
                      ));
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("SAVE EXPENSE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? colorScheme.primary.withValues(alpha: 0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.4),
              size: 26,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.4),
              letterSpacing: 0.5,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}

class SalaryTrackerScreen extends StatefulWidget {
  final TextEditingController salaryController;
  final TextEditingController daysController;
  final TextEditingController hoursController;
  final int initialSavedMillis;
  final int initialSessionStart;
  final bool initialIsTracking;
  final double totalExpenses;
  final Function(int, bool, int) onSave;
  final Function(double, int) onSessionEnd;

  const SalaryTrackerScreen({
    super.key,
    required this.salaryController,
    required this.daysController,
    required this.hoursController,
    required this.initialSavedMillis,
    required this.initialSessionStart,
    required this.initialIsTracking,
    required this.totalExpenses,
    required this.onSave,
    required this.onSessionEnd,
  });

  @override
  State<SalaryTrackerScreen> createState() => _SalaryTrackerScreenState();
}

class _SalaryTrackerScreenState extends State<SalaryTrackerScreen> with SingleTickerProviderStateMixin {
  late bool _isTracking;
  late int _sessionStartMillis;
  late int _savedElapsedMillis;
  
  final ValueNotifier<int> _currentMillisNotifier = ValueNotifier(DateTime.now().millisecondsSinceEpoch);
  Timer? _timer;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _savedElapsedMillis = widget.initialSavedMillis;
    _sessionStartMillis = widget.initialSessionStart;
    _isTracking = widget.initialIsTracking;
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    if (_isTracking) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _currentMillisNotifier.dispose();
    super.dispose();
  }

  int get _currentElapsed {
    if (_isTracking) {
      return _savedElapsedMillis + (_currentMillisNotifier.value - _sessionStartMillis).clamp(0, double.infinity).toInt();
    } else {
      return _savedElapsedMillis;
    }
  }

  void _triggerSave() {
    widget.onSave(_isTracking ? _savedElapsedMillis : _currentElapsed, _isTracking, _sessionStartMillis);
  }

  void _toggleTracking() {
    setState(() {
      if (_isTracking) {
        _savedElapsedMillis = _currentElapsed;
        _isTracking = false;
        _timer?.cancel();
      } else {
        _currentMillisNotifier.value = DateTime.now().millisecondsSinceEpoch;
        _sessionStartMillis = _currentMillisNotifier.value;
        _isTracking = true;
        _startTimer();
      }
    });
    _triggerSave();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _currentMillisNotifier.value = DateTime.now().millisecondsSinceEpoch;
      
      if (timer.tick % 50 == 0) {
        _triggerSave();
      }
    });
  }

  void _reset() {
    final currentAmount = _calculateEarnedAmount(_currentElapsed);
    if (currentAmount > 0) {
      widget.onSessionEnd(currentAmount, _currentElapsed);
    }
    setState(() {
      _savedElapsedMillis = 0;
      _sessionStartMillis = 0;
      _currentMillisNotifier.value = DateTime.now().millisecondsSinceEpoch;
      _isTracking = false;
      _timer?.cancel();
    });
    _triggerSave();
  }

  double _calculateEarnedAmount(int elapsed) {
    final salary = double.tryParse(widget.salaryController.text) ?? 0.0;
    final days = int.tryParse(widget.daysController.text) ?? 0;
    final hours = int.tryParse(widget.hoursController.text) ?? 0;
    
    final totalSecondsWorkedPerMonth = days * hours * 3600;
    if (totalSecondsWorkedPerMonth > 0) {
      final earningsPerSecond = salary / totalSecondsWorkedPerMonth;
      return (elapsed / 1000.0) * earningsPerSecond;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final currencyFormat = NumberFormat.currency(symbol: "RM ", decimalDigits: 2);
    final secondFormat = NumberFormat.currency(symbol: "RM ", decimalDigits: 5);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: Stack(
                children: [
                  Positioned(
                    top: -100,
                    right: -50,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(alpha: isDark ? 0.08 : 0.05),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const RepaintBoundary(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "GajiMeter",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.5,
                              ),
                            ),
                            Text(
                              "Real-time value tracker",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isTracking 
                                ? colorScheme.primary.withValues(alpha: 0.1 + (_pulseController.value * 0.1))
                                : colorScheme.onSurface.withValues(alpha: 0.05),
                            ),
                            child: Icon(
                              _isTracking ? Icons.timer : Icons.timer_off_outlined,
                              color: _isTracking ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.3),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28.0),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: colorScheme.onSurface.withValues(alpha: isDark ? 0.05 : 0.03),
                      ),
                    ),
                    child: Column(
                      children: [
                        StatusPill(
                          text: _isTracking ? "Working now" : (_currentElapsed > 0 ? "Paused" : "Ready"), 
                          color: _isTracking ? const Color(0xFF10B981) : const Color(0xFF64748B),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "EARNED THIS SESSION",
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        ValueListenableBuilder<int>(
                          valueListenable: _currentMillisNotifier,
                          builder: (context, now, _) {
                            final elapsed = _isTracking 
                              ? _savedElapsedMillis + (now - _sessionStartMillis).clamp(0, double.infinity).toInt()
                              : _savedElapsedMillis;
                            final amount = _calculateEarnedAmount(elapsed);
                            
                            return Column(
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [colorScheme.primary, colorScheme.primary.withBlue(200)],
                                  ).createShader(bounds),
                                  child: Text(
                                    currencyFormat.format(amount),
                                    style: theme.textTheme.displayMedium?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "+ ${secondFormat.format(_calculateEarnedAmount(1000))} / sec",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontFamily: 'monospace',
                                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final salary = double.tryParse(widget.salaryController.text) ?? 0.0;
                                    final days = int.tryParse(widget.daysController.text) ?? 0;
                                    final dailyTarget = days > 0 ? salary / days : 0.0;
                                    final progress = dailyTarget > 0 ? (amount / dailyTarget).clamp(0.0, 1.0) : 0.0;

                                    return Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 12,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: colorScheme.primary.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                            ),
                                            Container(
                                              height: 12,
                                              width: constraints.maxWidth * progress,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [colorScheme.primary, colorScheme.primary.withBlue(200)],
                                                ),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          "${(progress * 100).toStringAsFixed(1)}% of daily target",
                                          style: theme.textTheme.labelMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(
                        child: CompactStatCard(
                          label: "Hourly",
                          value: currencyFormat.format(_calculateHourlyRate()),
                          icon: Icons.hourglass_bottom_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CompactStatCard(
                          label: "Minute",
                          value: currencyFormat.format(_calculateHourlyRate() / 60),
                          icon: Icons.shutter_speed_rounded,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),

                  // NEW: Monthly Salary Progress Card with Expenses
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "MONTHLY OUTLOOK",
                              style: theme.textTheme.labelSmall?.copyWith(
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w800,
                                color: colorScheme.onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                            Icon(Icons.insights_rounded, size: 16, color: colorScheme.primary.withValues(alpha: 0.5)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ValueListenableBuilder<int>(
                          valueListenable: _currentMillisNotifier,
                          builder: (context, now, _) {
                            final elapsed = _isTracking 
                              ? _savedElapsedMillis + (now - _sessionStartMillis).clamp(0, double.infinity).toInt()
                              : _savedElapsedMillis;
                            final amountEarned = _calculateEarnedAmount(elapsed);
                            final totalSalary = double.tryParse(widget.salaryController.text) ?? 1.0;
                            final totalExpenses = widget.totalExpenses;

                            final expRatio = (totalExpenses / totalSalary).clamp(0.0, 1.0);
                            final earnRatio = (amountEarned / totalSalary).clamp(0.0, 1.0);

                            return Column(
                              children: [
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Stack(
                                      children: [
                                        // Background Track
                                        Container(
                                          height: 24,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: colorScheme.onSurface.withValues(alpha: 0.05),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        // Expense Zone (Red)
                                        Container(
                                          height: 24,
                                          width: constraints.maxWidth * expRatio,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.horizontal(
                                              left: const Radius.circular(12),
                                              right: expRatio >= 1.0 ? const Radius.circular(12) : Radius.zero,
                                            ),
                                          ),
                                        ),
                                        // Earnings Progress (Green)
                                        Container(
                                          height: 24,
                                          width: constraints.maxWidth * earnRatio,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [colorScheme.primary, colorScheme.primary.withBlue(200)],
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              if (earnRatio > 0)
                                                BoxShadow(
                                                  color: colorScheme.primary.withValues(alpha: 0.3),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 2),
                                                ),
                                            ],
                                          ),
                                        ),
                                        // Expense Marker
                                        if (expRatio > 0 && expRatio < 1.0)
                                          Positioned(
                                            left: constraints.maxWidth * expRatio - 1,
                                            child: Container(
                                              width: 2,
                                              height: 24,
                                              color: const Color(0xFFEF4444),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Earnings",
                                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colorScheme.primary),
                                        ),
                                        Text(
                                          currencyFormat.format(amountEarned),
                                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Expenses",
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFEF4444)),
                                        ),
                                        Text(
                                          currencyFormat.format(totalExpenses),
                                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (amountEarned >= totalExpenses && totalExpenses > 0)
                                 Container(
                                   margin: const EdgeInsets.only(top: 12),
                                   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),

                                    decoration: BoxDecoration(
                                      color: colorScheme.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.celebration_rounded, size: 14, color: colorScheme.primary),
                                        const SizedBox(width: 8),
                                        Text(
                                          "BREAK-EVEN ACHIEVED!",
                                          style: TextStyle(
                                            fontSize: 9, 
                                            fontWeight: FontWeight.w900, 
                                            color: colorScheme.primary,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  RepaintBoundary(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CONFIGURATION",
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SlickInputSection(
                          salaryController: widget.salaryController,
                          daysController: widget.daysController,
                          hoursController: widget.hoursController,
                          enabled: !_isTracking,
                          onChanged: (val) {
                            setState(() {});
                            _triggerSave();
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: _toggleTracking,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              gradient: _isTracking 
                                ? const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)])
                                : LinearGradient(colors: [colorScheme.primary, colorScheme.primary.withBlue(200)]),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: (_isTracking ? Colors.red : colorScheme.primary).withValues(alpha: 0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _isTracking ? "PAUSE SESSION" : "START WORKING",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (!_isTracking && _savedElapsedMillis > 0) ...[
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: _reset,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: colorScheme.onSurface.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
                              ),
                              child: Center(
                                child: Text(
                                  "RESET",
                                  style: TextStyle(
                                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  const AdMobBanner(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateHourlyRate() {
    final salary = double.tryParse(widget.salaryController.text) ?? 0.0;
    final days = int.tryParse(widget.daysController.text) ?? 0;
    final hours = int.tryParse(widget.hoursController.text) ?? 0;
    return (days > 0 && hours > 0) ? salary / days / hours : 0.0;
  }
}

class AdMobBanner extends StatefulWidget {
  const AdMobBanner({super.key});

  @override
  State<AdMobBanner> createState() => _AdMobBannerState();
}

class _AdMobBannerState extends State<AdMobBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  AdSize? _adSize;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-5978067529669035/6245822645'
      : 'ca-app-pub-3940256099942544/2934735716';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_adSize == null) {
      _loadAd();
    }
  }

  Future<void> _loadAd() async {
    final AdSize? size = 
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            (MediaQuery.of(context).size.width - 48).toInt());

    if (size == null) return;

    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('AdMob: Ad loaded successfully.');
          if (mounted) {
            setState(() {
              _bannerAd = ad as BannerAd;
              _isLoaded = true;
              _adSize = size;
            });
          }
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('AdMob: Ad failed to load: ${err.message}');
          debugPrint('AdMob: Error code: ${err.code}');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null || _adSize == null) {
      return const SlickAdBanner();
    }

    return Container(
      alignment: Alignment.center,
      width: _adSize!.width.toDouble(),
      height: _adSize!.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

class SlickAdBanner extends StatelessWidget {
  const SlickAdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ads_click_rounded, size: 20, color: Colors.grey),
            SizedBox(height: 4),
            Text(
              "ADVERTISEMENT",
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  final String text;
  final Color color;

  const StatusPill({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Text(
            text.toUpperCase(),
            style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

class CompactStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const CompactStatCard({super.key, required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colorScheme.primary.withValues(alpha: 0.6)),
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class SlickInputSection extends StatelessWidget {
  final TextEditingController salaryController;
  final TextEditingController daysController;
  final TextEditingController hoursController;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const SlickInputSection({
    super.key,
    required this.salaryController,
    required this.daysController,
    required this.hoursController,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        _buildField(
          controller: salaryController,
          label: "Monthly Salary",
          prefix: "RM",
          enabled: enabled,
          onChanged: onChanged,
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildField(
                controller: daysController,
                label: "Working Days",
                enabled: enabled,
                onChanged: onChanged,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildField(
                controller: hoursController,
                label: "Daily Hours",
                enabled: enabled,
                onChanged: onChanged,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? prefix,
    required bool enabled,
    required ValueChanged<String> onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          labelText: label,
          prefixText: prefix != null ? "$prefix " : null,
          labelStyle: TextStyle(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.4),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  final List<WorkSession> history;
  final VoidCallback onClear;

  const HistoryScreen({super.key, required this.history, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final currencyFormat = NumberFormat.currency(symbol: "RM ", decimalDigits: 2);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: RepaintBoundary(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(alpha: isDark ? 0.08 : 0.05),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Work History", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.5)),
                          Text("Your completed sessions", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      if (history.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.delete_sweep_rounded),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Clear History?"),
                                content: const Text("This will permanently delete all session records."),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                  TextButton(
                                    onPressed: () {
                                      onClear();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Clear", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: history.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history_rounded, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text("No history yet", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final session = history[index];
                            final duration = Duration(milliseconds: session.durationMillis);
                            final h = duration.inHours;
                            final m = duration.inMinutes.remainder(60);
                            final s = duration.inSeconds.remainder(60);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.05)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.check_circle_outline_rounded, color: colorScheme.primary),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('MMM dd, yyyy • hh:mm a').format(session.date),
                                          style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 4),
                                        Text("${h > 0 ? '${h}h ' : ''}${m}m ${s}s worked", style: const TextStyle(fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    currencyFormat.format(session.amount),
                                    style: TextStyle(fontWeight: FontWeight.w900, color: colorScheme.primary),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WorkSession {
  final DateTime date;
  final double amount;
  final int durationMillis;

  WorkSession({required this.date, required this.amount, required this.durationMillis});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'amount': amount,
        'durationMillis': durationMillis,
      };

  factory WorkSession.fromJson(Map<String, dynamic> json) => WorkSession(
        date: DateTime.parse(json['date']),
        amount: json['amount'],
        durationMillis: json['durationMillis'],
      );
}

class Expense {
  final DateTime date;
  final String category;
  final String description;
  final double amount;

  Expense({required this.date, required this.category, required this.description, required this.amount});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'category': category,
        'description': description,
        'amount': amount,
      };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        date: DateTime.parse(json['date']),
        category: json['category'],
        description: json['description'],
        amount: json['amount'],
      );
}
