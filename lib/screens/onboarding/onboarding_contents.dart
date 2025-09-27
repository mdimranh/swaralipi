import 'dart:ui';

class OnboardingContents {
  final String title;
  final String image;
  final String desc;
  final Color color;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
    required this.color,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "🎧 Welcome to Swaralipi",
    image: "assets/images/logo.png",
    desc:
        "Your personal offline music companion — enjoy your favorite tracks anytime, anywhere, no internet needed.",
    color: const Color(0xffDAD3C8),
  ),
  OnboardingContents(
    title: "🎵 All Your Songs in One Place",
    image: "assets/images/ob2.png",
    desc:
        "We scan your device automatically and organize your music by artist, album, and genre — no setup needed.",
    color: const Color(0xffFFE5DE),
  ),
  OnboardingContents(
    title: "🎶 Create & Customize Playlists",
    image: "assets/images/ob3.png",
    desc:
        "Build and edit playlists effortlessly — drag, drop, and reorder songs to match your mood.",
    color: const Color(0xffDCF6E6),
  ),
  OnboardingContents(
    title: "🕒 Fall Asleep to Music",
    image: "assets/images/ob4.png",
    desc: "Set a timer and let your music gently fade out while you drift off.",
    color: const Color(0xffE2F0CB),
  ),
  OnboardingContents(
    title: "🎚️ Tune Your Sound",
    image: "assets/images/ob5.png",
    desc:
        "Personalize your listening with the built-in equalizer — presets or full control.",
    color: const Color(0xffE0E7FF),
  ),
];
