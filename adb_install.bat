adb shell pm uninstall com.d954mas.ld45
adb install C:\Users\user\Desktop\armv7-android\LD45\LD45.apk
adb shell monkey -p com.d954mas.ld45 -c android.intent.category.LAUNCHER 1
pause
