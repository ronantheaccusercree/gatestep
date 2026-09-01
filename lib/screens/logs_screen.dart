import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../models/run_log.dart';
import '../providers/run_logs_provider.dart';
import '../widgets/map_preview.dart';

class LogsScreen extends ConsumerWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(runLogsProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HUNT ARCHIVE',
                  style: GoogleFonts.shareTechMono(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'SYSTEM_OS // ARCHIVE_ACCESS_GRANTED',
                  style: GoogleFonts.shareTechMono(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: logs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history,
                            size: 48, color: AppColors.textSecondary.withAlpha(100)),
                        const SizedBox(height: 12),
                        Text(
                          'NO CLEARINGS YET',
                          style: GoogleFonts.shareTechMono(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Complete a run to log it here.',
                          style: GoogleFonts.shareTechMono(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildLogEntry(logs[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogEntry(RunLog log) {
    final int hours = log.elapsedSeconds ~/ 3600;
    final int minutes = (log.elapsedSeconds % 3600) ~/ 60;
    final int seconds = log.elapsedSeconds % 60;
    final String timeString =
        '${hours > 0 ? '$hours:' : ''}${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    final String dateString =
        '${log.timestamp.year}.${log.timestamp.month.toString().padLeft(2, '0')}.${log.timestamp.day.toString().padLeft(2, '0')}';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.textSecondary.withAlpha(40), width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.textSecondary.withAlpha(40), width: 1),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.public, size: 12, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  log.id,
                  style: GoogleFonts.shareTechMono(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rank Box
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.textSecondary.withAlpha(60), width: 1),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _tierFor(log.distance),
                    style: GoogleFonts.shareTechMono(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GATE CLEARED',
                        style: GoogleFonts.shareTechMono(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            dateString,
                            style: GoogleFonts.shareTechMono(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.timer_outlined, size: 12, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            timeString,
                            style: GoogleFonts.shareTechMono(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DISTANCE',
                                  style: GoogleFonts.shareTechMono(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      log.distance.toStringAsFixed(2),
                                      style: GoogleFonts.shareTechMono(
                                        color: AppColors.textPrimary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'KM',
                                      style: GoogleFonts.shareTechMono(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'XP GAIN',
                                  style: GoogleFonts.shareTechMono(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  '+${log.xpEarned}',
                                  style: GoogleFonts.shareTechMono(
                                    color: AppColors.primaryCyan,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
          if (log.routePoints.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: MapPreview(
                label: 'TRACK LOG // CLEARED ROUTE',
                height: 140,
                routePoints: log.routePoints,
              ),
            ),
          ],
        ],
      ),
    );
  }
//hi
  String _tierFor(double distance) {
    if (distance >= 10) return 'S';
    if (distance >= 7.5) return 'A';
    if (distance >= 5) return 'B';
    if (distance >= 3) return 'C';
    return 'D';
  }
}
