import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class BiddingScreen extends StatefulWidget {
  const BiddingScreen({super.key});

  @override
  State<BiddingScreen> createState() => _BiddingScreenState();
}

class _BiddingScreenState extends State<BiddingScreen> {
  int _selectedTabIndex = 0;
  String _digitInput = '';
  String _pointsInput = '';
  bool _isEnteringPoints = false;

  final List<String> _tabs = ['Single', 'Jodi', 'Single Panna', 'Double Panna'];

  final List<Map<String, dynamic>> _basket = [
    {'number': '7', 'points': '500', 'type': 'SINGLE'},
    {'number': '3', 'points': '250', 'type': 'SINGLE'},
    {'number': '9', 'points': '1000', 'type': 'SINGLE'},
  ];

  void _onKeyPress(String key) {
    setState(() {
      if (_isEnteringPoints) {
        if (_pointsInput.length < 5) _pointsInput += key;
      } else {
        if (_digitInput.length < 3) _digitInput += key;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_isEnteringPoints) {
        if (_pointsInput.isNotEmpty) {
          _pointsInput = _pointsInput.substring(0, _pointsInput.length - 1);
        } else {
          _isEnteringPoints = false; // switch back to digit
        }
      } else {
        if (_digitInput.isNotEmpty) {
          _digitInput = _digitInput.substring(0, _digitInput.length - 1);
        }
      }
    });
  }

  void _switchInputFocus() {
    setState(() {
      _isEnteringPoints = !_isEnteringPoints;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _buildTabs(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildEnterBidSection(),
                    const SizedBox(height: 16),
                    _buildBidBasket(),
                    const SizedBox(height: 300), // Space for keypad
                  ],
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 72.0), // Padding above bottom nav
            child: _buildNumericKeypad(),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.stitchBackground.withOpacity(0.8),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedTabIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.stitchPrimaryContainer : AppColors.stitchSurfaceContainerHigh,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppColors.stitchOutlineVariant,
                ),
              ),
              child: Center(
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    color: isSelected ? AppColors.stitchOnPrimaryContainer : AppColors.stitchOnSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnterBidSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.stitchOutlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.stitchPrimaryContainer,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'MARKET: MILAN DAY',
                style: TextStyle(
                  color: AppColors.stitchOnSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Enter Bid',
            style: TextStyle(
              color: AppColors.stitchPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Enter digit and amount below to add to basket.',
            style: TextStyle(
              color: AppColors.stitchOnSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isEnteringPoints = false),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.stitchSurfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: !_isEnteringPoints ? AppColors.stitchPrimaryContainer : AppColors.stitchOutlineVariant,
                        width: !_isEnteringPoints ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Digit',
                          style: TextStyle(
                            color: AppColors.stitchOnSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _digitInput.isEmpty ? '_' : _digitInput,
                          style: const TextStyle(
                            color: AppColors.stitchPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isEnteringPoints = true),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.stitchSurfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isEnteringPoints ? AppColors.stitchPrimaryContainer : AppColors.stitchOutlineVariant,
                        width: _isEnteringPoints ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Points',
                          style: TextStyle(
                            color: AppColors.stitchOnSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _pointsInput.isEmpty ? '₹0' : '₹$_pointsInput',
                          style: const TextStyle(
                            color: AppColors.stitchPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBidBasket() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.stitchOutlineVariant),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.stitchSurfaceContainerHigh,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: AppColors.stitchOutlineVariant)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.shopping_basket, color: AppColors.stitchOnSurfaceVariant, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'BID BASKET',
                      style: TextStyle(
                        color: AppColors.stitchOnSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${_basket.length} Items Selected',
                  style: const TextStyle(
                    color: AppColors.stitchPrimary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _basket.length,
            separatorBuilder: (_, __) => const Divider(color: AppColors.stitchOutlineVariant, height: 1),
            itemBuilder: (context, index) {
              final item = _basket[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        item['number'],
                        style: const TextStyle(
                          color: AppColors.stitchPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        item['points'],
                        style: const TextStyle(
                          color: AppColors.stitchSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.stitchPrimaryContainer.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.stitchPrimaryContainer.withOpacity(0.2)),
                          ),
                          child: Text(
                            item['type'],
                            style: const TextStyle(
                              color: AppColors.stitchPrimaryFixed,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.delete, color: AppColors.stitchErrorContainer),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.stitchSurfaceContainerHigh,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              border: Border(top: BorderSide(color: AppColors.stitchOutlineVariant)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'TOTAL POINTS:',
                  style: TextStyle(
                    color: AppColors.stitchOnSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '₹1,750.00',
                  style: TextStyle(
                    color: AppColors.stitchPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumericKeypad() {
    return Container(
      color: AppColors.stitchSurfaceContainer,
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.stitchOutlineVariant)),
            color: AppColors.stitchBackground,
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.5,
                  children: [
                    _buildKey('1'), _buildKey('2'), _buildKey('3'),
                    _buildKey('4'), _buildKey('5'), _buildKey('6'),
                    _buildKey('7'), _buildKey('8'), _buildKey('9'),
                    _buildBackspaceKey(), _buildKey('0'), _buildSwitchKey(),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 250, // Match grid height
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.stitchPrimaryContainer,
                      foregroundColor: AppColors.stitchOnPrimaryContainer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_circle, size: 36),
                        SizedBox(height: 8),
                        Text('SUBMIT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKey(String label) {
    return ElevatedButton(
      onPressed: () => _onKeyPress(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.stitchSurfaceContainerHigh,
        foregroundColor: AppColors.stitchOnSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.stitchOutlineVariant.withOpacity(0.3)),
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBackspaceKey() {
    return ElevatedButton(
      onPressed: _onBackspace,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.stitchSurfaceContainerHigh,
        foregroundColor: AppColors.stitchErrorContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.stitchOutlineVariant.withOpacity(0.3)),
        ),
      ),
      child: const Icon(Icons.backspace),
    );
  }

  Widget _buildSwitchKey() {
    return ElevatedButton(
      onPressed: _switchInputFocus,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.stitchSurfaceContainerHigh,
        foregroundColor: AppColors.stitchPrimaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.stitchOutlineVariant.withOpacity(0.3)),
        ),
      ),
      child: const Icon(Icons.swap_horiz),
    );
  }
}
