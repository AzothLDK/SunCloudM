import 'package:dio/dio.dart';
import 'config.dart';
import 'network_utils.dart';

class LoginDao {
  static Future<Map> login(Map<String, dynamic> model) async {
    var r = await NetworkUtils.login(loginUrl, params: model);
    return r;
  }

  static Future<Map> cnLogin(Map<String, dynamic> model) async {
    var r = await NetworkUtils.post(cnloginUrl, params: model);
    return r;
  }

  static Future<Map> getAppMenuTree({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(appVgetAppMenuTreeersionUrl, params: params);
    return r;
  }

  static Future<Map> changePassword({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.post(editPasswordUrl, params: params);
    return r;
  }

  static Future<Map> getProjectListUrl({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(projectListUrl, params: params);
    return r;
  }

  static Future<Map> getItem({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getItemUrl, params: params);
    return r;
  }

  static Future<Map> getItemInfo({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getItemInfoUrl, params: params);
    return r;
  }

  //app版本
  static Future<Map> appVersion({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(appVersionUrl, params: params);
    return r;
  }

  static Future<Map> getworkTeamList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(workTeamListUrl, params: params);
    return r;
  }
  
  //获取告警消息列表
  static Future<Map> getAlarmList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(alarmListUrl, params: params);
    return r;
  }
}

class IndexDao {
  static Future<Map> getIndexNum({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(indexNumUrl, params: params);
    return r;
  }

  static Future<Map> getBossHomeTopInfo({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(bossHomeTopInfoUrl, params: params);
    return r;
  }

  static Future<Map> getBossHomeIncomeInfo(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(bossHomeIncomeInfoUrl, params: params);
    return r;
  }

  static Future<Map> getBossHomeInvestInfo(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(bossHomeInvestInfoUrl, params: params);
    return r;
  }

  static Future<Map> getBossHomeDeviceList(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(bossHomeDeviceListUrl, params: params);
    return r;
  }

  static Future<Map> getDeviceModelDistribution(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(deviceModelDistributionUrl, params: params);
    return r;
  }

//运营商首页
  static Future<Map> getYysIndexNum({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(yysIndexNumUrl, params: params);
    return r;
  }

  static Future<Map> getYysHomeTopInfo({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(yysHomeTopInfoUrl, params: params);
    return r;
  }

  static Future<Map> getYysHomeIncomeInfo(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(yysHomeIncomeInfoUrl, params: params);
    return r;
  }

  static Future<Map> getYysHomeIncomeCompare(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(yysHomeIncomeCompareUrl, params: params);
    return r;
  }

  //集成商首页数据
  static Future<Map> getJCTopNum({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(jcTopNumUrl, params: params);
    return r;
  }

  static Future<Map> getJCHomeTopInfo({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(jcHomeTopInfoUrl, params: params);
    return r;
  }

  static Future<Map> getJCHomeDistribution(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(jcHomeDistributionUrl, params: params);
    return r;
  }

  static Future<Map> getJCHomeEfficiencyInfo(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(jcHomeEfficiencyInfoUrl, params: params);
    return r;
  }

  //储能单站首页
  static Future<Map> getCnSingleHomeTopInfo(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnSingleHomeTopInfoUrl, params: params);
    return r;
  }

  static Future<Map> getCnSingleHomeRunInfo(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnSingleHomeRunInfoUrl, params: params);
    return r;
  }

  static Future<Map> getItemPicUrlInfo({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getItemPicUrlInfoUrl, params: params);
    return r;
  }

  static Future<Map> getCnSingleHomeIncomeInfo(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnSingleHomeIncomeInfoUrl, params: params);
    return r;
  }

  static Future<Map> getCnSingleHomeStatus(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnSingleHomeStatusUrl, params: params);
    return r;
  }

  static Future<Map> getCnSingleHomePowerChart(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnSingleHomePowerChartUrl, params: params);
    return r;
  }

  static Future<Map> getCnSingleHomeEnergyChart(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnSingleHomeEnergyChartUrl, params: params);
    return r;
  }

  static Future<Map> getCnSingleHomeIncomeChart(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnSingleHomeIncomeChartUrl, params: params);
    return r;
  }

  //储能运营商数据
  static Future<Map> getCnTopNum({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.post(cnTopNumUrl, params: params);
    return r;
  }

  static Future<Map> getCnIncomeInfo({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnIncomeInfoUrl, params: params);
    return r;
  }

  static Future<Map> getCnPowerChart({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnPowerChartUrl, params: params);
    return r;
  }

  static Future<Map> getCnEnergyChart({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnEnergyChartUrl, params: params);
    return r;
  }

  static Future<Map> getCnIncomeChart({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnIncomeChartUrl, params: params);
    return r;
  }

  static Future<Map> getCnRankList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnRankListUrl, params: params);
    return r;
  }

  //微网首页数据
  static Future<Map> getWwSingleHomeTopInfo(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(wwSingleHomeTopInfoUrl, params: params);
    return r;
  }

  static Future<Map> getWwSingleHomeStationInfo(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(wwSingleHomeStationInfoUrl, params: params);
    return r;
  }

  static Future<Map> getWwSingleHomePowerChart(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(wwSingleHomePowerChartUrl, params: params);
    return r;
  }

  static Future<Map> getWwSingleHomeEnergyChart(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(wwSingleHomeEnergyChartUrl, params: params);
    return r;
  }

  static Future<Map> getWwSingleHomeRunInfo(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(wwSingleHomeRunInfoUrl, params: params);
    return r;
  }

  //光伏运营商接口
  static Future<Map> getPvTopNum({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.post(pvTopNumUrl, params: params);
    return r;
  }

  static Future<Map> getPvStationList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(pvStationListUrl, params: params);
    return r;
  }

  static Future<Map> getPvPowerEnergyChart(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(pvPowerEnergyChartUrl, params: params);
    return r;
  }

  static Future<Map> getPvIncomeChart({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(pvIncomeChartUrl, params: params);
    return r;
  }

  static Future<Map> getPvRankList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(pvRankListUrl, params: params);
    return r;
  }

  //光伏单站接口
  static Future<Map> getPvSingleHomeTopInfo(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(pvSingleHomeTopInfoUrl, params: params);
    return r;
  }

  static Future<Map> getPvSingleHomeStationInfo(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(pvSingleHomeStationInfoUrl, params: params);
    return r;
  }

  static Future<Map> getPvSingleHomeRunInfo(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(pvSingleHomeRunInfoUrl, params: params);
    return r;
  }

  static Future<Map> getPvSingleHomePowerChart(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(pvSingleHomePowerChartUrl, params: params);
    return r;
  }

  static Future<Map> getPvSingleHomeEnergyChart(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(pvSingleHomeEnergyChartUrl, params: params);
    return r;
  }

  static Future<Map> getPvSingleHomeDayFullChart(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(pvSingleHomeDayFullChartUrl, params: params);
    return r;
  }

  static Future<Map> getPvSingleHomeIncomeChart(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(pvSingleHomeIncomeChartUrl, params: params);
    return r;
  }

  static Future<Map> getSingleTopInfo({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(singleTopInfoUrl, params: params);
    return r;
  }

  static Future<Map> getSingleCenter({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(singleCenterUrl, params: params);
    return r;
  }

  static Future<Map> getggSinglePowerChart(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(ggSinglePowerChartUrl, params: params);
    return r;
  }

  static Future<Map> getAirLoopList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(airLoopListUrl, params: params);
    return r;
  }

  static Future<Map> getMonitorInfo({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(monitorInfoUrl, params: params);
    return r;
  }

  static Future<Map> postIssue({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.post(postIssueUrl, params: params);
    return r;
  }

  static Future<Map> insertOrUpdate({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.post(insertOrUpdateUrl, params: params);
    return r;
  }

  static Future<Map> getindexGeneralView({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(indexGeneralViewUrl, params: params);
    return r;
  }

  static Future<Map> getWeather({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getWeatherUrl, params: params);
    return r;
  }

  static Future<Map> getindexSYLineChart({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(indexSYLineChart, params: params);
    return r;
  }

  static Future<Map> getindexStatusInfo({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(indexStatusInfoUrl, params: params);
    return r;
  }

  static Future<Map> getStrategyInfo({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getStrategyInfoUrl, params: params);
    return r;
  }

  static Future<Map> getSelectPeak({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(selectPeakUrl, params: params);
    return r;
  }

  static Future<Map> getindexPVLineChart({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(indexPVLineChart, params: params);
    return r;
  }

  static Future<Map> getindexDSYLineChart(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(indexDSYLineChart, params: params);
    return r;
  }

  static Future<Map> getProjectInfoUrl({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(projectInfoUrl, params: params);
    return r;
  }

  static Future<Map> getPvStationInfo({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(pvStationInfo, params: params);
    return r;
  }

  static Future<Map> getPvInverterEp({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.post(pvInverterEp, params: params);
    return r;
  }

  static Future<Map> getPvInverterPower({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.post(pvInverterPower, params: params);
    return r;
  }

  static Future<Map> getNbqList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(nbqList, params: params);
    return r;
  }

  static Future<Map> getycList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getycListUrl, params: params);
    return r;
  }

  static Future<Map> getDetailNbq({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.post(getDetailNbqUrl, params: params);
    return r;
  }

  //运维首页
  static Future<Map> getOplHomeInfo({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(oplHomeInfoUrl, params: params);
    return r;
  }

  //运维班组列表
  static Future<Map> getOplGroupList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(oplGroupListUrl, params: params);
    return r;
  }
}

class StrategyDao {
  static Future<Map> getStrategy({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(strategyUrl, params: params);
    return r;
  }

  static Future<Map> getStrateHistorygy({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(strategyHistoryUrl, params: params);
    return r;
  }

  static Future<Map> getprice({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(priceUrl, params: params);
    return r;
  }

  static Future<Map> getsettleList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(settleListUrl, params: params);
    return r;
  }

  static Future<Map> getsettleDetail({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(settleDetailUrl, params: params);
    return r;
  }

  static Future<Map> getCnSettleDetail({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnSettleDetail, params: params);
    return r;
  }

  static Future<Map> getcycleList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cycleListUrl, params: params);
    return r;
  }
}

class ReportDao {
  static Future<Map> getpvHourReport({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(pvHourReportUrl, params: params);
    return r;
  }

  static Future<Map> getstorageHourReport(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(storageHourReportUrl, params: params);
    return r;
  }

  static Future<Map> getmicIncome({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(micIncomeUrl, params: params);
    return r;
  }

  static Future<Map> getcnAndPvIncome({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnAndPvIncomeUrl, params: params);
    return r;
  }

  static Future<Map> getcnAppIncome({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnAppIncomeUrl, params: params);
    return r;
  }

  static Future<Map> getincomeChartData({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(incomeChartUrl, params: params);
    return r;
  }

  static Future<Map> getincomeinfoData({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(incomeinfoUrl, params: params);
    return r;
  }

  static Future<Map> getincomeRadarData({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(incomeRadarUrl, params: params);
    return r;
  }

  static Future<Map> getSingleIncome({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(singleIncomeUrl, params: params);
    return r;
  }

  static Future<Map> getOperationRun({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(operationRunUrl, params: params);
    return r;
  }

  static Future<Map> getSingleIncomeCurve(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(singleIncomeCurveUrl, params: params);
    return r;
  }
}

class ChartDao {
  static Future<Map> getEpChartAls({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(epChartAls, params: params);
    return r;
  }

  static Future<Map> getUIChartAls({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.post(uiChartAls, params: params);
    return r;
  }

  static Future<Map> getInverterList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(inverterList, params: params);
    return r;
  }

  static Future<Map> getCommonDropList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(commonDropList, params: params);
    return r;
  }

  static Future<Map> getDWChartAls({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(dwChartAls, params: params);
    return r;
  }
}

class AlarmDao {
  static Future<Map> getAlarmStationList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(alarmStationList, params: params);
    return r;
  }

  static Future<Map> getDeviceClassifyList(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(deviceClassifyList, params: params);
    return r;
  }

  static Future<Map> getDeviceModeList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(deviceModeList, params: params);
    return r;
  }

  static Future<Map> getDeviceList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(deviceList, params: params);
    return r;
  }

  static Future<Map> getfieldList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(fieldList, params: params);
    return r;
  }

  static Future<Map> getTodayCount({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(todayCount, params: params);
    return r;
  }

  static Future<Map> getAlarmList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(alarmList, params: params);
    return r;
  }

  static Future<Map> getAlarmHistoryList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(alarmHistoryList, params: params);
    return r;
  }
}

class EleMeterDao {
  static Future<Map> getMeterInfo({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(meterInfo, params: params);
    return r;
  }

  static Future<Map> getEleQuantityCure({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(eleQuantityCure, params: params);
    return r;
  }

  static Future<Map> getEleLoadCure({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(eleLoadCure, params: params);
    return r;
  }

  static Future<Map> getReactivePowerCure(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(reactivePowerCure, params: params);
    return r;
  }

  static Future<Map> getPowerFactorCure({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(powerFactorCure, params: params);
    return r;
  }

  static Future<Map> getEleCurrentCure({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(eleCurrentCure, params: params);
    return r;
  }

  static Future<Map> getVoltageCure({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(voltageCure, params: params);
    return r;
  }
}

class CnMonitorDao {
  static Future<Map> cnMonitorTabList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnMonitorTabListUrl, params: params);
    return r;
  }

  static Future<Map> cnOverviewHomepage({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnOverviewHomepageUrl, params: params);
    return r;
  }

  static Future<Map> getcnEpList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnEpListUrl, params: params);
    return r;
  }

  static Future<Map> getcnChargeList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(cnChargeListUrl, params: params);
    return r;
  }

  static Future<Map> tabDataSelectList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.post(tabDataSelectListUrl, params: params);
    return r;
  }

  static Future<Map> getTabDownData({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.post(getTabDownDataUrl, params: params);
    return r;
  }

  static Future<Map> getTabUpData({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.post(getTabUpDataUrl, params: params);
    return r;
  }

  static Future<Map> getDXdata({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getDXdataUrl, params: params);
    return r;
  }

  static Future<Map> getChangeRecord({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(changeRecordUrl, params: params);
    return r;
  }
}

class WorkDao {
  //工单列表
  static Future<Map> getworkOrderList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.post(workOrderListUrl, params: params);
    return r;
  }

  //工单详情
  static Future<Map> getdetailsByWorkNumber(
      {Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getdetailsByWorkNumberUrl, params: params);
    return r;
  }

  //工单流转详情
  static Future<Map> getworkEventList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getworkEventListUrl, params: params);
    return r;
  }

  //工单流转
  static Future<Map> saveWorkEvent({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.post(saveWorkEventUrl, params: params);
    return r;
  }

  //修改工单
  static Future<Map> updateWorkOrder({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.post(updateWorkOrderUrl, params: params);
    return r;
  }

  //获取班组人员列表
  static Future<Map> getTeamMemberList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getTeamMemberListUrl, params: params);
    return r;
  }

  //获取班组列表
  static Future<Map> getGroupList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getGroupListUrl, params: params);
    return r;
  }

  //获取团队列表
  static Future<Map> getTeamList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getTeamListUrl, params: params);
    return r;
  }

  //获取站点运维信息列表
  static Future<Map> selectStationById({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(selectStationByIdUrl, params: params);
    return r;
  }

  //获取工作类型列表
  static Future<Map> getWorkTypeList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getWorkTypeListUrl, params: params);
    return r;
  }

  //获取班组人员列表
  static Future<Map> getGroupMemberList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getGroupMemberListUrl, params: params);
    return r;
  }

  //获取工作列表
  static Future<Map> getWorkSchedule({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getWorkScheduleUrl, params: params);
    return r;
  }

  //获取工单汇总
  static Future<Map> getWorkSummary({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getWorkSummaryUrl, params: params);
    return r;
  }

  //获取单量统计
  static Future<Map> getAcceptStatistics({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getAcceptStatisticsUrl, params: params);
    return r;
  }

  //获取工作列表排名
  static Future<Map> getWorkRank({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(getWorkRankUrl, params: params);
    return r;
  }
  
  //获取工单消息列表
  static Future<Map> getWorkNotificationList({Map<String, dynamic>? params}) async {
    var r = await NetworkUtils.get(workNotificationListUrl, params: params);
    return r;
  }
}

class CommonDao {
  //上传文件
  static Future<Map> fileUpload({FormData? formData}) async {
    var r = await NetworkUtils.postFile(fileUploadUrl, formData: formData);
    return r;
  }
}
