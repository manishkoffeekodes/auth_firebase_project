import 'package:flutter/material.dart';
import '../models/market_model.dart';
import '../widgets/market_card.dart';
import '../utils/app_theme.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<MarketModel> _dummyMarkets = [
    MarketModel(
      id: '1',
      name: 'Kalyan Morning',
      openTime: '10:00 AM',
      closeTime: '11:00 AM',
      status: 'OPEN',
      isLive: true,
    ),
    MarketModel(
      id: '2',
      name: 'Milan Day',
      openTime: '01:00 PM',
      closeTime: '02:00 PM',
      status: 'CLOSED',
    ),
    MarketModel(
      id: '3',
      name: 'Rajdhani Night',
      openTime: '08:00 PM',
      closeTime: '10:00 PM',
      status: 'OPEN',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'MatkaTrading',
          style: TextStyle(
            color: AppColors.gold,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.gold),
            onPressed: () async {
              await AuthService.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.neonGreen,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad_rounded),
            label: 'Bidding',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.bgGradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWalletHeader(),
            const SizedBox(height: 24),
            _buildLiveResultsSlider(),
            const SizedBox(height: 24),
            const Text(
              'Live Markets',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildMarketList(),
          ],
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildWalletHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.cardDark, AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wallet Balance',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.account_balance_wallet, color: AppColors.gold, size: 24),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '₹1,500',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, color: AppColors.background, size: 18),
            label: const Text(
              'Add Points',
              style: TextStyle(
                color: AppColors.background,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveResultsSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Live Results',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _dummyMarkets.length,
            itemBuilder: (context, index) {
              final market = _dummyMarkets[index];
              return Container(
                width: 180,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      market.name,
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '345-25-123',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMarketList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _dummyMarkets.length,
      itemBuilder: (context, index) {
        return MarketCard(
          market: _dummyMarkets[index],
          onTap: () {
            // Navigate to bidding screen
          },
        );
      },
    );
  }
}
