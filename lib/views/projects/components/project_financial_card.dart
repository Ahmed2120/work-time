import 'package:flutter/material.dart';

/// بطاقة إحصائية مالية واحدة بتصميم ناصع وأنيق
class ProjectFinancialCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const ProjectFinancialCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x060F172A),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                fontFamily: 'Cairo',
                color: Color(0xFF0F172A),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Cairo',
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
