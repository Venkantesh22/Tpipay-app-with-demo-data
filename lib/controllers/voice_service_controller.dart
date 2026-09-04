import 'dart:developer';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lekra/services/constants.dart';

class VoiceServiceController extends GetxController implements GetxService {
  bool isLoading = false;
  AudioPlayer? _audioPlayer;

  static const String _azureRegion = "centralindia";

  Future<void> speak(String message, String shortLangCode) async {
    isLoading = false;
    update();
    try {
      _audioPlayer ??= AudioPlayer();

      // 1. Map your short codes to Azure's FEMALE Neural Voices
      String languageCode = "en-IN";
      String voiceName =
          "en-IN-NeerjaNeural"; // 👩 Natural Indian English Female

      if (shortLangCode == "hi") {
        languageCode = "hi-IN";
        voiceName = "hi-IN-SwaraNeural"; // 👩 Natural Hindi Female
      } else if (shortLangCode == "or") {
        languageCode = "or-IN";
        voiceName = "or-IN-SubhasiniNeural"; // 🔴👩 Natural Odia Female
      }

      log("Requesting Azure TTS for: $voiceName");

      // 2. Azure TTS Endpoint
      final String endpoint =
          "https://$_azureRegion.tts.speech.microsoft.com/cognitiveservices/v1";

      // 3. Build the SSML (XML) payload
      String ssml = '''
        <speak version='1.0' xml:lang='$languageCode'>
          <voice xml:lang='$languageCode' name='$voiceName'>
            <prosody rate="-10%"> $message
            </prosody>
          </voice>
        </speak>
      ''';

      // 4. Send the request
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          "Ocp-Apim-Subscription-Key":
              "AppConstants.azureAITextToSpeechAPIKey.trim()",
          "Content-Type": "application/ssml+xml",
          "X-Microsoft-OutputFormat":
              "audio-16khz-128kbitrate-mono-mp3", // Request MP3 format
        },
        body: ssml,
      );

      // 5. Play the Audio
      // 5. Play the Audio
      if (response.statusCode == 200) {
        Uint8List audioBytes = response.bodyBytes;

        // 🔴 CRITICAL: Tell Android to force this audio through the speaker even in the background
        await _audioPlayer!.setAudioContext(AudioContext(
          android: AudioContextAndroid(
            isSpeakerphoneOn: true,
            stayAwake: true,
            contentType: AndroidContentType.speech,
            usageType: AndroidUsageType
                .alarm, // Treats it like an alarm to bypass media silence
            audioFocus: AndroidAudioFocus
                .gainTransientMayDuck, // Hijacks the audio focus
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: {AVAudioSessionOptions.mixWithOthers},
          ),
        ));

        // Start playing the audio
        await _audioPlayer!.play(BytesSource(audioBytes));
        log("Azure TTS audio started playing...");

        // 🔴 CRITICAL: Wait for the audio to completely finish before moving to the next line!
        // This guarantees Android won't kill the app mid-sentence.
        await _audioPlayer!.onPlayerComplete.first;
        log("Azure TTS audio finished playing completely!");
      } else {
        log("Azure TTS Error: ${response.statusCode}");
      }
    } catch (e) {
      log("Error in VoiceService: $e");
    } finally {
      isLoading = false;
      update();
    }
  }
}
