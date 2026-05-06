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
      child: Opacity(
        opacity: isOpen ? 1.0 : 0.7,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.stitchSurfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.05),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.stitchSurfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.stitchOutlineVariant.withOpacity(0.2),
                        ),
                      ),
                      child: Icon(
                        isOpen ? Icons.monetization_on : Icons.lock,
                        color: isOpen ? AppColors.stitchPrimaryContainer : AppColors.stitchOnSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            market.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.stitchOnSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'Open: ${market.openTime}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.stitchOnSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Close: ${market.closeTime}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.stitchOnSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOpen ? AppColors.stitchPrimaryContainer.withOpacity(0.15) : AppColors.stitchErrorContainer.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isOpen ? AppColors.stitchPrimaryContainer.withOpacity(0.2) : AppColors.stitchErrorContainer.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      market.status.toUpperCase(),
                      style: TextStyle(
                        color: isOpen ? AppColors.stitchPrimaryContainer : AppColors.stitchError,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (isOpen)
                    const Icon(
                      Icons.play_circle_outline,
                      color: AppColors.stitchOnSurfaceVariant,
                      size: 24,
                    )
                  else
                    const Text(
                      'Bids Closed',
                      style: TextStyle(
                        color: AppColors.stitchOnSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
