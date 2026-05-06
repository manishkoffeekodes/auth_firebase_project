import 'package:flutter/material.dart';
import '../models/market_model.dart';
import '../widgets/market_card.dart';
import '../utils/app_theme.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'bidding_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _pulseController;

  final List<MarketModel> _dummyMarkets = [
    MarketModel(
      id: '1',
      name: 'MILAN MORNING',
      openTime: '10:15 AM',
      closeTime: '11:15 AM',
      status: 'OPEN',
      isLive: true,
    ),
    MarketModel(
      id: '2',
      name: 'KALYAN MORNING',
      openTime: '11:00 AM',
      closeTime: '12:00 PM',
      status: 'OPEN',
    ),
    MarketModel(
      id: '3',
      name: 'SRIDEVI',
      openTime: '09:15 AM',
      closeTime: '10:15 AM',
      status: 'CLOSED',
    ),
    MarketModel(
      id: '4',
      name: 'TIME BAZAR',
      openTime: '01:00 PM',
      closeTime: '02:00 PM',
      status: 'OPEN',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleLogout() async {
    await AuthService.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stitchBackground,
      appBar: _buildCustomAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.stitchPrimaryContainer,
        foregroundColor: AppColors.stitchOnPrimaryContainer,
        child: const Icon(Icons.add, size: 28),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: AppColors.stitchSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: AppColors.stitchOutlineVariant,
          height: 1.0,
        ),
      ),
      title: Row(
        children: [
          GestureDetector(
            onTap: _handleLogout,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.stitchOutlineVariant),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuA2g_i1NmAjunMKz729z1Z4rhDMW6P2VPzC9BP2KzrOhl4OdvCy8WEWxaOt4ljccLUcDV14QyoZoapa4vzi_svjVbWjxFHu5y1--GsPViHy0rUFT-snslkYCBG0bcVOM93Z7fLNzAuE7IBRAUAr-oprkr8uCiGOnwVKQpR2h-mHmPOjjMtGmRY9bkgyPHp5EGffEKzmtuh880XpGz1soRvtpUFkd9sSWdGOHmFt9Kmk1IGFSYDa9ltaaQsVlS2PfZIfhBs2jnk-iKI',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'PRO TRADER',
            style: TextStyle(
              color: AppColors.stitchPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: const [
            Icon(Icons.account_balance_wallet, color: AppColors.stitchPrimary),
            SizedBox(width: 4),
            Text(
              '₹1,500',
              style: TextStyle(
                color: AppColors.stitchOnSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.stitchError),
          onPressed: _handleLogout,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeDashboard();
      case 1:
        return const BiddingScreen();
      case 2:
        return const HistoryScreen();
      default:
        return _buildHomeDashboard();
    }
  }

  Widget _buildHomeDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWalletActions(),
          const SizedBox(height: 32),
          _buildLiveResultsSection(),
          const SizedBox(height: 32),
          const Text(
            'Active Markets',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.stitchOnSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildMarketList(),
          const SizedBox(height: 80), // Padding for FAB and Bottom Nav
        ],
      ),
    );
  }

  Widget _buildWalletActions() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.stitchSurfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AVAILABLE BALANCE',
                style: TextStyle(
                  color: AppColors.stitchOnSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '₹1,500.00',
                style: TextStyle(
                  color: AppColors.stitchOnSurface,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_circle, size: 18),
                      label: const Text('Add Points'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.stitchPrimaryContainer,
                        foregroundColor: AppColors.stitchOnPrimaryContainer,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.payments, size: 18),
                      label: const Text('Withdraw'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.stitchPrimaryContainer,
                        side: const BorderSide(color: AppColors.stitchPrimaryContainer),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.stitchSurfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'TODAY\'S PROFIT',
                    style: TextStyle(
                      color: AppColors.stitchOnSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '+ ₹450.00',
                    style: TextStyle(
                      color: AppColors.stitchPrimaryContainer,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  Icons.trending_up,
                  size: 100,
                  color: AppColors.stitchPrimary.withOpacity(0.05),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLiveResultsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Live Results',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.stitchOnSurface,
                  ),
                ),
                const SizedBox(width: 8),
                FadeTransition(
                  opacity: _pulseController,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.stitchError,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View All',
                style: TextStyle(
                  color: AppColors.stitchOnSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              _buildLiveCard(
                title: 'MILAN NIGHT',
                result: '123-60-789',
                time: '10:30 PM',
                status: 'Live Now',
                isLive: true,
                bottomText: 'Refresh in 02:45',
              ),
              const SizedBox(width: 16),
              _buildLiveCard(
                title: 'KALYAN NIGHT',
                result: '456-12-789',
                time: '09:15 PM',
                status: 'Ended',
                isLive: false,
                bottomText: 'Final Result Declared',
              ),
              const SizedBox(width: 16),
              _buildLiveCard(
                title: 'MAIN BAZAR',
                result: '248-55-122',
                time: '08:00 PM',
                status: 'Ended',
                isLive: false,
                bottomText: 'Final Result Declared',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLiveCard({
    required String title,
    required String result,
    required String time,
    required String status,
    required bool isLive,
    required String bottomText,
  }) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLive ? AppColors.stitchSurfaceContainerHighest : AppColors.stitchSurfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stitchOutlineVariant.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isLive ? AppColors.stitchPrimaryContainer.withOpacity(0.1) : AppColors.stitchSurfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: isLive ? AppColors.stitchPrimaryContainer : AppColors.stitchOnSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  color: AppColors.stitchOnSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.stitchOnSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            result,
            style: const TextStyle(
              color: AppColors.stitchOnSurface,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.stitchOutlineVariant.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bottomText,
                  style: const TextStyle(
                    color: AppColors.stitchOnSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                Icon(
                  isLive ? Icons.autorenew : Icons.check_circle,
                  color: isLive ? AppColors.stitchPrimaryContainer : AppColors.stitchOnSurfaceVariant,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceContainer,
        border: const Border(
          top: BorderSide(color: AppColors.stitchOutlineVariant),
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Icons.home_filled, label: 'Home', isSelected: _currentIndex == 0, index: 0),
              _buildNavItem(icon: Icons.account_tree_outlined, label: 'Bids', isSelected: _currentIndex == 1, index: 1),
              _buildNavItem(icon: Icons.history, label: 'History', isSelected: _currentIndex == 2, index: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required bool isSelected, required int index}) {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.stitchPrimaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.stitchOnPrimaryContainer : AppColors.stitchOnSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.stitchOnPrimaryContainer : AppColors.stitchOnSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
