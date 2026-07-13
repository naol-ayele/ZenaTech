import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

String timeAgo(DateTime date, BuildContext context) {
  final now = DateTime.now();
  final diff = now.difference(date);
  final l10n = AppLocalizations.of(context)!;
  final locale = Localizations.localeOf(context);

  if (diff.inMinutes < 1) {
    return l10n.timeJustNow;
  } else if (diff.inMinutes < 60) {
    return l10n.timeMinutesAgo(diff.inMinutes);
  } else if (diff.inHours < 24) {
    return l10n.timeHoursAgo(diff.inHours);
  } else if (diff.inDays < 7) {
    return l10n.timeDaysAgo(diff.inDays);
  } else {
    try {
      return DateFormat.yMd(locale.toString()).format(date);
    } catch (_) {
      return DateFormat.yMd().format(date);
    }
  }
}
