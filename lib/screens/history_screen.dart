import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPatternMatrix(),
          const SizedBox(height: 32),
          _buildTransactionHistory(),
          const SizedBox(height: 80), // Padding for Bottom Nav
        ],
      ),
    );
  }

  Widget _buildPatternMatrix() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Pattern Matrix',
              style: TextStyle(
                color: AppColors.stitchPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.stitchSurfaceContainerHigh,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.stitchOutlineVariant),
              ),
              child: const Text(
                'MONTHLY VIEW',
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.stitchSurfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _DayHeader('M'), _DayHeader('T'), _DayHeader('W'),
                  _DayHeader('T'), _DayHeader('F'), _DayHeader('S'), _DayHeader('S'),
                ],
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 21, // Just showing 3 weeks as per design
                itemBuilder: (context, index) {
                  final isHighlighted = index == 3;
                  return Container(
                    decoration: BoxDecoration(
                      color: isHighlighted ? AppColors.stitchSurfaceContainerHighest : AppColors.stitchSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isHighlighted ? AppColors.stitchPrimaryContainer : AppColors.stitchOutlineVariant,
                      ),
                      boxShadow: isHighlighted
                          ? [BoxShadow(color: AppColors.stitchPrimaryContainer.withOpacity(0.1), blurRadius: 15)]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (index + 1).toString().padLeft(2, '0'),
                          style: TextStyle(
                            color: isHighlighted ? AppColors.stitchPrimaryContainer : AppColors.stitchOnSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          (42 + (index * 7) % 99).toString(), // Random numbers
                          style: TextStyle(
                            color: isHighlighted ? AppColors.stitchPrimaryContainer : AppColors.stitchPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transaction History',
              style: TextStyle(
                color: AppColors.stitchPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Row(
                children: const [
                  Text(
                    'VIEW ALL',
                    style: TextStyle(
                      color: AppColors.stitchPrimaryContainer,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 16, color: AppColors.stitchPrimaryContainer),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTransactionItem(
          icon: Icons.trending_up,
          title: 'Market Winning - Gali',
          date: 'Oct 21, 2023 • 11:30 PM',
          amount: '+₹4,500.00',
          status: 'SUCCESS',
          isCredit: true,
        ),
        const SizedBox(height: 8),
        _buildTransactionItem(
          icon: Icons.payments,
          title: 'Bid Placement - Disawar',
          date: 'Oct 21, 2023 • 08:15 PM',
          amount: '-₹500.00',
          status: 'SETTLED',
          isCredit: false,
        ),
        const SizedBox(height: 8),
        _buildTransactionItem(
          icon: Icons.account_balance,
          title: 'Wallet Deposit',
          date: 'Oct 20, 2023 • 02:45 PM',
          amount: '+₹1,000.00',
          status: 'COMPLETED',
          isCredit: true,
        ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required String title,
    required String date,
    required String amount,
    required String status,
    required bool isCredit,
  }) {
    final color = isCredit ? AppColors.stitchPrimaryContainer : AppColors.stitchError;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.stitchOnSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: const TextStyle(
                      color: AppColors.stitchOnSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: const TextStyle(
                  color: AppColors.stitchOnSurfaceVariant,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  final String text;
  const _DayHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.stitchOnSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
