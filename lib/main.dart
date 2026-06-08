import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' show pi;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
  runApp(const GajiMeterApp());
}

class AppThemeModel {
  final String name;
  final Color swatch;
  final ThemeData data;
  const AppThemeModel({required this.name, required this.swatch, required this.data});
}

class AppThemes {
  static final List<AppThemeModel> all = [
    AppThemeModel(
      name: 'Dark Blue', swatch: const Color(0xFF3B82F6),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E40AF), brightness: Brightness.dark, primary: const Color(0xFF3B82F6), secondary: const Color(0xFF60A5FA), surface: const Color(0xFF0F172A), onSurface: const Color(0xFFF1F5F9))),
    ),
    AppThemeModel(
      name: 'Purple', swatch: const Color(0xFF8B5CF6),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B21B6), brightness: Brightness.dark, primary: const Color(0xFF8B5CF6), secondary: const Color(0xFFA78BFA), surface: const Color(0xFF1A0F2E), onSurface: const Color(0xFFF5F3FF))),
    ),
    AppThemeModel(
      name: 'Purple Light', swatch: const Color(0xFF7C3AED),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B21B6), brightness: Brightness.light, primary: const Color(0xFF7C3AED), secondary: const Color(0xFF8B5CF6), surface: const Color(0xFFFAF5FF), onSurface: const Color(0xFF1E1B4B))),
    ),
    AppThemeModel(
      name: 'Emerald Green', swatch: const Color(0xFF10B981),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF064E3B), brightness: Brightness.dark, primary: const Color(0xFF10B981), secondary: const Color(0xFF34D399), surface: const Color(0xFF0A1F18), onSurface: const Color(0xFFF0FDF9))),
    ),
    AppThemeModel(
      name: 'Soft Pink', swatch: const Color(0xFFEC4899),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFBE185D), brightness: Brightness.light, primary: const Color(0xFFEC4899), secondary: const Color(0xFFF472B6), surface: Colors.white, onSurface: const Color(0xFF1F2937))),
    ),
    AppThemeModel(
      name: 'Purple Dark', swatch: const Color(0xFF8B5CF6),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B21B6), brightness: Brightness.dark, primary: const Color(0xFF8B5CF6), secondary: const Color(0xFFA78BFA), surface: const Color(0xFF0D0920), onSurface: const Color(0xFFF5F3FF))),
    ),
    AppThemeModel(
      name: 'Cream Beige', swatch: const Color(0xFFD97706),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB45309), brightness: Brightness.light, primary: const Color(0xFFD97706), secondary: const Color(0xFFF59E0B), surface: const Color(0xFFFFFDF7), onSurface: const Color(0xFF1C1917))),
    ),
    AppThemeModel(
      name: 'Sky Blue', swatch: const Color(0xFF0EA5E9),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0284C7), brightness: Brightness.light, primary: const Color(0xFF0EA5E9), secondary: const Color(0xFF38BDF8), surface: Colors.white, onSurface: const Color(0xFF0C4A6E))),
    ),
    AppThemeModel(
      name: 'Lavender', swatch: const Color(0xFF7C3AED),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4C1D95), brightness: Brightness.light, primary: const Color(0xFF7C3AED), secondary: const Color(0xFF8B5CF6), surface: Colors.white, onSurface: const Color(0xFF1E1B4B))),
    ),
    AppThemeModel(
      name: 'Rose Gold', swatch: const Color(0xFFB5607A),
      data: ThemeData(useMaterial3: true, fontFamily: 'Inter', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9D174D), brightness: Brightness.light, primary: const Color(0xFFB5607A), secondary: const Color(0xFFD4846E), surface: Colors.white, onSurface: const Color(0xFF1A0A0E))),
    ),
  ];
}

class AppStrings {
  static String get(String langKey, String key) {
    final map = _all[langKey] ?? _all['ms']!;
    return map[key] ?? (_all['ms']![key] ?? key);
  }

  static const _all = {
    'en': {
      'nav_tracker': 'Tracker', 'nav_expenses': 'Expenses', 'nav_history': 'History', 'nav_settings': 'Settings',
      'app_title': 'GajiMeter', 'app_subtitle': 'Real-time value tracker',
      'status_working': 'Working now', 'status_paused': 'Paused', 'status_ready': 'Ready',
      'label_earned_session': 'EARNED THIS SESSION', 'label_per_sec': '/ sec',
      'label_daily_target': '% of daily target',
      'stat_hourly': 'Hourly', 'stat_minute': 'Minute',
      'label_monthly_outlook': 'MONTHLY OUTLOOK', 'label_expenses_bar': 'EXPENSES', 'label_full_gaji': 'FULL SALARY',
      'label_earnings': 'Earnings', 'label_expenses': 'Expenses',
      'msg_breakeven': 'BREAK-EVEN ACHIEVED!',
      'label_config': 'CONFIGURATION',
      'btn_start': 'START WORKING', 'btn_pause': 'PAUSE SESSION', 'btn_reset': 'RESET',
      'expenses_title': 'Expenses', 'expenses_subtitle': 'Track your commitments',
      'label_monthly_total': 'MONTHLY TOTAL EXPENSES',
      'empty_expenses': 'No monthly expenses pinned',
      'see_more': 'See More', 'see_less': 'See Less',
      'add_expense': 'Add Expense',
      'my_expenses': 'My Expenses', 'total_monthly': 'TOTAL MONTHLY',
      'empty_no_expenses': 'No expenses yet', 'empty_hint': 'Tap Add Expense below to get started',
      'form_title_add': 'Add Expense', 'form_title_edit': 'Edit Expense',
      'label_category': 'Category', 'label_type': 'Type', 'label_detail': 'Detail',
      'field_description': 'Description', 'field_amount': 'Amount (RM)', 'field_months': 'Duration (Months)',
      'btn_save': 'Save',
      'card_budget_title': 'Monthly Budget Formula',
      'btn_change': 'Change', 'sheet_pick_formula': 'Select Formula',
      'net_salary_prefix': 'Net salary after KWSP 11%:',
      'enter_salary_hint': 'Enter salary to see breakdown',
      'bucket_komitmen': 'Commitment', 'bucket_makan': 'Food', 'bucket_spend': 'Spend', 'bucket_saving': 'Saving',
      'formula_balanced': 'Balanced', 'formula_balanced_desc': 'Most balanced & realistic',
      'formula_saving': 'Saving Mode', 'formula_saving_desc': 'Save money fast',
      'formula_commitment': 'Commitment Heavy', 'formula_commitment_desc': 'Many bills/loans',
      'formula_lifestyle': 'Lifestyle Friendly', 'formula_lifestyle_desc': 'Enjoy but still save',
      'formula_strict': 'Strict Budget', 'formula_strict_desc': 'Control spending tightly',
      'history_title': 'Monthly Expenses History', 'history_subtitle': 'Month-by-month expense breakdown',
      'empty_history': 'No history yet',
      'settings_title': 'Settings',
      'section_theme': 'Theme', 'section_language': 'Language',
      'lang_standard': 'Standard', 'lang_dialect': 'Local Dialect Mode',
      'section_data': 'Data Management', 'section_about': 'About',
      'clear_history': 'Clear History', 'clear_history_sub': 'Remove all session records',
      'clear_expenses': 'Clear Expenses', 'clear_expenses_sub': 'Remove all pinned expenses',
      'reset_all': 'Reset All Data', 'reset_all_sub': 'Clear everything and start fresh',
      'app_version': 'App Version', 'rate_app': 'Rate GajiMeter', 'rate_app_sub': 'Love the app? Leave a review',
      'privacy': 'Privacy Policy', 'privacy_sub': 'How we handle your data',
      'about_app': 'About GajiMeter', 'about_sub': 'Built for Malaysian workers',
      'btn_cancel': 'Cancel', 'btn_delete': 'Delete',
      'nav_home': 'Home', 'nav_worth': 'Worth', 'nav_money': 'Money',
      'label_earned_today': 'EARNED TODAY',
      'status_ended': 'Work Ended',
      'payday_in': 'days to payday', 'payday_today': 'Payday today!',
      'safe_spend_today': 'Safe to spend today',
      'today_target': "Today's target", 'left_this_month': 'Left this month',
      'worth_title': 'Worth It?', 'worth_subtitle': 'How long to earn this?',
      'worth_item_label': 'Item name', 'worth_price_label': 'Price (RM)',
      'worth_calculate': 'Calculate',
      'worth_need': 'Need', 'worth_want': 'Want', 'worth_later': 'Later',
      'worth_result_min': 'min of work', 'worth_result_hr': 'hrs of work',
      'worth_result_sec': 'sec of work',
      'worth_setup_hint': 'Set your salary in Settings to use this.',
      'balance_left': 'Balance left', 'daily_safe_spend': 'Safe spend / day',
      'settings_payday': 'Payday date', 'settings_payday_sub': 'Day of month you receive salary',
      'settings_work': 'Work Setup',
      'setup_payday_q': 'When do you get paid?',
      'setup_payday_hint': 'Enter the day of month (e.g. 25)',
      'motivate_every_second': 'Every second counts.',
      'motivate_building': "You're building progress.",
      'motivate_value': 'Your time has value.',
      'overview_title': 'Financial Summary',
      'overview_net_salary': 'Net Salary (est.)',
      'overview_net_note': 'After KWSP, SOCSO, EIS',
      'overview_komitmen': '− Fixed Commitments',
      'overview_komitmen_note': 'Bills, rent, fixed loans',
      'overview_makan': '− Food Budget',
      'overview_baki': 'Balance to Allocate',
      'overview_baki_note': 'Split between Spend · Saving · Buffer',
      'overview_note': 'PCB/income tax not included. Ratio follows selected formula.',
      'label_spend': 'Spend',
      'label_buffer': 'Buffer',
      'work_schedule_title': 'Work Schedule',
      'schedule_active_badge': 'ACTIVE',
      'schedule_off_badge': 'OFF HOURS',
      'schedule_auto_on': 'Auto-start & stop enabled',
      'schedule_not_set': 'Tap edit to set your work hours',
      'schedule_dialog_hint': 'Auto-start and stop your session at these times',
      'schedule_start': 'START WORK',
      'schedule_end': 'END WORK',
      'schedule_save': 'Save Schedule',
      'sisa_belanjawan': 'Budget Leftover',
      'bajet_makan': 'Food Budget',
      'bajet_makan_hari': 'Food Budget / Day',
      'sasar_harian': 'Daily target',
      'hari_berbaki': 'days left',
      'per_hari': '/ day',
      'per_bulan': '/ month',
      'tersisa': 'Surplus',
      'lebih_belanja': 'Overspent',
      'surplus_to': 'Surplus allocated to:',
      'label_budget_short': 'Budget',
      'label_used': 'Used',
      'formula_not_eligible': 'Commitment exceeded',
      'label_max': 'Max', 'per_hari_short': 'day', 'after_expenses': 'after expenses',
      'exceeds_balance_title': 'Amount Too High',
      'exceeds_balance_body': 'Food budget exceeds your available balance after expenses. Maximum allowed:',
      'btn_download_pdf': 'Download PDF',
    },
    'ms': {
      'nav_tracker': 'Penjejak', 'nav_expenses': 'Belanja', 'nav_history': 'Sejarah', 'nav_settings': 'Tetapan',
      'app_title': 'GajiMeter', 'app_subtitle': 'Penjejak nilai masa nyata',
      'status_working': 'Sedang bekerja', 'status_paused': 'Dijeda', 'status_ready': 'Bersedia',
      'label_earned_session': 'DIPEROLEH SESI INI', 'label_per_sec': '/ saat',
      'label_daily_target': '% daripada sasaran harian',
      'stat_hourly': 'Sejam', 'stat_minute': 'Seminit',
      'label_monthly_outlook': 'PANDANGAN BULANAN', 'label_expenses_bar': 'BELANJA', 'label_full_gaji': 'PENUH GAJI',
      'label_earnings': 'Pendapatan', 'label_expenses': 'Belanja',
      'msg_breakeven': 'TITIK PULANG MODAL!',
      'label_config': 'KONFIGURASI',
      'btn_start': 'MULA BEKERJA', 'btn_pause': 'JEDA SESI', 'btn_reset': 'TETAPKAN SEMULA',
      'expenses_title': 'Perbelanjaan', 'expenses_subtitle': 'Jejak komitmen anda',
      'label_monthly_total': 'JUMLAH PERBELANJAAN BULANAN',
      'empty_expenses': 'Tiada perbelanjaan bulanan disematkan',
      'see_more': 'Lihat Lagi', 'see_less': 'Lihat Kurang',
      'add_expense': 'Tambah Belanja',
      'my_expenses': 'Belanja Saya', 'total_monthly': 'JUMLAH BULANAN',
      'empty_no_expenses': 'Tiada belanja lagi', 'empty_hint': 'Tekan Tambah Belanja untuk mulakan',
      'form_title_add': 'Tambah Belanja', 'form_title_edit': 'Edit Belanja',
      'label_category': 'Kategori', 'label_type': 'Jenis', 'label_detail': 'Butiran',
      'field_description': 'Penerangan', 'field_amount': 'Jumlah (RM)', 'field_months': 'Tempoh (Bulan)',
      'btn_save': 'Simpan',
      'card_budget_title': 'Formula Budget Bulanan',
      'btn_change': 'Tukar', 'sheet_pick_formula': 'Pilih Formula',
      'net_salary_prefix': 'Gaji bersih selepas KWSP 11%:',
      'enter_salary_hint': 'Masukkan gaji untuk lihat pecahan',
      'bucket_komitmen': 'Komitmen', 'bucket_makan': 'Makan', 'bucket_spend': 'Boleh Spend', 'bucket_saving': 'Saving',
      'formula_balanced': 'Balanced', 'formula_balanced_desc': 'Paling cantik & realistic',
      'formula_saving': 'Saving Mode', 'formula_saving_desc': 'Nak cepat kumpul duit',
      'formula_commitment': 'Commitment Heavy', 'formula_commitment_desc': 'Kalau banyak bil/loan',
      'formula_lifestyle': 'Lifestyle Friendly', 'formula_lifestyle_desc': 'Nak enjoy tapi masih saving',
      'formula_strict': 'Strict Budget', 'formula_strict_desc': 'Nak control spending ketat',
      'history_title': 'Sejarah Belanja Bulanan', 'history_subtitle': 'Pecahan belanja setiap bulan',
      'empty_history': 'Tiada sejarah lagi',
      'settings_title': 'Tetapan',
      'section_theme': 'Tema', 'section_language': 'Bahasa',
      'lang_standard': 'Standard', 'lang_dialect': 'Mod Dialek Tempatan',
      'section_data': 'Pengurusan Data', 'section_about': 'Tentang',
      'clear_history': 'Padam Sejarah', 'clear_history_sub': 'Buang semua rekod sesi',
      'clear_expenses': 'Padam Belanja', 'clear_expenses_sub': 'Buang semua belanja disematkan',
      'reset_all': 'Set Semula Semua Data', 'reset_all_sub': 'Padam semua dan mulakan semula',
      'app_version': 'Versi Aplikasi', 'rate_app': 'Nilai GajiMeter', 'rate_app_sub': 'Suka aplikasi ini? Bagi ulasan',
      'privacy': 'Polisi Privasi', 'privacy_sub': 'Cara kami uruskan data anda',
      'about_app': 'Tentang GajiMeter', 'about_sub': 'Dibina untuk pekerja Malaysia',
      'btn_cancel': 'Batal', 'btn_delete': 'Padam',
      'nav_home': 'Utama', 'nav_worth': 'Nilai', 'nav_money': 'Wang',
      'label_earned_today': 'DIPEROLEH HARI INI',
      'status_ended': 'Kerja Selesai',
      'payday_in': 'hari ke gaji', 'payday_today': 'Hari gaji!',
      'safe_spend_today': 'Selamat belanja hari ini',
      'today_target': 'Sasaran hari ini', 'left_this_month': 'Baki bulan ini',
      'worth_title': 'Berbaloi?', 'worth_subtitle': 'Berapa lama nak dapatkan ini?',
      'worth_item_label': 'Nama item', 'worth_price_label': 'Harga (RM)',
      'worth_calculate': 'Kira',
      'worth_need': 'Perlu', 'worth_want': 'Mahu', 'worth_later': 'Kemudian',
      'worth_result_min': 'min bekerja', 'worth_result_hr': 'jam bekerja',
      'worth_result_sec': 'saat bekerja',
      'worth_setup_hint': 'Tetapkan gaji anda dalam Tetapan dahulu.',
      'balance_left': 'Baki tersisa', 'daily_safe_spend': 'Belanja selamat / hari',
      'settings_payday': 'Tarikh gaji', 'settings_payday_sub': 'Hari bulan anda terima gaji',
      'settings_work': 'Tetapan Kerja',
      'setup_payday_q': 'Bila anda terima gaji?',
      'setup_payday_hint': 'Masukkan hari dalam bulan (cth. 25)',
      'motivate_every_second': 'Setiap saat bermakna.',
      'motivate_building': 'Anda sedang membina kemajuan.',
      'motivate_value': 'Masa anda amat berharga.',
      'overview_title': 'Ringkasan Kewangan',
      'overview_net_salary': 'Gaji Bersih (angg.)',
      'overview_net_note': 'Selepas KWSP, SOCSO, EIS',
      'overview_komitmen': '− Komitmen Tetap',
      'overview_komitmen_note': 'Bil, sewa, loan tetap',
      'overview_makan': '− Bajet Makan',
      'overview_baki': 'Baki Untuk Agih',
      'overview_baki_note': 'Dibahagi antara Spend · Saving · Buffer',
      'overview_note': 'PCB/cukai pendapatan tidak termasuk. Nisbah mengikut formula dipilih.',
      'label_spend': 'Spend',
      'label_buffer': 'Buffer',
      'work_schedule_title': 'Jadual Kerja',
      'schedule_active_badge': 'AKTIF',
      'schedule_off_badge': 'LUAR WAKTU',
      'schedule_auto_on': 'Auto-mula & henti diaktifkan',
      'schedule_not_set': 'Tekan edit untuk tetapkan waktu kerja',
      'schedule_dialog_hint': 'Auto-mula dan henti sesi pada waktu ini',
      'schedule_start': 'MULA KERJA',
      'schedule_end': 'TAMAT KERJA',
      'schedule_save': 'Simpan Jadual',
      'sisa_belanjawan': 'Sisa Belanjawan',
      'bajet_makan': 'Bajet Makan',
      'bajet_makan_hari': 'Bajet Makan / Hari',
      'sasar_harian': 'Sasar harian',
      'hari_berbaki': 'hari berbaki',
      'per_hari': '/ hari',
      'per_bulan': '/ bulan',
      'tersisa': 'Tersisa',
      'lebih_belanja': 'Lebih belanja',
      'surplus_to': 'Sisa ini ke:',
      'label_budget_short': 'Bajet',
      'label_used': 'Guna',
      'formula_not_eligible': 'Komitmen melebihi',
      'label_max': 'Maks', 'per_hari_short': 'hari', 'after_expenses': 'selepas belanja',
      'exceeds_balance_title': 'Jumlah Terlalu Tinggi',
      'exceeds_balance_body': 'Bajet makan melebihi baki selepas belanja. Maksimum dibenarkan:',
      'btn_download_pdf': 'Muat Turun PDF',
    },
    'kelantan': {
      'nav_tracker': 'Penjejak', 'nav_expenses': 'Belanje', 'nav_history': 'Sejarah', 'nav_settings': 'Tetapang',
      'app_title': 'GajiMeter', 'app_subtitle': 'Jejak duit demo masa nyata',
      'status_working': 'Tengah kijo', 'status_paused': 'Berhenti jap', 'status_ready': 'Sedia',
      'label_earned_session': 'DUIT DAPAT SESI NI', 'label_per_sec': '/ saat',
      'label_daily_target': '% daripada sasaran hari',
      'stat_hourly': 'Sejam', 'stat_minute': 'Seminit',
      'label_monthly_outlook': 'PANDANGAN BULANG', 'label_expenses_bar': 'BELANJE', 'label_full_gaji': 'GAJI PENUH',
      'label_earnings': 'Pendapate', 'label_expenses': 'Belanje',
      'msg_breakeven': 'DAH BALIK MODAL!',
      'label_config': 'KONFIGURASI',
      'btn_start': 'MULO KIJO', 'btn_pause': 'REHAT JE', 'btn_reset': 'TETAPKE SEMULO',
      'expenses_title': 'Belanje', 'expenses_subtitle': 'Jejak komitmen demo',
      'label_monthly_total': 'JUMLAH BELANJE BULANG',
      'empty_expenses': 'Takdok belanje bulan ni',
      'see_more': 'Tengok Lagi', 'see_less': 'Kurang Sikit',
      'add_expense': 'Tamboh Belanje',
      'my_expenses': 'Belanje Demo', 'total_monthly': 'JUMLAH BULANG',
      'empty_no_expenses': 'Takdok belanje lagi', 'empty_hint': 'Tekan Tamboh Belanje untuk mulo',
      'form_title_add': 'Tamboh Belanje', 'form_title_edit': 'Edit Belanje',
      'label_category': 'Kategori', 'label_type': 'Jenis', 'label_detail': 'Butire',
      'field_description': 'Huraie', 'field_amount': 'Jumlah (RM)', 'field_months': 'Tempoh (Bulan)',
      'btn_save': 'Simpang',
      'card_budget_title': 'Formula Budget Bulang',
      'btn_change': 'Tukar', 'sheet_pick_formula': 'Pilih Formula',
      'net_salary_prefix': 'Gaji bersih lepas KWSP 11%:',
      'enter_salary_hint': 'Masuk gaji demo tengok pecahang',
      'bucket_komitmen': 'Komitmeng', 'bucket_makan': 'Makae', 'bucket_spend': 'Boleh Belanje', 'bucket_saving': 'Simpang',
      'formula_balanced': 'Seimbang', 'formula_balanced_desc': 'Paling cantik & realistic',
      'formula_saving': 'Mod Simpang', 'formula_saving_desc': 'Nok cepak kumpul duit',
      'formula_commitment': 'Banyok Komitmeng', 'formula_commitment_desc': 'Kalu banyok bil/loan',
      'formula_lifestyle': 'Suko Enjoy', 'formula_lifestyle_desc': 'Nok enjoy tapi still simpang',
      'formula_strict': 'Jimat Ketat', 'formula_strict_desc': 'Nok kontrol belanje ketat',
      'history_title': 'Sejarah Belanja Bulanan', 'history_subtitle': 'Pecahan belanje tiap bulan',
      'empty_history': 'Takdok sejarah lagi',
      'settings_title': 'Tetapang',
      'section_theme': 'Tema', 'section_language': 'Bahaso',
      'lang_standard': 'Standard', 'lang_dialect': 'Mod Dialek',
      'section_data': 'Urus Data', 'section_about': 'Pasal',
      'clear_history': 'Buang Sejarah', 'clear_history_sub': 'Buang semua rekod sesi',
      'clear_expenses': 'Buang Belanje', 'clear_expenses_sub': 'Buang semua belanje',
      'reset_all': 'Set Semulo Semua', 'reset_all_sub': 'Padam habih mulo balik',
      'app_version': 'Versi App', 'rate_app': 'Nilai GajiMeter', 'rate_app_sub': 'Suko dak? Bagi bintang sikit',
      'privacy': 'Polisi Privasi', 'privacy_sub': 'Macam mano kito jago data demo',
      'about_app': 'Pasal GajiMeter', 'about_sub': 'Dibuat untuk pekerjo Malaysia',
      'btn_cancel': 'Batal', 'btn_delete': 'Buang',
    },
    'terengganu': {
      'nav_tracker': 'Penjejak', 'nav_expenses': 'Belanje', 'nav_history': 'Sejarah', 'nav_settings': 'Tetapan',
      'app_title': 'GajiMeter', 'app_subtitle': 'Jejak duit awok masa nyata',
      'status_working': 'Tengah kerje', 'status_paused': 'Berehat jap', 'status_ready': 'Sedia',
      'label_earned_session': 'DUIT DAPAT SESI NI', 'label_per_sec': '/ saat',
      'label_daily_target': '% daripade sasaran hari',
      'stat_hourly': 'Sejam', 'stat_minute': 'Seminit',
      'label_monthly_outlook': 'PANDANGAN BULANE', 'label_expenses_bar': 'BELANJE', 'label_full_gaji': 'GAJI PENUH',
      'label_earnings': 'Pendapate', 'label_expenses': 'Belanje',
      'msg_breakeven': 'DAH BALIK MODAL!',
      'label_config': 'KONFIGURASI',
      'btn_start': 'MULO KERJE', 'btn_pause': 'JEDA SESI', 'btn_reset': 'TETAPKAN SEMULE',
      'expenses_title': 'Belanje', 'expenses_subtitle': 'Jejak komitmen awok',
      'label_monthly_total': 'JUMLAH BELANJE BULAN NI',
      'empty_expenses': 'Takde belanje bulan ni',
      'see_more': 'Tengok Lagi', 'see_less': 'Kurang Sikit',
      'add_expense': 'Tamboh Belanje',
      'my_expenses': 'Belanje Sayo', 'total_monthly': 'JUMLAH BULANE',
      'empty_no_expenses': 'Takde belanje lagi', 'empty_hint': 'Tekan Tamboh Belanje untuk mulo',
      'form_title_add': 'Tamboh Belanje', 'form_title_edit': 'Edit Belanje',
      'label_category': 'Kategori', 'label_type': 'Jenis', 'label_detail': 'Butire',
      'field_description': 'Huraie', 'field_amount': 'Jumlah (RM)', 'field_months': 'Tempoh (Bulan)',
      'btn_save': 'Simpa',
      'card_budget_title': 'Formula Budget Bulan',
      'btn_change': 'Tukar', 'sheet_pick_formula': 'Pilih Formula',
      'net_salary_prefix': 'Gaji bersih lepas KWSP 11%:',
      'enter_salary_hint': 'Masuk gaji untuk tengok pecahan',
      'bucket_komitmen': 'Komitmen', 'bucket_makan': 'Makae', 'bucket_spend': 'Boleh Belanje', 'bucket_saving': 'Simpan',
      'formula_balanced': 'Seimbang', 'formula_balanced_desc': 'Paling cantik & realistic',
      'formula_saving': 'Mod Simpan', 'formula_saving_desc': 'Nok cepat kumpul duit',
      'formula_commitment': 'Banyok Komitmen', 'formula_commitment_desc': 'Kalu banyok bil/loan',
      'formula_lifestyle': 'Suke Enjoy', 'formula_lifestyle_desc': 'Nok enjoy tapi still simpan',
      'formula_strict': 'Jimat Ketat', 'formula_strict_desc': 'Nok kontrol belanje ketat',
      'history_title': 'Sejarah Belanja Bulanan', 'history_subtitle': 'Pecahan belanje tiap bulan',
      'empty_history': 'Takde sejarah lagi',
      'settings_title': 'Tetapan',
      'section_theme': 'Tema', 'section_language': 'Bahase',
      'lang_standard': 'Standard', 'lang_dialect': 'Mod Dialek',
      'section_data': 'Urus Data', 'section_about': 'Pasal',
      'clear_history': 'Padam Sejarah', 'clear_history_sub': 'Buang semue rekod sesi',
      'clear_expenses': 'Padam Belanje', 'clear_expenses_sub': 'Buang semue belanje',
      'reset_all': 'Set Semule Semue', 'reset_all_sub': 'Padam habis mule balik',
      'app_version': 'Versi App', 'rate_app': 'Nilai GajiMeter', 'rate_app_sub': 'Suke dak? Bagi bintang sikit',
      'privacy': 'Polisi Privasi', 'privacy_sub': 'Macam mane kite jage data awok',
      'about_app': 'Pasal GajiMeter', 'about_sub': 'Dibuat untuk pekerje Malaysia',
      'btn_cancel': 'Batal', 'btn_delete': 'Padam',
    },
    'ns': {
      'nav_tracker': 'Penjejak', 'nav_expenses': 'Belanja', 'nav_history': 'Sejarah', 'nav_settings': 'Tetapan',
      'app_title': 'GajiMeter', 'app_subtitle': 'Jejak duit den masa nyata',
      'status_working': 'Tengah kojo', 'status_paused': 'Berehat jap', 'status_ready': 'Sedia',
      'label_earned_session': 'DUIT DAPAT SESI NI', 'label_per_sec': '/ saat',
      'label_daily_target': '% daripado sasaran hari',
      'stat_hourly': 'Sejam', 'stat_minute': 'Seminit',
      'label_monthly_outlook': 'PANDANGAN BULANO', 'label_expenses_bar': 'BELANJA', 'label_full_gaji': 'GAJI PENUH',
      'label_earnings': 'Pendapatan', 'label_expenses': 'Belanja',
      'msg_breakeven': 'DAH BALIK MODAL!',
      'label_config': 'KONFIGURASI',
      'btn_start': 'MULO KOJO', 'btn_pause': 'JEDA SESI', 'btn_reset': 'TETAPKAN SEMULO',
      'expenses_title': 'Belanja', 'expenses_subtitle': 'Jejak komitmen den',
      'label_monthly_total': 'JUMLAH BELANJA BULAN NI',
      'empty_expenses': 'Tak ado belanja bulan ni',
      'see_more': 'Tengok Lagi', 'see_less': 'Kurang Sikit',
      'add_expense': 'Tambah Belanja',
      'my_expenses': 'Belanja Den', 'total_monthly': 'JUMLAH BULANO',
      'empty_no_expenses': 'Tak ado belanja lagi', 'empty_hint': 'Tekan Tambah Belanja untuk mulo',
      'form_title_add': 'Tambah Belanja', 'form_title_edit': 'Edit Belanja',
      'label_category': 'Kategori', 'label_type': 'Jenis', 'label_detail': 'Butiran',
      'field_description': 'Huraian', 'field_amount': 'Jumlah (RM)', 'field_months': 'Tempoh (Bulan)',
      'btn_save': 'Simpan',
      'card_budget_title': 'Formula Budget Bulan',
      'btn_change': 'Tukar', 'sheet_pick_formula': 'Pilih Formula',
      'net_salary_prefix': 'Gaji bersih lepas KWSP 11%:',
      'enter_salary_hint': 'Masuk gaji untuk tengok pecahan',
      'bucket_komitmen': 'Komitmen', 'bucket_makan': 'Makan', 'bucket_spend': 'Boleh Belanja', 'bucket_saving': 'Simpan',
      'formula_balanced': 'Seimbang', 'formula_balanced_desc': 'Paling cantik & realistic',
      'formula_saving': 'Mod Simpan', 'formula_saving_desc': 'Nak cepat kumpul duit',
      'formula_commitment': 'Banyak Komitmen', 'formula_commitment_desc': 'Kalu banyak bil/loan',
      'formula_lifestyle': 'Suko Enjoy', 'formula_lifestyle_desc': 'Nak enjoy tapi masih simpan',
      'formula_strict': 'Jimat Ketat', 'formula_strict_desc': 'Nak kontrol belanja ketat',
      'history_title': 'Sejarah Belanja Bulanan', 'history_subtitle': 'Pecahan belanja tiap bulan',
      'empty_history': 'Tak ado sejarah lagi',
      'settings_title': 'Tetapan',
      'section_theme': 'Tema', 'section_language': 'Bahasa',
      'lang_standard': 'Standard', 'lang_dialect': 'Mod Dialek',
      'section_data': 'Urus Data', 'section_about': 'Pasal',
      'clear_history': 'Padam Sejarah', 'clear_history_sub': 'Buang semua rekod sesi',
      'clear_expenses': 'Padam Belanja', 'clear_expenses_sub': 'Buang semua belanja',
      'reset_all': 'Set Semulo Semua', 'reset_all_sub': 'Padam habis mulo balik',
      'app_version': 'Versi App', 'rate_app': 'Nilai GajiMeter', 'rate_app_sub': 'Suko tak? Bagi bintang sikit',
      'privacy': 'Polisi Privasi', 'privacy_sub': 'Macam mano kito jago data den',
      'about_app': 'Pasal GajiMeter', 'about_sub': 'Dibuat untuk pokerjo Malaysia',
      'btn_cancel': 'Batal', 'btn_delete': 'Padam',
    },
    'utara': {
      'nav_tracker': 'Penjejak', 'nav_expenses': 'Belanja', 'nav_history': 'Sejarah', 'nav_settings': 'Tetapan',
      'app_title': 'GajiMeter', 'app_subtitle': 'Jejak duit hang masa nyata',
      'status_working': 'Tengah kerja', 'status_paused': 'Berehat jap', 'status_ready': 'Sedia',
      'label_earned_session': 'DUIT DAPAT SESI NI', 'label_per_sec': '/ saat',
      'label_daily_target': '% daripada sasaran hari',
      'stat_hourly': 'Sejam', 'stat_minute': 'Seminit',
      'label_monthly_outlook': 'PANDANGAN BULANAN', 'label_expenses_bar': 'BELANJA', 'label_full_gaji': 'GAJI PENUH',
      'label_earnings': 'Pendapatan', 'label_expenses': 'Belanja',
      'msg_breakeven': 'DAH BALIK MODAL!',
      'label_config': 'KONFIGURASI',
      'btn_start': 'MULA KERJA', 'btn_pause': 'JEDA SESI', 'btn_reset': 'TETAPKAN SEMULA',
      'expenses_title': 'Belanja', 'expenses_subtitle': 'Jejak komitmen hang',
      'label_monthly_total': 'JUMLAH BELANJA BULAN NI',
      'empty_expenses': 'Dok ada belanja bulan ni',
      'see_more': 'Tengok Lagi', 'see_less': 'Kurang Sikit',
      'add_expense': 'Tambah Belanja',
      'my_expenses': 'Belanja Hang', 'total_monthly': 'JUMLAH BULANAN',
      'empty_no_expenses': 'Dok ada belanja lagi', 'empty_hint': 'Tekan Tambah Belanja untuk mula',
      'form_title_add': 'Tambah Belanja', 'form_title_edit': 'Edit Belanja',
      'label_category': 'Kategori', 'label_type': 'Jenis', 'label_detail': 'Butiran',
      'field_description': 'Huraian', 'field_amount': 'Jumlah (RM)', 'field_months': 'Tempoh (Bulan)',
      'btn_save': 'Simpan',
      'card_budget_title': 'Formula Budget Bulan',
      'btn_change': 'Tukar', 'sheet_pick_formula': 'Pilih Formula',
      'net_salary_prefix': 'Gaji bersih lepas KWSP 11%:',
      'enter_salary_hint': 'Masuk gaji untuk tengok pecahan',
      'bucket_komitmen': 'Komitmen', 'bucket_makan': 'Makan', 'bucket_spend': 'Boleh Belanja', 'bucket_saving': 'Simpan',
      'formula_balanced': 'Seimbang', 'formula_balanced_desc': 'Paling cantik & realistic',
      'formula_saving': 'Mod Simpan', 'formula_saving_desc': 'Nak cepat kumpul duit',
      'formula_commitment': 'Banyak Komitmen', 'formula_commitment_desc': 'Kalu banyak bil/loan',
      'formula_lifestyle': 'Suka Enjoy', 'formula_lifestyle_desc': 'Nak enjoy tapi still simpan',
      'formula_strict': 'Jimat Ketat', 'formula_strict_desc': 'Nak kontrol belanja ketat',
      'history_title': 'Sejarah Belanja Bulanan', 'history_subtitle': 'Pecahan belanja tiap bulan',
      'empty_history': 'Dok ada sejarah lagi',
      'settings_title': 'Tetapan',
      'section_theme': 'Tema', 'section_language': 'Bahasa',
      'lang_standard': 'Standard', 'lang_dialect': 'Mod Dialek',
      'section_data': 'Urus Data', 'section_about': 'Pasal',
      'clear_history': 'Padam Sejarah', 'clear_history_sub': 'Buang semua rekod sesi',
      'clear_expenses': 'Padam Belanja', 'clear_expenses_sub': 'Buang semua belanja',
      'reset_all': 'Set Semula Semua', 'reset_all_sub': 'Padam habis mula balik',
      'app_version': 'Versi App', 'rate_app': 'Nilai GajiMeter', 'rate_app_sub': 'Suka dok? Bagi bintang sikit',
      'privacy': 'Polisi Privasi', 'privacy_sub': 'Macam mana kita jaga data hang',
      'about_app': 'Pasal GajiMeter', 'about_sub': 'Dibuat untuk pekerja Malaysia',
      'btn_cancel': 'Batal', 'btn_delete': 'Padam',
    },
    'sarawak': {
      'nav_tracker': 'Penjejak', 'nav_expenses': 'Belanja', 'nav_history': 'Sejarah', 'nav_settings': 'Tetapan',
      'app_title': 'GajiMeter', 'app_subtitle': 'Jejak duit kitak masa nyata',
      'status_working': 'Tengah kerja', 'status_paused': 'Berehat jap', 'status_ready': 'Sedia',
      'label_earned_session': 'DUIT DAPAT SESI TOK', 'label_per_sec': '/ saat',
      'label_daily_target': '% daripada sasaran hari',
      'stat_hourly': 'Sejam', 'stat_minute': 'Seminit',
      'label_monthly_outlook': 'PANDANGAN BULAN TOK', 'label_expenses_bar': 'BELANJA', 'label_full_gaji': 'GAJI PENUH',
      'label_earnings': 'Pendapatan', 'label_expenses': 'Belanja',
      'msg_breakeven': 'DAH BALIK MODAL!',
      'label_config': 'KONFIGURASI',
      'btn_start': 'MULA KERJA', 'btn_pause': 'JEDA SESI', 'btn_reset': 'TETAPKAN SEMULA',
      'expenses_title': 'Belanja', 'expenses_subtitle': 'Jejak komitmen kitak',
      'label_monthly_total': 'JUMLAH BELANJA BULAN TOK',
      'empty_expenses': 'Sik ada belanja bulan tok',
      'see_more': 'Nangga Lagi', 'see_less': 'Kurang Sikit',
      'add_expense': 'Tambah Belanja',
      'my_expenses': 'Belanja Kitak', 'total_monthly': 'JUMLAH BULAN TOK',
      'empty_no_expenses': 'Sik ada belanja lagi', 'empty_hint': 'Tekan Tambah Belanja untuk mula',
      'form_title_add': 'Tambah Belanja', 'form_title_edit': 'Edit Belanja',
      'label_category': 'Kategori', 'label_type': 'Jenis', 'label_detail': 'Butiran',
      'field_description': 'Huraian', 'field_amount': 'Jumlah (RM)', 'field_months': 'Tempoh (Bulan)',
      'btn_save': 'Simpan',
      'card_budget_title': 'Formula Budget Bulan',
      'btn_change': 'Tukar', 'sheet_pick_formula': 'Pilih Formula',
      'net_salary_prefix': 'Gaji bersih lepas KWSP 11%:',
      'enter_salary_hint': 'Masuk gaji untuk nangga pecahan',
      'bucket_komitmen': 'Komitmen', 'bucket_makan': 'Makan', 'bucket_spend': 'Boleh Belanja', 'bucket_saving': 'Simpan',
      'formula_balanced': 'Seimbang', 'formula_balanced_desc': 'Paling cantik & realistic',
      'formula_saving': 'Mod Simpan', 'formula_saving_desc': 'Nak cepat kumpul duit',
      'formula_commitment': 'Banyak Komitmen', 'formula_commitment_desc': 'Kalu banyak bil/loan',
      'formula_lifestyle': 'Suka Enjoy', 'formula_lifestyle_desc': 'Nak enjoy tapi still simpan',
      'formula_strict': 'Jimat Ketat', 'formula_strict_desc': 'Nak kontrol belanja ketat',
      'history_title': 'Sejarah Belanja Bulanan', 'history_subtitle': 'Pecahan belanja tiap bulan',
      'empty_history': 'Sik ada sejarah lagi',
      'settings_title': 'Tetapan',
      'section_theme': 'Tema', 'section_language': 'Bahasa',
      'lang_standard': 'Standard', 'lang_dialect': 'Mod Dialek',
      'section_data': 'Urus Data', 'section_about': 'Pasal',
      'clear_history': 'Padamka Sejarah', 'clear_history_sub': 'Buang semua rekod sesi',
      'clear_expenses': 'Padamka Belanja', 'clear_expenses_sub': 'Buang semua belanja',
      'reset_all': 'Set Semula Semua', 'reset_all_sub': 'Padam habis mula balit',
      'app_version': 'Versi App', 'rate_app': 'Nilai GajiMeter', 'rate_app_sub': 'Suka sik? Bagi bintang sikit',
      'privacy': 'Polisi Privasi', 'privacy_sub': 'Macam mana kitai jaga data kitak',
      'about_app': 'Pasal GajiMeter', 'about_sub': 'Dibuat untuk pekerja Malaysia',
      'btn_cancel': 'Batal', 'btn_delete': 'Padamka',
    },
    'sabah': {
      'nav_tracker': 'Penjejak', 'nav_expenses': 'Belanja', 'nav_history': 'Sejarah', 'nav_settings': 'Tetapan',
      'app_title': 'GajiMeter', 'app_subtitle': 'Jejak duit ko masa nyata',
      'status_working': 'Tengah kerja bah', 'status_paused': 'Berehat jap', 'status_ready': 'Sedia bah',
      'label_earned_session': 'DUIT DAPAT SESI NI', 'label_per_sec': '/ saat',
      'label_daily_target': '% daripada sasaran hari',
      'stat_hourly': 'Sejam', 'stat_minute': 'Seminit',
      'label_monthly_outlook': 'PANDANGAN BULANAN', 'label_expenses_bar': 'BELANJA', 'label_full_gaji': 'GAJI PENUH',
      'label_earnings': 'Pendapatan', 'label_expenses': 'Belanja',
      'msg_breakeven': 'DAH BALIK MODAL BAH!',
      'label_config': 'KONFIGURASI',
      'btn_start': 'MULA KERJA BAH', 'btn_pause': 'JEDA SESI', 'btn_reset': 'TETAPKAN SEMULA',
      'expenses_title': 'Belanja', 'expenses_subtitle': 'Jejak komitmen ko',
      'label_monthly_total': 'JUMLAH BELANJA BULAN NI',
      'empty_expenses': 'Nda ada belanja bulan ni',
      'see_more': 'Tengok Lagi', 'see_less': 'Kurang Sikit',
      'add_expense': 'Tambah Belanja',
      'my_expenses': 'Belanja Ko', 'total_monthly': 'JUMLAH BULANAN',
      'empty_no_expenses': 'Nda ada belanja lagi', 'empty_hint': 'Tekan Tambah Belanja untuk mula bah',
      'form_title_add': 'Tambah Belanja', 'form_title_edit': 'Edit Belanja',
      'label_category': 'Kategori', 'label_type': 'Jenis', 'label_detail': 'Butiran',
      'field_description': 'Huraian', 'field_amount': 'Jumlah (RM)', 'field_months': 'Tempoh (Bulan)',
      'btn_save': 'Simpan',
      'card_budget_title': 'Formula Budget Bulan',
      'btn_change': 'Tukar', 'sheet_pick_formula': 'Pilih Formula',
      'net_salary_prefix': 'Gaji bersih lepas KWSP 11%:',
      'enter_salary_hint': 'Masuk gaji untuk tengok pecahan',
      'bucket_komitmen': 'Komitmen', 'bucket_makan': 'Makan', 'bucket_spend': 'Boleh Belanja', 'bucket_saving': 'Simpan',
      'formula_balanced': 'Seimbang', 'formula_balanced_desc': 'Paling cantik & realistic',
      'formula_saving': 'Mod Simpan', 'formula_saving_desc': 'Nak cepat kumpul duit',
      'formula_commitment': 'Banyak Komitmen', 'formula_commitment_desc': 'Kalu banyak bil/loan',
      'formula_lifestyle': 'Suka Enjoy', 'formula_lifestyle_desc': 'Nak enjoy tapi still simpan',
      'formula_strict': 'Jimat Ketat', 'formula_strict_desc': 'Nak kontrol belanja ketat',
      'history_title': 'Sejarah Belanja Bulanan', 'history_subtitle': 'Pecahan belanja tiap bulan',
      'empty_history': 'Nda ada sejarah lagi',
      'settings_title': 'Tetapan',
      'section_theme': 'Tema', 'section_language': 'Bahasa',
      'lang_standard': 'Standard', 'lang_dialect': 'Mod Dialek',
      'section_data': 'Urus Data', 'section_about': 'Pasal',
      'clear_history': 'Padam Sejarah', 'clear_history_sub': 'Buang semua rekod sesi',
      'clear_expenses': 'Padam Belanja', 'clear_expenses_sub': 'Buang semua belanja',
      'reset_all': 'Set Semula Semua', 'reset_all_sub': 'Padam habis mula balik',
      'app_version': 'Versi App', 'rate_app': 'Nilai GajiMeter', 'rate_app_sub': 'Suka bah? Bagi bintang sikit',
      'privacy': 'Polisi Privasi', 'privacy_sub': 'Macam mana kami jaga data ko',
      'about_app': 'Pasal GajiMeter', 'about_sub': 'Dibuat untuk pekerja Malaysia',
      'btn_cancel': 'Batal', 'btn_delete': 'Padam',
    },
  };
}

class AppLang extends InheritedWidget {
  final String langKey;
  final Function(String) onChanged;

  const AppLang({super.key, required this.langKey, required this.onChanged, required super.child});

  static AppLang of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppLang>()!;

  String t(String key) => AppStrings.get(langKey, key);

  @override
  bool updateShouldNotify(AppLang old) => langKey != old.langKey;
}

class GajiMeterApp extends StatefulWidget {
  const GajiMeterApp({super.key});

  @override
  State<GajiMeterApp> createState() => _GajiMeterAppState();
}

class _GajiMeterAppState extends State<GajiMeterApp> {
  int _themeIndex = 5; // default: Dark
  String _langKey = 'ms';

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadLang();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt('themeIndex') ?? 5;
    // If saved value is not one of the allowed themes (5=Dark, 2=Light), default to Dark
    final allowed = [2, 5];
    setState(() => _themeIndex = allowed.contains(saved) ? saved : 5);
  }

  void _setTheme(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeIndex', index);
    setState(() => _themeIndex = index);
  }

  Future<void> _loadLang() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('langKey') ?? 'ms';
    setState(() => _langKey = saved);
  }

  void _setLang(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('langKey', key);
    setState(() => _langKey = key);
  }

  @override
  Widget build(BuildContext context) {
    return AppLang(
      langKey: _langKey,
      onChanged: _setLang,
      child: MaterialApp(
        title: 'GajiMeter',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: AppThemes.all[_themeIndex].data,
        home: MainScaffold(onThemeChanged: _setTheme, themeIndex: _themeIndex),
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  final Function(int) onThemeChanged;
  final int themeIndex;

  const MainScaffold({super.key, required this.onThemeChanged, required this.themeIndex});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  bool _isInitialized = false;
  bool _isSetupComplete = false;
  bool _adFlowComplete = false;
  RewardedInterstitialAd? _rewardedInterstitialAd;

  final TextEditingController _salaryController = TextEditingController(text: "");
  final TextEditingController _daysController = TextEditingController(text: "20");
  final TextEditingController _hoursController = TextEditingController(text: "8");
  
  int _savedElapsedMillis = 0;
  int _sessionStartMillis = 0;
  bool _isTracking = false;
  List<WorkSession> _history = [];
  List<Expense> _expenses = [];
  int _paydayDay = 25;
  int _formulaIndex = 0;
  double _customFoodDaily = 50.0;
  int _workStartHour = 8;
  int _workStartMinute = 0;
  int _workEndHour = 18;
  int _workEndMinute = 0;
  bool _workScheduleSet = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedInterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-5978067529669035/5766780268'
          : 'ca-app-pub-3940256099942544/5354046379',
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AdMob: Rewarded Interstitial Ad loaded.');
          _rewardedInterstitialAd = ad;
          
          _rewardedInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              setState(() => _adFlowComplete = true);
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              setState(() => _adFlowComplete = true);
            },
          );
          
          _showRewardedAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('AdMob: Rewarded Interstitial failed to load: $error');
          setState(() => _adFlowComplete = true);
        },
      ),
    );

    // Safety timeout: proceed after 8s if ad isn't ready
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted && !_adFlowComplete) {
        setState(() => _adFlowComplete = true);
      }
    });
  }

  void _showRewardedAd() {
    if (_rewardedInterstitialAd != null) {
      _rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          debugPrint('AdMob: User earned reward: ${reward.amount} ${reward.type}');
        },
      );
    }
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSalary = prefs.getString('salary');
    final savedDays = prefs.getString('days');
    final savedHours = prefs.getString('hours');
    final savedEarnings = prefs.getInt('savedElapsedMillis');
    final savedSessionStart = prefs.getInt('sessionStartMillis');
    final savedIsTracking = prefs.getBool('isTracking') ?? false;
    final savedHistoryJson = prefs.getString('history');
    final savedExpensesJson = prefs.getString('expenses');
    final savedSetupComplete = prefs.getBool('isSetupComplete') ?? false;
    final savedPaydayDay = prefs.getInt('paydayDay');
    final savedFormulaIndex = prefs.getInt('formulaIndex');
    final savedCustomFoodDaily = prefs.getDouble('customFoodDaily');
    final savedWorkStartHour = prefs.getInt('workStartHour');
    final savedWorkStartMinute = prefs.getInt('workStartMinute');
    final savedWorkEndHour = prefs.getInt('workEndHour');
    final savedWorkEndMinute = prefs.getInt('workEndMinute');
    final savedWorkScheduleSet = prefs.getBool('workScheduleSet') ?? false;

    if (mounted) {
      setState(() {
        if (savedSalary != null) _salaryController.text = savedSalary;
        if (savedDays != null) _daysController.text = savedDays;
        if (savedHours != null) _hoursController.text = savedHours;
        if (savedEarnings != null) _savedElapsedMillis = savedEarnings;
        if (savedSessionStart != null) _sessionStartMillis = savedSessionStart;
        _isTracking = savedIsTracking;
        _isSetupComplete = savedSetupComplete;
        if (savedPaydayDay != null) _paydayDay = savedPaydayDay.clamp(1, 31);
        if (savedFormulaIndex != null) _formulaIndex = savedFormulaIndex.clamp(0, 4);
        if (savedCustomFoodDaily != null) _customFoodDaily = savedCustomFoodDaily;
        if (savedWorkStartHour != null) _workStartHour = savedWorkStartHour.clamp(0, 23);
        if (savedWorkStartMinute != null) _workStartMinute = savedWorkStartMinute.clamp(0, 59);
        if (savedWorkEndHour != null) _workEndHour = savedWorkEndHour.clamp(0, 23);
        if (savedWorkEndMinute != null) _workEndMinute = savedWorkEndMinute.clamp(0, 59);
        _workScheduleSet = savedWorkScheduleSet;

        if (savedHistoryJson != null) {
          try {
            final List<dynamic> decoded = jsonDecode(savedHistoryJson);
            _history = decoded.map((item) => WorkSession.fromJson(item)).toList();
          } catch (_) {}
        }

        if (_history.isEmpty) {
          final now = DateTime.now();
          _history = [
            WorkSession(date: DateTime(now.year, now.month, now.day - 1, 9, 0), amount: 187.50, durationMillis: 3 * 3600000),
            WorkSession(date: DateTime(now.year, now.month, now.day - 3, 8, 30), amount: 125.00, durationMillis: 2 * 3600000),
            WorkSession(date: DateTime(now.year, now.month, now.day - 5, 10, 15), amount: 250.00, durationMillis: 4 * 3600000),
            WorkSession(date: DateTime(now.year, now.month - 1, 28, 9, 0), amount: 312.50, durationMillis: 5 * 3600000),
            WorkSession(date: DateTime(now.year, now.month - 1, 20, 8, 0), amount: 187.50, durationMillis: 3 * 3600000),
            WorkSession(date: DateTime(now.year, now.month - 1, 15, 13, 0), amount: 62.50, durationMillis: 1 * 3600000),
            WorkSession(date: DateTime(now.year, now.month - 1, 10, 9, 30), amount: 125.00, durationMillis: 2 * 3600000),
            WorkSession(date: DateTime(now.year, now.month - 2, 25, 8, 0), amount: 375.00, durationMillis: 6 * 3600000),
            WorkSession(date: DateTime(now.year, now.month - 2, 18, 9, 0), amount: 250.00, durationMillis: 4 * 3600000),
            WorkSession(date: DateTime(now.year, now.month - 2, 5, 10, 0), amount: 93.75, durationMillis: (1.5 * 3600000).toInt()),
          ];
        }

        if (savedExpensesJson != null) {
          try {
            final List<dynamic> decoded = jsonDecode(savedExpensesJson);
            _expenses = decoded.map((item) => Expense.fromJson(item)).toList();
          } catch (_) {}
        }

        if (_expenses.isEmpty) {
          final year = DateTime.now().year;
          _expenses = [
            // Ongoing from January — appear every month Jan–now
            Expense(id: 'd1', date: DateTime(year, 1, 1), category: 'Rent',       description: 'Monthly Rent',        amount: 1200.0),
            Expense(id: 'd2', date: DateTime(year, 1, 1), category: 'Transport',   description: 'Car Loan',            amount: 650.0),
            Expense(id: 'd3', date: DateTime(year, 1, 1), category: 'Utilities',   description: 'Electric & Water',    amount: 150.0),
            Expense(id: 'd4', date: DateTime(year, 1, 1), category: 'Bills',       description: 'Phone Plan',          amount: 80.0),
            Expense(id: 'd5', date: DateTime(year, 1, 1), category: 'Bills',       description: 'Netflix & Streaming', amount: 55.0),
            // Added in March — appear Mar–now
            Expense(id: 'd6', date: DateTime(year, 3, 1), category: 'Health',      description: 'Gym Membership',      amount: 100.0),
            Expense(id: 'd7', date: DateTime(year, 3, 1), category: 'Groceries',   description: 'Weekly Groceries',    amount: 400.0),
            // One-time in April (3 months)
            Expense(id: 'd8', date: DateTime(year, 4, 1), category: 'Shopping',    description: 'Laptop Installment',  amount: 350.0, months: 3),
            // Added in May — appear May–now
            Expense(id: 'd9', date: DateTime(year, 5, 1), category: 'Leisure',     description: 'Spotify Premium',     amount: 20.0),
            // This month only
            Expense(id: 'd10', date: DateTime(year, DateTime.now().month, 1), category: 'Shopping', description: 'New Shoes', amount: 250.0, months: 1),
          ];
        }
        
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _rewardedInterstitialAd?.dispose();
    super.dispose();
  }

  Future<void> _saveGlobalData({
    int? currentElapsed,
    bool? isTracking,
    int? sessionStart,
    List<WorkSession>? history,
    List<Expense>? expenses,
    bool? isSetupComplete,
    int? paydayDay,
    int? formulaIndex,
    double? customFoodDaily,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('salary', _salaryController.text);
    await prefs.setString('days', _daysController.text);
    await prefs.setString('hours', _hoursController.text);

    if (currentElapsed != null) await prefs.setInt('savedElapsedMillis', currentElapsed);
    if (sessionStart != null) await prefs.setInt('sessionStartMillis', sessionStart);
    if (isTracking != null) await prefs.setBool('isTracking', isTracking);
    if (isSetupComplete != null) await prefs.setBool('isSetupComplete', isSetupComplete);
    if (paydayDay != null) {
      await prefs.setInt('paydayDay', paydayDay.clamp(1, 31));
      setState(() => _paydayDay = paydayDay.clamp(1, 31));
    }
    if (formulaIndex != null) {
      await prefs.setInt('formulaIndex', formulaIndex.clamp(0, 4));
      setState(() => _formulaIndex = formulaIndex.clamp(0, 4));
    }
    if (customFoodDaily != null) {
      await prefs.setDouble('customFoodDaily', customFoodDaily);
      setState(() => _customFoodDaily = customFoodDaily);
    }
    
    if (history != null) {
      await prefs.setString('history', jsonEncode(history.map((e) => e.toJson()).toList()));
      setState(() => _history = history);
    }

    if (expenses != null) {
      await prefs.setString('expenses', jsonEncode(expenses.map((e) => e.toJson()).toList()));
      setState(() => _expenses = expenses);
    }

    setState(() {
      if (currentElapsed != null) _savedElapsedMillis = currentElapsed;
      if (isTracking != null) _isTracking = isTracking;
      if (sessionStart != null) _sessionStartMillis = sessionStart;
      if (isSetupComplete != null) _isSetupComplete = isSetupComplete;
    });
  }

  Future<void> _saveWorkSchedule(int startHour, int startMinute, int endHour, int endMinute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('workStartHour', startHour);
    await prefs.setInt('workStartMinute', startMinute);
    await prefs.setInt('workEndHour', endHour);
    await prefs.setInt('workEndMinute', endMinute);
    await prefs.setBool('workScheduleSet', true);
    setState(() {
      _workStartHour = startHour;
      _workStartMinute = startMinute;
      _workEndHour = endHour;
      _workEndMinute = endMinute;
      _workScheduleSet = true;
    });
  }

  void _addToHistory(double amount, int durationMillis) {
    if (amount <= 0) return;
    final newSession = WorkSession(
      date: DateTime.now(),
      amount: amount,
      durationMillis: durationMillis,
    );
    final updatedHistory = [newSession, ..._history];
    _saveGlobalData(history: updatedHistory);
  }

  void _onAddOrUpdateExpense(Expense expense) {
    setState(() {
      final index = _expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        _expenses[index] = expense;
      } else {
        _expenses.insert(0, expense);
      }
      _saveGlobalData(expenses: _expenses);
    });
  }

  void _onAddMultipleExpenses(List<Expense> newExpenses) {
    setState(() {
      _expenses.addAll(newExpenses);
      _saveGlobalData(expenses: _expenses);
    });
  }

  void _showAddExpenseFromNav() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddExpenseScreen(
          onAdd: _onAddOrUpdateExpense,
          onDelete: (index) {
            final updatedExpenses = List<Expense>.from(_expenses)..removeAt(index);
            _saveGlobalData(expenses: updatedExpenses);
          },
          expenses: _expenses,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // SHOW SPLASH SCREEN AS A LOADING GUARD
    if (!_isInitialized || !_adFlowComplete) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.analytics_rounded, size: 64, color: Color(0xFF10B981)),
              ),
              const SizedBox(height: 24),
              const Text(
                "GajiMeter",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1),
              ),
              const SizedBox(height: 48),
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: Color(0xFF10B981),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Loading your workspace...",
                style: TextStyle(
                  color: Colors.grey.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isSetupComplete) {
      return SetupWizard(
        salaryController: _salaryController,
        expenses: _expenses,
        onAddExpense: _onAddOrUpdateExpense,
        onDeleteExpense: (index) {
          final updatedExpenses = List<Expense>.from(_expenses)..removeAt(index);
          _saveGlobalData(expenses: updatedExpenses);
        },
        onComplete: () => _saveGlobalData(isSetupComplete: true),
        paydayDay: _paydayDay,
        onPaydayChanged: (day) => _saveGlobalData(paydayDay: day),
      );
    }

    final double salary = double.tryParse(_salaryController.text) ?? 0;
    final int workDays = int.tryParse(_daysController.text) ?? 20;
    final int workHours = int.tryParse(_hoursController.text) ?? 8;
    final double totalExpenses = _expenses.fold(0.0, (sum, item) => sum + item.amount);

    final List<Widget> screens = [
      SalaryTrackerScreen(
        salaryController: _salaryController,
        daysController: _daysController,
        hoursController: _hoursController,
        initialSavedMillis: _savedElapsedMillis,
        initialSessionStart: _sessionStartMillis,
        initialIsTracking: _isTracking,
        totalExpenses: totalExpenses,
        paydayDay: _paydayDay,
        formulaIndex: _formulaIndex,
        workStartHour: _workStartHour,
        workStartMinute: _workStartMinute,
        workEndHour: _workEndHour,
        workEndMinute: _workEndMinute,
        workScheduleSet: _workScheduleSet,
        onScheduleChanged: _saveWorkSchedule,
        onSave: (elapsed, isTracking, start) => _saveGlobalData(
          currentElapsed: elapsed,
          isTracking: isTracking,
          sessionStart: start,
        ),
        onSessionEnd: _addToHistory,
      ),
      ExpenseScreen(
        expenses: _expenses,
        salary: salary,
        paydayDay: _paydayDay,
        formulaIndex: _formulaIndex,
        onFormulaChanged: (i) => _saveGlobalData(formulaIndex: i),
        customFoodDaily: _customFoodDaily,
        onFoodDailyChanged: (v) => _saveGlobalData(customFoodDaily: v),
        onAdd: _onAddOrUpdateExpense,
        onDelete: (index) {
          final updatedExpenses = List<Expense>.from(_expenses)..removeAt(index);
          _saveGlobalData(expenses: updatedExpenses);
        },
        onClear: () => _saveGlobalData(expenses: []),
      ),
      HistoryScreen(
        history: _history,
        expenses: _expenses,
        salary: salary,
        onClear: () => _saveGlobalData(history: []),
      ),
      SettingsScreen(
        themeIndex: widget.themeIndex,
        onThemeChanged: widget.onThemeChanged,
        paydayDay: _paydayDay,
        onPaydayChanged: (day) => _saveGlobalData(paydayDay: day),
        onSalaryChanged: () => setState(() {}),
        salaryController: _salaryController,
        daysController: _daysController,
        hoursController: _hoursController,
        onClearHistory: () => _saveGlobalData(history: []),
        onClearExpenses: () => _saveGlobalData(expenses: []),
        onClearAll: () {
          _saveGlobalData(history: [], expenses: [], isSetupComplete: false);
          setState(() {
            _salaryController.text = '';
            _daysController.text = '20';
            _hoursController.text = '8';
          });
        },
      ),
    ];

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: MediaQuery(
        // Strip the nav-bar height from padding so inner Scaffolds fill the
        // full height — content then naturally scrolls behind the glass bar.
        data: MediaQuery.of(context).copyWith(
          padding: MediaQuery.of(context).padding.copyWith(bottom: 0),
          viewPadding: MediaQuery.of(context).viewPadding.copyWith(bottom: 0),
        ),
        child: IndexedStack(
          index: _selectedIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: GlassBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        onAddExpense: _showAddExpenseFromNav,
      ),
    );
  }
}

class GlassBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onAddExpense;

  const GlassBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onAddExpense,
  });

  static const _purple = Color(0xFF5B4FCF);

  @override
  Widget build(BuildContext context) {
    final lang = AppLang.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glassBg = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.30);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.6);
    final shadowColor = isDark ? Colors.black54 : Colors.black.withValues(alpha: 0.10);

    // Material(transparent) removes the solid canvasColor Scaffold paints behind bottomNavigationBar
    return Material(
      color: Colors.transparent,
      child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: SizedBox(
        height: 96,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // Floating glass nav bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    height: 72,
                    decoration: BoxDecoration(
                      color: glassBg,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: borderColor, width: 1.2),
                      boxShadow: [
                        BoxShadow(color: shadowColor, blurRadius: 24, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                  children: [
                    Expanded(
                      child: _NavBarItem(
                        icon: Icons.home_outlined,
                        activeIcon: Icons.home_rounded,
                        label: lang.t('nav_home'),
                        isSelected: selectedIndex == 0,
                        onTap: () => onItemSelected(0),
                      ),
                    ),
                    Expanded(
                      child: _NavBarItem(
                        icon: Icons.account_balance_wallet_outlined,
                        activeIcon: Icons.account_balance_wallet_rounded,
                        label: lang.t('nav_money'),
                        isSelected: selectedIndex == 1,
                        onTap: () => onItemSelected(1),
                      ),
                    ),
                    // Center gap for diamond button
                    const Expanded(child: SizedBox()),
                    Expanded(
                      child: _NavBarItem(
                        icon: Icons.history_rounded,
                        activeIcon: Icons.history_rounded,
                        label: lang.t('nav_history'),
                        isSelected: selectedIndex == 2,
                        onTap: () => onItemSelected(2),
                      ),
                    ),
                    Expanded(
                      child: _NavBarItem(
                        icon: Icons.settings_outlined,
                        activeIcon: Icons.settings_rounded,
                        label: lang.t('nav_settings'),
                        isSelected: selectedIndex == 3,
                        onTap: () => onItemSelected(3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
            // Raised diamond Add Expense button
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: onAddExpense,
                child: Transform.rotate(
                  angle: pi / 4,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: _purple,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: _purple.withValues(alpha: 0.40),
                          blurRadius: 24,
                          spreadRadius: 0,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: _purple.withValues(alpha: 0.18),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Transform.rotate(
                      angle: -pi / 4,
                      child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
                    ),
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
}

class SetupWizard extends StatefulWidget {
  final TextEditingController salaryController;
  final List<Expense> expenses;
  final Function(Expense) onAddExpense;
  final Function(int) onDeleteExpense;
  final VoidCallback onComplete;
  final int paydayDay;
  final Function(int) onPaydayChanged;

  const SetupWizard({
    super.key,
    required this.salaryController,
    required this.expenses,
    required this.onAddExpense,
    required this.onDeleteExpense,
    required this.onComplete,
    required this.paydayDay,
    required this.onPaydayChanged,
  });

  @override
  State<SetupWizard> createState() => _SetupWizardState();
}

class _SetupWizardState extends State<SetupWizard> {
  int _step = 0; // 0: Salary, 1: Payday, 2: Expenses
  late TextEditingController _paydayController;

  @override
  void initState() {
    super.initState();
    _paydayController = TextEditingController(text: widget.paydayDay.toString());
  }

  @override
  void dispose() {
    _paydayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = AppLang.of(context);
    final currencyFormat = NumberFormat.currency(symbol: "RM ", decimalDigits: 2);
    final stepTitles = [
      "Berapa gaji bersih anda?",
      lang.t('setup_payday_q'),
      "Pin Monthly Expenses",
    ];
    final stepHints = [
      "Sila masukkan jumlah gaji selepas potongan (EPF, SOCSO, Tax).",
      lang.t('setup_payday_hint'),
      "Sila masukkan semua komitmen bulanan tetap anda.",
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              // Step indicator
              Row(
                children: List.generate(3, (i) => Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                    decoration: BoxDecoration(
                      color: i <= _step ? const Color(0xFF3B82F6) : Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )),
              ),
              const SizedBox(height: 24),
              Text(
                stepTitles[_step],
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1.2),
              ),
              const SizedBox(height: 8),
              Text(
                stepHints[_step],
                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 40),

              if (_step == 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.3), width: 2),
                  ),
                  child: TextField(
                    controller: widget.salaryController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                    decoration: const InputDecoration(
                      labelText: "Gaji Bersih (RM)",
                      border: InputBorder.none,
                      prefixText: "RM ",
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () {
                      if (double.tryParse(widget.salaryController.text) != null) {
                        setState(() => _step = 1);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("NEXT →", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                  ),
                ),
              ] else if (_step == 1) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.3), width: 2),
                  ),
                  child: Row(
                    children: [
                      const Text("Day", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 16)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _paydayController,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                          decoration: const InputDecoration(border: InputBorder.none),
                          onChanged: (v) {
                            final d = int.tryParse(v);
                            if (d != null) widget.onPaydayChanged(d.clamp(1, 31));
                          },
                        ),
                      ),
                      const Text("of every month", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: [1, 5, 10, 15, 20, 25, 26, 27, 28, 30, 31].map((d) {
                    final sel = (int.tryParse(_paydayController.text) ?? 25) == d;
                    return GestureDetector(
                      onTap: () {
                        _paydayController.text = d.toString();
                        widget.onPaydayChanged(d);
                        setState(() {});
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? const Color(0xFF3B82F6) : (isDark ? const Color(0xFF0F172A) : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: sel ? const Color(0xFF3B82F6) : Colors.grey.withValues(alpha: 0.2)),
                        ),
                        child: Text("$d", style: TextStyle(fontWeight: FontWeight.w800, color: sel ? Colors.white : null)),
                      ),
                    );
                  }).toList(),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity, height: 64,
                  child: ElevatedButton(
                    onPressed: () => setState(() => _step = 2),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("NEXT: ADD EXPENSES (OPTIONAL)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                  ),
                ),
              ] else ...[
                // Unified Pinned Card in Setup
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.push_pin_rounded, color: Colors.white, size: 32),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "MONTHLY TOTAL EXPENSES",
                                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 10, letterSpacing: 1.2),
                                ),
                                Text(
                                  currencyFormat.format(widget.expenses.fold(0.0, (sum, item) => sum + item.amount)),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(color: Colors.white24, height: 1),
                        ),
                        Expanded(
                          child: widget.expenses.isEmpty
                              ? const Center(
                                  child: Text("No items pinned yet", style: TextStyle(color: Colors.white60, fontWeight: FontWeight.w500)),
                                )
                              : ListView.builder(
                                  itemCount: widget.expenses.length,
                                  itemBuilder: (context, index) {
                                    final exp = widget.expenses[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                                    children: [
                                                      TextSpan(text: exp.description, style: const TextStyle(fontWeight: FontWeight.w800)),
                                                      TextSpan(
                                                        text: " ( ${exp.category}${exp.subCategory != null ? ' | ${exp.subCategory}' : ''}${exp.months != null ? ' | ${exp.months} Month' : ''} )",
                                                        style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  currencyFormat.format(exp.amount),
                                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit_rounded, size: 18, color: Colors.white70),
                                                onPressed: () => _showAddExpenseDialog(context, widget.onAddExpense, expense: exp),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                              ),
                                              const SizedBox(width: 12),
                                              IconButton(
                                                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.white70),
                                                onPressed: () => widget.onDeleteExpense(index),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () => _showAddDialog(context),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text("ADD MONTHLY EXPENSE", style: TextStyle(fontWeight: FontWeight.w800)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: widget.onComplete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      widget.expenses.isNotEmpty ? "FINISH & SAVE ALL" : "SKIP & GET STARTED",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    _showAddExpenseDialog(context, widget.onAddExpense);
  }

  void _showAddExpenseDialog(BuildContext context, Function(Expense) onAdd, {Expense? expense}) {
    final descController = TextEditingController(text: expense?.description);
    final amountController = TextEditingController(text: expense?.amount.toString());
    final monthsController = TextEditingController(text: expense?.months?.toString());
    
    String selectedCategory = expense?.category ?? "Food";
    String? selectedSubCategory = expense?.subCategory;

    final categories = ["Food", "Groceries", "Bills", "Transport", "Rent", "Utilities", "Health", "Leisure", "Shopping", "Other"];
    
    final Map<String, List<String>> subCategories = {
      "Bills": ["Telephone", "Wifi", "Electric", "Water"],
      "Transport": ["Motor", "Car", "Public"],
      "Other": ["Shopping (Monthly)", "Custom"],
    };

    final Map<String, List<String>> transportOptions = {
      "Motor": ["Minyak"],
      "Car": ["Tol", "Minyak"],
      "Public": ["Daily", "Monthly"],
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense == null ? "Pin New Expense" : "Edit Pinned Expense",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 24),
                
                // Category Selection
                const Text("Category", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((cat) => ChoiceChip(
                    label: Text(cat),
                    selected: selectedCategory == cat,
                    onSelected: (selected) {
                      if (selected) {
                        setModalState(() {
                          selectedCategory = cat;
                          selectedSubCategory = null;
                        });
                      }
                    },
                  )).toList(),
                ),
                
                // SubCategory Selection
                if (subCategories.containsKey(selectedCategory)) ...[
                  const SizedBox(height: 16),
                  Text("Type of $selectedCategory", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: subCategories[selectedCategory]!.map((sub) => ChoiceChip(
                      label: Text(sub),
                      selected: selectedSubCategory == sub || (selectedCategory == "Transport" && transportOptions.containsKey(selectedSubCategory) && sub == selectedSubCategory),
                      onSelected: (selected) {
                        if (selected) setModalState(() => selectedSubCategory = sub);
                      },
                    )).toList(),
                  ),
                ],

                // Transport Specific Options (Nested)
                if (selectedCategory == "Transport" && transportOptions.containsKey(selectedSubCategory)) ...[
                  const SizedBox(height: 16),
                  Text("Details for $selectedSubCategory", style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: transportOptions[selectedSubCategory]!.map((opt) => ChoiceChip(
                      label: Text(opt),
                      selected: descController.text == opt,
                      onSelected: (selected) {
                        if (selected) setModalState(() => descController.text = opt);
                      },
                    )).toList(),
                  ),
                ],

                const SizedBox(height: 24),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    filled: true,
                    fillColor: Colors.grey.withValues(alpha: 0.1),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Amount (RM)",
                    filled: true,
                    fillColor: Colors.grey.withValues(alpha: 0.1),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                
                if (selectedCategory == "Other" || selectedCategory == "Bills" || selectedCategory == "Rent") ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: monthsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Duration (Months)",
                      hintText: "Enter number of months",
                      filled: true,
                      fillColor: Colors.grey.withValues(alpha: 0.1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                ],

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      final desc = descController.text;
                      final amount = double.tryParse(amountController.text) ?? 0.0;
                      final months = int.tryParse(monthsController.text);
                      
                      if (desc.isNotEmpty && amount > 0) {
                        onAdd(Expense(
                          id: expense?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                          date: expense?.date ?? DateTime.now(),
                          category: selectedCategory,
                          subCategory: selectedSubCategory,
                          description: desc,
                          amount: amount,
                          months: months,
                        ));
                        Navigator.pop(context);
                        setState(() {}); // Refresh setup list
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      expense == null ? "PIN IT" : "UPDATE PIN",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SetupAddProxy extends StatelessWidget {
  final Function(Expense) onAdd;
  const _SetupAddProxy({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    // Just a shell to access the _showAddExpenseDialog logic which is currently in ExpenseScreen
    // Since I can't easily move it without refactoring everything, I'll duplicate the logic for setup
    return Container(); 
  }
}

class ExpenseScreen extends StatefulWidget {
  final List<Expense> expenses;
  final Function(Expense) onAdd;
  final Function(int) onDelete;
  final VoidCallback onClear;
  final double salary;
  final int paydayDay;
  final int formulaIndex;
  final Function(int) onFormulaChanged;
  final double customFoodDaily;
  final Function(double) onFoodDailyChanged;

  const ExpenseScreen({
    super.key,
    required this.expenses,
    required this.onAdd,
    required this.onDelete,
    required this.onClear,
    required this.salary,
    required this.paydayDay,
    required this.formulaIndex,
    required this.onFormulaChanged,
    required this.customFoodDaily,
    required this.onFoodDailyChanged,
  });

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  bool _setupWizardShown = false;
  bool _showAllExpenses = false;
  static const int _visibleCount = 3;

  final ScrollController _scrollController = ScrollController();
  bool _scrolledPastHeader = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final past = _scrollController.offset > 60;
      if (past != _scrolledPastHeader) setState(() => _scrolledPastHeader = past);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.expenses.isEmpty && !_setupWizardShown) {
      _setupWizardShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSetupWizard(context);
      });
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "Food": return Icons.restaurant_rounded;
      case "Groceries": return Icons.shopping_cart_rounded;
      case "Transport": return Icons.directions_car_rounded;
      case "Bills": return Icons.receipt_rounded;
      case "Rent": return Icons.home_rounded;
      case "Utilities": return Icons.lightbulb_rounded;
      case "Health": return Icons.medical_services_rounded;
      case "Leisure": return Icons.theater_comedy_rounded;
      case "Shopping": return Icons.shopping_bag_rounded;
      default: return Icons.more_horiz_rounded;
    }
  }

  void _showSetupWizard(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Pin Expenses Setup", style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text("Welcome! Let's pin your fixed expenses first (Sewa, Bill, Wifi, etc.) to get an accurate tracking."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("LATER"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showAddExpenseDialog(context, widget.onAdd);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("START SETUP"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final lang = AppLang.of(context);
    final currencyFormat = NumberFormat.currency(symbol: "RM ", decimalDigits: 2);

    double totalExpenses = widget.expenses.fold(0, (sum, item) => sum + item.amount);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: RepaintBoundary(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3B82F6).withValues(alpha: isDark ? 0.08 : 0.05),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Unified Pinned Card in Expenses Tab
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Header (scrolls away, replaced by glass overlay) ──
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 16, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(lang.t('expenses_title'), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.5)),
                                  Text(lang.t('expenses_subtitle'), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline_rounded, size: 28, color: colorScheme.primary),
                                onPressed: () => _showAddExpenseDialog(context, widget.onAdd),
                                tooltip: lang.t('add_expense'),
                              ),
                            ],
                          ),
                        ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.75)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.push_pin_rounded, color: Colors.white, size: 32),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lang.t('label_monthly_total'),
                                      style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, fontSize: 10, letterSpacing: 1.2),
                                    ),
                                    Text(
                                      currencyFormat.format(totalExpenses),
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(color: Colors.white24, height: 1),
                          ),
                          if (widget.expenses.isEmpty)
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.push_pin_rounded, size: 48, color: Colors.white30),
                                    const SizedBox(height: 16),
                                    Text(lang.t('empty_expenses'), style: const TextStyle(color: Colors.white60)),
                                  ],
                                ),
                              )
                            else
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(bottom: 8),
                                    itemCount: _showAllExpenses
                                        ? widget.expenses.length
                                        : widget.expenses.length.clamp(0, _visibleCount),
                                    itemBuilder: (context, index) {
                                      final expense = widget.expenses[index];
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                                  children: [
                                                    TextSpan(text: expense.description, style: const TextStyle(fontWeight: FontWeight.w800)),
                                                    TextSpan(
                                                      text: " ( ${expense.category}${expense.subCategory != null ? ' | ${expense.subCategory}' : ''}${expense.months != null ? ' | ${expense.months} Month' : ''} )",
                                                      style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              currencyFormat.format(expense.amount),
                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  if (widget.expenses.length > _visibleCount)
                                    GestureDetector(
                                      onTap: () => setState(() => _showAllExpenses = !_showAllExpenses),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _showAllExpenses
                                                  ? lang.t('see_less')
                                                  : "${lang.t('see_more')} (${widget.expenses.length - _visibleCount} more)",
                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(
                                              _showAllExpenses ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                        ],
                      ),
                    ),
                    _MoneyOverviewCard(salary: widget.salary, totalExpenses: totalExpenses, paydayDay: widget.paydayDay, formulaIndex: widget.formulaIndex, customFoodDaily: widget.customFoodDaily),
                    _BudgetFormulaCard(salary: widget.salary, totalExpenses: totalExpenses, paydayDay: widget.paydayDay, formulaIndex: widget.formulaIndex, onFormulaChanged: widget.onFormulaChanged, customFoodDaily: widget.customFoodDaily, onFoodDailyChanged: widget.onFoodDailyChanged),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ── Sticky glass header overlay for Money tab ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              offset: _scrolledPastHeader ? Offset.zero : const Offset(0, -1),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 260),
                opacity: _scrolledPastHeader ? 1.0 : 0.0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.white.withValues(alpha: 0.30),
                        border: Border(
                          bottom: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.10)
                                : Colors.white.withValues(alpha: 0.60),
                            width: 1,
                          ),
                        ),
                      ),
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 12, 24, 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'TOTAL EXPENSE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.onSurface.withValues(alpha: 0.45),
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    currencyFormat.format(totalExpenses),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFFEF4444),
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'BALANCE ALLOCATION',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.onSurface.withValues(alpha: 0.45),
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    currencyFormat.format((widget.salary - totalExpenses).clamp(0, double.infinity)),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: colorScheme.primary,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context, Function(Expense) onAdd, {Expense? expense}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddExpenseScreen(
          onAdd: onAdd,
          onDelete: widget.onDelete,
          expenses: widget.expenses,
          expense: expense,
        ),
      ),
    );
  }
}

class AddExpenseScreen extends StatefulWidget {
  final Function(Expense) onAdd;
  final Function(int) onDelete;
  final List<Expense> expenses;
  final Expense? expense;

  const AddExpenseScreen({
    super.key,
    required this.onAdd,
    required this.onDelete,
    required this.expenses,
    this.expense,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late List<Expense> _expenses;

  final _categories = ["Food", "Groceries", "Bills", "Transport", "Rent", "Utilities", "Health", "Leisure", "Shopping", "Other"];
  final _subCategories = {
    "Bills": ["Telephone", "Wifi", "Electric", "Water"],
    "Transport": ["Motor", "Car", "Public"],
    "Other": ["Shopping (Monthly)", "Custom"],
  };
  final _transportOptions = {
    "Motor": ["Minyak"],
    "Car": ["Tol", "Minyak"],
    "Public": ["Daily", "Monthly"],
  };

  static const _categoryColors = {
    "Food": Color(0xFFF59E0B),
    "Groceries": Color(0xFF10B981),
    "Bills": Color(0xFFEF4444),
    "Transport": Color(0xFF3B82F6),
    "Rent": Color(0xFF8B5CF6),
    "Utilities": Color(0xFF06B6D4),
    "Health": Color(0xFFEC4899),
    "Leisure": Color(0xFFF97316),
    "Shopping": Color(0xFF6366F1),
    "Other": Color(0xFF64748B),
  };

  static const _categoryIcons = {
    "Food": Icons.restaurant_rounded,
    "Groceries": Icons.shopping_basket_rounded,
    "Bills": Icons.receipt_rounded,
    "Transport": Icons.directions_car_rounded,
    "Rent": Icons.home_rounded,
    "Utilities": Icons.bolt_rounded,
    "Health": Icons.favorite_rounded,
    "Leisure": Icons.sports_esports_rounded,
    "Shopping": Icons.shopping_bag_rounded,
    "Other": Icons.more_horiz_rounded,
  };

  @override
  void initState() {
    super.initState();
    _expenses = List.from(widget.expenses);
  }

  void _openForm({Expense? editing, int? editIndex}) {
    final descCtrl = TextEditingController(text: editing?.description);
    final amountCtrl = TextEditingController(text: editing?.amount.toString());
    final monthsCtrl = TextEditingController(text: editing?.months?.toString());
    String selCat = editing?.category ?? "Food";
    String? selSub = editing?.subCategory;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final colorScheme = Theme.of(ctx).colorScheme;
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          final sheetBg = isDark ? const Color(0xFF0F172A) : Colors.white;
          final fieldFill = colorScheme.onSurface.withValues(alpha: 0.06);
          final lang = AppLang.of(ctx);

          return Container(
            decoration: BoxDecoration(
              color: sheetBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              left: 24, right: 24, top: 8,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    editing == null ? lang.t('form_title_add') : lang.t('form_title_edit'),
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 20),
                  Text(lang.t('label_category'), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.5), letterSpacing: 0.8)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: _categories.map((cat) {
                      final selected = selCat == cat;
                      final color = _categoryColors[cat] ?? colorScheme.primary;
                      return GestureDetector(
                        onTap: () => setSheet(() { selCat = cat; selSub = null; }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: selected ? color.withValues(alpha: 0.15) : colorScheme.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: selected ? color : Colors.transparent, width: 1.5),
                          ),
                          child: Text(cat, style: TextStyle(fontSize: 12, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? color : colorScheme.onSurface.withValues(alpha: 0.6))),
                        ),
                      );
                    }).toList(),
                  ),

                  if (_subCategories.containsKey(selCat)) ...[
                    const SizedBox(height: 16),
                    Text(lang.t('label_type'), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.5), letterSpacing: 0.8)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: _subCategories[selCat]!.map((sub) => GestureDetector(
                        onTap: () => setSheet(() => selSub = sub),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: selSub == sub ? colorScheme.primary.withValues(alpha: 0.15) : colorScheme.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: selSub == sub ? colorScheme.primary : Colors.transparent, width: 1.5),
                          ),
                          child: Text(sub, style: TextStyle(fontSize: 12, fontWeight: selSub == sub ? FontWeight.w700 : FontWeight.w500, color: selSub == sub ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6))),
                        ),
                      )).toList(),
                    ),
                  ],

                  if (selCat == "Transport" && _transportOptions.containsKey(selSub)) ...[
                    const SizedBox(height: 16),
                    Text(lang.t('label_detail'), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.5), letterSpacing: 0.8)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: _transportOptions[selSub]!.map((opt) => GestureDetector(
                        onTap: () => setSheet(() => descCtrl.text = opt),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: descCtrl.text == opt ? colorScheme.primary.withValues(alpha: 0.15) : colorScheme.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: descCtrl.text == opt ? colorScheme.primary : Colors.transparent, width: 1.5),
                          ),
                          child: Text(opt, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colorScheme.onSurface.withValues(alpha: 0.6))),
                        ),
                      )).toList(),
                    ),
                  ],

                  const SizedBox(height: 20),
                  TextField(
                    controller: descCtrl,
                    decoration: InputDecoration(
                      labelText: lang.t('field_description'),
                      filled: true, fillColor: fieldFill,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: lang.t('field_amount'),
                      filled: true, fillColor: fieldFill,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                  if (selCat == "Other" || selCat == "Bills" || selCat == "Rent") ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: monthsCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: lang.t('field_months'),
                        filled: true, fillColor: fieldFill,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity, height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        final desc = descCtrl.text.trim();
                        final amount = double.tryParse(amountCtrl.text) ?? 0.0;
                        final months = int.tryParse(monthsCtrl.text);
                        if (desc.isNotEmpty && amount > 0) {
                          final e = Expense(
                            id: editing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                            date: editing?.date ?? DateTime.now(),
                            category: selCat,
                            subCategory: selSub,
                            description: desc,
                            amount: amount,
                            months: months,
                          );
                          widget.onAdd(e);
                          setState(() {
                            if (editIndex != null) {
                              _expenses[editIndex] = e;
                            } else {
                              _expenses.add(e);
                            }
                          });
                          Navigator.pop(ctx);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Text(lang.t('btn_save'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final lang = AppLang.of(context);
    final bg = isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = colorScheme.onSurface.withValues(alpha: 0.07);
    final currencyFormat = NumberFormat.currency(symbol: "RM ", decimalDigits: 2);
    final total = _expenses.fold(0.0, (s, e) => s + e.amount);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(lang.t('my_expenses'), style: TextStyle(fontWeight: FontWeight.w900, color: colorScheme.onSurface)),
      ),
      body: Column(
        children: [
          // ── Total banner ──
          Container(
            margin: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.7)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.push_pin_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lang.t('total_monthly'), style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
                    Text(currencyFormat.format(total), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                  ],
                ),
                const Spacer(),
                Text("${_expenses.length} item${_expenses.length == 1 ? '' : 's'}",
                  style: const TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          // ── List ──
          Expanded(
            child: _expenses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.push_pin_outlined, size: 52, color: colorScheme.onSurface.withValues(alpha: 0.15)),
                      const SizedBox(height: 12),
                      Text(lang.t('empty_no_expenses'), style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.35), fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(lang.t('empty_hint'), style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.25))),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                  itemCount: _expenses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final exp = _expenses[index];
                    final color = _categoryColors[exp.category] ?? colorScheme.primary;
                    final icon = _categoryIcons[exp.category] ?? Icons.label_rounded;
                    return Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        leading: Container(
                          width: 42, height: 42,
                          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                          child: Icon(icon, size: 20, color: color),
                        ),
                        title: Text(exp.description, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: colorScheme.onSurface)),
                        subtitle: Text(
                          "${exp.category}${exp.subCategory != null ? ' · ${exp.subCategory}' : ''}",
                          style: TextStyle(fontSize: 11, color: colorScheme.onSurface.withValues(alpha: 0.4)),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(currencyFormat.format(exp.amount),
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: color)),
                                if (exp.months != null)
                                  Text("${exp.months}mo", style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withValues(alpha: 0.35))),
                              ],
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: Icon(Icons.edit_rounded, size: 16, color: colorScheme.onSurface.withValues(alpha: 0.35)),
                              onPressed: () => _openForm(editing: exp, editIndex: index),
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline_rounded, size: 16, color: Colors.red.withValues(alpha: 0.5)),
                              onPressed: () {
                                widget.onDelete(index);
                                setState(() => _expenses.removeAt(index));
                              },
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),

      // ── Add button ──
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
            label: Text(lang.t('add_expense'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 4,
              shadowColor: colorScheme.primary.withValues(alpha: 0.4),
            ),
          ),
        ),
      ),
    );
  }
}

class _BudgetFormula {
  final String name;
  final String suitableFor;
  final int komitmen;
  final int makan;
  final int bolehSpend;
  final int saving;
  final int buffer;
  const _BudgetFormula({
    required this.name,
    required this.suitableFor,
    required this.komitmen,
    required this.makan,
    required this.bolehSpend,
    required this.saving,
    required this.buffer,
  });
}

List<_BudgetFormula> _getBudgetFormulas(String langKey) => [
  _BudgetFormula(name: AppStrings.get(langKey, 'formula_balanced'), suitableFor: AppStrings.get(langKey, 'formula_balanced_desc'), komitmen: 40, makan: 20, bolehSpend: 20, saving: 15, buffer: 5),
  _BudgetFormula(name: AppStrings.get(langKey, 'formula_saving'), suitableFor: AppStrings.get(langKey, 'formula_saving_desc'), komitmen: 35, makan: 20, bolehSpend: 10, saving: 30, buffer: 5),
  _BudgetFormula(name: AppStrings.get(langKey, 'formula_commitment'), suitableFor: AppStrings.get(langKey, 'formula_commitment_desc'), komitmen: 55, makan: 20, bolehSpend: 10, saving: 10, buffer: 5),
  _BudgetFormula(name: AppStrings.get(langKey, 'formula_lifestyle'), suitableFor: AppStrings.get(langKey, 'formula_lifestyle_desc'), komitmen: 35, makan: 20, bolehSpend: 30, saving: 10, buffer: 5),
  _BudgetFormula(name: AppStrings.get(langKey, 'formula_strict'), suitableFor: AppStrings.get(langKey, 'formula_strict_desc'), komitmen: 45, makan: 20, bolehSpend: 5, saving: 25, buffer: 5),
];

class _BudgetFormulaCard extends StatelessWidget {
  final double salary;
  final double totalExpenses;
  final int paydayDay;
  final int formulaIndex;
  final Function(int) onFormulaChanged;
  final double customFoodDaily;
  final Function(double) onFoodDailyChanged;

  const _BudgetFormulaCard({
    required this.salary,
    required this.totalExpenses,
    required this.paydayDay,
    required this.formulaIndex,
    required this.onFormulaChanged,
    required this.customFoodDaily,
    required this.onFoodDailyChanged,
  });

  int _daysUntilPayday() {
    final now = DateTime.now();
    final day = paydayDay.clamp(1, 28);
    DateTime next = DateTime(now.year, now.month, day);
    if (!next.isAfter(DateTime(now.year, now.month, now.day))) {
      next = DateTime(now.year, now.month + 1, day);
    }
    return next.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  void _showFormulaPicker(BuildContext context, ColorScheme colorScheme, bool isDark, AppLang lang) {
    final formulas = _getBudgetFormulas(lang.langKey);
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => SizedBox(
          height: MediaQuery.of(ctx).size.height * 0.55,
          child: Column(
            children: [
              // fixed header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(width: 36, height: 4, decoration: BoxDecoration(color: colorScheme.onSurface.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
                    ),
                    const SizedBox(height: 16),
                    Text(lang.t('sheet_pick_formula'), style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: colorScheme.onSurface)),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              // scrollable list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: formulas.length,
                  itemBuilder: (_, i) {
                    final f = formulas[i];
                    final selected = i == formulaIndex;
                    final net = _estimateNetSalary(salary);
                    final eligible = salary <= 0 || totalExpenses <= net * f.komitmen / 100;
                    final fmt0 = NumberFormat.currency(symbol: "RM ", decimalDigits: 0);
                    final excess = eligible ? 0.0 : totalExpenses - net * f.komitmen / 100;
                    return Opacity(
                      opacity: eligible ? 1.0 : 0.4,
                      child: GestureDetector(
                        onTap: eligible ? () { onFormulaChanged(i); Navigator.pop(ctx); } : null,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: !eligible
                                ? colorScheme.onSurface.withValues(alpha: 0.04)
                                : selected
                                    ? colorScheme.primary.withValues(alpha: 0.12)
                                    : colorScheme.onSurface.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: !eligible
                                  ? const Color(0xFFEF4444).withValues(alpha: 0.3)
                                  : selected ? colorScheme.primary : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text("${i + 1}. ${f.name}", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: selected ? colorScheme.primary : colorScheme.onSurface)),
                                        if (!eligible) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(color: const Color(0xFFEF4444).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                                            child: Text("${lang.t('formula_not_eligible')} +${fmt0.format(excess)}", style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFFEF4444))),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(f.suitableFor, style: TextStyle(fontSize: 11, color: colorScheme.onSurface.withValues(alpha: 0.5))),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        _formulaChip("K ${f.komitmen}%", const Color(0xFFEF4444)),
                                        const SizedBox(width: 4),
                                        _formulaChip("M ${f.makan}%", const Color(0xFFF59E0B)),
                                        const SizedBox(width: 4),
                                        _formulaChip("S ${f.bolehSpend}%", colorScheme.primary),
                                        const SizedBox(width: 4),
                                        _formulaChip("💰 ${f.saving}%", const Color(0xFF10B981)),
                                        const SizedBox(width: 4),
                                        _formulaChip("🛡 ${f.buffer}%", const Color(0xFF6366F1)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (selected && eligible)
                                Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 20)
                              else if (!eligible)
                                const Icon(Icons.block_rounded, color: Color(0xFFEF4444), size: 18),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formulaChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = AppLang.of(context);
    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = colorScheme.onSurface.withValues(alpha: 0.07);

    final formulas = _getBudgetFormulas(lang.langKey);
    final netSalary = _estimateNetSalary(salary);
    final f = formulas[formulaIndex.clamp(0, formulas.length - 1)];

    final foodMonthly = customFoodDaily * 30;
    final leftover = (netSalary - totalExpenses - foodMonthly).clamp(0.0, double.infinity);
    final splitTotal = f.bolehSpend + f.saving + f.buffer;
    final spendAmt  = splitTotal > 0 ? leftover * f.bolehSpend / splitTotal : 0.0;
    final savingAmt = splitTotal > 0 ? leftover * f.saving   / splitTotal : 0.0;
    final bufferAmt = splitTotal > 0 ? leftover * f.buffer   / splitTotal : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart_rounded, color: colorScheme.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(lang.t('card_budget_title'), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: colorScheme.onSurface)),
              ),
              GestureDetector(
                onTap: () => _showFormulaPicker(context, colorScheme, isDark, lang),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.tune_rounded, size: 13, color: colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(lang.t('btn_change'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: colorScheme.primary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text("${formulaIndex + 1}. ${f.name}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colorScheme.primary)),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(f.suitableFor, style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withValues(alpha: 0.45), fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            salary > 0
                ? "${lang.t('net_salary_prefix')} ${NumberFormat.currency(symbol: "RM ", decimalDigits: 0).format(netSalary)}"
                : lang.t('enter_salary_hint'),
            style: TextStyle(fontSize: 11, color: colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.w500),
          ),
          if (salary > 0) ...[
            const SizedBox(height: 16),

            // ── Leftover Breakdown header ──
            Row(
              children: [
                Icon(Icons.account_balance_wallet_rounded, size: 15, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(lang.t('sisa_belanjawan'), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: colorScheme.onSurface)),
              ],
            ),
            const SizedBox(height: 12),

            // Komitmen vs actual expenses
            _komitmenRow(
              budget: netSalary * f.komitmen / 100,
              actual: totalExpenses,
              percent: f.komitmen,
              bolehSpend: f.bolehSpend,
              saving: f.saving,
              buffer: f.buffer,
              colorScheme: colorScheme,
              lang: lang,
            ),
            const SizedBox(height: 10),

            // Food per day
            _foodRow(
              makanBudget: netSalary * f.makan / 100,
              percent: f.makan,
              daysLeft: _daysUntilPayday(),
              colorScheme: colorScheme,
              customFoodDaily: customFoodDaily,
              lang: lang,
              onEdit: () => _showEditFoodDialog(context, lang),
            ),
            const SizedBox(height: 10),

            // Spend + Saving + Buffer — based on actual leftover (matches Overview Card)
            Row(
              children: [
                Expanded(child: _bucketChip("${f.bolehSpend}% ${lang.t('label_spend')}", spendAmt, colorScheme.primary, lang)),
                const SizedBox(width: 8),
                Expanded(child: _bucketChip("${f.saving}% ${lang.t('bucket_saving')}", savingAmt, const Color(0xFF10B981), lang)),
                const SizedBox(width: 8),
                Expanded(child: _bucketChip("${f.buffer}% ${lang.t('label_buffer')}", bufferAmt, const Color(0xFF6366F1), lang)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _komitmenRow({
    required double budget,
    required double actual,
    required int percent,
    required int bolehSpend,
    required int saving,
    required int buffer,
    required ColorScheme colorScheme,
    required AppLang lang,
  }) {
    final surplus = budget - actual;
    final isOver = surplus < 0;
    final color = isOver ? const Color(0xFFEF4444) : const Color(0xFF10B981);
    final fmt0 = NumberFormat.currency(symbol: "RM ", decimalDigits: 0);

    final splitTotal = bolehSpend + saving + buffer;
    final spendShare  = splitTotal > 0 ? surplus * bolehSpend / splitTotal : 0.0;
    final savingShare = splitTotal > 0 ? surplus * saving   / splitTotal : 0.0;
    final bufferShare = splitTotal > 0 ? surplus * buffer   / splitTotal : 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$percent% ${lang.t('bucket_komitmen')}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
                  const SizedBox(height: 2),
                  Text("${lang.t('label_budget_short')} ${fmt0.format(budget)} · ${lang.t('label_used')} ${fmt0.format(actual)}", style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withValues(alpha: 0.45))),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${isOver ? '−' : '+'}${fmt0.format(surplus.abs())}",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color),
                  ),
                  Text(isOver ? lang.t('lebih_belanja') : lang.t('tersisa'), style: TextStyle(fontSize: 9, color: color.withValues(alpha: 0.7))),
                ],
              ),
            ],
          ),
          if (!isOver && surplus > 0) ...[
            const SizedBox(height: 10),
            Text(lang.t('surplus_to'), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: colorScheme.onSurface.withValues(alpha: 0.4))),
            const SizedBox(height: 6),
            Row(
              children: [
                _surplusChip(lang.t('label_spend'),   fmt0.format(spendShare),  colorScheme.primary),
                const SizedBox(width: 6),
                _surplusChip(lang.t('bucket_saving'), fmt0.format(savingShare), const Color(0xFF10B981)),
                const SizedBox(width: 6),
                _surplusChip(lang.t('label_buffer'),  fmt0.format(bufferShare), const Color(0xFF6366F1)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _surplusChip(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: color)),
            Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: color.withValues(alpha: 0.7))),
          ],
        ),
      ),
    );
  }

  void _showEditFoodDialog(BuildContext context, AppLang lang) {
    const amber = Color(0xFFF59E0B);
    final ctrl = TextEditingController(text: customFoodDaily.toStringAsFixed(0));
    final colorScheme = Theme.of(context).colorScheme;
    final netSalary = _estimateNetSalary(salary);
    final maxFoodMonthly = (netSalary - totalExpenses).clamp(0.0, double.infinity);
    final maxFoodDaily = maxFoodMonthly / 30;
    final fmt0 = NumberFormat.currency(symbol: "RM ", decimalDigits: 0);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.restaurant_rounded, color: amber, size: 20),
            const SizedBox(width: 8),
            Text(lang.t('bajet_makan_hari'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: ctrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              decoration: InputDecoration(
                prefixText: 'RM ',
                suffix: Text(lang.t('per_hari')),
                filled: true,
                fillColor: colorScheme.onSurface.withValues(alpha: 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            if (maxFoodDaily > 0) ...[
              const SizedBox(height: 8),
              Text(
                '${lang.t('label_max')}: ${fmt0.format(maxFoodDaily)}/${lang.t('per_hari_short')} (${lang.t('after_expenses')})',
                style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withValues(alpha: 0.45)),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang.t('btn_cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              final v = double.tryParse(ctrl.text);
              if (v != null && v > 0) {
                if (maxFoodDaily > 0 && v > maxFoodDaily) {
                  showDialog(
                    context: ctx,
                    builder: (errCtx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: Row(
                        children: [
                          const Icon(Icons.warning_rounded, color: Color(0xFFEF4444), size: 22),
                          const SizedBox(width: 8),
                          Text(lang.t('exceeds_balance_title'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        ],
                      ),
                      content: Text(
                        '${lang.t('exceeds_balance_body')} ${fmt0.format(maxFoodDaily)}/${lang.t('per_hari_short')}.',
                        style: const TextStyle(fontSize: 13),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(errCtx),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF4444),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                  );
                  return;
                }
                onFoodDailyChanged(v);
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: amber,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(lang.t('btn_save'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Widget _foodRow({required double makanBudget, required int percent, required int daysLeft, required ColorScheme colorScheme, required double customFoodDaily, required AppLang lang, required VoidCallback onEdit}) {
    const amber = Color(0xFFF59E0B);
    final double targetPerDay = customFoodDaily;
    final double monthlyTarget = targetPerDay * 30;
    final fmt2 = NumberFormat.currency(symbol: "RM ", decimalDigits: 2);
    final fmt0 = NumberFormat.currency(symbol: "RM ", decimalDigits: 0);
    final totalForDaysLeft = targetPerDay * daysLeft;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: amber.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: amber.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.restaurant_rounded, size: 14, color: amber),
                  const SizedBox(width: 6),
                  Text(lang.t('bajet_makan'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: amber)),
                ],
              ),
              Row(
                children: [
                  Text(fmt0.format(monthlyTarget), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: amber)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: amber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.edit_rounded, size: 12, color: amber),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _dayChip("${fmt2.format(targetPerDay)} ${lang.t('per_hari')}", lang.t('sasar_harian'), amber),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _dayChip(fmt0.format(totalForDaysLeft), "$daysLeft ${lang.t('hari_berbaki')}", const Color(0xFFF97316)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dayChip(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: color), textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 9, color: color.withValues(alpha: 0.75), fontWeight: FontWeight.w500), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _bucketChip(String label, double amount, Color color, AppLang lang) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color.withValues(alpha: 0.85))),
          const SizedBox(height: 4),
          Text(
            NumberFormat.currency(symbol: "RM ", decimalDigits: 0).format(amount),
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color),
          ),
          Text(lang.t('per_bulan'), style: TextStyle(fontSize: 9, color: color.withValues(alpha: 0.6))),
        ],
      ),
    );
  }
}

class _BudgetBucket {
  final String label;
  final int percent;
  final double amount;
  final Color color;
  final IconData icon;
  const _BudgetBucket({required this.label, required this.percent, required this.amount, required this.color, required this.icon});
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  static const _purple = Color(0xFF5B4FCF);
  static const _inactive = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? _purple : _inactive;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
            child: Icon(
              isSelected ? activeIcon : icon,
              key: ValueKey(isSelected),
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: color,
              letterSpacing: 0.3,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}

class SalaryTrackerScreen extends StatefulWidget {
  final TextEditingController salaryController;
  final TextEditingController daysController;
  final TextEditingController hoursController;
  final int initialSavedMillis;
  final int initialSessionStart;
  final bool initialIsTracking;
  final double totalExpenses;
  final int paydayDay;
  final int formulaIndex;
  final int workStartHour;
  final int workStartMinute;
  final int workEndHour;
  final int workEndMinute;
  final bool workScheduleSet;
  final Function(int, int, int, int) onScheduleChanged;
  final Function(int, bool, int) onSave;
  final Function(double, int) onSessionEnd;

  const SalaryTrackerScreen({
    super.key,
    required this.salaryController,
    required this.daysController,
    required this.hoursController,
    required this.initialSavedMillis,
    required this.initialSessionStart,
    required this.initialIsTracking,
    required this.totalExpenses,
    required this.paydayDay,
    required this.formulaIndex,
    required this.workStartHour,
    required this.workStartMinute,
    required this.workEndHour,
    required this.workEndMinute,
    required this.workScheduleSet,
    required this.onScheduleChanged,
    required this.onSave,
    required this.onSessionEnd,
  });

  @override
  State<SalaryTrackerScreen> createState() => _SalaryTrackerScreenState();
}

class _SalaryTrackerScreenState extends State<SalaryTrackerScreen> with SingleTickerProviderStateMixin {
  late bool _isTracking;
  late int _sessionStartMillis;
  late int _savedElapsedMillis;

  final ValueNotifier<int> _currentMillisNotifier = ValueNotifier(DateTime.now().millisecondsSinceEpoch);
  Timer? _timer;
  Timer? _scheduleTimer;
  bool _promptShown = false;
  bool _autoStartedToday = false;
  bool _autoEndedToday = false;
  String _autoActionDate = '';

  late AnimationController _pulseController;
  final ScrollController _scrollController = ScrollController();
  bool _scrolledPastHeader = false;

  @override
  void initState() {
    super.initState();
    _savedElapsedMillis = widget.initialSavedMillis;
    _sessionStartMillis = widget.initialSessionStart;
    _isTracking = widget.initialIsTracking;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scrollController.addListener(() {
      final past = _scrollController.offset > 72;
      if (past != _scrolledPastHeader) setState(() => _scrolledPastHeader = past);
    });

    if (_isTracking) {
      _startTimer();
    }

    _scheduleTimer = Timer.periodic(const Duration(seconds: 30), (_) => _checkAutoSchedule());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAutoSchedule();
      if (mounted && !widget.workScheduleSet && !_promptShown) {
        _promptShown = true;
        _showScheduleDialog();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scheduleTimer?.cancel();
    _pulseController.dispose();
    _currentMillisNotifier.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  int get _currentElapsed {
    if (_isTracking) {
      return _savedElapsedMillis + (_currentMillisNotifier.value - _sessionStartMillis).clamp(0, double.infinity).toInt();
    } else {
      return _savedElapsedMillis;
    }
  }

  void _triggerSave() {
    widget.onSave(_isTracking ? _savedElapsedMillis : _currentElapsed, _isTracking, _sessionStartMillis);
  }

  void _toggleTracking() {
    setState(() {
      if (_isTracking) {
        _savedElapsedMillis = _currentElapsed;
        _isTracking = false;
        _timer?.cancel();
      } else {
        _currentMillisNotifier.value = DateTime.now().millisecondsSinceEpoch;
        _sessionStartMillis = _currentMillisNotifier.value;
        _isTracking = true;
        _startTimer();
      }
    });
    _triggerSave();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _currentMillisNotifier.value = DateTime.now().millisecondsSinceEpoch;
      
      if (timer.tick % 50 == 0) {
        _triggerSave();
      }
    });
  }

  void _reset() {
    final currentAmount = _calculateEarnedAmount(_currentElapsed);
    if (currentAmount > 0) {
      widget.onSessionEnd(currentAmount, _currentElapsed);
    }
    setState(() {
      _savedElapsedMillis = 0;
      _sessionStartMillis = 0;
      _currentMillisNotifier.value = DateTime.now().millisecondsSinceEpoch;
      _isTracking = false;
      _timer?.cancel();
    });
    _triggerSave();
  }

  void _checkAutoSchedule() {
    if (!widget.workScheduleSet) return;
    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';

    if (_autoActionDate != today) {
      _autoActionDate = today;
      _autoStartedToday = false;
      _autoEndedToday = false;
    }

    final startTotal = widget.workStartHour * 60 + widget.workStartMinute;
    final endTotal = widget.workEndHour * 60 + widget.workEndMinute;
    final nowTotal = now.hour * 60 + now.minute;

    if (!_autoStartedToday && !_isTracking && _savedElapsedMillis == 0 &&
        nowTotal >= startTotal && nowTotal < endTotal) {
      _autoStartedToday = true;
      _toggleTracking();
    }

    if (!_autoEndedToday && _isTracking && nowTotal >= endTotal) {
      _autoEndedToday = true;
      _reset();
    }
  }

  void _showScheduleDialog() {
    var startHour = widget.workStartHour;
    var startMinute = widget.workStartMinute;
    var endHour = widget.workEndHour;
    var endMinute = widget.workEndMinute;

    String fmt(int h, int m) {
      final period = h < 12 ? 'AM' : 'PM';
      final dh = h == 0 ? 12 : (h > 12 ? h - 12 : h);
      return '${dh.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $period';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final colorScheme = Theme.of(ctx).colorScheme;
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
              left: 24, right: 24, top: 8,
            ),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(AppLang.of(context).t('work_schedule_title'), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
                const SizedBox(height: 4),
                Text(
                  AppLang.of(context).t('schedule_dialog_hint'),
                  style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withValues(alpha: 0.45)),
                ),
                const SizedBox(height: 28),
                GestureDetector(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: ctx,
                      initialTime: TimeOfDay(hour: startHour, minute: startMinute),
                    );
                    if (picked != null) setSheet(() { startHour = picked.hour; startMinute = picked.minute; });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.play_circle_rounded, color: colorScheme.primary, size: 24),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLang.of(context).t('schedule_start'), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colorScheme.onSurface.withValues(alpha: 0.4), letterSpacing: 0.8)),
                            const SizedBox(height: 2),
                            Text(fmt(startHour, startMinute), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: colorScheme.onSurface)),
                          ],
                        ),
                        const Spacer(),
                        Icon(Icons.edit_rounded, size: 18, color: colorScheme.onSurface.withValues(alpha: 0.3)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: ctx,
                      initialTime: TimeOfDay(hour: endHour, minute: endMinute),
                    );
                    if (picked != null) setSheet(() { endHour = picked.hour; endMinute = picked.minute; });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.stop_circle_rounded, color: Color(0xFFEF4444), size: 24),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLang.of(context).t('schedule_end'), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colorScheme.onSurface.withValues(alpha: 0.4), letterSpacing: 0.8)),
                            const SizedBox(height: 2),
                            Text(fmt(endHour, endMinute), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: colorScheme.onSurface)),
                          ],
                        ),
                        const Spacer(),
                        Icon(Icons.edit_rounded, size: 18, color: colorScheme.onSurface.withValues(alpha: 0.3)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      widget.onScheduleChanged(startHour, startMinute, endHour, endMinute);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(AppLang.of(context).t('schedule_save'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double _calculateEarnedAmount(int elapsed) {
    final salary = double.tryParse(widget.salaryController.text) ?? 0.0;
    final days = int.tryParse(widget.daysController.text) ?? 0;
    final hours = int.tryParse(widget.hoursController.text) ?? 0;
    
    final totalSecondsWorkedPerMonth = days * hours * 3600;
    if (totalSecondsWorkedPerMonth > 0) {
      final earningsPerSecond = salary / totalSecondsWorkedPerMonth;
      return (elapsed / 1000.0) * earningsPerSecond;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final lang = AppLang.of(context);

    final currencyFormat = NumberFormat.currency(symbol: "RM ", decimalDigits: 2);
    final secondFormat = NumberFormat.currency(symbol: "RM ", decimalDigits: 5);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF020617) : const Color(0xFFF0F4F8),
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colorScheme.primary.withValues(alpha: isDark ? 0.12 : 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.t('app_title'),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.2,
                              ),
                            ),
                            Text(
                              lang.t('app_subtitle'),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isTracking
                                  ? colorScheme.primary.withValues(alpha: 0.1 + (_pulseController.value * 0.08))
                                  : colorScheme.onSurface.withValues(alpha: 0.06),
                                border: Border.all(
                                  color: _isTracking
                                    ? colorScheme.primary.withValues(alpha: 0.25)
                                    : colorScheme.onSurface.withValues(alpha: 0.08),
                                ),
                              ),
                              child: Icon(
                                _isTracking ? Icons.timer : Icons.timer_off_outlined,
                                size: 22,
                                color: _isTracking
                                  ? colorScheme.primary
                                  : colorScheme.onSurface.withValues(alpha: 0.3),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Hero Earnings Card ──
                  LayoutBuilder(
                    builder: (context, heroConstraints) => ValueListenableBuilder<int>(
                      valueListenable: _currentMillisNotifier,
                      builder: (context, now, _) {
                        final elapsed = _isTracking
                          ? _savedElapsedMillis + (now - _sessionStartMillis).clamp(0, double.infinity).toInt()
                          : _savedElapsedMillis;
                        final amount = _calculateEarnedAmount(elapsed);
                        final daily = _calculateDailyRate();
                        final ended = !_isTracking && elapsed > 0 && daily > 0 && amount >= daily;
                        final progress = daily > 0 ? (amount / daily).clamp(0.0, 1.0) : 0.0;

                        final statusColor = _isTracking
                          ? const Color(0xFF10B981)
                          : ended
                            ? const Color(0xFF8B5CF6)
                            : const Color(0xFF64748B);
                        final statusText = _isTracking
                          ? lang.t('status_working')
                          : ended
                            ? lang.t('status_ended')
                            : (elapsed > 0 ? lang.t('status_paused') : lang.t('status_ready'));

                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                ? [const Color(0xFF0D1117), const Color(0xFF1E1B4B)]
                                : [const Color(0xFF1E1B4B), const Color(0xFF312E81)],
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withValues(alpha: 0.22),
                                blurRadius: 28,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -40,
                                  right: -40,
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          colorScheme.primary.withValues(alpha: 0.28),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: statusColor.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(99),
                                          border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 6, height: 6,
                                              decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              statusText.toUpperCase(),
                                              style: TextStyle(
                                                color: statusColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 28),
                                      Text(
                                        lang.t('label_earned_session'),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white54,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        currencyFormat.format(amount),
                                        style: const TextStyle(
                                          fontSize: 44,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: -2,
                                          height: 1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "+ ${secondFormat.format(_calculateEarnedAmount(1000))} ${lang.t('label_per_sec')}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'monospace',
                                          color: Colors.white38,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${(progress * 100).toStringAsFixed(1)}${lang.t('label_daily_target')}",
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.white54,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Stack(
                                    children: [
                                      Container(height: 5, color: Colors.white.withValues(alpha: 0.08)),
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 400),
                                        height: 5,
                                        width: heroConstraints.maxWidth * progress,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [colorScheme.primary, const Color(0xFF10B981)],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Payday + Safe Spend ──
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.calendar_month_rounded,
                          label: lang.t('payday_in'),
                          value: _getDaysUntilPayday() == 0
                            ? lang.t('payday_today')
                            : "${_getDaysUntilPayday()}",
                          valueUnit: _getDaysUntilPayday() == 0 ? '' : lang.t('payday_in'),
                          color: const Color(0xFF8B5CF6),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.shield_rounded,
                          label: lang.t('safe_spend_today'),
                          value: currencyFormat.format(_getSafeSpendToday()),
                          color: const Color(0xFF10B981),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Unified Stats Card ──
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 18),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.05)),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              icon: Icons.hourglass_bottom_rounded,
                              label: lang.t('stat_hourly'),
                              value: currencyFormat.format(_calculateHourlyRate()),
                              colorScheme: colorScheme,
                            ),
                          ),
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: colorScheme.onSurface.withValues(alpha: 0.07),
                          ),
                          Expanded(
                            child: _buildStatItem(
                              icon: Icons.flag_rounded,
                              label: lang.t('today_target'),
                              value: currencyFormat.format(_calculateDailyRate()),
                              colorScheme: colorScheme,
                            ),
                          ),
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: colorScheme.onSurface.withValues(alpha: 0.07),
                          ),
                          Expanded(
                            child: _buildStatItem(
                              icon: Icons.diamond_rounded,
                              label: lang.t('left_this_month'),
                              value: currencyFormat.format(
                                (_estimateNetSalary(double.tryParse(widget.salaryController.text) ?? 0) - widget.totalExpenses).clamp(0, double.infinity),
                              ),
                              colorScheme: colorScheme,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Work Schedule ──
                  Builder(builder: (context) {
                    final now = DateTime.now();
                    final startTotal = widget.workStartHour * 60 + widget.workStartMinute;
                    final endTotal = widget.workEndHour * 60 + widget.workEndMinute;
                    final nowTotal = now.hour * 60 + now.minute;
                    final isActive = widget.workScheduleSet && nowTotal >= startTotal && nowTotal < endTotal;

                    String fmtTime(int h, int m) {
                      final period = h < 12 ? 'AM' : 'PM';
                      final dh = h == 0 ? 12 : (h > 12 ? h - 12 : h);
                      return '${dh.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $period';
                    }

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isActive
                              ? colorScheme.primary.withValues(alpha: 0.3)
                              : colorScheme.onSurface.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      lang.t('work_schedule_title').toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        letterSpacing: 1.2,
                                        fontWeight: FontWeight.w800,
                                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                                      ),
                                    ),
                                    if (widget.workScheduleSet) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isActive
                                              ? const Color(0xFF10B981).withValues(alpha: 0.12)
                                              : colorScheme.onSurface.withValues(alpha: 0.06),
                                          borderRadius: BorderRadius.circular(99),
                                        ),
                                        child: Text(
                                          isActive ? lang.t('schedule_active_badge') : lang.t('schedule_off_badge'),
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.w800,
                                            color: isActive
                                                ? const Color(0xFF10B981)
                                                : colorScheme.onSurface.withValues(alpha: 0.35),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (widget.workScheduleSet) ...[
                                  Row(
                                    children: [
                                      Icon(Icons.play_circle_outline_rounded, size: 15, color: colorScheme.primary),
                                      const SizedBox(width: 5),
                                      Text(
                                        fmtTime(widget.workStartHour, widget.workStartMinute),
                                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(Icons.arrow_forward_rounded, size: 13, color: colorScheme.onSurface.withValues(alpha: 0.25)),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.stop_circle_outlined, size: 15, color: Color(0xFFEF4444)),
                                      const SizedBox(width: 5),
                                      Text(
                                        fmtTime(widget.workEndHour, widget.workEndMinute),
                                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    lang.t('schedule_auto_on'),
                                    style: TextStyle(fontSize: 11, color: colorScheme.onSurface.withValues(alpha: 0.35)),
                                  ),
                                ] else
                                  Text(
                                    lang.t('schedule_not_set'),
                                    style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withValues(alpha: 0.4)),
                                  ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: _showScheduleDialog,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.edit_rounded, size: 18, color: colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  // ── Work Config ──
                  RepaintBoundary(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.05)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lang.t('label_config'),
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w800,
                                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                                ),
                              ),
                              if (_isTracking)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'LOCKED',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFFF59E0B),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SlickInputSection(
                            salaryController: widget.salaryController,
                            daysController: widget.daysController,
                            hoursController: widget.hoursController,
                            enabled: !_isTracking,
                            onChanged: (val) {
                              setState(() {});
                              _triggerSave();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Start / Pause ──
                  GestureDetector(
                    onTap: _toggleTracking,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        gradient: _isTracking
                          ? const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)])
                          : LinearGradient(colors: [colorScheme.primary, colorScheme.primary.withBlue(200)]),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (_isTracking ? Colors.red : colorScheme.primary).withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _isTracking ? lang.t('btn_pause') : lang.t('btn_start'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const AdMobBanner(),
                ],
              ),
            ),
          ),
          // ── Sticky glass header overlay ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              offset: _scrolledPastHeader ? Offset.zero : const Offset(0, -1),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 260),
                opacity: _scrolledPastHeader ? 1.0 : 0.0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.white.withValues(alpha: 0.30),
                        border: Border(
                          bottom: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.10)
                                : Colors.white.withValues(alpha: 0.60),
                            width: 1,
                          ),
                        ),
                      ),
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 12, 24, 14),
                          child: ValueListenableBuilder<int>(
                            valueListenable: _currentMillisNotifier,
                            builder: (_, now, __) {
                              final elapsed = _isTracking
                                  ? _savedElapsedMillis + (now - _sessionStartMillis).clamp(0, 999999999)
                                  : _savedElapsedMillis;
                              final earned = _calculateEarnedAmount(elapsed);
                              final fmt = NumberFormat.currency(symbol: 'RM ', decimalDigits: 2);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    lang.t('label_earned_session'),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.onSurface.withValues(alpha: 0.45),
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    fmt.format(earned),
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      color: colorScheme.primary,
                                      letterSpacing: -0.8,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: colorScheme.primary.withValues(alpha: 0.6)),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  double _calculateHourlyRate() {
    final salary = double.tryParse(widget.salaryController.text) ?? 0.0;
    final days = int.tryParse(widget.daysController.text) ?? 0;
    final hours = int.tryParse(widget.hoursController.text) ?? 0;
    return (days > 0 && hours > 0) ? salary / days / hours : 0.0;
  }

  double _calculateDailyRate() {
    final salary = double.tryParse(widget.salaryController.text) ?? 0.0;
    final days = int.tryParse(widget.daysController.text) ?? 0;
    return days > 0 ? salary / days : 0.0;
  }

  int _getDaysUntilPayday() {
    final now = DateTime.now();
    final day = widget.paydayDay.clamp(1, 28);
    DateTime next = DateTime(now.year, now.month, day);
    if (!next.isAfter(DateTime(now.year, now.month, now.day))) {
      next = DateTime(now.year, now.month + 1, day);
    }
    return next.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  double _getSafeSpendToday() {
    final gross = double.tryParse(widget.salaryController.text) ?? 0.0;
    final net = _estimateNetSalary(gross);
    final formulas = _getBudgetFormulas('ms');
    final f = formulas[widget.formulaIndex.clamp(0, formulas.length - 1)];
    final savingBudget = net * f.saving / 100;
    final bufferBudget = net * f.buffer / 100;
    final spendable = net - widget.totalExpenses - savingBudget - bufferBudget;
    if (spendable <= 0) return 0;
    final days = _getDaysUntilPayday();
    return days > 0 ? spendable / days : spendable;
  }
}

class AdMobBanner extends StatefulWidget {
  const AdMobBanner({super.key});

  @override
  State<AdMobBanner> createState() => _AdMobBannerState();
}

class _AdMobBannerState extends State<AdMobBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  AdSize? _adSize;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-5978067529669035/6245822645'
      : 'ca-app-pub-3940256099942544/2934735716';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_adSize == null) {
      _loadAd();
    }
  }

  Future<void> _loadAd() async {
    final AdSize? size = 
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            (MediaQuery.of(context).size.width - 48).toInt());

    if (size == null) return;

    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('AdMob: Ad loaded successfully.');
          if (mounted) {
            setState(() {
              _bannerAd = ad as BannerAd;
              _isLoaded = true;
              _adSize = size;
            });
          }
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('AdMob: Ad failed to load: ${err.message}');
          debugPrint('AdMob: Error code: ${err.code}');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null || _adSize == null) {
      return const SlickAdBanner();
    }

    return Container(
      alignment: Alignment.center,
      width: _adSize!.width.toDouble(),
      height: _adSize!.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

class SlickAdBanner extends StatelessWidget {
  const SlickAdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ads_click_rounded, size: 20, color: Colors.grey),
            SizedBox(height: 4),
            Text(
              "ADVERTISEMENT",
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  final String text;
  final Color color;

  const StatusPill({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Text(
            text.toUpperCase(),
            style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

class CompactStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const CompactStatCard({super.key, required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colorScheme.primary.withValues(alpha: 0.6)),
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class SlickInputSection extends StatelessWidget {
  final TextEditingController salaryController;
  final TextEditingController daysController;
  final TextEditingController hoursController;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const SlickInputSection({
    super.key,
    required this.salaryController,
    required this.daysController,
    required this.hoursController,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        _buildField(
          controller: salaryController,
          label: "Monthly Salary",
          prefix: "RM",
          enabled: enabled,
          onChanged: onChanged,
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildField(
                controller: daysController,
                label: "Working Days",
                enabled: enabled,
                onChanged: onChanged,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildField(
                controller: hoursController,
                label: "Daily Hours",
                enabled: enabled,
                onChanged: onChanged,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? prefix,
    required bool enabled,
    required ValueChanged<String> onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          labelText: label,
          prefixText: prefix != null ? "$prefix " : null,
          labelStyle: TextStyle(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.4),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final int themeIndex;
  final Function(int) onThemeChanged;
  final VoidCallback onClearHistory;
  final VoidCallback onClearExpenses;
  final VoidCallback onClearAll;
  final int paydayDay;
  final Function(int) onPaydayChanged;
  final VoidCallback onSalaryChanged;
  final TextEditingController salaryController;
  final TextEditingController daysController;
  final TextEditingController hoursController;

  const SettingsScreen({
    super.key,
    required this.themeIndex,
    required this.onThemeChanged,
    required this.onClearHistory,
    required this.onClearExpenses,
    required this.onClearAll,
    required this.paydayDay,
    required this.onPaydayChanged,
    required this.onSalaryChanged,
    required this.salaryController,
    required this.daysController,
    required this.hoursController,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _standardLangs = [
    {'key': 'en', 'label': 'English', 'flag': '🇬🇧'},
    {'key': 'ms', 'label': 'Bahasa Melayu', 'flag': '🇲🇾'},
  ];

  static const _dialectLangs = [
    {'key': 'kelantan',   'label': 'Kelantan',    'flag': '🌙'},
    {'key': 'terengganu', 'label': 'Terengganu',  'flag': '🐢'},
    {'key': 'ns',         'label': 'N. Sembilan', 'flag': '🦅'},
    {'key': 'utara',      'label': 'Utara',       'flag': '⭐'},
    {'key': 'sarawak',    'label': 'Sarawak',     'flag': '🦅'},
    {'key': 'sabah',      'label': 'Sabah',       'flag': '🏔️'},
  ];

  // The 3 allowed themes: Lavender (8), Midnight Black (5), Pearl (2)
  static const _allowedThemes = [
    {'index': 5, 'label': 'Dark',  'icon': Icons.dark_mode_rounded},
    {'index': 2, 'label': 'Light', 'icon': Icons.wb_sunny_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = AppLang.of(context);
    final bg = isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC);
    final surface = isDark ? const Color(0xFF0F172A) : Colors.white;
    final List<BoxShadow> shadow = isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 3))];
    final muted = colorScheme.onSurface.withValues(alpha: 0.3);
    final activeTheme = AppThemes.all[widget.themeIndex];
    final activeLang = [..._standardLangs, ..._dialectLangs].firstWhere(
      (l) => l['key'] == lang.langKey, orElse: () => _standardLangs[1]);
    const langColor = Color(0xFF8B5CF6);
    const dangerColor = Color(0xFFEF4444);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header ──────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("GAJIMETER", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: colorScheme.primary, letterSpacing: 2.5)),
                        const SizedBox(height: 3),
                        Text(lang.t('settings_title'), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: colorScheme.onSurface, letterSpacing: -1.2, height: 1.05)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
                    ),
                    child: Text("v 1.0.0", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: colorScheme.primary, letterSpacing: 0.5)),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // ── 00 — Work Setup ────────────────────────────────
              _SettingsSection(number: "00", label: lang.t('settings_work'), color: const Color(0xFF10B981)),
              const SizedBox(height: 18),
              _WorkSetupCard(
                salaryController: widget.salaryController,
                daysController: widget.daysController,
                hoursController: widget.hoursController,
                paydayDay: widget.paydayDay,
                onPaydayChanged: widget.onPaydayChanged,
                onChanged: widget.onSalaryChanged,
              ),

              const SizedBox(height: 40),

              // ── 01 — Theme ─────────────────────────────────────
              _SettingsSection(number: "01", label: lang.t('section_theme'), color: colorScheme.primary),
              const SizedBox(height: 18),

              Container(
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: _allowedThemes.map((t) {
                    final idx = t['index'] as int;
                    final sel = widget.themeIndex == idx;
                    final icon = t['icon'] as IconData;
                    final label = t['label'] as String;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onThemeChanged(idx),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: sel ? colorScheme.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: sel ? [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))] : [],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(icon, size: 18, color: sel ? Colors.white : colorScheme.onSurface.withValues(alpha: 0.5)),
                              const SizedBox(width: 8),
                              Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: sel ? Colors.white : colorScheme.onSurface.withValues(alpha: 0.5))),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 40),

              // ── 02 — Language ──────────────────────────────────
              _SettingsSection(number: "02", label: lang.t('section_language'), color: langColor),
              const SizedBox(height: 18),

              // Active language banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: langColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: langColor.withValues(alpha: 0.25), width: 1.5),
                  boxShadow: [BoxShadow(color: langColor.withValues(alpha: isDark ? 0.08 : 0.06), blurRadius: 12, offset: const Offset(0, 3))],
                ),
                child: Row(
                  children: [
                    Text(activeLang['flag'] ?? '🗣️', style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(activeLang['label']!, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: langColor)),
                          Text("Active Language", style: TextStyle(fontSize: 11, color: langColor.withValues(alpha: 0.6))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: langColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.check_rounded, size: 14, color: langColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Standard
              Text(lang.t('lang_standard').toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.4, color: muted)),
              const SizedBox(height: 10),
              Row(
                children: _standardLangs.map((e) {
                  final sel = lang.langKey == e['key'];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => lang.onChanged(e['key']!),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(right: e == _standardLangs.last ? 0 : 10),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: sel ? langColor.withValues(alpha: 0.08) : surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: sel ? langColor : colorScheme.onSurface.withValues(alpha: 0.07), width: sel ? 1.5 : 1),
                          boxShadow: sel ? <BoxShadow>[] : shadow,
                        ),
                        child: Column(
                          children: [
                            Text(e['flag']!, style: TextStyle(fontSize: sel ? 24 : 20)),
                            const SizedBox(height: 6),
                            Text(e['label']!, style: TextStyle(fontSize: 11, fontWeight: sel ? FontWeight.w800 : FontWeight.w500, color: sel ? langColor : colorScheme.onSurface.withValues(alpha: 0.7)), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 16),
              Text(lang.t('lang_dialect').toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.4, color: muted)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _dialectLangs.map((e) {
                  final sel = lang.langKey == e['key'];
                  return GestureDetector(
                    onTap: () => lang.onChanged(e['key']!),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: (MediaQuery.of(context).size.width - 48 - 20) / 3,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: sel ? langColor.withValues(alpha: 0.08) : surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: sel ? langColor : colorScheme.onSurface.withValues(alpha: 0.07), width: sel ? 1.5 : 1),
                        boxShadow: sel ? [] : shadow,
                      ),
                      child: Column(
                        children: [
                          Text(e['flag']!, style: TextStyle(fontSize: sel ? 22 : 18)),
                          const SizedBox(height: 5),
                          Text(e['label']!, style: TextStyle(fontSize: 11, fontWeight: sel ? FontWeight.w800 : FontWeight.w500, color: sel ? langColor : colorScheme.onSurface.withValues(alpha: 0.7)), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              // ── 03 — Data ──────────────────────────────────────
              _SettingsSection(number: "03", label: lang.t('section_data'), color: dangerColor),
              const SizedBox(height: 18),

              _DataActionRow(label: lang.t('clear_history'), sub: lang.t('clear_history_sub'), accentColor: Colors.orange, surface: surface, onTap: () => _confirmClear(context, lang.t('clear_history'), "This will permanently delete all work session history.", widget.onClearHistory)),
              const SizedBox(height: 10),
              _DataActionRow(label: lang.t('clear_expenses'), sub: lang.t('clear_expenses_sub'), accentColor: Colors.orange, surface: surface, onTap: () => _confirmClear(context, lang.t('clear_expenses'), "This will permanently delete all pinned monthly expenses.", widget.onClearExpenses)),
              const SizedBox(height: 10),
              _DataActionRow(label: lang.t('reset_all'), sub: lang.t('reset_all_sub'), accentColor: dangerColor, surface: surface, isDestructive: true, onTap: () => _confirmClear(context, lang.t('reset_all'), "This will permanently delete all your data including salary, history, and expenses.", widget.onClearAll)),

              const SizedBox(height: 40),

              // ── 04 — About ─────────────────────────────────────
              _SettingsSection(number: "04", label: lang.t('section_about'), color: colorScheme.primary),
              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(child: _AboutPill(
                    icon: Icons.star_rounded,
                    label: lang.t('rate_app'),
                    sub: lang.t('rate_app_sub'),
                    color: const Color(0xFFF59E0B),
                    surface: surface,
                    shadow: shadow,
                    onTap: () => launchUrl(
                      Uri.parse('https://play.google.com/store/apps/details?id=com.gajimeter.gajimeter_flutter'),
                      mode: LaunchMode.externalApplication,
                    ),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _AboutPill(
                    icon: Icons.lock_outline_rounded,
                    label: lang.t('privacy'),
                    sub: lang.t('privacy_sub'),
                    color: langColor,
                    surface: surface,
                    shadow: shadow,
                    onTap: () => launchUrl(
                      Uri.parse('https://gajimeter-privacy.vercel.app'),
                      mode: LaunchMode.externalApplication,
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 28),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 6, height: 6, decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.25), shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text("GajiMeter  ·  Made for Malaysia", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colorScheme.onSurface.withValues(alpha: 0.2), letterSpacing: 0.3)),
                        const SizedBox(width: 8),
                        Container(width: 6, height: 6, decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.25), shape: BoxShape.circle)),
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _confirmClear(BuildContext context, String title, String content, VoidCallback onConfirm) {
    final lang = AppLang.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(lang.t('btn_cancel'))),
          TextButton(
            onPressed: () { Navigator.pop(ctx); onConfirm(); },
            child: Text(lang.t('btn_delete'), style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      label.toUpperCase(),
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: colorScheme.onSurface.withValues(alpha: 0.4)),
    );
  }
}

class _SettingsGroupHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SettingsGroupHeader({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 8),
        Text(label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.1, color: color)),
      ],
    );
  }
}

class _SettingsSubLabel extends StatelessWidget {
  final String label;
  const _SettingsSubLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colorScheme.onSurface.withValues(alpha: 0.4)));
  }
}

class _SettingsSection extends StatelessWidget {
  final String number;
  final String label;
  final Color color;
  const _SettingsSection({required this.number, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Row(
      children: [
        Text(number, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: color.withValues(alpha: 0.5), letterSpacing: 1)),
        const SizedBox(width: 8),
        Expanded(child: Container(height: 1, color: color.withValues(alpha: 0.15))),
        const SizedBox(width: 8),
        Text(label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: onSurface.withValues(alpha: 0.5), letterSpacing: 1.2)),
      ],
    );
  }
}

class _DataActionRow extends StatelessWidget {
  final String label;
  final String sub;
  final Color accentColor;
  final Color surface;
  final VoidCallback onTap;
  final bool isDestructive;
  const _DataActionRow({required this.label, required this.sub, required this.accentColor, required this.surface, required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDestructive ? accentColor.withValues(alpha: 0.06) : surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accentColor.withValues(alpha: isDestructive ? 0.25 : 0.12)),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 56,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: isDestructive ? accentColor : Theme.of(context).colorScheme.onSurface)),
                  Text(sub, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4))),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 18, color: accentColor.withValues(alpha: 0.5)),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class _AboutPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;
  final Color surface;
  final List<BoxShadow> shadow;
  final VoidCallback? onTap;
  const _AboutPill({required this.icon, required this.label, required this.sub, required this.color, required this.surface, required this.shadow, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.18)),
        boxShadow: shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 10),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 2),
          Text(sub, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)), maxLines: 2),
        ],
      ),
    ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color iconColor;
  final VoidCallback? onTap;

  const _SettingsTile({required this.icon, required this.label, required this.subtitle, required this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.45))),
                ],
              ),
            ),
            if (onTap != null) Icon(Icons.chevron_right_rounded, size: 18, color: colorScheme.onSurface.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}

class _LangTile extends StatelessWidget {
  final String flag;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _LangTile({required this.flag, required this.label, required this.selected, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selected ? color.withValues(alpha: 0.12) : colorScheme.onSurface.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(flag, style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: TextStyle(fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? color : colorScheme.onSurface)),
            ),
            if (selected) Icon(Icons.check_circle_rounded, size: 20, color: color),
          ],
        ),
      ),
    );
  }
}

class HistoryScreen extends StatefulWidget {
  final List<WorkSession> history;
  final List<Expense> expenses;
  final double salary;
  final VoidCallback onClear;

  const HistoryScreen({
    super.key,
    required this.history,
    required this.expenses,
    required this.salary,
    required this.onClear,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _generatingPdf = false;
  final Set<String> _expandedMonths = {};

  @override
  void initState() {
    super.initState();
    // Current month expanded by default
    final now = DateTime.now();
    _expandedMonths.add(DateFormat('yyyy-MM').format(now));
  }

  // Returns months from the earliest expense date to now, newest first
  List<DateTime> _buildMonths() {
    if (widget.expenses.isEmpty) return [DateTime(DateTime.now().year, DateTime.now().month)];
    final earliest = widget.expenses
        .map((e) => DateTime(e.date.year, e.date.month))
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final now = DateTime.now();
    var cursor = DateTime(now.year, now.month);
    final months = <DateTime>[];
    while (!cursor.isBefore(earliest)) {
      months.add(cursor);
      cursor = DateTime(cursor.year, cursor.month - 1);
    }
    return months;
  }

  // Expenses active during a given month
  List<Expense> _expensesForMonth(DateTime month) {
    return widget.expenses.where((e) {
      final start = DateTime(e.date.year, e.date.month);
      if (start.isAfter(month)) return false;
      if (e.months == null || e.months == 0) return true;
      final end = DateTime(start.year, start.month + e.months!);
      return month.isBefore(end);
    }).toList();
  }

  static const _catColors = {
    'Food': Color(0xFFF59E0B), 'Groceries': Color(0xFF10B981),
    'Bills': Color(0xFF3B82F6), 'Transport': Color(0xFF8B5CF6),
    'Rent': Color(0xFFEF4444), 'Utilities': Color(0xFF06B6D4),
    'Health': Color(0xFFEC4899), 'Leisure': Color(0xFFF97316),
    'Shopping': Color(0xFF6366F1), 'Other': Color(0xFF94A3B8),
  };

  static const _catIcons = {
    'Food': Icons.restaurant_rounded, 'Groceries': Icons.shopping_cart_rounded,
    'Bills': Icons.description_rounded, 'Transport': Icons.directions_car_rounded,
    'Rent': Icons.home_rounded, 'Utilities': Icons.bolt_rounded,
    'Health': Icons.favorite_rounded, 'Leisure': Icons.sports_esports_rounded,
    'Shopping': Icons.shopping_bag_rounded, 'Other': Icons.category_rounded,
  };

  Future<void> _downloadPdf(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _generatingPdf = true);
    try {
      final doc = pw.Document();
      final fmt0 = NumberFormat.currency(symbol: 'RM ', decimalDigits: 0);
      final fmt2 = NumberFormat.currency(symbol: 'RM ', decimalDigits: 2);
      final months = _buildMonths();
      final netSalary = _estimateNetSalary(widget.salary);
      final totalExpenses = widget.expenses.fold(0.0, (s, e) => s + e.amount);

      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context ctx) {
            final sections = <pw.Widget>[];

            // Header
            sections.add(pw.Container(
              padding: const pw.EdgeInsets.only(bottom: 14),
              decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300))),
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Text('GajiMeter', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Monthly Expense History', style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey600)),
                ]),
                pw.Text('Generated: ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
              ]),
            ));
            sections.add(pw.SizedBox(height: 16));

            // Summary
            sections.add(pw.Text('Summary', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)));
            sections.add(pw.SizedBox(height: 6));
            sections.add(pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(color: PdfColors.grey100, borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6))),
              child: pw.Column(children: [
                _pdfRow('Gross Salary', fmt0.format(widget.salary)),
                _pdfRow('Net Salary (after EPF/SOCSO/EIS)', fmt0.format(netSalary)),
                _pdfRow('Total Monthly Commitments', fmt0.format(totalExpenses)),
                _pdfRow('Available', fmt0.format((netSalary - totalExpenses).clamp(0.0, double.infinity))),
              ]),
            ));
            sections.add(pw.SizedBox(height: 20));

            // Monthly breakdown
            for (final month in months) {
              final activeExpenses = _expensesForMonth(month);
              if (activeExpenses.isEmpty) continue;
              final monthTotal = activeExpenses.fold(0.0, (s, e) => s + e.amount);
              final label = DateFormat('MMMM yyyy').format(month);

              sections.add(pw.Container(
                margin: const pw.EdgeInsets.only(top: 10, bottom: 4),
                child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Text(label, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Text(fmt0.format(monthTotal),
                      style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.red700)),
                ]),
              ));

              for (final e in activeExpenses) {
                sections.add(pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                  decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200))),
                  child: pw.Row(children: [
                    pw.Expanded(flex: 2, child: pw.Text(e.category, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600))),
                    pw.Expanded(flex: 3, child: pw.Text(e.description, style: const pw.TextStyle(fontSize: 10))),
                    pw.Text(fmt2.format(e.amount), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ]),
                ));
              }
            }

            return sections;
          },
        ),
      );

      final bytes = await doc.save();
      final filename = 'GajiMeter_Expenses_${DateFormat('yyyyMM').format(DateTime.now())}.pdf';

      Directory dir;
      if (Platform.isAndroid) {
        dir = (await getExternalStorageDirectory()) ?? await getApplicationDocumentsDirectory();
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes);
      await OpenFilex.open(file.path);

      messenger.showSnackBar(SnackBar(
        content: Text('Saved: ${file.path}'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ));
    } catch (e) {
      messenger.showSnackBar(SnackBar(
        content: Text('PDF error: $e'),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
      ));
    } finally {
      if (mounted) setState(() => _generatingPdf = false);
    }
  }

  pw.Widget _pdfRow(String label, String value) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 3),
    child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      pw.Text(label, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
      pw.Text(value, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
    ]),
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = AppLang.of(context);
    final fmt0 = NumberFormat.currency(symbol: 'RM ', decimalDigits: 0);
    final bg = isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final months = _buildMonths();

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(lang.t('history_title'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1)),
                      Text(lang.t('history_subtitle'), style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.45), fontWeight: FontWeight.w500)),
                    ]),
                  ),
                  GestureDetector(
                    onTap: _generatingPdf ? null : () => _downloadPdf(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(14)),
                      child: _generatingPdf
                          ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onPrimary))
                          : Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.picture_as_pdf_rounded, size: 15, color: colorScheme.onPrimary),
                              const SizedBox(width: 6),
                              Text(lang.t('btn_download_pdf'), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colorScheme.onPrimary)),
                            ]),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: widget.expenses.isEmpty
                  ? Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.receipt_long_rounded, size: 56, color: colorScheme.onSurface.withValues(alpha: 0.2)),
                        const SizedBox(height: 12),
                        Text(lang.t('empty_no_expenses'), style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.4))),
                      ]),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 120),
                      children: [

                        // ── Monthly expense groups ──
                        ...months.map((month) {
                          final active = _expensesForMonth(month);
                          if (active.isEmpty) return const SizedBox.shrink();
                          final monthKey = DateFormat('yyyy-MM').format(month);
                          final monthTotal = active.fold(0.0, (s, e) => s + e.amount);
                          final label = DateFormat('MMMM yyyy').format(month);
                          final isExpanded = _expandedMonths.contains(monthKey);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: colorScheme.primary.withValues(alpha: 0.12)),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withValues(alpha: isDark ? 0.06 : 0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Column(
                                children: [
                                  // ── Coloured top accent bar ──
                                  Container(
                                    height: 3,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [colorScheme.primary, colorScheme.secondary],
                                      ),
                                    ),
                                  ),

                                  // ── Month header (tap to toggle) ──
                                  InkWell(
                                    onTap: () => setState(() {
                                      if (isExpanded) {
                                        _expandedMonths.remove(monthKey);
                                      } else {
                                        _expandedMonths.add(monthKey);
                                      }
                                    }),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: colorScheme.primary.withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: colorScheme.primary)),
                                          ),
                                          const SizedBox(width: 8),
                                          Text('${active.length} items', style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withValues(alpha: 0.4))),
                                          const Spacer(),
                                          Text('− ${fmt0.format(monthTotal)}',
                                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFEF4444))),
                                          const SizedBox(width: 6),
                                          AnimatedRotation(
                                            turns: isExpanded ? 0.0 : -0.25,
                                            duration: const Duration(milliseconds: 200),
                                            child: Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: colorScheme.primary.withValues(alpha: 0.6)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // ── Expense items (animated expand/collapse) ──
                                  AnimatedCrossFade(
                                    firstChild: Padding(
                                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                                      child: Column(
                                        children: active.map((e) {
                                          final color = _catColors[e.category] ?? const Color(0xFF94A3B8);
                                          final icon = _catIcons[e.category] ?? Icons.category_rounded;
                                          return Container(
                                            margin: const EdgeInsets.only(bottom: 8),
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: colorScheme.primary.withValues(alpha: isDark ? 0.05 : 0.03),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: colorScheme.primary.withValues(alpha: 0.08)),
                                            ),
                                            child: Row(children: [
                                              Container(
                                                width: 34, height: 34,
                                                decoration: BoxDecoration(color: color.withValues(alpha: 0.14), shape: BoxShape.circle),
                                                child: Icon(icon, size: 15, color: color),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(e.description, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                                                  Text(e.category, style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withValues(alpha: 0.4))),
                                                ],
                                              )),
                                              Text(fmt0.format(e.amount), style: TextStyle(fontWeight: FontWeight.w900, color: color)),
                                            ]),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    secondChild: const SizedBox.shrink(),
                                    crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                    duration: const Duration(milliseconds: 250),
                                    sizeCurve: Curves.easeInOut,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color color, ColorScheme colorScheme) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.6))),
      Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
    ],
  );
}

class WorkSession {
  final DateTime date;
  final double amount;
  final int durationMillis;

  WorkSession({required this.date, required this.amount, required this.durationMillis});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'amount': amount,
        'durationMillis': durationMillis,
      };

  factory WorkSession.fromJson(Map<String, dynamic> json) => WorkSession(
        date: DateTime.parse(json['date']),
        amount: json['amount'],
        durationMillis: json['durationMillis'],
      );
}

class Expense {
  final String id;
  final DateTime date;
  final String category;
  final String? subCategory;
  final String description;
  final double amount;
  final int? months;

  Expense({
    required this.id,
    required this.date,
    required this.category,
    this.subCategory,
    required this.description,
    required this.amount,
    this.months,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'category': category,
        'subCategory': subCategory,
        'description': description,
        'amount': amount,
        'months': months,
      };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.parse(json['date']),
        category: json['category'],
        subCategory: json['subCategory'],
        description: json['description'],
        amount: json['amount'],
        months: json['months'],
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// WorthScreen — "Is this item worth it?"
// ─────────────────────────────────────────────────────────────────────────────

class WorthScreen extends StatefulWidget {
  final double salary;
  final int workDays;
  final int workHours;

  const WorthScreen({super.key, required this.salary, required this.workDays, required this.workHours});

  @override
  State<WorthScreen> createState() => _WorthScreenState();
}

class _WorthScreenState extends State<WorthScreen> {
  final _itemCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  double? _resultSeconds;
  String? _itemName;
  double? _itemPrice;
  String? _reflection;

  double get _secondRate {
    if (widget.salary <= 0 || widget.workDays <= 0 || widget.workHours <= 0) return 0;
    return widget.salary / (widget.workDays * widget.workHours * 3600);
  }

  void _calculate() {
    final price = double.tryParse(_priceCtrl.text.replaceAll(',', '.'));
    if (price == null || price <= 0 || _secondRate <= 0) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _itemName = _itemCtrl.text.trim().isEmpty ? null : _itemCtrl.text.trim();
      _itemPrice = price;
      _resultSeconds = price / _secondRate;
      _reflection = null;
    });
  }

  String _formatTime(BuildContext context, double seconds, AppLang lang) {
    if (seconds < 60) return "${seconds.toStringAsFixed(0)} ${lang.t('worth_result_sec')}";
    if (seconds < 3600) return "${(seconds / 60).toStringAsFixed(1)} ${lang.t('worth_result_min')}";
    return "${(seconds / 3600).toStringAsFixed(1)} ${lang.t('worth_result_hr')}";
  }

  @override
  void dispose() {
    _itemCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final lang = AppLang.of(context);
    final bg = isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final fieldFill = colorScheme.onSurface.withValues(alpha: 0.06);
    final currencyFormat = NumberFormat.currency(symbol: "RM ", decimalDigits: 2);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(lang.t('worth_title'), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.5)),
              const SizedBox(height: 4),
              Text(lang.t('worth_subtitle'), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
              const SizedBox(height: 32),

              // Input card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.06)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _itemCtrl,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: lang.t('worth_item_label'),
                        filled: true, fillColor: fieldFill,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                        prefixIcon: Icon(Icons.label_outline_rounded, color: colorScheme.primary),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _priceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: lang.t('worth_price_label'),
                        filled: true, fillColor: fieldFill,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                        prefixIcon: Icon(Icons.attach_money_rounded, color: colorScheme.primary),
                        prefixText: "RM ",
                      ),
                      onSubmitted: (_) => _calculate(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity, height: 52,
                      child: ElevatedButton(
                        onPressed: widget.salary > 0 ? _calculate : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text(lang.t('worth_calculate'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                      ),
                    ),
                    if (widget.salary <= 0) ...[
                      const SizedBox(height: 10),
                      Text(lang.t('worth_setup_hint'), style: TextStyle(fontSize: 11, color: colorScheme.onSurface.withValues(alpha: 0.4)), textAlign: TextAlign.center),
                    ],
                  ],
                ),
              ),

              // Result card
              if (_resultSeconds != null) ...[
                const SizedBox(height: 20),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.75)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_itemName != null)
                        Text(_itemName!, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormat.format(_itemPrice),
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "= ${_formatTime(context, _resultSeconds!, lang)}",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(lang.t('motivate_value'), style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),

                // Need / Want / Later
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.06)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Worth it?", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: colorScheme.onSurface)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _WorthChip(
                            label: lang.t('worth_need'),
                            icon: Icons.check_circle_rounded,
                            color: const Color(0xFF10B981),
                            selected: _reflection == 'need',
                            onTap: () => setState(() => _reflection = 'need'),
                          ),
                          const SizedBox(width: 10),
                          _WorthChip(
                            label: lang.t('worth_want'),
                            icon: Icons.favorite_rounded,
                            color: const Color(0xFF8B5CF6),
                            selected: _reflection == 'want',
                            onTap: () => setState(() => _reflection = 'want'),
                          ),
                          const SizedBox(width: 10),
                          _WorthChip(
                            label: lang.t('worth_later'),
                            icon: Icons.watch_later_rounded,
                            color: const Color(0xFFF59E0B),
                            selected: _reflection == 'later',
                            onTap: () => setState(() => _reflection = 'later'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              // Motivational footer
              const SizedBox(height: 32),
              Center(
                child: Text(
                  lang.t('motivate_every_second'),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.onSurface.withValues(alpha: 0.25)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorthChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _WorthChip({required this.label, required this.icon, required this.color, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.15) : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? color : Colors.transparent, width: 1.5),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: selected ? color : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: selected ? color : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4))),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _InfoCard — compact card for payday / safe spend
// ─────────────────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? valueUnit;
  final Color color;
  final bool isDark;

  const _InfoCard({required this.icon, required this.label, required this.value, this.valueUnit, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color, letterSpacing: -0.5)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color.withValues(alpha: 0.6)), maxLines: 2),
        ],
      ),
    );
  }
}

double _estimateNetSalary(double gross) {
  if (gross <= 0) return 0.0;
  final kwsp = gross * 0.11;
  final socso = (gross * 0.005).clamp(0.0, 19.75);
  final eis = (gross * 0.002).clamp(0.0, 7.90);
  return gross - kwsp - socso - eis;
}



// ─────────────────────────────────────────────────────────────────────────────
// _MoneyOverviewCard — balance left + safe spend summary in Money tab
// ─────────────────────────────────────────────────────────────────────────────

class _MoneyOverviewCard extends StatelessWidget {
  final double salary;
  final double totalExpenses;
  final int paydayDay;
  final int formulaIndex;
  final double customFoodDaily;

  const _MoneyOverviewCard({
    required this.salary,
    required this.totalExpenses,
    required this.paydayDay,
    required this.formulaIndex,
    required this.customFoodDaily,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = AppLang.of(context);
    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final fmt0 = NumberFormat.currency(symbol: "RM ", decimalDigits: 0);

    final netSalary = _estimateNetSalary(salary);
    final foodMonthly = customFoodDaily * 30;
    final afterKomitmen = netSalary - totalExpenses;
    final leftover = (afterKomitmen - foodMonthly).clamp(0.0, double.infinity);

    final formulas = _getBudgetFormulas(lang.langKey);
    final f = formulas[formulaIndex.clamp(0, formulas.length - 1)];
    final splitTotal = f.bolehSpend + f.saving + f.buffer;
    final spend  = splitTotal > 0 ? leftover * f.bolehSpend / splitTotal : 0.0;
    final saving = splitTotal > 0 ? leftover * f.saving   / splitTotal : 0.0;
    final buffer = splitTotal > 0 ? leftover * f.buffer   / splitTotal : 0.0;

    final noData = salary <= 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.06)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.account_balance_rounded, color: colorScheme.primary, size: 18),
            const SizedBox(width: 8),
            Text(lang.t('overview_title'), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: colorScheme.onSurface)),
          ]),
          const SizedBox(height: 16),
          _row(icon: Icons.payments_rounded, label: lang.t('overview_net_salary'), sub: lang.t('overview_net_note'),
              value: noData ? '--' : fmt0.format(netSalary), color: const Color(0xFF10B981), colorScheme: colorScheme),
          _divider(colorScheme),
          _row(icon: Icons.receipt_long_rounded, label: lang.t('overview_komitmen'), sub: lang.t('overview_komitmen_note'),
              value: noData ? '--' : "− ${fmt0.format(totalExpenses)}", color: const Color(0xFFEF4444), colorScheme: colorScheme),
          _divider(colorScheme),
          _row(icon: Icons.restaurant_rounded, label: lang.t('overview_makan'), sub: "${fmt0.format(customFoodDaily)} ${lang.t('per_hari')} × 30",
              value: noData ? '--' : "− ${fmt0.format(foodMonthly)}", color: const Color(0xFFF59E0B), colorScheme: colorScheme),
          _divider(colorScheme),
          _row(icon: Icons.wallet_rounded, label: lang.t('overview_baki'), sub: lang.t('overview_baki_note'),
              value: noData ? '--' : fmt0.format(leftover),
              color: leftover > 0 ? colorScheme.primary : const Color(0xFFEF4444), colorScheme: colorScheme),
          if (!noData && leftover > 0) ...[
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: _chip(label: lang.t('label_spend'),        value: fmt0.format(spend),  color: colorScheme.primary,    icon: Icons.shopping_bag_rounded, isDark: isDark)),
              const SizedBox(width: 8),
              Expanded(child: _chip(label: lang.t('bucket_saving'),      value: fmt0.format(saving), color: const Color(0xFF10B981), icon: Icons.diamond_rounded,      isDark: isDark)),
              const SizedBox(width: 8),
              Expanded(child: _chip(label: lang.t('label_buffer'),       value: fmt0.format(buffer), color: const Color(0xFF6366F1), icon: Icons.shield_rounded,       isDark: isDark)),
            ]),
          ],
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.info_outline_rounded, size: 11, color: colorScheme.onSurface.withValues(alpha: 0.3)),
            const SizedBox(width: 4),
            Expanded(child: Text(lang.t('overview_note'), style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withValues(alpha: 0.35)))),
          ]),
        ],
      ),
    );
  }

  Widget _row({required IconData icon, required String label, required String sub, required String value, required Color color, required ColorScheme colorScheme}) {
    return Row(children: [
      Container(width: 34, height: 34, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 16, color: color)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.onSurface.withValues(alpha: 0.7))),
        Text(sub, style: TextStyle(fontSize: 10, color: colorScheme.onSurface.withValues(alpha: 0.35))),
      ])),
      Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color)),
    ]);
  }

  Widget _chip({required String label, required String value, required Color color, required IconData icon, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color)),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color.withValues(alpha: 0.7))),
      ]),
    );
  }

  Widget _divider(ColorScheme colorScheme) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Divider(color: colorScheme.onSurface.withValues(alpha: 0.06), height: 1),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// _WorkSetupCard — salary / payday / days / hours in Settings
// ─────────────────────────────────────────────────────────────────────────────

class _WorkSetupCard extends StatefulWidget {
  final TextEditingController salaryController;
  final TextEditingController daysController;
  final TextEditingController hoursController;
  final int paydayDay;
  final Function(int) onPaydayChanged;
  final VoidCallback onChanged;

  const _WorkSetupCard({
    required this.salaryController,
    required this.daysController,
    required this.hoursController,
    required this.paydayDay,
    required this.onPaydayChanged,
    required this.onChanged,
  });

  @override
  State<_WorkSetupCard> createState() => _WorkSetupCardState();
}

class _WorkSetupCardState extends State<_WorkSetupCard> {
  late TextEditingController _paydayCtrl;

  @override
  void initState() {
    super.initState();
    _paydayCtrl = TextEditingController(text: widget.paydayDay.toString());
  }

  @override
  void didUpdateWidget(_WorkSetupCard old) {
    super.didUpdateWidget(old);
    if (old.paydayDay != widget.paydayDay) {
      _paydayCtrl.text = widget.paydayDay.toString();
    }
  }

  @override
  void dispose() {
    _paydayCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final fieldFill = colorScheme.onSurface.withValues(alpha: 0.06);

    Widget field(String label, TextEditingController ctrl, {String? prefix, String? suffix}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: fieldFill,
          borderRadius: BorderRadius.circular(14),
        ),
        child: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          onChanged: (_) => widget.onChanged(),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          decoration: InputDecoration(
            labelText: label,
            prefixText: prefix != null ? "$prefix " : null,
            suffixText: suffix,
            border: InputBorder.none,
            labelStyle: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.45)),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          field("Monthly Salary", widget.salaryController, prefix: "RM"),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: field("Work Days / Month", widget.daysController, suffix: "days")),
              const SizedBox(width: 10),
              Expanded(child: field("Hours / Day", widget.hoursController, suffix: "hrs")),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(color: fieldFill, borderRadius: BorderRadius.circular(14)),
            child: TextField(
              controller: _paydayCtrl,
              keyboardType: TextInputType.number,
              onChanged: (v) {
                final d = int.tryParse(v);
                if (d != null && d >= 1 && d <= 31) widget.onPaydayChanged(d);
              },
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              decoration: InputDecoration(
                labelText: "Payday — Day of Month",
                suffixText: "of every month",
                border: InputBorder.none,
                labelStyle: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.45)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
