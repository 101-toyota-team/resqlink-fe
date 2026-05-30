import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          _buildIconBox(Icons.account_balance_wallet),
          const SizedBox(width: 10),
          
          Text(
            _isBalanceVisible ? 'Rp100.000' : 'Rp ••••••••',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          
          const SizedBox(width: 6),
          
          GestureDetector(
            onTap: () {
              setState(() {
                _isBalanceVisible = !_isBalanceVisible;
              });
            },
            child: Icon(
              _isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppColors.textGrey,
              size: 16,
            ),
          ),
          
          const Spacer(),
          Container(width: 1, height: 30, color: AppColors.divider),
          const SizedBox(width: 14),
          _ActionButton(icon: Icons.add, label: 'Top-up'),
          const SizedBox(width: 14),
          _ActionButton(icon: Icons.history, label: 'Riwayat'),
          const SizedBox(width: 14),
          _ActionButton(icon: Icons.more_horiz, label: 'Lainnya'),
        ],
      ),
    );
  }

  Widget _buildIconBox(IconData icon) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ShaderMask(
        shaderCallback: (bounds) => AppColors.gradient.createShader(bounds),
        blendMode: BlendMode.srcIn,
        child: Icon(icon, size: 20, color: Colors.white),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ShaderMask(
            shaderCallback: (bounds) => AppColors.gradient.createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: Icon(icon, size: 20, color: Colors.white),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: AppColors.textGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}