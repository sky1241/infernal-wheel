import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../utils/infernal_day.dart';
import '../models/addiction.dart';
import '../models/day_entry.dart';
import 'components/addiction_card.dart';
import 'components/sleep_card.dart';
import 'journal_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late DayEntry _today;
  DayEntry? _yesterday;

  // TODO: Charger depuis StorageService
  final List<AddictionType> _enabledAddictions = [
    AddictionType.tabac,
    AddictionType.alcoolBiere,
    AddictionType.alcoolVin,
    AddictionType.alcoolFort,
  ];

  @override
  void initState() {
    super.initState();
    _today = DayEntry(dayKey: InfernalDay.current().key);
    // TODO: Charger depuis storage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildDashboard(),
          const JournalScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildDashboard() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: Column(
                children: [
                  Text(
                    InfernalDay.current().dayName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    InfernalDay.current().formattedDate,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          // Sommeil
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: SleepCard(
                sleep: _today.sleep,
                onTap: () {
                  // TODO: Ouvrir modal saisie manuelle ou demander HealthKit
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: Spacing.md),
          ),

          // Addictions
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final type = _enabledAddictions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.sm),
                    child: AddictionCard(
                      type: type,
                      count: _today.countFor(type),
                      trend: _today.trendFor(type, _yesterday),
                      onIncrement: () {
                        setState(() {
                          _today.increment(type);
                        });
                        // TODO: Sauvegarder
                      },
                      onDecrement: () {
                        setState(() {
                          _today.decrement(type);
                        });
                        // TODO: Sauvegarder
                      },
                    ),
                  );
                },
                childCount: _enabledAddictions.length,
              ),
            ),
          ),

          // Espace en bas
          const SliverToBoxAdapter(
            child: SizedBox(height: Spacing.xxxl),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: 'Aujourd\'hui',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Config',
          ),
        ],
      ),
    );
  }
}
