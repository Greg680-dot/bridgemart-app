@echo off
echo =======================================================
echo   BridgeMart - Script de Compilation Locale de l'APK
echo =======================================================
echo.

where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERREUR] Flutter SDK n'a pas ete detecte dans votre PATH.
    echo.
    echo Pour compiler l'APK sans installer Flutter sur votre machine :
    echo Utilisez le workflow automatique GitHub Actions inclus dans :
    echo   .github\workflows\build_apk.yml
    echo.
    echo Poussez ce dossier sur votre compte GitHub, et GitHub compilera
    echo l'APK gratuitement dans le Cloud en moins de 3 minutes !
    echo.
    pause
    exit /b 1
)

echo [1/3] Nettoyage et recuperation des dependances...
call flutter clean
call flutter pub get

echo.
echo [2/3] Compilation de l'APK Release...
call flutter build apk --release --no-tree-shake-icons

if %errorlevel% equ 0 (
    echo.
    echo =======================================================
    echo   [SUCCES] APK compile avec succes !
    echo   Emplacement du fichier APK :
    echo   build\app\outputs\flutter-apk\app-release.apk
    echo =======================================================
    echo.
    copy build\app\outputs\flutter-apk\app-release.apk BridgeMart-v1.0.0.apk
    echo Une copie nommee "BridgeMart-v1.0.0.apk" a ete placee a la racine.
) else (
    echo.
    echo [ERREUR] La compilation a echoue. Verifiez les logs ci-dessus.
)

pause
