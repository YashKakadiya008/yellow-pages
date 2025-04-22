import 'package:yellowpages/utils/app_constants.dart';

class OnBordingData {
  String imagePath;
  String title;
  String description;

  OnBordingData(
      {required this.imagePath,
      required this.title,
      required this.description});
}

List<OnBordingData> onBordingDataList = [
  OnBordingData(
      imagePath: "$rootImageDir/onbording_1.png",
      title: "Track Down Your Best Listing",
      description:
          "You can get your desired listing items here\nby name, category or location."),
  OnBordingData(
      imagePath: "$rootImageDir/onbording_2.png",
      title: "Select your Category Easily",
      description:
          "You can get your desired listing items here\nby name, category or location."),
  OnBordingData(
      imagePath: "$rootImageDir/onbording_3.png",
      title: "Choose Your Pricing Plan",
      description:
          "You can get your desired listing items here\nby name, category or location."),
];
