class UnboardingContent {
  String image;
  String title;
  String description;
  UnboardingContent(
      {required this.description, required this.image, required this.title});
}

List<UnboardingContent> contents = [
  UnboardingContent(
      description: 'Find partners for your projects\n          ',
      image: "assets/globe.png",
      title: 'BMS Collabify'),
  UnboardingContent(
      description: 'Chat with others and\n  build your network',
      image: "assets/message.png",
      title: 'Develop Your Network'),
  UnboardingContent(
      description: 'Work hard and level up',
      image: "assets/levelup.png",
      title: 'Enjoy your progress!')
];
