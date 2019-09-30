adb shell pm uninstall com.d954mas.speech.game
adb install C:\Users\user\Desktop\armv7-android\SpeechGame\SpeechGame.apk
adb shell monkey -p com.d954mas.speech.game -c android.intent.category.LAUNCHER 1
pause
