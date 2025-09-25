// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Sign in`
  String get sign_in {
    return Intl.message(
      'Sign in',
      name: 'sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Please input password`
  String get please_input_password {
    return Intl.message(
      'Please input password',
      name: 'please_input_password',
      desc: '',
      args: [],
    );
  }

  /// `Please input username`
  String get please_input_username {
    return Intl.message(
      'Please input username',
      name: 'please_input_username',
      desc: '',
      args: [],
    );
  }

  /// `Please enter name`
  String get please_input_name {
    return Intl.message(
      'Please enter name',
      name: 'please_input_name',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `The password length must be at least 6 characters`
  String get password_lengtherror {
    return Intl.message(
      'The password length must be at least 6 characters',
      name: 'password_lengtherror',
      desc: '',
      args: [],
    );
  }

  /// `The username cannot be empty`
  String get username_lengtherror {
    return Intl.message(
      'The username cannot be empty',
      name: 'username_lengtherror',
      desc: '',
      args: [],
    );
  }

  /// `Login Success`
  String get login_success {
    return Intl.message(
      'Login Success',
      name: 'login_success',
      desc: '',
      args: [],
    );
  }

  /// `Login Failed`
  String get login_failed {
    return Intl.message(
      'Login Failed',
      name: 'login_failed',
      desc: '',
      args: [],
    );
  }

  /// `Project`
  String get project_num {
    return Intl.message(
      'Project',
      name: 'project_num',
      desc: '',
      args: [],
    );
  }

  /// `MG`
  String get mg_num {
    return Intl.message(
      'MG',
      name: 'mg_num',
      desc: '',
      args: [],
    );
  }

  /// `ESS`
  String get ess_num {
    return Intl.message(
      'ESS',
      name: 'ess_num',
      desc: '',
      args: [],
    );
  }

  /// `PV`
  String get pv_num {
    return Intl.message(
      'PV',
      name: 'pv_num',
      desc: '',
      args: [],
    );
  }

  /// `MG`
  String get mg {
    return Intl.message(
      'MG',
      name: 'mg',
      desc: '',
      args: [],
    );
  }

  /// `ESS`
  String get ess {
    return Intl.message(
      'ESS',
      name: 'ess',
      desc: '',
      args: [],
    );
  }

  /// `PV`
  String get pv {
    return Intl.message(
      'PV',
      name: 'pv',
      desc: '',
      args: [],
    );
  }

  /// `No.`
  String get num {
    return Intl.message(
      'No.',
      name: 'num',
      desc: '',
      args: [],
    );
  }

  /// `Charger`
  String get charger {
    return Intl.message(
      'Charger',
      name: 'charger',
      desc: '',
      args: [],
    );
  }

  /// `Charger`
  String get charger_num {
    return Intl.message(
      'Charger',
      name: 'charger_num',
      desc: '',
      args: [],
    );
  }

  /// `MG Info`
  String get mg_info {
    return Intl.message(
      'MG Info',
      name: 'mg_info',
      desc: '',
      args: [],
    );
  }

  /// `ESS Info`
  String get ess_info {
    return Intl.message(
      'ESS Info',
      name: 'ess_info',
      desc: '',
      args: [],
    );
  }

  /// `PV Info`
  String get pv_info {
    return Intl.message(
      'PV Info',
      name: 'pv_info',
      desc: '',
      args: [],
    );
  }

  /// `Charger Info`
  String get charger_info {
    return Intl.message(
      'Charger Info',
      name: 'charger_info',
      desc: '',
      args: [],
    );
  }

  /// `No Data Available`
  String get no_data {
    return Intl.message(
      'No Data Available',
      name: 'no_data',
      desc: '',
      args: [],
    );
  }

  /// `Data Overview`
  String get data_overview {
    return Intl.message(
      'Data Overview',
      name: 'data_overview',
      desc: '',
      args: [],
    );
  }

  /// `Revenue Overview`
  String get revenue_overview {
    return Intl.message(
      'Revenue Overview',
      name: 'revenue_overview',
      desc: '',
      args: [],
    );
  }

  /// `Revenue`
  String get revenue {
    return Intl.message(
      'Revenue',
      name: 'revenue',
      desc: '',
      args: [],
    );
  }

  /// `Generation power`
  String get generation_power {
    return Intl.message(
      'Generation power',
      name: 'generation_power',
      desc: '',
      args: [],
    );
  }

  /// `Monitoring load`
  String get monitoring_load {
    return Intl.message(
      'Monitoring load',
      name: 'monitoring_load',
      desc: '',
      args: [],
    );
  }

  /// `Adjustable load`
  String get adjustable_load {
    return Intl.message(
      'Adjustable load',
      name: 'adjustable_load',
      desc: '',
      args: [],
    );
  }

  /// `Today's/Total revenue(10k)`
  String get todayTotalRevenue {
    return Intl.message(
      'Today\'s/Total revenue(10k)',
      name: 'todayTotalRevenue',
      desc: '',
      args: [],
    );
  }

  /// `yuan`
  String get yuan {
    return Intl.message(
      'yuan',
      name: 'yuan',
      desc: '',
      args: [],
    );
  }

  /// `10k RMB`
  String get tenk_RMB {
    return Intl.message(
      '10k RMB',
      name: 'tenk_RMB',
      desc: '',
      args: [],
    );
  }

  /// `yuan/10k RMB`
  String get yuan_per_tenk_RMB {
    return Intl.message(
      'yuan/10k RMB',
      name: 'yuan_per_tenk_RMB',
      desc: '',
      args: [],
    );
  }

  /// `Last month revenue(10k)`
  String get Last_Month_revenue_10k {
    return Intl.message(
      'Last month revenue(10k)',
      name: 'Last_Month_revenue_10k',
      desc: '',
      args: [],
    );
  }

  /// `This month revenue(10k)`
  String get This_Month_revenue_10k {
    return Intl.message(
      'This month revenue(10k)',
      name: 'This_Month_revenue_10k',
      desc: '',
      args: [],
    );
  }

  /// `Total revenue(10k)`
  String get Total_revenue_10k {
    return Intl.message(
      'Total revenue(10k)',
      name: 'Total_revenue_10k',
      desc: '',
      args: [],
    );
  }

  /// `Dividend revenue(10k)`
  String get dividend_revenue_10k {
    return Intl.message(
      'Dividend revenue(10k)',
      name: 'dividend_revenue_10k',
      desc: '',
      args: [],
    );
  }

  /// `D`
  String get day {
    return Intl.message(
      'D',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `M`
  String get month {
    return Intl.message(
      'M',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Y`
  String get year {
    return Intl.message(
      'Y',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Investment Summary`
  String get investment_summary {
    return Intl.message(
      'Investment Summary',
      name: 'investment_summary',
      desc: '',
      args: [],
    );
  }

  /// `Investment amount`
  String get investment_amount {
    return Intl.message(
      'Investment amount',
      name: 'investment_amount',
      desc: '',
      args: [],
    );
  }

  /// `Amount increase`
  String get amount_increase {
    return Intl.message(
      'Amount increase',
      name: 'amount_increase',
      desc: '',
      args: [],
    );
  }

  /// `Operational projects`
  String get operational_projects {
    return Intl.message(
      'Operational projects',
      name: 'operational_projects',
      desc: '',
      args: [],
    );
  }

  /// `New projects`
  String get new_projects {
    return Intl.message(
      'New projects',
      name: 'new_projects',
      desc: '',
      args: [],
    );
  }

  /// `Retired projects`
  String get retired_projects {
    return Intl.message(
      'Retired projects',
      name: 'retired_projects',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message(
      'Dashboard',
      name: 'dashboard',
      desc: '',
      args: [],
    );
  }

  /// `Project`
  String get project {
    return Intl.message(
      'Project',
      name: 'project',
      desc: '',
      args: [],
    );
  }

  /// `Mine`
  String get mine {
    return Intl.message(
      'Mine',
      name: 'mine',
      desc: '',
      args: [],
    );
  }

  /// `Total projects`
  String get total_projects {
    return Intl.message(
      'Total projects',
      name: 'total_projects',
      desc: '',
      args: [],
    );
  }

  /// `Maintenance`
  String get maintenance {
    return Intl.message(
      'Maintenance',
      name: 'maintenance',
      desc: '',
      args: [],
    );
  }

  /// `Normal`
  String get normal {
    return Intl.message(
      'Normal',
      name: 'normal',
      desc: '',
      args: [],
    );
  }

  /// `Abnormal`
  String get abnormal {
    return Intl.message(
      'Abnormal',
      name: 'abnormal',
      desc: '',
      args: [],
    );
  }

  /// `Offline`
  String get offline {
    return Intl.message(
      'Offline',
      name: 'offline',
      desc: '',
      args: [],
    );
  }

  /// `Back to Home`
  String get back_to_home {
    return Intl.message(
      'Back to Home',
      name: 'back_to_home',
      desc: '',
      args: [],
    );
  }

  /// `Single View`
  String get single_view {
    return Intl.message(
      'Single View',
      name: 'single_view',
      desc: '',
      args: [],
    );
  }

  /// `GCT`
  String get grid_connection_time {
    return Intl.message(
      'GCT',
      name: 'grid_connection_time',
      desc: '',
      args: [],
    );
  }

  /// `Site name`
  String get site_name {
    return Intl.message(
      'Site name',
      name: 'site_name',
      desc: '',
      args: [],
    );
  }

  /// `Rated power(kW)`
  String get rated_power_kW {
    return Intl.message(
      'Rated power(kW)',
      name: 'rated_power_kW',
      desc: '',
      args: [],
    );
  }

  /// `Power station status`
  String get power_station_status {
    return Intl.message(
      'Power station status',
      name: 'power_station_status',
      desc: '',
      args: [],
    );
  }

  /// `Installed capacity(kWp)`
  String get installed_capacity_kWp {
    return Intl.message(
      'Installed capacity(kWp)',
      name: 'installed_capacity_kWp',
      desc: '',
      args: [],
    );
  }

  /// `Installed capacity(kWh)`
  String get installed_capacity_kWh {
    return Intl.message(
      'Installed capacity(kWh)',
      name: 'installed_capacity_kWh',
      desc: '',
      args: [],
    );
  }

  /// `Installed capacity(MW)`
  String get installed_capacity_MW {
    return Intl.message(
      'Installed capacity(MW)',
      name: 'installed_capacity_MW',
      desc: '',
      args: [],
    );
  }

  /// `Device`
  String get device {
    return Intl.message(
      'Device',
      name: 'device',
      desc: '',
      args: [],
    );
  }

  /// `User type`
  String get user_type {
    return Intl.message(
      'User type',
      name: 'user_type',
      desc: '',
      args: [],
    );
  }

  /// `Super administrator`
  String get super_administrator {
    return Intl.message(
      'Super administrator',
      name: 'super_administrator',
      desc: '',
      args: [],
    );
  }

  /// `Single station user`
  String get single_station_user {
    return Intl.message(
      'Single station user',
      name: 'single_station_user',
      desc: '',
      args: [],
    );
  }

  /// `Investor`
  String get investor {
    return Intl.message(
      'Investor',
      name: 'investor',
      desc: '',
      args: [],
    );
  }

  /// `Operation analyst`
  String get operation_analyst {
    return Intl.message(
      'Operation analyst',
      name: 'operation_analyst',
      desc: '',
      args: [],
    );
  }

  /// `Operation and maintenance personnel`
  String get operation_and_maintenance_personnel {
    return Intl.message(
      'Operation and maintenance personnel',
      name: 'operation_and_maintenance_personnel',
      desc: '',
      args: [],
    );
  }

  /// `Equipment supplier`
  String get equipment_supplier {
    return Intl.message(
      'Equipment supplier',
      name: 'equipment_supplier',
      desc: '',
      args: [],
    );
  }

  /// `Unknown type`
  String get unknown_type {
    return Intl.message(
      'Unknown type',
      name: 'unknown_type',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get change_password {
    return Intl.message(
      'Change password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Update version`
  String get update_version {
    return Intl.message(
      'Update version',
      name: 'update_version',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `New version`
  String get new_version_available {
    return Intl.message(
      'New version',
      name: 'new_version_available',
      desc: '',
      args: [],
    );
  }

  /// `Please input old password`
  String get please_input_old_password {
    return Intl.message(
      'Please input old password',
      name: 'please_input_old_password',
      desc: '',
      args: [],
    );
  }

  /// `Old password cannot be empty`
  String get old_password_cannot_be_empty {
    return Intl.message(
      'Old password cannot be empty',
      name: 'old_password_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Please input new password`
  String get please_input_new_password {
    return Intl.message(
      'Please input new password',
      name: 'please_input_new_password',
      desc: '',
      args: [],
    );
  }

  /// `New password cannot be empty`
  String get new_password_cannot_be_empty {
    return Intl.message(
      'New password cannot be empty',
      name: 'new_password_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Please input confirm password`
  String get please_input_confirm_password {
    return Intl.message(
      'Please input confirm password',
      name: 'please_input_confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password cannot be empty`
  String get confirm_password_cannot_be_empty {
    return Intl.message(
      'Confirm password cannot be empty',
      name: 'confirm_password_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Password mismatch`
  String get password_mismatch {
    return Intl.message(
      'Password mismatch',
      name: 'password_mismatch',
      desc: '',
      args: [],
    );
  }

  /// `Password updated successfully`
  String get password_updated_successfully {
    return Intl.message(
      'Password updated successfully',
      name: 'password_updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Revenue analysis`
  String get revenue_analysis {
    return Intl.message(
      'Revenue analysis',
      name: 'revenue_analysis',
      desc: '',
      args: [],
    );
  }

  /// `Strategy management`
  String get strategy_management {
    return Intl.message(
      'Strategy management',
      name: 'strategy_management',
      desc: '',
      args: [],
    );
  }

  /// `Electricity price periods`
  String get electricity_price_periods {
    return Intl.message(
      'Electricity price periods',
      name: 'electricity_price_periods',
      desc: '',
      args: [],
    );
  }

  /// `Reports statements`
  String get reports_statements {
    return Intl.message(
      'Reports statements',
      name: 'reports_statements',
      desc: '',
      args: [],
    );
  }

  /// `Settement management`
  String get settlement_management {
    return Intl.message(
      'Settement management',
      name: 'settlement_management',
      desc: '',
      args: [],
    );
  }

  /// `PV monitoring`
  String get photovoltaic_monitoring {
    return Intl.message(
      'PV monitoring',
      name: 'photovoltaic_monitoring',
      desc: '',
      args: [],
    );
  }

  /// `ESS monitoring`
  String get energy_storage_monitoring {
    return Intl.message(
      'ESS monitoring',
      name: 'energy_storage_monitoring',
      desc: '',
      args: [],
    );
  }

  /// `Fault alarm`
  String get fault_alarm {
    return Intl.message(
      'Fault alarm',
      name: 'fault_alarm',
      desc: '',
      args: [],
    );
  }

  /// `Operating`
  String get operating {
    return Intl.message(
      'Operating',
      name: 'operating',
      desc: '',
      args: [],
    );
  }

  /// `Operational`
  String get operational {
    return Intl.message(
      'Operational',
      name: 'operational',
      desc: '',
      args: [],
    );
  }

  /// `Operational_Data`
  String get operational_data {
    return Intl.message(
      'Operational_Data',
      name: 'operational_data',
      desc: '',
      args: [],
    );
  }

  /// `Search application modules`
  String get search_application_modules {
    return Intl.message(
      'Search application modules',
      name: 'search_application_modules',
      desc: '',
      args: [],
    );
  }

  /// `Today/Year PV generation`
  String get today_toyear_PV_generation {
    return Intl.message(
      'Today/Year PV generation',
      name: 'today_toyear_PV_generation',
      desc: '',
      args: [],
    );
  }

  /// `Total generation/on-grid`
  String get total_generation_on_grid {
    return Intl.message(
      'Total generation/on-grid',
      name: 'total_generation_on_grid',
      desc: '',
      args: [],
    );
  }

  /// `Today/Year/Total revenue`
  String get revenue_today_toyear_total {
    return Intl.message(
      'Today/Year/Total revenue',
      name: 'revenue_today_toyear_total',
      desc: '',
      args: [],
    );
  }

  /// `Carbon reduction`
  String get carbon_reduction {
    return Intl.message(
      'Carbon reduction',
      name: 'carbon_reduction',
      desc: '',
      args: [],
    );
  }

  /// `This month/Total carbon reduction`
  String get thismonth_total_carbon_reduction {
    return Intl.message(
      'This month/Total carbon reduction',
      name: 'thismonth_total_carbon_reduction',
      desc: '',
      args: [],
    );
  }

  /// `This month/Total Absorption rate`
  String get thismonth_total_Absorption_rate {
    return Intl.message(
      'This month/Total Absorption rate',
      name: 'thismonth_total_Absorption_rate',
      desc: '',
      args: [],
    );
  }

  /// `Power`
  String get power {
    return Intl.message(
      'Power',
      name: 'power',
      desc: '',
      args: [],
    );
  }

  /// `Energy today`
  String get energy_today {
    return Intl.message(
      'Energy today',
      name: 'energy_today',
      desc: '',
      args: [],
    );
  }

  /// `On-grid today`
  String get on_grid_today {
    return Intl.message(
      'On-grid today',
      name: 'on_grid_today',
      desc: '',
      args: [],
    );
  }

  /// `Gen today`
  String get gen_today {
    return Intl.message(
      'Gen today',
      name: 'gen_today',
      desc: '',
      args: [],
    );
  }

  /// `EleUsageToday`
  String get ele_usage_today {
    return Intl.message(
      'EleUsageToday',
      name: 'ele_usage_today',
      desc: '',
      args: [],
    );
  }

  /// `Consumption % today`
  String get absorption_rate_today {
    return Intl.message(
      'Consumption % today',
      name: 'absorption_rate_today',
      desc: '',
      args: [],
    );
  }

  /// `Full Generation Hr today`
  String get full_service_hours_today {
    return Intl.message(
      'Full Generation Hr today',
      name: 'full_service_hours_today',
      desc: '',
      args: [],
    );
  }

  /// `Power curve`
  String get power_curve {
    return Intl.message(
      'Power curve',
      name: 'power_curve',
      desc: '',
      args: [],
    );
  }

  /// `Electricity index`
  String get electricity_index {
    return Intl.message(
      'Electricity index',
      name: 'electricity_index',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday power`
  String get yesterday_power {
    return Intl.message(
      'Yesterday power',
      name: 'yesterday_power',
      desc: '',
      args: [],
    );
  }

  /// `Today power`
  String get today_power {
    return Intl.message(
      'Today power',
      name: 'today_power',
      desc: '',
      args: [],
    );
  }

  /// `Today grid power`
  String get today_grid_power {
    return Intl.message(
      'Today grid power',
      name: 'today_grid_power',
      desc: '',
      args: [],
    );
  }

  /// `Generation`
  String get generation {
    return Intl.message(
      'Generation',
      name: 'generation',
      desc: '',
      args: [],
    );
  }

  /// `On-grid`
  String get on_grid {
    return Intl.message(
      'On-grid',
      name: 'on_grid',
      desc: '',
      args: [],
    );
  }

  /// `Absorption rate`
  String get absorption_rate {
    return Intl.message(
      'Absorption rate',
      name: 'absorption_rate',
      desc: '',
      args: [],
    );
  }

  /// `Daily full generation hours`
  String get daily_full_generation_hours {
    return Intl.message(
      'Daily full generation hours',
      name: 'daily_full_generation_hours',
      desc: '',
      args: [],
    );
  }

  /// `Running data`
  String get running_data {
    return Intl.message(
      'Running data',
      name: 'running_data',
      desc: '',
      args: [],
    );
  }

  /// `Running status`
  String get running_status {
    return Intl.message(
      'Running status',
      name: 'running_status',
      desc: '',
      args: [],
    );
  }

  /// `Total charging`
  String get total_charging {
    return Intl.message(
      'Total charging',
      name: 'total_charging',
      desc: '',
      args: [],
    );
  }

  /// `Total discharge`
  String get total_discharge {
    return Intl.message(
      'Total discharge',
      name: 'total_discharge',
      desc: '',
      args: [],
    );
  }

  /// `Charging capacity`
  String get charging_capacity {
    return Intl.message(
      'Charging capacity',
      name: 'charging_capacity',
      desc: '',
      args: [],
    );
  }

  /// `Discharging capacity`
  String get discharging_capacity {
    return Intl.message(
      'Discharging capacity',
      name: 'discharging_capacity',
      desc: '',
      args: [],
    );
  }

  /// `Enterprise load`
  String get enterprise_load {
    return Intl.message(
      'Enterprise load',
      name: 'enterprise_load',
      desc: '',
      args: [],
    );
  }

  /// `Grid`
  String get grid {
    return Intl.message(
      'Grid',
      name: 'grid',
      desc: '',
      args: [],
    );
  }

  /// `OT`
  String get occurrence_time {
    return Intl.message(
      'OT',
      name: 'occurrence_time',
      desc: '',
      args: [],
    );
  }

  /// `Ele today`
  String get electricity_consumption_today {
    return Intl.message(
      'Ele today',
      name: 'electricity_consumption_today',
      desc: '',
      args: [],
    );
  }

  /// `MMd`
  String get monthly_peak_demand {
    return Intl.message(
      'MMd',
      name: 'monthly_peak_demand',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Daily charging`
  String get daily_charging {
    return Intl.message(
      'Daily charging',
      name: 'daily_charging',
      desc: '',
      args: [],
    );
  }

  /// `Daily discharge`
  String get daily_discharge {
    return Intl.message(
      'Daily discharge',
      name: 'daily_discharge',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message(
      'Yesterday',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday grid`
  String get yesterday_grid {
    return Intl.message(
      'Yesterday grid',
      name: 'yesterday_grid',
      desc: '',
      args: [],
    );
  }

  /// `Today grid`
  String get today_grid {
    return Intl.message(
      'Today grid',
      name: 'today_grid',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get to_year {
    return Intl.message(
      'Year',
      name: 'to_year',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get to_month {
    return Intl.message(
      'Month',
      name: 'to_month',
      desc: '',
      args: [],
    );
  }

  /// `Charge/discharge ratio this year`
  String get charge_discharge_ratio_this_year {
    return Intl.message(
      'Charge/discharge ratio this year',
      name: 'charge_discharge_ratio_this_year',
      desc: '',
      args: [],
    );
  }

  /// `Charge/discharge ratio this month`
  String get charge_discharge_ratio_this_month {
    return Intl.message(
      'Charge/discharge ratio this month',
      name: 'charge_discharge_ratio_this_month',
      desc: '',
      args: [],
    );
  }

  /// `Charge/discharge ratio`
  String get charge_discharge_ratio {
    return Intl.message(
      'Charge/discharge ratio',
      name: 'charge_discharge_ratio',
      desc: '',
      args: [],
    );
  }

  /// `Charging amount`
  String get charging_amount {
    return Intl.message(
      'Charging amount',
      name: 'charging_amount',
      desc: '',
      args: [],
    );
  }

  /// `Discharging amount`
  String get discharging_amount {
    return Intl.message(
      'Discharging amount',
      name: 'discharging_amount',
      desc: '',
      args: [],
    );
  }

  /// `Charging`
  String get charging {
    return Intl.message(
      'Charging',
      name: 'charging',
      desc: '',
      args: [],
    );
  }

  /// `Discharging`
  String get discharging {
    return Intl.message(
      'Discharging',
      name: 'discharging',
      desc: '',
      args: [],
    );
  }

  /// `PV today/total generation`
  String get pv_today_total_generation {
    return Intl.message(
      'PV today/total generation',
      name: 'pv_today_total_generation',
      desc: '',
      args: [],
    );
  }

  /// `ESS charging/discharge today`
  String get ess_charging_discharge_today {
    return Intl.message(
      'ESS charging/discharge today',
      name: 'ess_charging_discharge_today',
      desc: '',
      args: [],
    );
  }

  /// `ESS3 total charging/discharge`
  String get ess_total_charging_discharge {
    return Intl.message(
      'ESS3 total charging/discharge',
      name: 'ess_total_charging_discharge',
      desc: '',
      args: [],
    );
  }

  /// `Today/total revenue`
  String get today_total_revenue {
    return Intl.message(
      'Today/total revenue',
      name: 'today_total_revenue',
      desc: '',
      args: [],
    );
  }

  /// `PV revenue`
  String get PV_revenue {
    return Intl.message(
      'PV revenue',
      name: 'PV_revenue',
      desc: '',
      args: [],
    );
  }

  /// `ESS revenue`
  String get ESS_revenue {
    return Intl.message(
      'ESS revenue',
      name: 'ESS_revenue',
      desc: '',
      args: [],
    );
  }

  /// `Charger revenue`
  String get Charger_revenue {
    return Intl.message(
      'Charger revenue',
      name: 'Charger_revenue',
      desc: '',
      args: [],
    );
  }

  /// `Revenue YoY/MoM analysis`
  String get revenue_YoY_MoM_analysis {
    return Intl.message(
      'Revenue YoY/MoM analysis',
      name: 'revenue_YoY_MoM_analysis',
      desc: '',
      args: [],
    );
  }

  /// `Load`
  String get loadd {
    return Intl.message(
      'Load',
      name: 'loadd',
      desc: '',
      args: [],
    );
  }

  /// `Unprocessed`
  String get unprocessed {
    return Intl.message(
      'Unprocessed',
      name: 'unprocessed',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Collaboration`
  String get collaboration {
    return Intl.message(
      'Collaboration',
      name: 'collaboration',
      desc: '',
      args: [],
    );
  }

  /// `ESS status overview`
  String get ESS_status_overview {
    return Intl.message(
      'ESS status overview',
      name: 'ESS_status_overview',
      desc: '',
      args: [],
    );
  }

  /// `ESS No.`
  String get ESS_Num {
    return Intl.message(
      'ESS No.',
      name: 'ESS_Num',
      desc: '',
      args: [],
    );
  }

  /// `Access`
  String get Access {
    return Intl.message(
      'Access',
      name: 'Access',
      desc: '',
      args: [],
    );
  }

  /// `Malfunction`
  String get Malfunction {
    return Intl.message(
      'Malfunction',
      name: 'Malfunction',
      desc: '',
      args: [],
    );
  }

  /// `Offline`
  String get Offline {
    return Intl.message(
      'Offline',
      name: 'Offline',
      desc: '',
      args: [],
    );
  }

  /// `To be connected`
  String get To_be_connected {
    return Intl.message(
      'To be connected',
      name: 'To_be_connected',
      desc: '',
      args: [],
    );
  }

  /// `Total operational capacity`
  String get Total_Operational_Capacity {
    return Intl.message(
      'Total operational capacity',
      name: 'Total_Operational_Capacity',
      desc: '',
      args: [],
    );
  }

  /// `Device model distribution`
  String get Device_Model_Distribution {
    return Intl.message(
      'Device model distribution',
      name: 'Device_Model_Distribution',
      desc: '',
      args: [],
    );
  }

  /// `Device %`
  String get Device_Percent {
    return Intl.message(
      'Device %',
      name: 'Device_Percent',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get Device_Model {
    return Intl.message(
      'Type',
      name: 'Device_Model',
      desc: '',
      args: [],
    );
  }

  /// `Device No.`
  String get Device_No {
    return Intl.message(
      'Device No.',
      name: 'Device_No',
      desc: '',
      args: [],
    );
  }

  /// `Project No.`
  String get Project_No {
    return Intl.message(
      'Project No.',
      name: 'Project_No',
      desc: '',
      args: [],
    );
  }

  /// `PCS`
  String get PCS {
    return Intl.message(
      'PCS',
      name: 'PCS',
      desc: '',
      args: [],
    );
  }

  /// `BMS`
  String get BMS {
    return Intl.message(
      'BMS',
      name: 'BMS',
      desc: '',
      args: [],
    );
  }

  /// `Cluster`
  String get Cluster {
    return Intl.message(
      'Cluster',
      name: 'Cluster',
      desc: '',
      args: [],
    );
  }

  /// `Air conditioner`
  String get Air_Conditioner {
    return Intl.message(
      'Air conditioner',
      name: 'Air_Conditioner',
      desc: '',
      args: [],
    );
  }

  /// `Environment`
  String get Environment {
    return Intl.message(
      'Environment',
      name: 'Environment',
      desc: '',
      args: [],
    );
  }

  /// `Measuring meter`
  String get Measuring_Meter {
    return Intl.message(
      'Measuring meter',
      name: 'Measuring_Meter',
      desc: '',
      args: [],
    );
  }

  /// `Grid meter`
  String get Grid_Meter {
    return Intl.message(
      'Grid meter',
      name: 'Grid_Meter',
      desc: '',
      args: [],
    );
  }

  /// `Charger`
  String get Charger {
    return Intl.message(
      'Charger',
      name: 'Charger',
      desc: '',
      args: [],
    );
  }

  /// `SMOKE`
  String get SMOKE {
    return Intl.message(
      'SMOKE',
      name: 'SMOKE',
      desc: '',
      args: [],
    );
  }

  /// `USER_LOAD`
  String get USER_LOAD {
    return Intl.message(
      'USER_LOAD',
      name: 'USER_LOAD',
      desc: '',
      args: [],
    );
  }

  /// `TRANSFORMER_METER`
  String get TRANSFORMER_METER {
    return Intl.message(
      'TRANSFORMER_METER',
      name: 'TRANSFORMER_METER',
      desc: '',
      args: [],
    );
  }

  /// `GATEWAY_METER`
  String get GATEWAY_METER {
    return Intl.message(
      'GATEWAY_METER',
      name: 'GATEWAY_METER',
      desc: '',
      args: [],
    );
  }

  /// `DEHUMIDIFIER`
  String get DEHUMIDIFIER {
    return Intl.message(
      'DEHUMIDIFIER',
      name: 'DEHUMIDIFIER',
      desc: '',
      args: [],
    );
  }

  /// `DETECTOR`
  String get DETECTOR {
    return Intl.message(
      'DETECTOR',
      name: 'DETECTOR',
      desc: '',
      args: [],
    );
  }

  /// `PHOTOVOLTAIC`
  String get PHOTOVOLTAIC {
    return Intl.message(
      'PHOTOVOLTAIC',
      name: 'PHOTOVOLTAIC',
      desc: '',
      args: [],
    );
  }

  /// `CHARGE_PILE`
  String get CHARGE_PILE {
    return Intl.message(
      'CHARGE_PILE',
      name: 'CHARGE_PILE',
      desc: '',
      args: [],
    );
  }

  /// `INVERTER`
  String get INVERTER {
    return Intl.message(
      'INVERTER',
      name: 'INVERTER',
      desc: '',
      args: [],
    );
  }

  /// `IO`
  String get IO {
    return Intl.message(
      'IO',
      name: 'IO',
      desc: '',
      args: [],
    );
  }

  /// `CABINET_METER`
  String get CABINET_METER {
    return Intl.message(
      'CABINET_METER',
      name: 'CABINET_METER',
      desc: '',
      args: [],
    );
  }

  /// `IRRADIATION_INSTRUMENT`
  String get IRRADIATION_INSTRUMENT {
    return Intl.message(
      'IRRADIATION_INSTRUMENT',
      name: 'IRRADIATION_INSTRUMENT',
      desc: '',
      args: [],
    );
  }

  /// `ATS`
  String get ATS {
    return Intl.message(
      'ATS',
      name: 'ATS',
      desc: '',
      args: [],
    );
  }

  /// `GENERATOR_CONTROLLER`
  String get GENERATOR_CONTROLLER {
    return Intl.message(
      'GENERATOR_CONTROLLER',
      name: 'GENERATOR_CONTROLLER',
      desc: '',
      args: [],
    );
  }

  /// `GENERATOR_OPERATION`
  String get GENERATOR_OPERATION {
    return Intl.message(
      'GENERATOR_OPERATION',
      name: 'GENERATOR_OPERATION',
      desc: '',
      args: [],
    );
  }

  /// `BUZZER`
  String get BUZZER {
    return Intl.message(
      'BUZZER',
      name: 'BUZZER',
      desc: '',
      args: [],
    );
  }

  /// `FAST_FREQUENCY`
  String get FAST_FREQUENCY {
    return Intl.message(
      'FAST_FREQUENCY',
      name: 'FAST_FREQUENCY',
      desc: '',
      args: [],
    );
  }

  /// `TMS`
  String get TMS {
    return Intl.message(
      'TMS',
      name: 'TMS',
      desc: '',
      args: [],
    );
  }

  /// `FRE_CONVERTER`
  String get FRE_CONVERTER {
    return Intl.message(
      'FRE_CONVERTER',
      name: 'FRE_CONVERTER',
      desc: '',
      args: [],
    );
  }

  /// `WEATHER_STATION`
  String get WEATHER_STATION {
    return Intl.message(
      'WEATHER_STATION',
      name: 'WEATHER_STATION',
      desc: '',
      args: [],
    );
  }

  /// `VRV_AIR`
  String get VRV_AIR {
    return Intl.message(
      'VRV_AIR',
      name: 'VRV_AIR',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `My shift`
  String get my_shift {
    return Intl.message(
      'My shift',
      name: 'my_shift',
      desc: '',
      args: [],
    );
  }

  /// `O&M team`
  String get OM_team {
    return Intl.message(
      'O&M team',
      name: 'OM_team',
      desc: '',
      args: [],
    );
  }

  /// `Already latest version`
  String get already_latest_version {
    return Intl.message(
      'Already latest version',
      name: 'already_latest_version',
      desc: '',
      args: [],
    );
  }

  /// `W/O Management`
  String get work_order_management {
    return Intl.message(
      'W/O Management',
      name: 'work_order_management',
      desc: '',
      args: [],
    );
  }

  /// `Inspection task`
  String get inspection_task {
    return Intl.message(
      'Inspection task',
      name: 'inspection_task',
      desc: '',
      args: [],
    );
  }

  /// `Shift plan`
  String get shift_plan {
    return Intl.message(
      'Shift plan',
      name: 'shift_plan',
      desc: '',
      args: [],
    );
  }

  /// `Personal Shift plan`
  String get personal_shift_plan {
    return Intl.message(
      'Personal Shift plan',
      name: 'personal_shift_plan',
      desc: '',
      args: [],
    );
  }

  /// `Workbench`
  String get workbench {
    return Intl.message(
      'Workbench',
      name: 'workbench',
      desc: '',
      args: [],
    );
  }

  /// `Event record`
  String get event_record {
    return Intl.message(
      'Event record',
      name: 'event_record',
      desc: '',
      args: [],
    );
  }

  /// `Data analysis`
  String get data_analysis {
    return Intl.message(
      'Data analysis',
      name: 'data_analysis',
      desc: '',
      args: [],
    );
  }

  /// `Please enter W/O name`
  String get please_input_work_order_name {
    return Intl.message(
      'Please enter W/O name',
      name: 'please_input_work_order_name',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message(
      'Pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Returned`
  String get returned {
    return Intl.message(
      'Returned',
      name: 'returned',
      desc: '',
      args: [],
    );
  }

  /// `Received`
  String get received {
    return Intl.message(
      'Received',
      name: 'received',
      desc: '',
      args: [],
    );
  }

  /// `Confirming`
  String get confirming {
    return Intl.message(
      'Confirming',
      name: 'confirming',
      desc: '',
      args: [],
    );
  }

  /// `Discarded`
  String get discarded {
    return Intl.message(
      'Discarded',
      name: 'discarded',
      desc: '',
      args: [],
    );
  }

  /// `W/O Name`
  String get work_order_name {
    return Intl.message(
      'W/O Name',
      name: 'work_order_name',
      desc: '',
      args: [],
    );
  }

  /// `W/O Source`
  String get work_order_source {
    return Intl.message(
      'W/O Source',
      name: 'work_order_source',
      desc: '',
      args: [],
    );
  }

  /// `External W/O`
  String get external_work_order {
    return Intl.message(
      'External W/O',
      name: 'external_work_order',
      desc: '',
      args: [],
    );
  }

  /// `Alarm W/O`
  String get alarm_work_order {
    return Intl.message(
      'Alarm W/O',
      name: 'alarm_work_order',
      desc: '',
      args: [],
    );
  }

  /// `Station Name`
  String get station_name {
    return Intl.message(
      'Station Name',
      name: 'station_name',
      desc: '',
      args: [],
    );
  }

  /// `Device Name`
  String get device_name {
    return Intl.message(
      'Device Name',
      name: 'device_name',
      desc: '',
      args: [],
    );
  }

  /// `Dispatch Time`
  String get dispatch_time {
    return Intl.message(
      'Dispatch Time',
      name: 'dispatch_time',
      desc: '',
      args: [],
    );
  }

  /// `Handler`
  String get handler {
    return Intl.message(
      'Handler',
      name: 'handler',
      desc: '',
      args: [],
    );
  }

  /// `Station Address`
  String get station_address {
    return Intl.message(
      'Station Address',
      name: 'station_address',
      desc: '',
      args: [],
    );
  }

  /// `Unit`
  String get unit {
    return Intl.message(
      'Unit',
      name: 'unit',
      desc: '',
      args: [],
    );
  }

  /// `Personnel`
  String get personnel {
    return Intl.message(
      'Personnel',
      name: 'personnel',
      desc: '',
      args: [],
    );
  }

  /// `W/O Content`
  String get work_order_content {
    return Intl.message(
      'W/O Content',
      name: 'work_order_content',
      desc: '',
      args: [],
    );
  }

  /// `Result`
  String get result {
    return Intl.message(
      'Result',
      name: 'result',
      desc: '',
      args: [],
    );
  }

  /// `Create W/O`
  String get create_work_order {
    return Intl.message(
      'Create W/O',
      name: 'create_work_order',
      desc: '',
      args: [],
    );
  }

  /// `Read W/O`
  String get read_work_order {
    return Intl.message(
      'Read W/O',
      name: 'read_work_order',
      desc: '',
      args: [],
    );
  }

  /// `Received W/O`
  String get received_work_order {
    return Intl.message(
      'Received W/O',
      name: 'received_work_order',
      desc: '',
      args: [],
    );
  }

  /// `Processed W/O`
  String get processed_work_order {
    return Intl.message(
      'Processed W/O',
      name: 'processed_work_order',
      desc: '',
      args: [],
    );
  }

  /// `Returned W/O`
  String get returned_work_order {
    return Intl.message(
      'Returned W/O',
      name: 'returned_work_order',
      desc: '',
      args: [],
    );
  }

  /// `Creator`
  String get creator {
    return Intl.message(
      'Creator',
      name: 'creator',
      desc: '',
      args: [],
    );
  }

  /// `Create date`
  String get create_date {
    return Intl.message(
      'Create date',
      name: 'create_date',
      desc: '',
      args: [],
    );
  }

  /// `W/O Details`
  String get work_order_details {
    return Intl.message(
      'W/O Details',
      name: 'work_order_details',
      desc: '',
      args: [],
    );
  }

  /// `Platform`
  String get platform {
    return Intl.message(
      'Platform',
      name: 'platform',
      desc: '',
      args: [],
    );
  }

  /// `Applicant`
  String get applicant {
    return Intl.message(
      'Applicant',
      name: 'applicant',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get processing {
    return Intl.message(
      'Processing',
      name: 'processing',
      desc: '',
      args: [],
    );
  }

  /// `Return`
  String get return_d {
    return Intl.message(
      'Return',
      name: 'return_d',
      desc: '',
      args: [],
    );
  }

  /// `Receive`
  String get receive {
    return Intl.message(
      'Receive',
      name: 'receive',
      desc: '',
      args: [],
    );
  }

  /// `W/O Info`
  String get work_order_info {
    return Intl.message(
      'W/O Info',
      name: 'work_order_info',
      desc: '',
      args: [],
    );
  }

  /// `Process Content`
  String get process_content {
    return Intl.message(
      'Process Content',
      name: 'process_content',
      desc: '',
      args: [],
    );
  }

  /// `Cause`
  String get cause {
    return Intl.message(
      'Cause',
      name: 'cause',
      desc: '',
      args: [],
    );
  }

  /// `Please input`
  String get please_input {
    return Intl.message(
      'Please input',
      name: 'please_input',
      desc: '',
      args: [],
    );
  }

  /// `Solution`
  String get solution {
    return Intl.message(
      'Solution',
      name: 'solution',
      desc: '',
      args: [],
    );
  }

  /// `Is use spare`
  String get is_use_spare {
    return Intl.message(
      'Is use spare',
      name: 'is_use_spare',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Internal & external investment`
  String get internal_external_investment {
    return Intl.message(
      'Internal & external investment',
      name: 'internal_external_investment',
      desc: '',
      args: [],
    );
  }

  /// `Internal`
  String get internal {
    return Intl.message(
      'Internal',
      name: 'internal',
      desc: '',
      args: [],
    );
  }

  /// `External`
  String get external {
    return Intl.message(
      'External',
      name: 'external',
      desc: '',
      args: [],
    );
  }

  /// `Investment Details`
  String get investment_details {
    return Intl.message(
      'Investment Details',
      name: 'investment_details',
      desc: '',
      args: [],
    );
  }

  /// `Processing photos/videos`
  String get processing_photos_videos {
    return Intl.message(
      'Processing photos/videos',
      name: 'processing_photos_videos',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Failed to obtain address`
  String get failed_to_obtain_address {
    return Intl.message(
      'Failed to obtain address',
      name: 'failed_to_obtain_address',
      desc: '',
      args: [],
    );
  }

  /// `Reposition`
  String get reposition {
    return Intl.message(
      'Reposition',
      name: 'reposition',
      desc: '',
      args: [],
    );
  }

  /// `CC this W/O to supervisor`
  String get cc_this_w_o_to_supervisor {
    return Intl.message(
      'CC this W/O to supervisor',
      name: 'cc_this_w_o_to_supervisor',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `W/O List`
  String get work_order_list {
    return Intl.message(
      'W/O List',
      name: 'work_order_list',
      desc: '',
      args: [],
    );
  }

  /// `H`
  String get high_priority {
    return Intl.message(
      'H',
      name: 'high_priority',
      desc: '',
      args: [],
    );
  }

  /// `M`
  String get medium_priority {
    return Intl.message(
      'M',
      name: 'medium_priority',
      desc: '',
      args: [],
    );
  }

  /// `L`
  String get low_priority {
    return Intl.message(
      'L',
      name: 'low_priority',
      desc: '',
      args: [],
    );
  }

  /// `I`
  String get immediate_priority {
    return Intl.message(
      'I',
      name: 'immediate_priority',
      desc: '',
      args: [],
    );
  }

  /// `W/O about to timeout`
  String get work_order_about_to_timeout {
    return Intl.message(
      'W/O about to timeout',
      name: 'work_order_about_to_timeout',
      desc: '',
      args: [],
    );
  }

  /// `W/O timeout`
  String get work_order_timeout {
    return Intl.message(
      'W/O timeout',
      name: 'work_order_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Unauthorized to obtain address`
  String get unauthorized_to_obtain_address {
    return Intl.message(
      'Unauthorized to obtain address',
      name: 'unauthorized_to_obtain_address',
      desc: '',
      args: [],
    );
  }

  /// `Submit success`
  String get submit_success {
    return Intl.message(
      'Submit success',
      name: 'submit_success',
      desc: '',
      args: [],
    );
  }

  /// `Correlation alarm`
  String get correlation_alarm {
    return Intl.message(
      'Correlation alarm',
      name: 'correlation_alarm',
      desc: '',
      args: [],
    );
  }

  /// `Refuse`
  String get refuse {
    return Intl.message(
      'Refuse',
      name: 'refuse',
      desc: '',
      args: [],
    );
  }

  /// `Pass`
  String get pass {
    return Intl.message(
      'Pass',
      name: 'pass',
      desc: '',
      args: [],
    );
  }

  /// `Unknown user`
  String get unknown_user {
    return Intl.message(
      'Unknown user',
      name: 'unknown_user',
      desc: '',
      args: [],
    );
  }

  /// `No data available`
  String get no_data_available {
    return Intl.message(
      'No data available',
      name: 'no_data_available',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Last`
  String get last_month {
    return Intl.message(
      'Last',
      name: 'last_month',
      desc: '',
      args: [],
    );
  }

  /// `This`
  String get this_month {
    return Intl.message(
      'This',
      name: 'this_month',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next_month {
    return Intl.message(
      'Next',
      name: 'next_month',
      desc: '',
      args: [],
    );
  }

  /// `Monthly work order`
  String get monthly_work_order {
    return Intl.message(
      'Monthly work order',
      name: 'monthly_work_order',
      desc: '',
      args: [],
    );
  }

  /// `Monthly work order complete`
  String get monthly_work_order_complete {
    return Intl.message(
      'Monthly work order complete',
      name: 'monthly_work_order_complete',
      desc: '',
      args: [],
    );
  }

  /// `Monthly work order timeout`
  String get monthly_work_order_timeout {
    return Intl.message(
      'Monthly work order timeout',
      name: 'monthly_work_order_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Monthly inspection task`
  String get monthly_inspection_task {
    return Intl.message(
      'Monthly inspection task',
      name: 'monthly_inspection_task',
      desc: '',
      args: [],
    );
  }

  /// `Monthly inspection task complete`
  String get monthly_inspection_task_complete {
    return Intl.message(
      'Monthly inspection task complete',
      name: 'monthly_inspection_task_complete',
      desc: '',
      args: [],
    );
  }

  /// `Monthly inspection task timeout`
  String get monthly_inspection_task_timeout {
    return Intl.message(
      'Monthly inspection task timeout',
      name: 'monthly_inspection_task_timeout',
      desc: '',
      args: [],
    );
  }

  /// `My todo`
  String get my_todo {
    return Intl.message(
      'My todo',
      name: 'my_todo',
      desc: '',
      args: [],
    );
  }

  /// `Pending return work order`
  String get pending_return_work_order {
    return Intl.message(
      'Pending return work order',
      name: 'pending_return_work_order',
      desc: '',
      args: [],
    );
  }

  /// `Pending transfer work order`
  String get pending_transfer_work_order {
    return Intl.message(
      'Pending transfer work order',
      name: 'pending_transfer_work_order',
      desc: '',
      args: [],
    );
  }

  /// `Pending return inspection task`
  String get pending_return_inspection_task {
    return Intl.message(
      'Pending return inspection task',
      name: 'pending_return_inspection_task',
      desc: '',
      args: [],
    );
  }

  /// `Pending transfer inspection task`
  String get pending_transfer_inspection_task {
    return Intl.message(
      'Pending transfer inspection task',
      name: 'pending_transfer_inspection_task',
      desc: '',
      args: [],
    );
  }

  /// `My work order`
  String get my_work_order {
    return Intl.message(
      'My work order',
      name: 'my_work_order',
      desc: '',
      args: [],
    );
  }

  /// `My inspection task`
  String get my_inspection_task {
    return Intl.message(
      'My inspection task',
      name: 'my_inspection_task',
      desc: '',
      args: [],
    );
  }

  /// `My station`
  String get my_station {
    return Intl.message(
      'My station',
      name: 'my_station',
      desc: '',
      args: [],
    );
  }

  /// `Station list`
  String get station_list {
    return Intl.message(
      'Station list',
      name: 'station_list',
      desc: '',
      args: [],
    );
  }

  /// `7 days`
  String get seven_days {
    return Intl.message(
      '7 days',
      name: 'seven_days',
      desc: '',
      args: [],
    );
  }

  /// `14 days`
  String get fourteen_days {
    return Intl.message(
      '14 days',
      name: 'fourteen_days',
      desc: '',
      args: [],
    );
  }

  /// `1 month`
  String get one_month {
    return Intl.message(
      '1 month',
      name: 'one_month',
      desc: '',
      args: [],
    );
  }

  /// `Please select`
  String get please_select {
    return Intl.message(
      'Please select',
      name: 'please_select',
      desc: '',
      args: [],
    );
  }

  /// `Group members`
  String get group_member {
    return Intl.message(
      'Group members',
      name: 'group_member',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get monthly {
    return Intl.message(
      'Monthly',
      name: 'monthly',
      desc: '',
      args: [],
    );
  }

  /// `shift plan num`
  String get shift_plan_num {
    return Intl.message(
      'shift plan num',
      name: 'shift_plan_num',
      desc: '',
      args: [],
    );
  }

  /// `station num`
  String get station_num {
    return Intl.message(
      'station num',
      name: 'station_num',
      desc: '',
      args: [],
    );
  }

  /// `Upload failed`
  String get upload_failed {
    return Intl.message(
      'Upload failed',
      name: 'upload_failed',
      desc: '',
      args: [],
    );
  }

  /// `Confirm submit`
  String get confirm_submit {
    return Intl.message(
      'Confirm submit',
      name: 'confirm_submit',
      desc: '',
      args: [],
    );
  }

  /// `Please input cause`
  String get please_input_cause {
    return Intl.message(
      'Please input cause',
      name: 'please_input_cause',
      desc: '',
      args: [],
    );
  }

  /// `Please input solution`
  String get please_input_solution {
    return Intl.message(
      'Please input solution',
      name: 'please_input_solution',
      desc: '',
      args: [],
    );
  }

  /// `Please upload photos/videos`
  String get please_upload_photos_videos {
    return Intl.message(
      'Please upload photos/videos',
      name: 'please_upload_photos_videos',
      desc: '',
      args: [],
    );
  }

  /// `Getting address please wait`
  String get getting_address_please_wait {
    return Intl.message(
      'Getting address please wait',
      name: 'getting_address_please_wait',
      desc: '',
      args: [],
    );
  }

  /// `Uploading file please wait`
  String get uploading_file_please_wait {
    return Intl.message(
      'Uploading file please wait',
      name: 'uploading_file_please_wait',
      desc: '',
      args: [],
    );
  }

  /// `Upload success`
  String get upload_success {
    return Intl.message(
      'Upload success',
      name: 'upload_success',
      desc: '',
      args: [],
    );
  }

  /// `Take photo or record`
  String get take_photo_or_record {
    return Intl.message(
      'Take photo or record',
      name: 'take_photo_or_record',
      desc: '',
      args: [],
    );
  }

  /// `Album`
  String get album {
    return Intl.message(
      'Album',
      name: 'album',
      desc: '',
      args: [],
    );
  }

  /// `Order confirmation`
  String get order_confirmation {
    return Intl.message(
      'Order confirmation',
      name: 'order_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Plan presence time`
  String get plan_presence_time {
    return Intl.message(
      'Plan presence time',
      name: 'plan_presence_time',
      desc: '',
      args: [],
    );
  }

  /// `Is there cooperative personnel`
  String get is_there_cooperative_personnel {
    return Intl.message(
      'Is there cooperative personnel',
      name: 'is_there_cooperative_personnel',
      desc: '',
      args: [],
    );
  }

  /// `Please select O&M personnel`
  String get please_select_om_personnel {
    return Intl.message(
      'Please select O&M personnel',
      name: 'please_select_om_personnel',
      desc: '',
      args: [],
    );
  }

  /// `Video play failed`
  String get video_play_failed {
    return Intl.message(
      'Video play failed',
      name: 'video_play_failed',
      desc: '',
      args: [],
    );
  }

  /// `Please input reason`
  String get please_input_reason {
    return Intl.message(
      'Please input reason',
      name: 'please_input_reason',
      desc: '',
      args: [],
    );
  }

  /// `Refuse return work order`
  String get refuse_return_work_order {
    return Intl.message(
      'Refuse return work order',
      name: 'refuse_return_work_order',
      desc: '',
      args: [],
    );
  }

  /// `Apply return work order`
  String get apply_return_work_order {
    return Intl.message(
      'Apply return work order',
      name: 'apply_return_work_order',
      desc: '',
      args: [],
    );
  }

  /// `Apply transfer work order`
  String get apply_transfer_work_order {
    return Intl.message(
      'Apply transfer work order',
      name: 'apply_transfer_work_order',
      desc: '',
      args: [],
    );
  }

  /// `Return platform`
  String get return_platform {
    return Intl.message(
      'Return platform',
      name: 'return_platform',
      desc: '',
      args: [],
    );
  }

  /// `Send to other`
  String get send_to_other_group_members {
    return Intl.message(
      'Send to other',
      name: 'send_to_other_group_members',
      desc: '',
      args: [],
    );
  }

  /// `Preview new features in advance`
  String get premium_features {
    return Intl.message(
      'Preview new features in advance',
      name: 'premium_features',
      desc: '',
      args: [],
    );
  }

  /// `Immediate update`
  String get immediate_update {
    return Intl.message(
      'Immediate update',
      name: 'immediate_update',
      desc: '',
      args: [],
    );
  }

  /// `Language settings`
  String get language_settings {
    return Intl.message(
      'Language settings',
      name: 'language_settings',
      desc: '',
      args: [],
    );
  }

  /// `AC`
  String get ac {
    return Intl.message(
      'AC',
      name: 'ac',
      desc: '',
      args: [],
    );
  }

  /// `Firefighting`
  String get Firefighting {
    return Intl.message(
      'Firefighting',
      name: 'Firefighting',
      desc: '',
      args: [],
    );
  }

  /// `Overview`
  String get overview {
    return Intl.message(
      'Overview',
      name: 'overview',
      desc: '',
      args: [],
    );
  }

  /// `Inverter`
  String get inverter {
    return Intl.message(
      'Inverter',
      name: 'inverter',
      desc: '',
      args: [],
    );
  }

  /// `Station overview`
  String get station_overview {
    return Intl.message(
      'Station overview',
      name: 'station_overview',
      desc: '',
      args: [],
    );
  }

  /// `Generation today`
  String get generation_today {
    return Intl.message(
      'Generation today',
      name: 'generation_today',
      desc: '',
      args: [],
    );
  }

  /// `FLH today`
  String get flh_today {
    return Intl.message(
      'FLH today',
      name: 'flh_today',
      desc: '',
      args: [],
    );
  }

  /// `Generation this month`
  String get generation_this_month {
    return Intl.message(
      'Generation this month',
      name: 'generation_this_month',
      desc: '',
      args: [],
    );
  }

  /// `Generation this year`
  String get generation_this_year {
    return Intl.message(
      'Generation this year',
      name: 'generation_this_year',
      desc: '',
      args: [],
    );
  }

  /// `Total generation`
  String get total_generation {
    return Intl.message(
      'Total generation',
      name: 'total_generation',
      desc: '',
      args: [],
    );
  }

  /// `Total on-grid`
  String get total_on_grid {
    return Intl.message(
      'Total on-grid',
      name: 'total_on_grid',
      desc: '',
      args: [],
    );
  }

  /// `Consumption`
  String get consumption {
    return Intl.message(
      'Consumption',
      name: 'consumption',
      desc: '',
      args: [],
    );
  }

  /// `Irradiance`
  String get irradiance {
    return Intl.message(
      'Irradiance',
      name: 'irradiance',
      desc: '',
      args: [],
    );
  }

  /// `Power trend`
  String get power_trend {
    return Intl.message(
      'Power trend',
      name: 'power_trend',
      desc: '',
      args: [],
    );
  }

  /// `Energy trend`
  String get energy_trend {
    return Intl.message(
      'Energy trend',
      name: 'energy_trend',
      desc: '',
      args: [],
    );
  }

  /// `Weather details`
  String get weather_details {
    return Intl.message(
      'Weather details',
      name: 'weather_details',
      desc: '',
      args: [],
    );
  }

  /// `Page development in process`
  String get page_development_in_process {
    return Intl.message(
      'Page development in process',
      name: 'page_development_in_process',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get online {
    return Intl.message(
      'Online',
      name: 'online',
      desc: '',
      args: [],
    );
  }

  /// `Serial number`
  String get serial_number {
    return Intl.message(
      'Serial number',
      name: 'serial_number',
      desc: '',
      args: [],
    );
  }

  /// `Update time`
  String get update_time {
    return Intl.message(
      'Update time',
      name: 'update_time',
      desc: '',
      args: [],
    );
  }

  /// `Commissioning time`
  String get commissioning_time {
    return Intl.message(
      'Commissioning time',
      name: 'commissioning_time',
      desc: '',
      args: [],
    );
  }

  /// `Safe operation days`
  String get safe_operation_days {
    return Intl.message(
      'Safe operation days',
      name: 'safe_operation_days',
      desc: '',
      args: [],
    );
  }

  /// `Rated power`
  String get rated_power {
    return Intl.message(
      'Rated power',
      name: 'rated_power',
      desc: '',
      args: [],
    );
  }

  /// `Installed capacity`
  String get installed_capacity {
    return Intl.message(
      'Installed capacity',
      name: 'installed_capacity',
      desc: '',
      args: [],
    );
  }

  /// `Real time alarm`
  String get real_time_alarm {
    return Intl.message(
      'Real time alarm',
      name: 'real_time_alarm',
      desc: '',
      args: [],
    );
  }

  /// `Historical alarm`
  String get historical_alarm {
    return Intl.message(
      'Historical alarm',
      name: 'historical_alarm',
      desc: '',
      args: [],
    );
  }

  /// `Today count`
  String get today_alarm_count {
    return Intl.message(
      'Today count',
      name: 'today_alarm_count',
      desc: '',
      args: [],
    );
  }

  /// `Total count`
  String get total_alarm_count {
    return Intl.message(
      'Total count',
      name: 'total_alarm_count',
      desc: '',
      args: [],
    );
  }

  /// `Filter criteria`
  String get filter_criteria {
    return Intl.message(
      'Filter criteria',
      name: 'filter_criteria',
      desc: '',
      args: [],
    );
  }

  /// `Select project`
  String get select_project {
    return Intl.message(
      'Select project',
      name: 'select_project',
      desc: '',
      args: [],
    );
  }

  /// `Alarm level`
  String get alarm_level {
    return Intl.message(
      'Alarm level',
      name: 'alarm_level',
      desc: '',
      args: [],
    );
  }

  /// `Minor alarm`
  String get minor_alarm {
    return Intl.message(
      'Minor alarm',
      name: 'minor_alarm',
      desc: '',
      args: [],
    );
  }

  /// `Moderate alarm`
  String get moderate_alarm {
    return Intl.message(
      'Moderate alarm',
      name: 'moderate_alarm',
      desc: '',
      args: [],
    );
  }

  /// `Critical alarm`
  String get critical_alarm {
    return Intl.message(
      'Critical alarm',
      name: 'critical_alarm',
      desc: '',
      args: [],
    );
  }

  /// `Fault`
  String get fault {
    return Intl.message(
      'Fault',
      name: 'fault',
      desc: '',
      args: [],
    );
  }

  /// `Event`
  String get event {
    return Intl.message(
      'Event',
      name: 'event',
      desc: '',
      args: [],
    );
  }

  /// `Alarm status`
  String get alarm_status {
    return Intl.message(
      'Alarm status',
      name: 'alarm_status',
      desc: '',
      args: [],
    );
  }

  /// `Processed`
  String get processed {
    return Intl.message(
      'Processed',
      name: 'processed',
      desc: '',
      args: [],
    );
  }

  /// `Start time`
  String get start_time {
    return Intl.message(
      'Start time',
      name: 'start_time',
      desc: '',
      args: [],
    );
  }

  /// `End time`
  String get end_time {
    return Intl.message(
      'End time',
      name: 'end_time',
      desc: '',
      args: [],
    );
  }

  /// `Select date`
  String get select_date {
    return Intl.message(
      'Select date',
      name: 'select_date',
      desc: '',
      args: [],
    );
  }

  /// `Alarm content`
  String get alarm_content {
    return Intl.message(
      'Alarm content',
      name: 'alarm_content',
      desc: '',
      args: [],
    );
  }

  /// `Enter alarm content`
  String get enter_alarm_content {
    return Intl.message(
      'Enter alarm content',
      name: 'enter_alarm_content',
      desc: '',
      args: [],
    );
  }

  /// `Device type`
  String get device_type {
    return Intl.message(
      'Device type',
      name: 'device_type',
      desc: '',
      args: [],
    );
  }

  /// `Cluster`
  String get cluster {
    return Intl.message(
      'Cluster',
      name: 'cluster',
      desc: '',
      args: [],
    );
  }

  /// `Firefighting`
  String get firefighting {
    return Intl.message(
      'Firefighting',
      name: 'firefighting',
      desc: '',
      args: [],
    );
  }

  /// `Device model`
  String get device_model {
    return Intl.message(
      'Device model',
      name: 'device_model',
      desc: '',
      args: [],
    );
  }

  /// `Device metrics`
  String get device_metrics {
    return Intl.message(
      'Device metrics',
      name: 'device_metrics',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `First occurrence time`
  String get first_occurrence_time {
    return Intl.message(
      'First occurrence time',
      name: 'first_occurrence_time',
      desc: '',
      args: [],
    );
  }

  /// `Recovery time`
  String get recovery_time {
    return Intl.message(
      'Recovery time',
      name: 'recovery_time',
      desc: '',
      args: [],
    );
  }

  /// `Operation Strategy`
  String get operation_strategy {
    return Intl.message(
      'Operation Strategy',
      name: 'operation_strategy',
      desc: '',
      args: [],
    );
  }

  /// `Set strategy`
  String get set_strategy {
    return Intl.message(
      'Set strategy',
      name: 'set_strategy',
      desc: '',
      args: [],
    );
  }

  /// `Strategy name`
  String get strategy_name {
    return Intl.message(
      'Strategy name',
      name: 'strategy_name',
      desc: '',
      args: [],
    );
  }

  /// `peak shaving and valley filling`
  String get peak_shaving_and_valley_filling {
    return Intl.message(
      'peak shaving and valley filling',
      name: 'peak_shaving_and_valley_filling',
      desc: '',
      args: [],
    );
  }

  /// `Anti backflow`
  String get anti_backflow {
    return Intl.message(
      'Anti backflow',
      name: 'anti_backflow',
      desc: '',
      args: [],
    );
  }

  /// `Power(kW)`
  String get power_kW {
    return Intl.message(
      'Power(kW)',
      name: 'power_kW',
      desc: '',
      args: [],
    );
  }

  /// `SOC upper limit`
  String get soc_upper_limit {
    return Intl.message(
      'SOC upper limit',
      name: 'soc_upper_limit',
      desc: '',
      args: [],
    );
  }

  /// `SOC lower limit`
  String get soc_lower_limit {
    return Intl.message(
      'SOC lower limit',
      name: 'soc_lower_limit',
      desc: '',
      args: [],
    );
  }

  /// `Power upper limit`
  String get power_upper_limit {
    return Intl.message(
      'Power upper limit',
      name: 'power_upper_limit',
      desc: '',
      args: [],
    );
  }

  /// `Power lower limit`
  String get power_lower_limit {
    return Intl.message(
      'Power lower limit',
      name: 'power_lower_limit',
      desc: '',
      args: [],
    );
  }

  /// `Execution`
  String get execution {
    return Intl.message(
      'Execution',
      name: 'execution',
      desc: '',
      args: [],
    );
  }

  /// `Min power`
  String get min_power {
    return Intl.message(
      'Min power',
      name: 'min_power',
      desc: '',
      args: [],
    );
  }

  /// `Max power`
  String get max_power {
    return Intl.message(
      'Max power',
      name: 'max_power',
      desc: '',
      args: [],
    );
  }

  /// `SOC start value`
  String get soc_start_value {
    return Intl.message(
      'SOC start value',
      name: 'soc_start_value',
      desc: '',
      args: [],
    );
  }

  /// `SOC end value`
  String get soc_end_value {
    return Intl.message(
      'SOC end value',
      name: 'soc_end_value',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Time period type`
  String get time_period_type {
    return Intl.message(
      'Time period type',
      name: 'time_period_type',
      desc: '',
      args: [],
    );
  }

  /// `Time period`
  String get time_period {
    return Intl.message(
      'Time period',
      name: 'time_period',
      desc: '',
      args: [],
    );
  }

  /// `Sharp`
  String get sharp {
    return Intl.message(
      'Sharp',
      name: 'sharp',
      desc: '',
      args: [],
    );
  }

  /// `Peak`
  String get peak {
    return Intl.message(
      'Peak',
      name: 'peak',
      desc: '',
      args: [],
    );
  }

  /// `Flat`
  String get flat {
    return Intl.message(
      'Flat',
      name: 'flat',
      desc: '',
      args: [],
    );
  }

  /// `Valley`
  String get valley {
    return Intl.message(
      'Valley',
      name: 'valley',
      desc: '',
      args: [],
    );
  }

  /// `Deep valley`
  String get deep_valley {
    return Intl.message(
      'Deep valley',
      name: 'deep_valley',
      desc: '',
      args: [],
    );
  }

  /// `Online price(yuan/kWh)`
  String get online_price {
    return Intl.message(
      'Online price(yuan/kWh)',
      name: 'online_price',
      desc: '',
      args: [],
    );
  }

  /// `Consumed price(yuan/kWh)`
  String get consumed_price {
    return Intl.message(
      'Consumed price(yuan/kWh)',
      name: 'consumed_price',
      desc: '',
      args: [],
    );
  }

  /// `Ele price`
  String get ele_price {
    return Intl.message(
      'Ele price',
      name: 'ele_price',
      desc: '',
      args: [],
    );
  }

  /// `View settlement record`
  String get view_settlement_record {
    return Intl.message(
      'View settlement record',
      name: 'view_settlement_record',
      desc: '',
      args: [],
    );
  }

  /// `Settlement`
  String get settlement {
    return Intl.message(
      'Settlement',
      name: 'settlement',
      desc: '',
      args: [],
    );
  }

  /// `Please select settlement month`
  String get please_select_settlement_month {
    return Intl.message(
      'Please select settlement month',
      name: 'please_select_settlement_month',
      desc: '',
      args: [],
    );
  }

  /// `Settlement method`
  String get settlement_method {
    return Intl.message(
      'Settlement method',
      name: 'settlement_method',
      desc: '',
      args: [],
    );
  }

  /// `Settlement month`
  String get settlement_month {
    return Intl.message(
      'Settlement month',
      name: 'settlement_month',
      desc: '',
      args: [],
    );
  }

  /// `Settlement time`
  String get settlement_time {
    return Intl.message(
      'Settlement time',
      name: 'settlement_time',
      desc: '',
      args: [],
    );
  }

  /// `Settlement list`
  String get settlement_list {
    return Intl.message(
      'Settlement list',
      name: 'settlement_list',
      desc: '',
      args: [],
    );
  }

  /// `Billing date`
  String get billing_date {
    return Intl.message(
      'Billing date',
      name: 'billing_date',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get report {
    return Intl.message(
      'Report',
      name: 'report',
      desc: '',
      args: [],
    );
  }

  /// `Energy report`
  String get energy_report {
    return Intl.message(
      'Energy report',
      name: 'energy_report',
      desc: '',
      args: [],
    );
  }

  /// `View and analyze energy related data`
  String get energy_report_content {
    return Intl.message(
      'View and analyze energy related data',
      name: 'energy_report_content',
      desc: '',
      args: [],
    );
  }

  /// `Revenue report`
  String get revenue_report {
    return Intl.message(
      'Revenue report',
      name: 'revenue_report',
      desc: '',
      args: [],
    );
  }

  /// `View and analyze revenue related data`
  String get revenue_report_content {
    return Intl.message(
      'View and analyze revenue related data',
      name: 'revenue_report_content',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Total revenue`
  String get total_revenue {
    return Intl.message(
      'Total revenue',
      name: 'total_revenue',
      desc: '',
      args: [],
    );
  }

  /// `PV revenue`
  String get pv_revenue {
    return Intl.message(
      'PV revenue',
      name: 'pv_revenue',
      desc: '',
      args: [],
    );
  }

  /// `ESS revenue`
  String get ess_revenue {
    return Intl.message(
      'ESS revenue',
      name: 'ess_revenue',
      desc: '',
      args: [],
    );
  }

  /// `Consumption revenue`
  String get consumption_revenue {
    return Intl.message(
      'Consumption revenue',
      name: 'consumption_revenue',
      desc: '',
      args: [],
    );
  }

  /// `Online revenue`
  String get online_revenue {
    return Intl.message(
      'Online revenue',
      name: 'online_revenue',
      desc: '',
      args: [],
    );
  }

  /// `Total investment`
  String get total_investment {
    return Intl.message(
      'Total investment',
      name: 'total_investment',
      desc: '',
      args: [],
    );
  }

  /// `Payback period`
  String get payback_period {
    return Intl.message(
      'Payback period',
      name: 'payback_period',
      desc: '',
      args: [],
    );
  }

  /// `Charge cost`
  String get charge_cost {
    return Intl.message(
      'Charge cost',
      name: 'charge_cost',
      desc: '',
      args: [],
    );
  }

  /// `Discharge revenue`
  String get discharge_revenue {
    return Intl.message(
      'Discharge revenue',
      name: 'discharge_revenue',
      desc: '',
      args: [],
    );
  }

  /// `Revenue this month`
  String get revenue_this_month {
    return Intl.message(
      'Revenue this month',
      name: 'revenue_this_month',
      desc: '',
      args: [],
    );
  }

  /// `Month total charging amount`
  String get charging_this_month {
    return Intl.message(
      'Month total charging amount',
      name: 'charging_this_month',
      desc: '',
      args: [],
    );
  }

  /// `Month total discharging amount`
  String get discharge_this_month {
    return Intl.message(
      'Month total discharging amount',
      name: 'discharge_this_month',
      desc: '',
      args: [],
    );
  }

  /// `Month total fault hour`
  String get total_fault_hour_this_month {
    return Intl.message(
      'Month total fault hour',
      name: 'total_fault_hour_this_month',
      desc: '',
      args: [],
    );
  }

  /// `Operation time`
  String get operation_time {
    return Intl.message(
      'Operation time',
      name: 'operation_time',
      desc: '',
      args: [],
    );
  }

  /// `Consume energy`
  String get consume_energy {
    return Intl.message(
      'Consume energy',
      name: 'consume_energy',
      desc: '',
      args: [],
    );
  }

  /// `Grid energy`
  String get grid_energy {
    return Intl.message(
      'Grid energy',
      name: 'grid_energy',
      desc: '',
      args: [],
    );
  }

  /// `Charging efficiency`
  String get charging_efficiency {
    return Intl.message(
      'Charging efficiency',
      name: 'charging_efficiency',
      desc: '',
      args: [],
    );
  }

  /// `Month on month analysis`
  String get month_on_month_analysis {
    return Intl.message(
      'Month on month analysis',
      name: 'month_on_month_analysis',
      desc: '',
      args: [],
    );
  }

  /// `Same period last year`
  String get same_period_last_year {
    return Intl.message(
      'Same period last year',
      name: 'same_period_last_year',
      desc: '',
      args: [],
    );
  }

  /// `Charge discharge efficiency`
  String get charge_discharge_efficiency {
    return Intl.message(
      'Charge discharge efficiency',
      name: 'charge_discharge_efficiency',
      desc: '',
      args: [],
    );
  }

  /// `Battery decay rate`
  String get battery_decay_rate {
    return Intl.message(
      'Battery decay rate',
      name: 'battery_decay_rate',
      desc: '',
      args: [],
    );
  }

  /// `Peak valley price difference`
  String get peak_valley_price_difference {
    return Intl.message(
      'Peak valley price difference',
      name: 'peak_valley_price_difference',
      desc: '',
      args: [],
    );
  }

  /// `Fault time`
  String get fault_time {
    return Intl.message(
      'Fault time',
      name: 'fault_time',
      desc: '',
      args: [],
    );
  }

  /// `Spot trading`
  String get spot_trading {
    return Intl.message(
      'Spot trading',
      name: 'spot_trading',
      desc: '',
      args: [],
    );
  }

  /// `Elec`
  String get elec {
    return Intl.message(
      'Elec',
      name: 'elec',
      desc: '',
      args: [],
    );
  }

  /// `MG revenue`
  String get mg_revenue {
    return Intl.message(
      'MG revenue',
      name: 'mg_revenue',
      desc: '',
      args: [],
    );
  }

  /// `Today revenue`
  String get todayRevenue {
    return Intl.message(
      'Today revenue',
      name: 'todayRevenue',
      desc: '',
      args: [],
    );
  }

  /// `Total revenue`
  String get totalRevenue {
    return Intl.message(
      'Total revenue',
      name: 'totalRevenue',
      desc: '',
      args: [],
    );
  }

  /// `Total charging`
  String get totalCharging {
    return Intl.message(
      'Total charging',
      name: 'totalCharging',
      desc: '',
      args: [],
    );
  }

  /// `Total discharge`
  String get totalDischarge {
    return Intl.message(
      'Total discharge',
      name: 'totalDischarge',
      desc: '',
      args: [],
    );
  }

  /// `Total generation`
  String get totalGeneration {
    return Intl.message(
      'Total generation',
      name: 'totalGeneration',
      desc: '',
      args: [],
    );
  }

  /// `Total on grid`
  String get totalOnGrid {
    return Intl.message(
      'Total on grid',
      name: 'totalOnGrid',
      desc: '',
      args: [],
    );
  }

  /// `Peak valley revenue`
  String get peakValleyRevenue {
    return Intl.message(
      'Peak valley revenue',
      name: 'peakValleyRevenue',
      desc: '',
      args: [],
    );
  }

  /// `Demand response`
  String get demandResponse {
    return Intl.message(
      'Demand response',
      name: 'demandResponse',
      desc: '',
      args: [],
    );
  }

  /// `Spot trading`
  String get spotTrading {
    return Intl.message(
      'Spot trading',
      name: 'spotTrading',
      desc: '',
      args: [],
    );
  }

  /// `Green electricity trading`
  String get greenElectricityTrading {
    return Intl.message(
      'Green electricity trading',
      name: 'greenElectricityTrading',
      desc: '',
      args: [],
    );
  }

  /// `PV consumption`
  String get pvConsumption {
    return Intl.message(
      'PV consumption',
      name: 'pvConsumption',
      desc: '',
      args: [],
    );
  }

  /// `On grid`
  String get onGrid {
    return Intl.message(
      'On grid',
      name: 'onGrid',
      desc: '',
      args: [],
    );
  }

  /// `Charger charging`
  String get chargerCharging {
    return Intl.message(
      'Charger charging',
      name: 'chargerCharging',
      desc: '',
      args: [],
    );
  }

  /// `ESS discharge`
  String get essDischarge {
    return Intl.message(
      'ESS discharge',
      name: 'essDischarge',
      desc: '',
      args: [],
    );
  }

  /// `ESS charging`
  String get essCharging {
    return Intl.message(
      'ESS charging',
      name: 'essCharging',
      desc: '',
      args: [],
    );
  }

  /// `TS switch record`
  String get tsSwitchRecord {
    return Intl.message(
      'TS switch record',
      name: 'tsSwitchRecord',
      desc: '',
      args: [],
    );
  }

  /// `Past month`
  String get pastMonth {
    return Intl.message(
      'Past month',
      name: 'pastMonth',
      desc: '',
      args: [],
    );
  }

  /// `Past 3 months`
  String get past3Months {
    return Intl.message(
      'Past 3 months',
      name: 'past3Months',
      desc: '',
      args: [],
    );
  }

  /// `Past 6 months`
  String get past6Months {
    return Intl.message(
      'Past 6 months',
      name: 'past6Months',
      desc: '',
      args: [],
    );
  }

  /// `Total switch times`
  String get totalSwitchTimes {
    return Intl.message(
      'Total switch times',
      name: 'totalSwitchTimes',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Value`
  String get value {
    return Intl.message(
      'Value',
      name: 'value',
      desc: '',
      args: [],
    );
  }

  /// `No switch record`
  String get noSwitchRecord {
    return Intl.message(
      'No switch record',
      name: 'noSwitchRecord',
      desc: '',
      args: [],
    );
  }

  /// `Universal meter monitoring`
  String get universalMeterMonitoring {
    return Intl.message(
      'Universal meter monitoring',
      name: 'universalMeterMonitoring',
      desc: '',
      args: [],
    );
  }

  /// `Standby`
  String get standby {
    return Intl.message(
      'Standby',
      name: 'standby',
      desc: '',
      args: [],
    );
  }

  /// `Charge`
  String get charge {
    return Intl.message(
      'Charge',
      name: 'charge',
      desc: '',
      args: [],
    );
  }

  /// `Discharge`
  String get discharge {
    return Intl.message(
      'Discharge',
      name: 'discharge',
      desc: '',
      args: [],
    );
  }

  /// `Cluster monitoring`
  String get cluster_monitoring {
    return Intl.message(
      'Cluster monitoring',
      name: 'cluster_monitoring',
      desc: '',
      args: [],
    );
  }

  /// `Cell monitoring`
  String get cell_monitoring {
    return Intl.message(
      'Cell monitoring',
      name: 'cell_monitoring',
      desc: '',
      args: [],
    );
  }

  /// `Inverter details`
  String get inverter_details {
    return Intl.message(
      'Inverter details',
      name: 'inverter_details',
      desc: '',
      args: [],
    );
  }

  /// `Please select parameter`
  String get please_select_parameter {
    return Intl.message(
      'Please select parameter',
      name: 'please_select_parameter',
      desc: '',
      args: [],
    );
  }

  /// `Please select telemetry field`
  String get please_select_telemetry_field {
    return Intl.message(
      'Please select telemetry field',
      name: 'please_select_telemetry_field',
      desc: '',
      args: [],
    );
  }

  /// `Total energy consumption`
  String get total_energy_consumption {
    return Intl.message(
      'Total energy consumption',
      name: 'total_energy_consumption',
      desc: '',
      args: [],
    );
  }

  /// `Carbon emission`
  String get carbon_emission {
    return Intl.message(
      'Carbon emission',
      name: 'carbon_emission',
      desc: '',
      args: [],
    );
  }

  /// `tce`
  String get tce {
    return Intl.message(
      'tce',
      name: 'tce',
      desc: '',
      args: [],
    );
  }

  /// `0 carbon index`
  String get zero_carbon_index {
    return Intl.message(
      '0 carbon index',
      name: 'zero_carbon_index',
      desc: '',
      args: [],
    );
  }

  /// `t`
  String get t {
    return Intl.message(
      't',
      name: 't',
      desc: '',
      args: [],
    );
  }

  /// `Monthly energy`
  String get monthly_energy {
    return Intl.message(
      'Monthly energy',
      name: 'monthly_energy',
      desc: '',
      args: [],
    );
  }

  /// `Use`
  String get use {
    return Intl.message(
      'Use',
      name: 'use',
      desc: '',
      args: [],
    );
  }

  /// `Revenue type`
  String get revenue_type {
    return Intl.message(
      'Revenue type',
      name: 'revenue_type',
      desc: '',
      args: [],
    );
  }

  /// `Yearly revenue`
  String get yearly_revenue {
    return Intl.message(
      'Yearly revenue',
      name: 'yearly_revenue',
      desc: '',
      args: [],
    );
  }

  /// `Monthly revenue`
  String get monthly_revenue {
    return Intl.message(
      'Monthly revenue',
      name: 'monthly_revenue',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
