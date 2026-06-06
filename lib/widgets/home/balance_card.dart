import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_typography.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceVisible = false;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              _buildBalanceSection(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: VerticalDivider(width: 1, thickness: 1, color: AppColors.divider),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _ActionButton(icon: Icons.add_rounded, label: 'Isi Saldo'),
                    _ActionButton(icon: Icons.history_rounded, label: 'Riwayat'),
                    _ActionButton(icon: Icons.grid_view_rounded, label: 'Menu'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceSection() {
    return InkWell(
      onTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Saldo Anda',
                style: AppTypography.captionSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.textGrey,
                size: 14,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _isBalanceVisible ? 'Rp124.500' : 'Rp ••••••••',
            style: AppTypography.title.copyWith(
              color: AppColors.textDark,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ShaderMask(
                shaderCallback: (bounds) => AppColors.gradient.createShader(bounds),
                blendMode: BlendMode.srcIn,
                child: Icon(icon, size: 22, color: Colors.white),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.captionSmall.copyWith(
                fontSize: 10,
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}