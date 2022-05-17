
import 'package:supercab/utils/model/cityModel.dart';
import 'package:supercab/utils/model/airportNameModel.dart';
import 'package:supercab/generated/l10n.dart';


List<CityNameModel> cityNamesList(context) => [
  CityNameModel(name:S.of(context).Melbourne,index: '0'),
  CityNameModel(name:S.of(context).Sydney,index: '1'),
  CityNameModel(name:S.of(context).Adelaide,index :'2'),
  CityNameModel(name:S.of(context).Perth,index: '3'),
  CityNameModel(name:S.of(context).Brisbane,index: '4'),
  CityNameModel(name:S.of(context).Canberra,index: '5'),
  CityNameModel(name:S.of(context).Darwin,index: '6'),
  CityNameModel(name:S.of(context).Gold_Coast,index: '7'),
  CityNameModel(name:S.of(context).Cairns,index: '8')
];

List<String> vehicleNames(context) => [
  S.of(context).Business_Sedan,
  S.of(context).European_Prestige,
  S.of(context).SUV,
  S.of(context).Mini_Van,
];

List<AirportNameModel> airPortNamesListForCity(context) => [
  AirportNameModel(name:S.of(context).Adelaide_Airport,index:'0'),
  AirportNameModel(name:S.of(context).Brisbane_Airport,index:'1'),
  AirportNameModel(name:S.of(context).Cairns_Airport,index: '2'),
  AirportNameModel(name:S.of(context).Canberra_Airport,index: '3'),
  AirportNameModel(name:S.of(context).Darwin_Airport,index: '4'),
  AirportNameModel(name:S.of(context).Gold_Cost_Airport,index: '5'),
  AirportNameModel(name:S.of(context).Melbourne_Tullamarine_Airport,index: '6'),
  AirportNameModel(name:S.of(context).Melbourne_Avalon_Airport,index: '7'),
  AirportNameModel(name:S.of(context).Perth_Airport,index:'8'),
  AirportNameModel(name:S.of(context).Sydney_Airport,index: '9')
];

List<AirportNameModel> airPortNamesList(context) => [
  //'Adelaide Airport',
  //'Brisbane Airport',
  //'Cairns Airport',
  //'Canberra Airport',
  //'Darwin Airport',
  //'Gold Cost Airport',
  AirportNameModel(name:S.of(context).Melbourne_Tullamarine_Airport,index: '0'),
  AirportNameModel(name:S.of(context).Melbourne_Avalon_Airport,index: '1'),
  //'Perth Airport',
  //'Sydney Airport'
];