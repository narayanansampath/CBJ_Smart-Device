import 'package:SmartDeviceDart/features/smart_device/application/usecases/smart_device_objects_usecase/abstracts_devices/smart_device_static_abstract.dart';
import 'package:SmartDeviceDart/features/smart_device/domain/entities/enums.dart';
import 'package:SmartDeviceDart/features/smart_device/domain/entities/wish_classes/blinds_wish.dart';
import 'package:SmartDeviceDart/features/smart_device/infrastructure/datasources/manage_physical_components/device_pin_manager.dart';
import 'package:SmartDeviceDart/features/smart_device/infrastructure/datasources/manage_physical_components/devices_pin_configuration/pin_information.dart';
import 'package:SmartDeviceDart/features/smart_device/infrastructure/repositories/button_click/button_object_local.dart';
import 'package:SmartDeviceDart/injection.dart';


class BlindsObject extends SmartDeviceStaticAbstract {


  PinInformation buttonPinUp, blindsUpPin, buttonPinDown, blindsDownPin;


  BlindsObject(macAddress, deviceName, onOffPinNumber,
      onOffButtonPinNumber,
      int blindsUpPin, int upButtonPinNumber, int blindsDownPin, int downButtonPinNumber)
      : super(macAddress, deviceName, onOffPinNumber,
      onOffButtonPinNumber: onOffButtonPinNumber) {
    buttonPinUp = getIt<DevicePinListManagerAbstract>().getGpioPin(
        this, upButtonPinNumber);
    buttonPinDown =
        getIt<DevicePinListManagerAbstract>().getGpioPin(
            this, downButtonPinNumber);

    this.blindsUpPin =
        getIt<DevicePinListManagerAbstract>().getGpioPin(this, blindsUpPin);
    this.blindsDownPin =
        getIt<DevicePinListManagerAbstract>().getGpioPin(this, blindsDownPin);
    listenToTwoButtonsPress();
  }


  @override
  Future<String> executeWish(String wishString) async {
    var wish = convertWishStringToWishesObject(wishString);
    return await wishInBlindsClass(wish);
  }

  //  All the wishes that are legit to execute from the blinds class
  Future<String> wishInBlindsClass(WishEnum wish) async {
    if(wish == null) return 'Your wish does not exist in blinds class';
    if (wish == WishEnum.blindsUp) return await BlindsWish.BlindsUp(this);
    if(wish == WishEnum.blindsDown) return await BlindsWish.blindsDown(this);
    if(wish == WishEnum.blindsStop) return await BlindsWish.blindsStop(this);

    return wishInStaticClass(wish);
  }


  void listenToTwoButtonsPress() {
    if (buttonPinUp != null && buttonPinDown != null &&
        blindsUpPin != null && blindsDownPin != null) {
      ButtonObjectLocal()
          .listenToTwoButtonPressedButtOnlyOneCanBePressedAtATime(
          this, buttonPinUp, blindsUpPin, buttonPinDown,
          blindsDownPin);
    }
    else {
      print('Cannot listen to blinds, one of the variables is null');
    }
  }
}