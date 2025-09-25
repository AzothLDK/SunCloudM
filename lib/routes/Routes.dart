import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suncloudm/View/HomeView/white_page.dart';
import 'package:suncloudm/View/LogView/editpassword_page.dart';
import 'package:suncloudm/View/LogView/test_page.dart';
import 'package:suncloudm/View/OAM/oam_mine/opl_operationteam_detail_page.dart';
import 'package:suncloudm/View/OAM/oam_mine/opl_operationteam_page.dart';
import 'package:suncloudm/View/OAM/oam_workspace/opl_dataAnalysis.dart';
import 'package:suncloudm/View/OAM/oam_workspace/opl_eventRecord_page.dart';
import 'package:suncloudm/View/OAM/oam_workspace/opl_inspectiontask_page.dart';
import 'package:suncloudm/View/OAM/oam_workspace/workingPage/op_workInfo_page.dart';
import 'package:suncloudm/View/OAM/oam_workspace/workingPage/opl_workInfo_page.dart';
import 'package:suncloudm/View/OAM/oam_workspace/workingPage/opl_worklist_page.dart';
import 'package:suncloudm/View/OAM/oam_workspace/opl_workschedule_page.dart';
import 'package:suncloudm/View/ProjectView/projectdetail_page.dart';
import 'package:suncloudm/View/WorkspaceView/Alarm/alarmRL_page.dart';
import 'package:suncloudm/View/WorkspaceView/Alarm/alarmSelete.dart';
import 'package:suncloudm/View/WorkspaceView/ChartAnalysis/chartAnalysisZ_page.dart';
import 'package:suncloudm/View/WorkspaceView/CnMonitoring/cnmonitoring_page.dart';
import 'package:suncloudm/View/WorkspaceView/CnMonitoring/cnmonitoring_page_single.dart';
import 'package:suncloudm/View/WorkspaceView/CnMonitoring/cnmonitoring_yxpage.dart';
import 'package:suncloudm/View/WorkspaceView/CollectingCycles/collectingcycles_page.dart';
import 'package:suncloudm/View/WorkspaceView/EMMonitoring/emMonitor_page.dart';
import 'package:suncloudm/View/WorkspaceView/ElePrice/eleprice_page.dart';
import 'package:suncloudm/View/WorkspaceView/ProfitAnalysis/profitanalysis_page.dart';
import 'package:suncloudm/View/WorkspaceView/PvMonitoring/pvnbq_detail_view.dart';
import 'package:suncloudm/View/WorkspaceView/PvMonitoring/pvoverview_page.dart';
import 'package:suncloudm/View/WorkspaceView/PvMonitoring/pvweather_detail.dart';
import 'package:suncloudm/View/WorkspaceView/ReportView/eleDetailReport_page.dart';
import 'package:suncloudm/View/WorkspaceView/ReportView/rewardReport_page.dart';
import 'package:suncloudm/View/WorkspaceView/ReportView/seleteReport_page.dart';
import 'package:suncloudm/View/WorkspaceView/Settlement/settlementanalysis_page.dart';
import 'package:suncloudm/View/WorkspaceView/Settlement/settlementdetail_cn_page.dart';
import 'package:suncloudm/View/WorkspaceView/Settlement/settlementdetail_page.dart';
import 'package:suncloudm/View/WorkspaceView/Settlement/settlementlist_page.dart';
import 'package:suncloudm/View/WorkspaceView/Settlement/settlementselete_page.dart';
import 'package:suncloudm/View/WorkspaceView/StrategicManagement/strategic_page.dart';
import '../View/WorkspaceView/Alarm/alarmHS_page.dart';
import '../View/WorkspaceView/ChartAnalysis/chartAlsSelete_page.dart';
import '../View/WorkspaceView/ChartAnalysis/chartAnalysisW_page.dart';
import '../View/WorkspaceView/ChartAnalysis/chartAnalysis_page.dart';
import '../View/WorkspaceView/ReportView/eleReport_page.dart';

class Routes {
  static final FluroRouter router = FluroRouter();

  static const seletereport = '/seletereport';

  static const dlreport = '/dlreport';

  static const eledetailreport = '/eledetailreport';

  static const rewardreport = '/rewardreport';

  static const profitanalysis = '/profitanalysis';

  static const strategic = '/strategic';

  static const settlementselete = '/settlementselete';

  static const settlementlist = '/settlementlist';

  static const settlementdetail = '/settlementdetail';

  static const cnSettlementdetail = '/cnSettlementdetail';

  static const settlementanalysis = '/settlementanalysis';

  static const collectingcycles = '/collectingcycles';

  static const eleprice = '/eleprice';

  static const editpassword = '/editpassword';

  static const pvOverViewPage = '/pvOverViewPage';

  static const pvweatherDetail = '/pvweatherDetail';

  static const pvnbqDetailView = '/pvnbqDetailView';

  static const chartAlsSeletePage = '/chartAlsSeletePage';

  static const chartAlsPage = '/chartAlsPage';

  static const chartAlsZPage = '/chartAlsZPage';

  static const chartAlsWPage = '/chartAlsWPage';

  static const alarmSeletePage = '/alarmSeletePage';

  static const alarmRLPage = '/alarmRLPage';

  static const alarmHSPage = '/alarmHSPage';

  static const whitePage = '/whitePage';

  static const emMonitorPage = '/emMonitorPage';

  static const projectDetail = '/projectDetail';

  static const cnmonitorPage = '/cnmonitorPage';

  static const cnmonitorPageSingle = '/cnmonitorPageSingle';

  static const cnmonitoringYxpage = '/cnmonitoringYxpage';

  static const oplteam = '/oplteam';

  static const oplteamDetail = '/oplteamDetail';

  static const oplworklist = '/oplworklist';

  static const opleventRecord = '/opleventRecord';

  static const oplInspectiontask = '/oplInspectiontask';

  static const oplWorkschedule = '/oplWorkschedule';

  static const oplWorkInfo = '/oplWorkInfo';

  static const opWorkInfo = '/opWorkInfo';

  static const testpage = '/testpage';

  static const oplDataAnalysis = '/oplDataAnalysis';

  void _config() {
    router.define(whitePage,
        handler: Handler(handlerFunc: (context, params) => const WhitePage()));

    router.define(seletereport,
        handler: Handler(
            handlerFunc: (context, params) => const SeleteReportPage()));

    router.define(dlreport,
        handler:
            Handler(handlerFunc: (context, params) => const EleReportPage()));

    router.define(eledetailreport,
        handler: Handler(
            handlerFunc: (context, params) => const EleDetailReportPage()));

    router.define(rewardreport,
        handler: Handler(
            handlerFunc: (context, params) => const RewardReportPage()));

    router.define(profitanalysis,
        handler: Handler(
            handlerFunc: (context, params) => const ProfitAnalysisPage()));

    router.define(strategic,
        handler:
            Handler(handlerFunc: (context, params) => const StrategicPage()));

    router.define(settlementselete,
        handler: Handler(
            handlerFunc: (context, params) => const SettlementseletePage()));

    router.define(settlementlist,
        handler: Handler(
            handlerFunc: (context, params) => const SettlementlistPage()));

    router.define('$settlementdetail/:str',
        handler: Handler(
            handlerFunc: (context, params) =>
                SettlementdetailPage(settleId: params['str']![0])));

    router.define('$cnSettlementdetail/:str',
        handler: Handler(
            handlerFunc: (context, params) =>
                SettlementdetailCnPage(settleId: params['str']![0])));

    router.define(settlementanalysis,
        handler: Handler(
            handlerFunc: (context, params) => const SettlementanalysisPage()));

    router.define(collectingcycles,
        handler: Handler(
            handlerFunc: (context, params) => const CollectingcyclesPage()));

    router.define(eleprice,
        handler:
            Handler(handlerFunc: (context, params) => const ElepricePage()));

    router.define(editpassword,
        handler: Handler(handlerFunc: (context, params) => const EditPWPage()));

    router.define(pvOverViewPage,
        handler:
            Handler(handlerFunc: (context, params) => const PVOverViewPage()));

    router.define('$pvnbqDetailView/:json',
        handler: Handler(
            handlerFunc: (context, params) =>
                PvnbqDetailView(nbqInfo: jsonDecode(params['json']![0]))));

    router.define(chartAlsSeletePage,
        handler: Handler(
            handlerFunc: (context, params) => const ChartAlsSeletePage()));

    router.define(chartAlsPage,
        handler:
            Handler(handlerFunc: (context, params) => const ChartAlsPage()));

    router.define(chartAlsZPage,
        handler: Handler(
            handlerFunc: (context, params) => const ChartanalysiszPage()));

    router.define(chartAlsWPage,
        handler: Handler(
            handlerFunc: (context, params) => const ChartanalysiswPage()));

    router.define(alarmSeletePage,
        handler:
            Handler(handlerFunc: (context, params) => const AlarmSelete()));

    router.define('$alarmRLPage/:id',
        handler: Handler(
            handlerFunc: (context, params) =>
                AlarmRLPage(itemId: int.parse(params['id']![0]))));

    router.define(alarmRLPage,
        handler:
            Handler(handlerFunc: (context, params) => const AlarmRLPage()));

    router.define('$alarmHSPage/:id',
        handler: Handler(
            handlerFunc: (context, params) =>
                AlarmHSPage(itemId: int.parse(params['id']![0]))));

    router.define(alarmHSPage,
        handler:
            Handler(handlerFunc: (context, params) => const AlarmHSPage()));

    router.define(emMonitorPage,
        handler:
            Handler(handlerFunc: (context, params) => const EmMonitorPage()));

    router.define(cnmonitorPage,
        handler: Handler(
            handlerFunc: (context, params) => const CnmonitoringPage()));

    router.define(cnmonitorPageSingle,
        handler: Handler(
            handlerFunc: (context, params) => const CnmonitoringPageSingle()));

    // router.define('$projectDetail/:json',
    //     handler: Handler(
    //         handlerFunc: (context, params) => ProjectdetailPage(
    //             projectInfo: jsonDecode(params['json']![0]))));

    router.define('$cnmonitoringYxpage/:json',
        handler: Handler(
            handlerFunc: (context, params) => CnmonitoringYxpage(
                projectInfo: jsonDecode(params['json']![0]))));

    router.define('$pvweatherDetail/:json',
        handler: Handler(
            handlerFunc: (context, params) =>
                PvweatherDetail(pageData: jsonDecode(params['json']![0]))));

    //OAM
    router.define(oplteam,
        handler: Handler(
            handlerFunc: (context, params) => const OplOperationteamPage()));

    router.define('$oplteamDetail/:id',
        handler: Handler(
            handlerFunc: (context, params) => OplOperationteamDetailPage(
                teamId: int.parse(params['id']![0]))));

    router.define(oplworklist,
        handler:
            Handler(handlerFunc: (context, params) => const OplWorklistPage()));

    //工单列表
    router.define('$oplworklist/:str',
        handler: Handler(handlerFunc: (context, params) {
      return OplWorklistPage(statusId: params['str']![0]);
    }));

    router.define(opleventRecord,
        handler: Handler(
            handlerFunc: (context, params) => const OplEventrecordPage()));

    router.define(oplInspectiontask,
        handler: Handler(
            handlerFunc: (context, params) => const OplInspectiontaskPage()));

    //工单详情
    router.define('$oplWorkInfo/:str',
        handler: Handler(handlerFunc: (context, params) {
      return OplWorkinfoPage(params['str']![0]);
    }));

    //工单详情
    router.define('$opWorkInfo/:str',
        handler: Handler(handlerFunc: (context, params) {
      return OpWorkinfoPage(params['str']![0]);
    }));

    router.define(oplWorkschedule,
        handler: Handler(
            handlerFunc: (context, params) => const OplWorkschedulePage()));

    router.define(oplDataAnalysis,
        handler:
            Handler(handlerFunc: (context, params) => const OplDataAnalysis()));

    router.define(testpage,
        handler: Handler(handlerFunc: (context, params) => const TestPage()));
  }

  Future navigateTo(BuildContext context, String path, [String param = '']) {
    var p = param.isNotEmpty ? '$path/$param' : path;
    return router.navigateTo(context, p,
        transition: TransitionType.inFromRight);
  }

  Future navigateFromBottom(BuildContext context, String path,
      [String param = '']) {
    var p = param.isNotEmpty ? '$path/$param' : path;
    return router.navigateTo(context, p,
        transition: TransitionType.inFromBottom);
  }

  factory Routes() => _getInstance()!;

  static Routes? get instance => _getInstance();
  static Routes? _instance;

  Routes._() {
    _config();
  }

  static Routes? _getInstance() {
    _instance ??= Routes._();
    return _instance;
  }
}
