class WelcomeSlide {
  final String gifAsset;
  final String text;

  WelcomeSlide({required this.gifAsset, required this.text});
}

final List<WelcomeSlide> slidesData = [
  WelcomeSlide(gifAsset: "assets/welcome_slide_1.gif", text: "Welcome to Tawkie your all-in-one messaging aplication."),
  WelcomeSlide(gifAsset: "assets/welcome_slide_2.gif", text: "We are a little start-up but with strong values."),
  WelcomeSlide(gifAsset: "assets/welcome_slide_3.gif", text: "Thank you to be one of the first to use Tawkie. Your feed bach with be gold for us."),
  WelcomeSlide(gifAsset: "assets/welcome_slide_1.gif", text: "Enjoy your all-in-one messaging journey."),
];
