import 'package:flutter/material.dart';
import '../models/market_model.dart';
import '../utils/app_theme.dart';

class MarketCard extends StatelessWidget {
  final MarketModel market;
  final VoidCallback onTap;

  const MarketCard({
    super.key,
    required this.market,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOpen = market.status.toUpperCase() == 'OPEN';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.cardBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isOpen ? AppColors.neonGreen.withOpacity(0.05) : Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Market Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    market.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'Open: ${market.openTime}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time_filled, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'Close: ${market.closeTime}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
            // Status Badge & Play Icon
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isOpen ? AppColors.neonGreen.withOpacity(0.1) : Colors.redAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isOpen ? AppColors.neonGreen : Colors.redAccent,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    market.status.toUpperCase(),
                    style: TextStyle(
                      color: isOpen ? AppColors.neonGreen : Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (isOpen)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.neonGreen.withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.neonGreen,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
