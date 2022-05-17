import 'package:supercab/utils/userController.dart';
import 'package:get/get.dart';
import 'package:supercab/utils/model/AirportPriceList.dart';
import 'package:supercab/utils/model/AirportPriceModel.dart';
import 'package:flutter/material.dart';
import 'package:supercab/generated/l10n.dart';

CurrentUser user;

List<String> checkPriceListForSelectedAirportInAirportFare(airPortFareVehiclePrice) {
  user = Get.find<CurrentUser>();

  if(user.fromCityToAirport || user.fromMelbourneAirportsToAreas)
    {
      if (user.selectedAirport == 0 || user.selectedAirport == 6) //'Melbourne Tullamarine Airport'
      {

        AirportPriceModel model =  melbournePriceList.firstWhere((element) => element.locationName == user.areaNameForAirport);
        user.areaPriceForAirport = model.price;

        if(user.areaPriceForAirport != null)
        {
          int sedanPrice = user.areaPriceForAirport;
          int prestigePrice = sedanPrice + 20;
          int suvPrice = sedanPrice + 20;
          int miniVanPrice = sedanPrice + 40;
          return airPortFareVehiclePrice = ['$sedanPrice', '$prestigePrice', '$suvPrice', '$miniVanPrice'];
        }
        else
        {
          print('************');
          print('Area Price is :' + user.areaPriceForAirport.toString());
          print('************');
        }
      }
      else if (user.selectedAirport == 1 || user.selectedAirport == 7) //'Melbourne Avalon Airport'
      {
        AirportPriceModel model = melbourneAvalonPriceList.firstWhere((element) => element.locationName == user.areaNameForAirport);
        user.areaPriceForAirport = model.price;

        if(user.areaPriceForAirport != null)
        {
          int sedanPrice = user.areaPriceForAirport;
          int prestigePrice = sedanPrice + 20;
          int suvPrice = sedanPrice + 20;
          int miniVanPrice = sedanPrice + 40;
          return airPortFareVehiclePrice = ['$sedanPrice', '$prestigePrice', '$suvPrice', '$miniVanPrice'];
        }
        else
        {
          print('************');
          print('Area Price is :' + user.areaPriceForAirport.toString());
          print('************');
        }
      }
    }

  else if(user.fromAirportToCity)
    {
      if (user.selectedAirport == 0) //'Adelaide Airport'
      {
        return airPortFareVehiclePrice = ['70', '90', '90', '105'];
      }
      else if (user.selectedAirport == 1) //'Brisbane Airport'
      {
        return airPortFareVehiclePrice = ['75', '95', '95', '110'];
      }
      else if (user.selectedAirport == 2) //'Cairns Airport'
      {
        return airPortFareVehiclePrice = ['80', '100', '100', '115'];
      }
      else if (user.selectedAirport == 3)
      {
        return airPortFareVehiclePrice = ['70', '90', '90', '105'];
      }
      else if (user.selectedAirport == 4)
      {
        return airPortFareVehiclePrice = ['80', '100', '100', '115'];
      }
      else if (user.selectedAirport == 5)
      {
        return airPortFareVehiclePrice = ['85', '95', '95', '120'];
      }
      else if (user.selectedAirport == 6)
      {
        return airPortFareVehiclePrice = ['73', '93', '93', '108'];
      }
      else if (user.selectedAirport == 7)
      {
        return airPortFareVehiclePrice = ['140', '160', '160', '175'];
      }
      else if (user.selectedAirport == 8)
      {
        return airPortFareVehiclePrice = ['75', '95', '95', '110'];
      }
      else if (user.selectedAirport == 9)
      {
        return airPortFareVehiclePrice = ['75', '95', '95', '110'];
      }
    }

  return ['nothing'];
}

List<String> checkPriceListForSelectedCityInHourlyTransfer(hourTransferVehiclePrice,BuildContext context) {
  user = Get.find<CurrentUser>();
  if (user.selectedCity == 0) {
    return hourTransferVehiclePrice = ['80', '85', '90', '100'];
  } else if (user.selectedCity == 1) {
    return hourTransferVehiclePrice = ['80', '90', '95', '100'];
  } else if (user.selectedCity == 2) {
    return hourTransferVehiclePrice = ['80', '85', '90', '100'];
  } else if (user.selectedCity == 3) {
    return hourTransferVehiclePrice = ['80', '85', '90', '100'];
  } else if (user.selectedCity == 4) {
    return hourTransferVehiclePrice = ['80', '90', '90', '100'];
  } else if (user.selectedCity == 5) {
    return hourTransferVehiclePrice = ['80', '90', '90', '100'];
  } else if (user.selectedCity == 6) {
    return hourTransferVehiclePrice = ['85', '95', '95', '110'];
  } else if (user.selectedCity == 7) {
    return hourTransferVehiclePrice = ['85', '95', '95', '110'];
  } else if (user.selectedCity == 8) {
    return hourTransferVehiclePrice = ['85', '95', '95', '110'];
  }
  return ['nothing'];
}

int calculateCostForHourlyTransfer(int price, int hours) {
  int totalCost = price * hours;
  return totalCost;
}

List<String> costForHourlyTransfer(List<String> vehiclePrices, int hours) {
  List<String> totalCostList = [];
  user = Get.find<CurrentUser>();
  for (int i = 0; i < 4; i++) {
    int price = int.parse(vehiclePrices[i]);
    totalCostList.add(calculateCostForHourlyTransfer(price, hours).toString());
  }
  return totalCostList;
}

int calculateCostForLocalTransfer(String selectedVehicle, int totalKilometers, BuildContext context) {

  double pricePerKM = 2.30;
  double totalKMCost = pricePerKM * totalKilometers;
  double totalPrice = totalKMCost + 15;

  if(totalPrice < 55)
    {
      print('***** Estimated Fare is less than 55\$ *****');
      totalPrice = 55;
    }

  if (selectedVehicle == S.of(context).Business_Sedan) {
    return totalPrice.toInt();
  }
  if (selectedVehicle == S.of(context).European_Prestige) {
    totalPrice = totalPrice + 25;
    return totalPrice.toInt();
  } else if (selectedVehicle == S.of(context).SUV) {
    totalPrice = totalPrice + 20;
    return totalPrice.toInt();
  } else if (selectedVehicle == S.of(context).Mini_Van) {
    totalPrice = totalPrice + 40;
    return totalPrice.toInt();
  }

  return totalPrice.toInt();
}

List<String> costForLocalTransfer(List<String> vehicleNames,BuildContext context) {
  List<String> totalCostList = [];
  user = Get.find<CurrentUser>();
  for (int i = 0; i < 4; i++) {
    totalCostList.add(calculateCostForLocalTransfer(vehicleNames[i], user.totalKilometers, context).toString());
  }
  return totalCostList;
}
