$SplashWindowContent = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
x:Name="splash"
WindowStartupLocation="CenterScreen"
Topmost="True"
WindowStyle="None"
Background="Transparent"
AllowsTransparency="True"
Width="1024"
Height="600"
ShowInTaskbar="false">
<Border CornerRadius="15" Height="600" Width="1024">
<Border.Background>
<ImageBrush ImageSource="http://127.0.0.1:5500/static/Images/splash.jpg"/>
</Border.Background>
<StackPanel Orientation="Vertical" VerticalAlignment="Center" HorizontalAlignment="Center">
<TextBlock Text="itt"
FontSize="250"
Foreground="#0366d6"
FontFamily="Arial"
FontWeight="Bold"
TextAlignment="Center"/>
<TextBlock Text="Wake up, Neo..."
FontSize="20"
Foreground="white"
TextAlignment="Center"/>
</StackPanel>
</Border>
</Window>
"@
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
[DllImport("kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
}
"@
$hwnd = [Win32]::GetConsoleWindow()
[Win32]::ShowWindowAsync($hwnd, 3) | Out-Null
$Host.UI.RawUI.BackgroundColor = 'Black'
$Host.UI.RawUI.WindowTitle = "Install Twaeks Tool"
Clear-Host
Add-Type -AssemblyName 'System.Windows.Forms', 'PresentationFramework', 'PresentationCore', 'WindowsBase','System.Net.Http'
$reader = New-Object System.Xml.XmlNodeReader ([xml]$SplashWindowContent)
$splash = [Windows.Markup.XamlReader]::Load($reader)
$splash.Show()
Write-Host "`n  Relax, good things are loading… almost there!" -ForegroundColor Yellow
$itt = [Hashtable]::Synchronized(@{
ProcessRunning = $false
database       = @{}
api            = $null
version        = "25.12.29"
registryPath   = "HKCU:\Software\ITT@emadadel"
icon           = "https://raw.githubusercontent.com/emadadeldev/ittea/main/static/Icons/icon.ico"
Theme          = "default"
Date           = (Get-Date -Format "MM/dd/yyy")
Language       = "default"
ittDir         = "$env:ProgramData\itt\"
command        = "$($MyInvocation.MyCommand.Definition)"
})
if(-not $Debug)
{
$checkUrl = "https://ver.emadadel4-a0a.workers.dev/check?version=$($itt.version)"
$itt.api = Invoke-RestMethod -Uri $checkUrl -ErrorAction Stop
if ($itt.api.status) {
Write-Host "$($itt.api.message)" -ForegroundColor Red
read-host "   Press Enter to visit https://github.com/emadadeldev/ittea"
Start-Process("https://github.com/emadadeldev/ittea")
$splash.Close()
exit
}
}
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
Start-Process -FilePath "PowerShell" -ArgumentList "-ExecutionPolicy Bypass -NoProfile -Command `"$($MyInvocation.MyCommand.Definition)`"" -Verb RunAs
exit
}
if (-not (Test-Path -Path $itt.ittDir)) {New-Item -ItemType Directory -Path $itt.ittDir -Force | Out-Null}
Start-Transcript -Path (Join-Path $itt.ittDir "logs\log_$(Get-Date -Format 'yyyy-MM-dd').log") -Append -Force *> $null
$itt.database.locales = @'
{"Controls":{"ar":{"name":"عربي","Welcome":"توفر هذه الأداة تسهيلات كبيرة في عملية تثبيت البرامج وتحسين الويندوز. انضم إلينا وكن جزءًا في تطويرها","System_Info":"معلومات النظام","Power_Options":"خيارات الطاقة","Device_Manager":"إدارة الأجهزة","Services":"خدمات","Networks":"شبكات","Apps_features":"التطبيقات و الميزات","Task_Manager":"مدير المهام","Disk_Managment":"إدارة القرص","Msconfig":"تكوين النظام","Environment_Variables":"متغيرات بيئة النظام","Install":"تثبيت","Apply":"تطبيق","Downloading":"...جارٍ التحميل","About":"عن الاداة","Third_party":"ادوات اخرى","Preferences":"التفضيلات","Management":"إدارة الجهاز","Apps":"برامج","Tweaks":"تحسينات","Settings":"إعدادات","Save":"حفظ البرامج","Restore":"أسترجاع البرامج","On":"تشغيل ","Off":"إيقاف","Dark":"ليلا","Light":"نهارا","Use_system_setting":"استخدم إعدادات النظام","Create_desktop_shortcut":"أنشاء أختصار على سطح المكتب","Reset_preferences":"إعادة التفضيلات إلى الوضع الافتراضي","Reopen_itt_again":"يرجى اعادة فتح الاداة مرة اخرى","Theme":"المظهر","Language":"اللغة","Browsers_extensions":"أضافات المتصفحات","All":"الكل","Search":"بحث","Create_restore_point":"إنشاء نقطة الاستعادة","Portable_Downloads_Folder":"مجلد التنزيلات المحمولة","Install_msg":"هل تريد تثبيت البرامج التالية","Apply_msg":"هل تريد تطبيق التحسينات التالية","Applying":"...جارٍي التطبيق","Please_wait":"يرجى الانتظار، يوجد عملية في الخلفية","Last_update":"آخر تحديث","Exit_msg":"هل أنت متأكد من رغبتك في إغلاق البرنامج؟ إذا كان هناك أي تثبيتات، فسيتم إيقافها.","system_protection":"حماية النظام","web browsers":"متصفحات","media":"مشغل","media tools":"أدوات الفيديو","documents":"المستندات","compression":"الضغط","communication":"الاتصال","file sharing":"مشاركة الملفات","imaging":"صور","gaming":"ألعاب","utilities":"أدوات النظام","disk tools":"أدوات القرص","development":"تطوير","security":"حماية","portable":"محمولة","runtimes":"مكاتب","drivers":"تعريفات","privacy":"الخصوصية","fixer":"المصحح","performance":"الأداء","personalization":"التخصيص","power":"الطاقة","protection":"حماية","classic":"كلاسيكي","auto":"تلقائي","package_manager":"مدير الحزم","DisablePopupText":"اظهار عند التحديث","FlowDirection":"RightToLeft"},"de":{"name":"Deutsch","Welcome":"Sparen Sie Zeit indem Sie mehrere Programme gleichzeitig instAllieren und die Leistung Ihres Windows steigern. Schließen Sie sich uns an um dieses Tool zu verbessern und noch besser zu machen. Sie können auch Ihre Lieblings-Musik-Apps und Anpassungen hinzufügen.","Install":"InstAllieren","Apply":"Anwenden","Downloading":"Herunterladen...","About":"Über","Third_party":"Drittanbieter","Preferences":"Einstellungen","Management":"Verwaltung","Apps":"Apps","Tweaks":"Optimierungen","Settings":"Einstellungen","Save":"Speichern","Restore":"Wiederherstellen","On":"Ein","Off":"Aus","Disk_Managment":"Datenträgerverwaltung","Msconfig":"Systemkonfiguration","Environment_Variables":"Umgebungsvariablen","Task_Manager":"Task-Manager","Apps_features":"Apps-FunktiOnen","Networks":"Netzwerke","Services":"Dienste","Device_Manager":"Geräte-Manager","Power_Options":"EnergieoptiOnen","System_Info":"Systeminfo","Use_system_setting":"Systemeinstellungen verwenden","Create_desktop_shortcut":"Desktop-Verknüpfung erstellen","Reset_preferences":"Einstellungen zurücksetzen","Reopen_itt_again":"Bitte ITT erneut öffnen.","Theme":"Thema","Language":"Sprache","Browsers_extensions":"Browser-Erweiterungen","All":"Alle","Search":"Suchen","Create_restore_point":"Wiederherstellungspunkt erstellen","Portable_Downloads_Folder":"Ordner für tragbare Downloads","Install_msg":"Sind Sie sicher  dass Sie die folgenden Anwendungen instAllieren möchten?","Apply_msg":"Sind Sie sicher dass Sie die folgenden Anpassungen anwenden möchten?","Applying":"Anwenden...","Please_wait":"Bitte warten ein Prozess läuft im Hintergrund","Last_update":"Letztes Update","Exit_msg":"Sind Sie sicher dass Sie das Programm schließen möchten? Alle InstAllatiOnen werden abgebrochen.","system_protection":"Systemschutz","web browsers":"Webbrowser","media":"Medien","media tools":"Medienwerkzeuge","documents":"Dokumente","compression":"Komprimierung","communication":"Kommunikation","file sharing":"Dateifreigabe","imaging":"Bildbearbeitung","gaming":"Spiele","utilities":"Dienstprogramme","disk tools":"Laufwerkswerkzeuge","development":"Entwicklung","security":"Sicherheit","portable":"Tragbar","runtimes":"Laufzeitumgebungen","drivers":"Treiber","privacy":"Datenschutz","fixer":"Reparierer","performance":"Leistung","personalization":"Personalisierung","power":"Energie","protection":"Schutz","classic":"Klassisch","auto":"automatisch","package_manager":"Manager der Pakete","DisablePopupText":"Beim Update anzeigen"},"en":{"name":"English","Welcome":"Save time and install all your programs at once and debloat Windows and more. Be part of ITT and contribute to improving it","Install":"INSTALL","Apply":"APPLY","Downloading":"Downloading...","About":"About","Third_party":"Third-party","Preferences":"Preferences","Management":"Management","Apps":"Apps","Tweaks":"Tweaks","Settings":"Settings","Save":"Save","Restore":"Restore","On":"On","Off":"Off","Disk_Managment":"Disk Managment","Msconfig":"System Configuration","Environment_Variables":"Environment Variables","Task_Manager":"Task Manager","Apps_features":"Programs and Features","Networks":"Networks","Services":"Services","Device_Manager":"Device Manager","Power_Options":"Power options","System_Info":"System Info","Use_system_setting":"Use system setting","Create_desktop_shortcut":"Create desktop shortcut","Reset_preferences":"Reset Preferences","Reopen_itt_again":"Please reopen itt again.","Theme":"Theme","Language":"Language","Browsers_extensions":"Browsers extensions","All":"All","Search":"Search","Create_restore_point":"Create a restore point","Portable_Downloads_Folder":"Portable Downloads Folder","Install_msg":"Are you sure you want to install the following App(s)","Apply_msg":"Are you sure you want to apply the following Tweak(s)","Applying":"APPLYING...","Please_wait":"Please wait a process is running in the background","Last_update":"Last update","Exit_msg":"Are you sure you want to close the program? Any ongoing installations will be canceled","system_protection":"System protection","web browsers":"Web Browsers","media":"Media","media tools":"Media Tools","documents":"Documents","compression":"Compression","communication":"Communication","file sharing":"File Sharing","imaging":"Imaging","gaming":"Gaming","utilities":"Utilities","disk tools":"Disk Tools","development":"Development","security":"Security","portable":"Portable","runtimes":"Runtimes","drivers":"Drivers","privacy":"Privacy","fixer":"Fixer","performance":"Performance","personalization":"Personalization","power":"Power","protection":"Protection","classic":"Classic","auto":"Auto","package_manager":"Package Manager","DisablePopupText":"Show on update"},"es":{"name":"Español","Welcome":"Ahorra tiempo instalando varios prograMAS a la vez y mejora el rendimiento de tu Windows. Únete a nosotros para mejorar esta herramienta y hacerla aún mejor. También puedes agregar tus aplicaciOnes Musicales y ajustes favoritos.","Install":"Instalar","Apply":"Aplicar","Downloading":"Descargando...","About":"Acerca de","Third_party":"Terceros","Preferences":"Preferencias","Management":"Gestión","Apps":"AplicaciOnes","Tweaks":"Ajustes","Settings":"COnfiguración","Save":"Guardar","Restore":"Restaurar","On":"Encendido","Off":"Apagado","Disk_Managment":"Administración de discos","Msconfig":"Configuración del sistema","Environment_Variables":"Variables de entorno","Task_Manager":"Administrador de tareas","Apps_features":"AplicaciOnes-FunciOnes","Networks":"Redes","Services":"Servicios","Device_Manager":"Administrador de dispositivos","Power_Options":"OpciOnes de energía","System_Info":"Información del sistema","Use_system_setting":"Usar la cOnfiguración del sistema","Create_desktop_shortcut":"Crear acceso directo en el escritorio","Reset_preferences":"Restablecer preferencias","Reopen_itt_again":"Vuelve a abrir ITT.","Theme":"Tema","Language":"Idioma","Browsers_extensions":"ExtensiOnes del navegador","All":"Todos","Search":"Buscar","Create_restore_point":"Crear un punto de restauración","Portable_Downloads_Folder":"Carpeta de descargas portátiles","Install_msg":"¿Estás seguro de que deseas instalar las siguientes aplicaciOnes?","Apply_msg":"¿Estás seguro de que deseas aplicar los siguientes ajustes?","Applying":"Aplicando...","Please_wait":"Por favorespera un proceso se está ejecutando en segundo plano.","Last_update":"Última actualización","Exit_msg":"¿Estás seguro de que deseas cerrar el programa? Si hay instalaciOnes se interrumpirán.","system_protection":"Protección del sistema","web browsers":"Navegadores web","media":"Medios","media tools":"Herramientas multimedia","documents":"Documentos","compression":"Compresión","communication":"Comunicación","file sharing":"Compartición de archivos","imaging":"Imágenes","gaming":"Juegos","utilities":"Utilidades","disk tools":"Herramientas de disco","development":"Desarrollo","security":"Seguridad","portable":"Portátil","runtimes":"Runtimes","drivers":"Controladores","privacy":"Privacidad","fixer":"Reparador","performance":"Rendimiento","personalization":"Personalización","power":"Potencia","protection":"Protección","classic":"Clásico","auto":"automático","package_manager":"Manager de paquetes","DisablePopupText":"Mostrar en la actualización"},"fr":{"name":"Français","Welcome":"Gagnez du temps en instAllant plusieurs programmes à la fois et améliorez les performances de votre Windows. Rejoignez-nous pour améliorer cet outil et le rendre encore meilleur. Vous pouvez également ajouter vos applicatiOns Musicales et vos Tweaks préférés.","Install":"InstAller","Apply":"Appliquer","Downloading":"Téléchargement...","About":"À propos","Third_party":"Tiers","Preferences":"Préférences","Management":"GestiOn","Apps":"ApplicatiOns","Tweaks":"OptimisatiOns","Settings":"Paramètres","Save":"Sauvegarder","Restore":"Restaurer","On":"Activé","Off":"Désactivé","Disk_Managment":"GestiOn des disques","Msconfig":"Configuration du système","Environment_Variables":"Variables d'environnement","Task_Manager":"GestiOnnaire des tâches","Apps_features":"ApplicatiOns-FOnctiOnnalités","Networks":"Réseaux","Services":"Services","Device_Manager":"GestiOnnaire de périphériques","Power_Options":"OptiOns d'alimentatiOn","System_Info":"Infos système","Use_system_setting":"Utiliser les paramètres système","Create_desktop_shortcut":"Créer un raccourci sur le bureau","Reset_preferences":"Réinitialiser les préférences","Reopen_itt_again":"Veuillez rouvrir ITT.","Theme":"Thème","Language":"Langue","Browsers_extensions":"Browsers_extensions de navigateurs","All":"Tout","Search":"Rechercher","Create_restore_point":"Créer un point de restauratiOn","Portable_Downloads_Folder":"Dossier de téléchargements portables","Install_msg":"Êtes-vous sûr de vouloir instAller les applicatiOns suivantes ?","Apply_msg":"Êtes-vous sûr de vouloir appliquer les Tweaks suivants ?","Applying":"ApplicatiOn...","Please_wait":"Veuillez patienter","Last_update":"Dernière mise à jour  un processus est en cours d'exécutiOn en arrière-plan.","Exit_msg":"Êtes-vous sûr de vouloir fermer le programme ? Si des instAllatiOns sOnt en cours  elles serOnt interrompues","system_protection":"Protection du système","web browsers":"Navigateurs Web","media":"Médias","media tools":"Outils multimédias","documents":"Documents","compression":"Compression","communication":"Communication","file sharing":"Partage de fichiers","imaging":"Imagerie","gaming":"Jeux","utilities":"Utilitaires","disk tools":"Outils de disque","development":"Développement","security":"Sécurité","portable":"Portable","runtimes":"Runtimes","drivers":"Pilotes","privacy":"Confidentialité","fixer":"Réparateur","performance":"Performance","personalization":"Personnalisation","power":"Puissance","protection":"Protection","classic":"Classique","auto":"automatique","package_manager":"Manager des paquets","DisablePopupText":"Afficher lors de la mise à jour"},"hi":{"name":"अंग्रेज़ी","Welcome":"एक बार में कई प्रोग्राम इंस्टॉल करके समय बचाएं और अपने विंडोज़ के प्रदर्शन को बढ़ावा दें। इस टूल को बेहतर बनाने और इसे और अच्छा बनाने में हमारा साथ दें। आप अपने पसंदीदा म्यूज़िक ऐप्स और ट्विक्स भी जोड़ सकते हैं।","Install":"इंस्टॉल करें","Apply":"लागू करें","Downloading":"डाउनलोड हो रहा है...","About":"के बारे में","Third_party":"थर्ड-पार्टी","Preferences":"पसंद","Management":"प्रबंधन","Apps":"ऐप्स","Tweaks":"ट्विक्स","Settings":"सेटिंग्स","Save":"सहेजें","Restore":"पुनर्स्थापित करें","On":"चालू","Off":"बंद","Disk_Managment":"डिस्क प्रबंधन","Msconfig":"सिस्टम कॉन्फ़िगरेशन","Environment_Variables":"एन्विर्बल वार्डियल्स","Task_Manager":"टास्क मैनेजर","Apps_features":"ऐप्स-फीचर्स","Networks":"नेटवर्क्स","Services":"सेवाएँ","Device_Manager":"डिवाइस मैनेजर","Power_Options":"पावर विकल्प","System_Info":"सिस्टम जानकारी","Use_system_setting":"सिस्टम सेटिंग का उपयोग करें","Create_desktop_shortcut":"डेस्कटॉप शॉर्टकट बनाएं","Reset_preferences":"पसंद रीसेट करें","Reopen_itt_again":"कृपया इसे फिर से खोलें।","Theme":"थीम","Language":"भाषा","Browsers_extensions":"ब्राउज़र एक्सटेंशन","All":"सभी","Search":"खोज","Create_restore_point":"पुनर्स्थापना बिंदु बनाएँ","Portable_Downloads_Folder":"पोर्टेबल डाउनलोड फ़ोल्डर","Install_msg":"क्या आप निश्चित हैं कि आप निम्न ऐप्स इंस्टॉल करना चाहते हैं?","Apply_msg":"क्या आप निश्चित हैं कि आप निम्न ट्विक्स लागू करना चाहते हैं?","Applying":"लागू किया जा रहा है...","Please_wait":"कृपया प्रतीक्षा करें बैकग्राउंड में एक प्रक्रिया चल रही है","Last_update":"आखिरी अपडेट","Exit_msg":"क्या आप निश्चित हैं कि आप प्रोग्राम बंद करना चाहते हैं? यदि कोई इंस्टॉलेशन चल रहा हो तो वह समाप्त हो जाएगा","system_protection":"सिस्टम सुरक्षा","web browsers":"वेब ब्राउज़र","media":"मीडिया","media tools":"मीडिया उपकरण","documents":"दस्तावेज़","compression":"संपीड़न","communication":"संचार","file sharing":"फ़ाइल साझा करना","imaging":"इमेजिंग","gaming":"गेमिंग","utilities":"उपयोगिताएँ","disk tools":"डिस्क उपकरण","development":"विकास","security":"सुरक्षा","portable":"पोर्टेबल","runtimes":"रनटाइम्स","drivers":"ड्राइवर","privacy":"गोपनीयता","fixer":"ठीक करने वाला","performance":"प रदर्शन","personalization":"वैयक्तिकरण","power":"शक्ति","protection":"सुरक्षा","classic":"क्लासिक","auto":"स्वचालित","package_manager":"पैकेज मैनेजर","DisablePopupText":"अपडेट पर दिखाएँ"},"it":{"name":"Italiano","Welcome":"Risparmia tempo installando più programmi contemporaneamente e migliora le prestazioni di Windows. Unisciti a noi per migliorare questo strumento e renderlo migliore. Puoi anche aggiungere le tue app musicali preferite e le personalizzazioni.","Install":"Installa","Apply":"Applica","Downloading":"Download in corso...","About":"Informazioni","Third_party":"Terze parti","Preferences":"Preferenze","Management":"Gestione","Apps":"App","Tweaks":"Personalizzazioni","Settings":"Impostazioni","Save":"Salva","Restore":"Ripristina","On":"Acceso","Off":"Spento","Disk_Managment":"Gestione disco","Msconfig":"Configurazione di sistema","Environment_Variables":"Variabili di ambiente","Task_Manager":"Gestore attività","Apps_features":"App-Funzionalità","Networks":"Reti","Services":"Servizi","Device_Manager":"Gestore dispositivi","Power_Options":"Opzioni risparmio energia","System_Info":"Informazioni di sistema","Use_system_setting":"Usa impostazioni di sistema","Create_desktop_shortcut":"Crea collegamento sul desktop","Reset_preferences":"Reimposta preferenze","Reopen_itt_again":"Per favore riapri di nuovo.","Theme":"Tema","Language":"Lingua","Browsers_extensions":"Estensioni per browser","All":"Tutti","Search":"Cerca","Create_restore_point":"Crea un punto di ripristino","Portable_Downloads_Folder":"Cartella download portatile","Install_msg":"Sei sicuro di voler installare le seguenti app?","Apply_msg":"Sei sicuro di voler applicare le seguenti personalizzazioni?","Applying":"Applicazione in corso...","Please_wait":"Attendere un processo è in corso in background","Last_update":"Ultimo aggiornamento","Exit_msg":"Sei sicuro di voler chiudere il programma? Se ci sono installazioni in corso verranno terminate.","system_protection":"Protezione del sistema","web browsers":"Browser Web","media":"Media","media tools":"Strumenti Media","documents":"Documenti","compression":"Compressione","communication":"Comunicazione","file sharing":"Condivisione File","imaging":"Imaging","gaming":"Giochi","utilities":"Utilità","disk tools":"Strumenti Disco","development":"Sviluppo","security":"Sicurezza","portable":"Portatile","runtimes":"Runtime","drivers":"Driver","privacy":"Privacy","fixer":"Riparatore","performance":"Prestazioni","personalization":"Personalizzazione","power":"Potenza","protection":"Protezione","classic":"Classico","auto":"automatico","package_manager":"Gestore pacchetti","DisablePopupText":"Mostra all aggiornamento"},"ko":{"name":"한국어","Welcome":"여러 프로그램을 한 번에 설치하여 시간을 절약하고 Windows 성능을 향상시킵니다. 도구를 개선하고 우리와 함께 훌륭하게 만들어 보세요.","System_Info":"시스템 정보","Power_Options":"전원 옵션","Device_Manager":"장치 관리자","Services":"서비스","Networks":"네트워크","Apps_features":"앱 기능","Task_Manager":"작업 관리자","Disk_Managment":"디스크 관리","Msconfig":"시스템 구성","Environment_Variables":"연습별 변수","Install":"설치","Apply":"적용","Downloading":"다운로드 중","About":"정보","Third_party":"외부","Preferences":"환경 설정","Management":"관리","Apps":"앱","Tweaks":"설정","Settings":"설정","Save":"선택한 앱 저장","Restore":"선택한 앱 복원","On":"켜기","Reset_preferences":"환경 설정 초기화","Off":"끄기","Dark":"다크","Light":"라이트","Use_system_setting":"시스템","Create_desktop_shortcut":"바탕화면 바로 가기 만들기","Reopen_itt_again":"ITT를 다시 열어주세요.","Theme":"테마","Language":"언어","Browsers_extensions":"브라우저 확장 프로그램","All":"모두","Create_restore_point":"복원 지점 생성","Portable_Downloads_Folder":"휴대용 다운로드 폴더","Install_msg":"선택한 앱을 설치하시겠습니까","Apply_msg":"선택한 조정 사항을 적용하시겠습니까","instAlling":"설치 중..","Applying":"적용 중..","Please_wait":"배경에서 프로세스가 진행 중입니다. 잠시 기다려주세요.","Last_update":"마지막 업데이트","Exit_msg":"프로그램을 종료하시겠습니까? 진행 중인 설치가 있으면 중단됩니다.","system_protection":"웹 보호","web browsers":"웹 브라우저","media":"미디어","media tools":"미디어 도구","documents":"문서","compression":"압축","communication":"커뮤니케이션","file sharing":"파일 공유","imaging":"이미지 처리","gaming":"게임","utilities":"유틸리티","disk tools":"디스크 도구","development":"개발","security":"보호","portable":"포터블","runtimes":"런타임","drivers":"드라이버","privacy":"개인 정보 보호","fixer":"수리공","performance":"성능","personalization":"개인화","power":"전력","protection":"보호","classic":"클래식","auto":"자동","package_manager":"패키지 관리자","DisablePopupText":"업데이트 시 표시"},"ru":{"name":"Русский","Welcome":"Сэкономьте время устанавливая несколько программ одновременно и улучшите производительность Windows. Присоединяйтесь к нам для улучшения этого инструмента и его совершенствования. Вы также можете добавить свои любимые музыкальные приложения и настройки.","Install":"Установить","Apply":"Применить","Downloading":"Загрузка...","About":"О нас","Third_party":"Сторонние","Preferences":"Настройки","Management":"Управление","Apps":"Приложения","Tweaks":"Настройки","Settings":"Параметры","Save":"Сохранить","Restore":"Восстановить","On":"Вкл","Off":"Выкл","Disk_Managment":"Управление дисками","Msconfig":"Конфигурация системы","Environment_Variables":"Переменные окружения","Task_Manager":"Диспетчер задач","Apps_features":"Приложения-Функции","Networks":"Сети","Services":"Сервисы","Device_Manager":"Диспетчер устройств","Power_Options":"Энергопитание","System_Info":"Информация о системе","Use_system_setting":"Использовать системные настройки","Create_desktop_shortcut":"Создать ярлык на рабочем столе","Reset_preferences":"Сбросить настройки","Reopen_itt_again":"Пожалуйста перезапустите ITT.","Theme":"Тема","Language":"Язык","Browsers_extensions":"Расширения для браузеров","All":"Все","Search":"Поиск","Create_restore_point":"Создать точку восстановления","Portable_Downloads_Folder":"Папка для портативных загрузок","Install_msg":"Вы уверены что хотите установить следующие приложения?","Apply_msg":"Вы уверены что хотите применить следующие настройки?","Applying":"Применение...","Please_wait":"Подождите выполняется фоновый процесс.","Last_update":"Последнее обновление","Exit_msg":"Вы уверены что хотите закрыть программу? Все установки будут прерваны.","system_protection":"Системная защита","web browsers":"Веб-браузеры","media":"Медиа","media tools":"Медиа-инструменты","documents":"Документы","compression":"Архивация","communication":"Связь","file sharing":"Обмен файлами","imaging":"Обработка изображений","gaming":"Игры","utilities":"Утилиты","disk tools":"Работа с дисками","development":"Разработка","security":"Безопасность","portable":"Портативные","runtimes":"Среды выполнения","drivers":"Драйверы","privacy":"Конфиденциальность","fixer":"Исправитель","performance":"Производительность","personalization":"Персонализация","power":"Мощность","protection":"Защита","classic":"Классический","auto":"Автоматический","package_manager":"Менеджер пакетов","DisablePopupText":"Показывать при обновлении"},"tr":{"name":"Türkçe","Welcome":"Birden fazla programı aynı anda yükleyerek zaman kazanın ve Windows performansınızı artırın. Bu aracı geliştirmek ve daha da iyileştirmek için bize katılın. Ayrıca favori müzik uygulamalarınızı ve ayarlarınızı da ekleyebilirsiniz.","Install":"Yükle","Apply":"Uygula","Downloading":"İndiriliyor...","About":"Hakkında","Third_party":"Üçüncü Taraf","Preferences":"Tercihler","Management":"Yönetim","Apps":"Uygulamalar","Tweaks":"İnce Ayarlar","Settings":"Ayarlar","Save":"Kayıt Et","Restore":"Geri Yükle","On":"Açık","Off":"Kapalı","Disk_Managment":"Disk Yönetimi","Msconfig":"Sistem Yapılandırması","Environment_Variables":"Ortam Değişkenleri","Task_Manager":"Görev Yöneticisi","Apps_features":"Uygulamalar-Özellikler","Networks":"Ağlar","Services":"Hizmetler","Device_Manager":"Aygıt Yöneticisi","Power_Options":"Güç Seçenekleri","System_Info":"Sistem Bilgisi","Use_system_setting":"Sistem ayarlarını kullan","Create_desktop_shortcut":"MASaüstü kısayolu oluştur","Reset_preferences":"Tercihleri sıfırla","Reopen_itt_again":"Lütfen ITT'yi tekrar açın.","Theme":"Tema","Language":"Dil","Browsers_extensions":"Tarayıcı Eklentileri","All":"Tümü","Search":"Ara","Create_restore_point":"Geri yükleme noktası oluştur","Portable_Downloads_Folder":"Taşınabilir İndirilenler Klasörü","Install_msg":"Aşağıdaki uygulamaları yüklemek istediğinizden emin misiniz?","Apply_msg":"Aşağıdaki ayarları uygulamak istediğinizden emin misiniz?","Applying":"Uygulanıyor...","Please_wait":"Lütfen bekleyin arka planda bir işlem çalışıyor","Last_update":"SOn güncelleme","Exit_msg":"Programı kapatmak istediğinizden emin misiniz? Herhangi bir kurulum varsa durdurulacak","system_protection":"Sistem koruması","web browsers":"Web Tarayıcıları","media":"Medya","media tools":"Medya Araçları","documents":"Belgeler","compression":"Sıkıştırma","communication":"İletişim","file sharing":"Dosya Paylaşımı","imaging":"Görüntü İşleme","gaming":"Oyun","utilities":"Araçlar","disk tools":"Disk Araçları","development":"Geliştirme","security":"Güvenlik","portable":"Taşınabilir","runtimes":"Çalışma Zamanı","drivers":"Sürücüler","privacy":"Gizlilik","fixer":"Düzeltici","performance":"Performans","personalization":"Kişiselleştirme","power":"Güç","protection":"Koruma","classic":"Klasik","auto":"otomatik","package_manager":"Paket Yöneticisi","DisablePopupText":"Güncellemede göster"},"zh":{"name":"中文","Welcome":"通过一次安装多个程序节省时间并提升您的Windows性能。加入我们，改进工具，使其更加优秀。","System_Info":"系统信息","Power_Options":"电源选项","Device_Manager":"设备管理器","Services":"服务","Networks":"网络","Apps_features":"应用特性","Task_Manager":"任务管理器","Disk_Managment":"磁盘管理","Msconfig":"系统配置","Environment_Variables":"环境变量","Install":"安装","Apply":"应用","Downloading":"下载中","About":"关于","Third_party":"第三方","Preferences":"偏好","Management":"管理","Apps":"应用","Tweaks":"调整","Settings":"设置","Save":"保存选定应用","Restore":"恢复选定应用","On":"开启","Off":"关闭","Reset_preferences":"重置偏好设置","Dark":"深色","Light":"浅色","Use_system_setting":"系统","Create_desktop_shortcut":"创建桌面快捷方式","Reopen_itt_again":"请重新打开ITT。","Theme":"主题","Language":"语言","Browsers_extensions":"浏览器扩展","All":"都","Create_restore_point":"创建还原点","Portable_Downloads_Folder":"便携下载文件夹","Install_msg":"是否要安装选定的应用","Apply_msg":"是否要应用选定的调整","instAlling":"安装中..","Applying":"应用中..","Please_wait":"请等待，后台有进程在进行中。","Last_update":"最后更新","Exit_msg":"您确定要关闭程序吗？如果有任何安装正在进行，它们将被终止。","system_protection":"系统保护","web browsers":"网页浏览器","media":"媒体","media tools":"媒体工具","documents":"文档","compression":"压缩","communication":"通讯","file sharing":"文件共享","imaging":"图像处理","gaming":"游戏","utilities":"实用工具","disk tools":"磁盘工具","development":"开发","security":"安全","portable":"便携版","runtimes":"运行时","drivers":"驱动程序","privacy":"隐私","fixer":"修复工具","performance":"性能","personalization":"个性化","power":"电力","protection":"保护","classic":"经典","auto":"自动","package_manager":"包管理器","DisablePopupText":"更新时显示"}}}
'@ | ConvertFrom-Json
function Invoke-Button {
Param ([string]$action, [string]$Content)
Switch -Wildcard ($action) {
"installBtn" {
$itt.SearchInput.Text = $null
Invoke-Install
}
"applyBtn" {
Invoke-Apply
}
"$($itt.CurrentCategory)" {
FilterByCat($itt["window"].FindName($itt.CurrentCategory).SelectedItem.Tag)
}
"searchInput" {
Search
}
"auto" {
Set-ItemProperty -Path $itt.registryPath -Name "source" -Value "auto" -Force
Set-Statusbar -Text "📢 Switched to auto"
}
"choco" {
Set-ItemProperty -Path $itt.registryPath -Name "source" -Value "choco" -Force
Set-Statusbar -Text "📢 Switched to choco"
}
"winget" {
Set-ItemProperty -Path $itt.registryPath -Name "source" -Value "winget" -Force
Set-Statusbar -Text "📢 Switched to winget"
}
"systemlang" {
Set-Language -lang "default"
}
"ar" {
Set-Language -lang "ar"
}
"de" {
Set-Language -lang "de"
}
"en" {
Set-Language -lang "en"
}
"es" {
Set-Language -lang "es"
}
"fr" {
Set-Language -lang "fr"
}
"hi" {
Set-Language -lang "hi"
}
"it" {
Set-Language -lang "it"
}
"ko" {
Set-Language -lang "ko"
}
"ru" {
Set-Language -lang "ru"
}
"tr" {
Set-Language -lang "tr"
}
"zh" {
Set-Language -lang "zh"
}
"save" {
Save-File
}
"load" {
Get-file
}
"deviceManager" {
Start-Process devmgmt.msc
}
"appsfeatures" {
Start-Process appwiz.cpl
}
"sysinfo" {
Start-Process msinfo32.exe
Start-Process dxdiag.exe
}
"poweroption" {
Start-Process powercfg.cpl
}
"services" {
Start-Process services.msc
}
"network" {
Start-Process ncpa.cpl
}
"taskmgr" {
Start-Process taskmgr.exe
}
"diskmgmt" {
Start-Process diskmgmt.msc
}
"msconfig" {
Start-Process msconfig.exe
}
"ev" {
rundll32 sysdm.cpl, EditEnvironmentVariables
}
"spp" {
systemPropertiesProtection
}
"systheme" {
SwitchToSystem
}
"Dark" {
Set-Theme -Theme $action
}
"DarkKnight" {
Set-Theme -Theme $action
}
"Light" {
Set-Theme -Theme $action
}
"Palestine" {
Set-Theme -Theme $action
}
"chocoloc" {
Start-Process explorer.exe "C:\ProgramData\chocolatey\lib"
}
"itt" {
Start-Process explorer.exe $env:ProgramData\itt
}
"restorepoint" {
ITT-ScriptBlock -ScriptBlock { CreateRestorePoint }
}
"unhook" {
Start-Process "https://unhook.app/"
}
"efy" {
Start-Process "https://www.mrfdev.com/enhancer-for-youtube"
}
"uBlock" {
Start-Process "https://ublockorigin.com/"
}
"mas" {
Add-Log -Message "Microsoft Activation Scripts (MAS)" -Level "info"
ITT-ScriptBlock -ScriptBlock { irm https://get.activated.win | iex }
}
"idm" {
Add-Log -Message "Running IDM Activation..." -Level "info"
ITT-ScriptBlock -ScriptBlock { curl.exe -L -o $env:TEMP\\IDM_Trial_Reset.exe "https://github.com/itt-co/itt-packages/raw/refs/heads/main/automation/idm-trial-reset/IDM%20Trial%20Reset.exe"; cmd /c "$env:TEMP\\IDM_Trial_Reset.exe" }
}
"winoffice" {
Start-Process "https://linkjust.com/massgrave"
}
"sordum" {
Start-Process "https://linkjust.com/sordum"
}
"majorgeeks" {
Start-Process "https://www.majorgeeks.com/"
}
"techpowerup" {
Start-Process "https://www.techpowerup.com/download/"
}
"ittshortcut" {
ITTShortcut $action
}
"dev" {
About
}
"shelltube" {
Start-Process -FilePath "powershell" -ArgumentList "irm https://github.com/emadadeldev/shelltube/releases/latest/download/st.ps1 | iex"
}
"asustool" {
Start-Process ("https://github.com/codecrafting-io/asus-setup-tool")
}
"webtor" {
Start-Process ("https://webtor.io/")
}
"spotifydown" {
Start-Process ("https://spotidownloader.com/")
}
"finddriver" {
Find-Driver
}
"taps" {
ChangeTap
}
"github" {
Start-Process("https://github.com/emadadeldev/ittea")
}
"community" {
Start-Process("https://discord.gg/6HkJpAWpSM")
}
"translate" {
Start-Process("https://github.com/emadadeldev/ittea/tree/main/locales")
}
"donate" {
Start-Process("https://github.com/emadadeldev/ittea/blob/main/.github/DONATE.md")
}
"feedback" {
FeedbackWindow
}
}
}
function ITT-ScriptBlock {
param(
[scriptblock]$ScriptBlock,
[array]$ArgumentList,
$Debug
)
$script:powershell = [powershell]::Create()
$script:powershell.AddScript($ScriptBlock)
$script:powershell.AddArgument($ArgumentList)
$script:powershell.AddArgument($Debug)
$script:powershell.RunspacePool = $itt.runspace
$script:handle = $script:powershell.BeginInvoke()
if ($script:handle.IsCompleted) {
$script:powershell.EndInvoke($script:handle)
$script:powershell.Dispose()
$itt.runspace.Dispose()
$itt.runspace.Close()
[System.GC]::Collect()
}
return $handle
}
function CreateRestorePoint {
try {
Set-Statusbar -Text "✋ Please wait Creating a restore point..."
Add-Log "Creating restore point..." "info"
Set-ItemProperty "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" "SystemRestorePointCreationFrequency" 0 -Type DWord -Force
powershell.exe -NoProfile -Command {
Enable-ComputerRestore -Drive $env:SystemDrive
Checkpoint-Computer -Description ("ITT-" + (Get-Date -Format "yyyyMMdd-hhmmss-tt")) -RestorePointType "MODIFY_SETTINGS"
}
Set-ItemProperty $itt.registryPath "backup" 1 -Force
Set-Statusbar -Text "✔ Created successfully. Applying tweaks..."
Add-Log "Created successfully. Applying tweaks..." "info"
} catch {
Add-Log -Message "ERROR: $($_.Exception.Message)" -Level "ERROR"
}
}
function Add-Log {
param ([string]$Message, [string]$Level = "Default")
$level = $Level.ToUpper()
$colorMap = @{ INFO="White"; WARNING="Yellow"; ERROR="Red"; INSTALLED="White"; APPLY="White"; DEBUG="Yellow" }
$iconMap  = @{ INFO="[i]"; WARNING="[!]"; ERROR="[X]"; DEFAULT=""; DEBUG="[DEBUG]"; ITT="[ITT]"; Chocolatey="[Chocolatey]"; Winget="[Winget]" }
$color = if ($colorMap.ContainsKey($level)) { $colorMap[$level] } else { "White" }
$icon  = if ($iconMap.ContainsKey($level)) { $iconMap[$level] } else { "i" }
Write-Host "  $icon $Message" -ForegroundColor $color
}
function ExecuteCommand {
param ($tweak)
try {
Add-Log -Message "Please wait..."
$script = [scriptblock]::Create($tweak)
Invoke-Command  $script -ErrorAction Stop
} catch  {
Add-Log -Message "ERROR: $($_.Exception.Message)" -Level "WARNING"
}
}
function Finish {
param (
[string]$ListView,
[string]$title = "ITT Emad Adel",
[string]$icon = "Info"
)
switch ($ListView) {
"AppsListView" {
UpdateUI -Name "installBtn" -Content "Install" -Width "auto"
Notify -title "$title" -msg "All installations have finished" -icon "Info" -time 30000
Add-Log -Message "`n::::All installations have finished::::"
Set-Statusbar -Text "📢 All installations have finished"
}
"TweaksListView" {
UpdateUI -Name "applyBtn" -Content "Apply" -Width "auto"
Add-Log -Message "`n::::All tweaks have finished::::"
Set-Statusbar -Text "📢 All tweaks have finished"
Notify -title "$title" -msg "All tweaks have finished" -icon "Info" -time 30000
}
}
$itt["window"].Dispatcher.Invoke([action] { Set-Taskbar -progress "None" -value 0.01 -icon "logo" })
$itt.$ListView.Dispatcher.Invoke([Action] {
foreach ($item in $itt.$ListView.Items) {$item.IsChecked = $false}
$collectionView = [System.Windows.Data.CollectionViewSource]::GetDefaultView($itt.$ListView.Items)
$collectionView.Filter = $null
$collectionView.Refresh()
})
}
function Get-SelectedItems {
param ([ValidateSet("AppsListView","TweaksListView")] [string]$Mode)
$listView = if ($Mode -eq "AppsListView") { $itt.AppsListView } else { $itt.TweaksListView }
$props    = if ($Mode -eq "AppsListView") { 'Content','Choco','Scoop','Winget','ITT' } else { 'Name','Script' }
$selected = foreach ($item in $listView.Items) {
if ($item.IsChecked) {
$obj = @{}
foreach ($p in $props) { $obj[$p] = $item.$p }
$obj
}
}
return $selected
}
function Show-Selected {
param (
[string]$ListView,
[string]$Mode
)
$view = [System.Windows.Data.CollectionViewSource]::GetDefaultView($itt.$ListView.Items)
if ($Mode -eq "Filter" -and -not ($itt.$ListView.Items | Where-Object { $_.IsChecked })) {
return
}
if ($Mode -eq 'Filter') {
$view.Filter = { param($i) $i.IsChecked }
}
else {
foreach ($i in $itt.$ListView.Items) { $i.IsChecked = $false }
$view.Filter = $null
}
}
function Get-ToggleStatus {
Param($ToggleSwitch)
if ($ToggleSwitch -eq "darkmode") {
$app = (Get-ItemProperty -path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize').AppsUseLightTheme
$system = (Get-ItemProperty -path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize').SystemUsesLightTheme
if ($app -eq 0 -and $system -eq 0) {
return $true
}
else {
return $false
}
}
if ($ToggleSwitch -eq "showfileextensions") {
$hideextvalue = (Get-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced').HideFileExt
if ($hideextvalue -eq 0) {
return $true
}
else {
return $false
}
}
if ($ToggleSwitch -eq "showsuperhidden") {
$hideextvalue = (Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden")
if ($hideextvalue -eq 1) {
return $true
}
else {
return $false
}
}
if ($ToggleSwitch -eq "numlook") {
$numlockvalue = (Get-ItemProperty -path 'HKCU:\Control Panel\Keyboard').InitialKeyboardIndicators
if ($numlockvalue -eq 2) {
return $true
}
else {
return $false
}
}
if ($ToggleSwitch -eq "stickykeys") {
$StickyKeys = (Get-ItemProperty -path 'HKCU:\Control Panel\Accessibility\StickyKeys').Flags
if ($StickyKeys -eq 58) {
return $false
}
else {
return $true
}
}
if ($ToggleSwitch -eq "mouseacceleration") {
$Speed = (Get-ItemProperty -path 'HKCU:\Control Panel\Mouse').MouseSpeed
$Threshold1 = (Get-ItemProperty -path 'HKCU:\Control Panel\Mouse').MouseThreshold1
$Threshold2 = (Get-ItemProperty -path 'HKCU:\Control Panel\Mouse').MouseThreshold2
if ($Speed -eq 1 -and $Threshold1 -eq 6 -and $Threshold2 -eq 10) {
return $true
}
else {
return $false
}
}
if ($ToggleSwitch -eq "endtaskontaskbarwindows11") {
$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings"
if (-not (Test-Path $path)) {
return $false
}
else {
$TaskBar = (Get-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings').TaskbarEndTask
if ($TaskBar -eq 1) {
return $true
}
else {
return $false
}
}
}
if ($ToggleSwitch -eq "clearpagefileatshutdown") {
$PageFile = (Get-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\\Memory Management').ClearPageFileAtShutdown
if ($PageFile -eq 1) {
return $true
}
else {
return $false
}
}
if ($ToggleSwitch -eq "autoendtasks") {
$PageFile = (Get-ItemProperty -path 'HKCU:\Control Panel\Desktop').AutoEndTasks
if ($PageFile -eq 1) {
return $true
}
else {
return $false
}
}
if ($ToggleSwitch -eq "performanceoptions") {
$VisualFXSetting = (Get-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects').VisualFXSetting
if ($VisualFXSetting -eq 2) {
return $true
}
else {
return $false
}
}
if ($ToggleSwitch -eq "launchtothispc") {
$LaunchTo = (Get-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced').LaunchTo
if ($LaunchTo -eq 1) {
return $true
}
else {
return $false
}
}
if ($ToggleSwitch -eq "disableautomaticdriverinstallation") {
$disableautomaticdrive = (Get-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching').SearchOrderConfig
if ($disableautomaticdrive -eq 1) {
return $true
}
else {
return $false
}
}
if ($ToggleSwitch -eq "AlwaysshowiconsneverThumbnail") {
$alwaysshowicons = (Get-ItemProperty -path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced').IconsOnly
if ($alwaysshowicons -eq 1) {
return $true
}
else {
return $false
}
}
if ($ToggleSwitch -eq "WindowsSandbox") {
$WS = Get-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableClientVM"
if ($WS.State -eq "Enabled") {
return $true
}
else {
return $false
}
}
if ($ToggleSwitch -eq "WindowsSubsystemforLinux") {
$WSL = Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux"
if ($WSL.State -eq "Enabled") {
return $true
}
else {
return $false
}
}
if ($ToggleSwitch -eq "HyperVVirtualization") {
$HyperV = Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V"
if ($HyperV.State -eq "Enabled") {
return $true
}
else {
return $false
}
}
if ($ToggleSwitch -eq "EnableAutoTray") {
$EnableAutoTray = (Get-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer').EnableAutoTray
if ($EnableAutoTray -eq 0) {
return $true
}
else {
return $false
}
}
}
function Install-App {
param ([string]$Source, [string]$Name,[string]$Choco,[string]$Scoop,[string]$Winget,[string]$ITT)
$wingetArgs = "install --id $Winget --silent --accept-source-agreements --accept-package-agreements --force"
$chocoArgs = "install $Choco --confirm --acceptlicense -q --ignore-http-cache --limit-output --allowemptychecksumsecure --ignorechecksum --allowemptychecksum --usepackagecodes --ignoredetectedreboot --ignore-checksums --ignore-reboot-requests"
$ittArgs = "install $ITT -y"
$scoopArgs = "$Scoop"
function Install-AppWithInstaller {
param ([string]$Installer,[string]$InstallArgs)
$process = Start-Process -FilePath $Installer -ArgumentList $InstallArgs -NoNewWindow -Wait -PassThru
return $process.ExitCode
}
function Log {
param ([string]$Installer,[string]$Source)
if ($Installer -ne 0) {
return @{ Success = $false; Message = "Installation Failed for ($Name). Report the issue in ITT repository." }
}
else {
return @{ Success = $true; Message = "Successfully Installed ($Name)" }
}
}
if ($Source -ne "auto") {
switch ($Source.ToLower()) {
"choco" {
if ($Choco -eq "na") {
Add-Log -Message "Chocolatey package not available for $Name" -Level "WARNING"
return @{ Success = $false; Message = "This app is not available in Chocolatey" }
}
Install-Dependencies -PKGMan "choco"
$exitCode = Install-AppWithInstaller "choco" $chocoArgs
return Log $exitCode "Chocolatey"
}
"winget" {
if ($Winget -eq "na") {
Add-Log -Message "Winget package not available for $Name" -Level "WARNING"
return @{ Success = $false; Message = "This app is not available in Winget" }
}
Install-Dependencies -PKGMan "winget"
$exitCode = Install-AppWithInstaller "winget" $wingetArgs
return Log $exitCode "Winget"
}
"scoop" {
if ($Scoop -eq "na") {
Add-Log -Message "Scoop package not available for $Name" -Level "WARNING"
return @{ Success = $false; Message = "This app is not available in Scoop" }
}
Install-Dependencies -PKGMan "scoop"
$LASTEXITCODE = scoop install $scoopArgs
return Log $LASTEXITCODE "Scoop"
}
default {
Add-Log -Message "Invalid package manager specified: $Source" -Level "ERROR"
return @{ Success = $false; Message = "Invalid package manager" }
}
}
}
if ($Choco -eq "na" -and $Winget -eq "na" -and $itt -ne "na") {
Install-Dependencies -PKGMan "itt"
Add-Log -Message "Attempting to install $Name." -Level "ITT"
$ITTResult = Install-AppWithInstaller "itt" $ittArgs
Log $ITTResult "itt"
}
else
{
if ($Choco -eq "na" -and $Scoop -eq "na" -and $Winget -ne "na")
{
Add-Log -Message "Attempting to install $Name." -Level "Winget"
Install-Dependencies -PKGMan "winget"
Start-Process -FilePath "winget" -ArgumentList "settings --enable InstallerHashOverride" -NoNewWindow -Wait -PassThru
$wingetResult = Install-AppWithInstaller "winget" $wingetArgs
Log $wingetResult "Winget"
}
else
{
if ($Choco -ne "na" -or $Winget -ne "na" -or $Scoop -ne "na")
{
Add-Log -Message "Attempting to install $Name." -Level "Chocolatey"
Install-Dependencies -PKGMan "choco"
$chocoResult = Install-AppWithInstaller "choco" $chocoArgs
if ($chocoResult -ne 0) {
Add-Log -Message "installation failed, Falling back to winget." -Level "info"
Install-Dependencies -PKGMan "winget"
$wingetResult = Install-AppWithInstaller "winget" $wingetArgs
if ($wingetResult -ne 0) {
Add-Log -Message "installation failed, Falling back to scoop." -Level "info"
Install-Dependencies -PKGMan "scoop"
scoop install $scoopArgs
Log $LASTEXITCODE "Scoop"
}else {
Log $wingetResult "Winget"
}
}
else
{
Log $chocoResult "Chocolatey"
}
}
else
{
Add-Log -Message "$Name is not available in any package manager" -Level "info"
}
}
}
}
function Install-Dependencies {
param ([string]$PKGMan)
switch ($PKGMan)
{
"itt" {
if (-not (Get-Command itt -ErrorAction SilentlyContinue))
{
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/emadadeldev/bin/refs/heads/main/install.ps1')) *> $null
}
else
{
try {
$currentVersion = (itt.exe -ver)
$installerPath = "$env:TEMP\installer.msi"
$latestReleaseApi = "https://api.github.com/repos/emadadeldev/bin/releases/latest"
$latestVersion = (Invoke-RestMethod -Uri $latestReleaseApi).tag_name
if ($latestVersion -eq $currentVersion) {return}
Invoke-WebRequest "https://github.com/emadadeldev/bin/releases/latest/download/installer.msi" -OutFile $installerPath
Start-Process msiexec.exe -ArgumentList "/i `"$installerPath`" /q" -NoNewWindow -Wait
Write-Host "Updated to version $latestVersion successfully."
}
catch {
Add-Log -Message "$_" -Level "error"
}
}
}
"choco" {
if (-not (Get-Command choco -ErrorAction SilentlyContinue))
{
Add-Log -Message "Installing dependencies..." -Level "INFO"
Add-Log -Message "This might take few seconds" -Level "INFO"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) *> $null
}
}
"winget" {
if(Get-Command winget -ErrorAction SilentlyContinue) {return}
$ComputerInfo = Get-ComputerInfo -ErrorAction Stop
$arch = [int](($ComputerInfo).OsArchitecture -replace '\D', '')
if ($ComputerInfo.WindowsVersion -lt "1809") {
Add-Log -Message "Winget is not supported on this version of Windows Upgrade to 1809 or newer." -Level "info"
return
}
$VCLibs = "https://aka.ms/Microsoft.VCLibs.x$arch.14.00.Desktop.appx"
$UIXaml = "https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x$arch.appx"
$WingetLatset = "https://aka.ms/getwinget"
try {
Add-Log -Message "Installing Winget..." -Level "info"
Add-Log -Message "This might take several minutes" -Level "info"
Start-BitsTransfer -Source $VCLibs -Destination "$env:TEMP\Microsoft.VCLibs.Desktop.appx"
Start-BitsTransfer -Source $UIXaml -Destination "$env:TEMP\Microsoft.UI.Xaml.appx"
Start-BitsTransfer -Source $WingetLatset -Destination "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
Add-AppxPackage "$env:TEMP\Microsoft.VCLibs.Desktop.appx"
Add-AppxPackage "$env:TEMP\Microsoft.UI.Xaml.appx"
Add-AppxPackage "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
Start-Sleep -Seconds 1
Add-Log -Message "Successfully installed Winget. Continuing to install selected apps..." -Level "info"
return
}
catch {
Write-Error "Failed to install $_"
}
}
"scoop" {
if (-not (Get-Command scoop -ErrorAction SilentlyContinue))
{
Add-Log -Message "Installing scoop..." -Level "info"
Add-Log -Message "This might take few seconds" -Level "info"
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
scoop bucket add extras
}
}
}
}
function Refresh-Explorer {
Add-Log -Message "Restart explorer." -Level "info"
Stop-Process -processName: Explorer -Force
Start-Sleep -Seconds 1
if (-not (Get-Process -processName: Explorer)) {
Start-Process explorer.exe
}
}
function Get-file {
if ($itt.ProcessRunning) {
Message -key "Please_wait" -icon "Warning" -action "OK"
return
}
$openFileDialog = New-Object Microsoft.Win32.OpenFileDialog -Property @{
Filter = "itt file (*.itt)|*.itt"
Title  = "itt File"
}
if ($openFileDialog.ShowDialog() -eq $true) {
try {
$FileContent = Get-Content -Path $openFileDialog.FileName -Raw | ConvertFrom-Json -ErrorAction Stop
if ($FileContent.ListView -ne $itt.currentList) {
Message -NoneKey "PLEASE SELECT THE CORRECT TAB" -icon "Warning" -action "OK"
return
}
$collectionView = [System.Windows.Data.CollectionViewSource]::GetDefaultView($itt.($itt.currentList).Items)
$collectionView.Filter = {
param($item)
if ($FileContent.Items.Name -contains $item.Content) {
$item.IsChecked = $true
return $true
} else {
return $false
}
}
}
catch {
Write-Warning "Failed to load or parse JSON file: $_"
}
}
}
function Save-File {
if($itt.currentList -eq "SettingsList") {return}
Show-Selected -ListView "$($itt.currentList)" -Mode "Filter"
$selectedApps = Get-SelectedItems -Mode "$($itt.currentList)"
if ($selectedApps.Count -le 0) { return }
$items = foreach ($item in $itt.$($itt.currentList).Items) {
if ($item.IsChecked) {
[PSCustomObject]@{
Name = $item.Content
}
}
}
$jsonObject = @{
ListView = $itt.currentList
Items    = $items
}
$saveFileDialog = New-Object Microsoft.Win32.SaveFileDialog -Property @{
Filter = "JSON files (*.itt)|*.itt"
Title  = "Save JSON File"
}
if ($saveFileDialog.ShowDialog() -eq $true) {
$jsonObject | ConvertTo-Json -Compress | Out-File -FilePath $saveFileDialog.FileName -Force
Message -NoneKey "Saved $($saveFileDialog.FileName)" -icon "Information" -action "OK"
Write-Host "Saved: $($saveFileDialog.FileName)"
}
Show-Selected -ListView "$($itt.currentList)" -Mode "Default"
}
function Set-Taskbar {
param ([string]$progress,[double]$value,[string]$icon)
try {
if ($value) {
$itt["window"].taskbarItemInfo.ProgressValue = $value
}
if($progress)
{
switch ($progress) {
'None' { $itt["window"].taskbarItemInfo.ProgressState = "None" }
'Normal' { $itt["window"].taskbarItemInfo.ProgressState = "Normal" }
'Indeterminate' { $itt["window"].taskbarItemInfo.ProgressState = "Indeterminate" }
'Error' { $itt["window"].taskbarItemInfo.ProgressState = "Error" }
default { throw "Set-Taskbar Invalid state" }
}
}
if($icon)
{
switch ($icon) {
"done" {$itt["window"].taskbarItemInfo.Overlay = "https://raw.githubusercontent.com/emadadeldev/ittea/main/static/Icons/done.png"}
"logo" {$itt["window"].taskbarItemInfo.Overlay = "https://raw.githubusercontent.com/emadadeldev/ittea/main/static/Icons/icon.ico"}
"error" {$itt["window"].taskbarItemInfo.Overlay = "https://raw.githubusercontent.com/emadadeldev/ittea/main/static/Icons/error.png"}
default{$itt["window"].taskbarItemInfo.Overlay = "https://raw.githubusercontent.com/emadadeldev/ittea/main/static/Icons/icon.ico"}
}
}
}
catch {
}
}
function Startup {
ITT-ScriptBlock -ArgumentList $Debug -ScriptBlock {
param($Debug)
function UsageCount {
try {
$Message = "👨‍💻 Version: $($itt.version)`n🚀 URL: $($itt.command)"
$EncodedMessage = [uri]::EscapeDataString($Message)
$Url = "https://itt.emadadel4-a0a.workers.dev/log?text=$EncodedMessage"
$response = Invoke-WebRequest -Uri $Url -UseBasicParsing -Method GET
$result = $response.Content
Add-Log -Message "`n  $result times worldwide`n"
}
catch {
Add-Log -Message "Unstable internet connection detected." -Level "info"
Start-Sleep 10
UsageCount
}
}
function Quotes {
$q = (Invoke-RestMethod "https://raw.githubusercontent.com/emadadeldev/ittea/refs/heads/main/static/Database/Quotes.json").Quotes | Sort-Object { Get-Random }
Start-Sleep 18
$i = @{quote = "💬"; info = "📢"; music = "🎵"; Cautton = "⚠"; default = "☕" }
while (1) { foreach ($x in $q) { $c = $i[$x.type]; if (-not $c) { $c = $i.default }; $t = "`“$($x.text)`”"; if ($x.name) { $t += " ― $($x.name)" }; Set-Statusbar -Text "$c $t"; Start-Sleep 25 } }
}
function LOG {
Write-Host "`n  $($itt.api.message)`n" -ForegroundColor Green
Write-Host "  ███████████████████╗ " -NoNewline
Write-Host "My old GitHub account was restricted without any reason." -ForegroundColor Gray
Write-Host "  ██╚══██╔══╚═══██╔══╝ " -NoNewline
Write-Host "This is the new official repo:" -ForegroundColor Gray
Write-Host "  ██║  ██║ Emad ██║    " -NoNewline
Write-Host "Main repository: https://github.com/emadadeldev/ittea" -ForegroundColor Gray
Write-Host "  ██║  ██║ Adel ██║    " -NoNewline
Write-Host "Backup 1: https://gitlab.com/emadadel/itt" -ForegroundColor Gray
Write-Host "  ██║  ██║      ██║    " -NoNewline
Write-Host "Backup 2: https://codeberg.org/emadadel/itt" -ForegroundColor Gray
Write-Host "  ╚═╝  ╚═╝      ╚═╝    " -ForegroundColor White
UsageCount
Quotes
}
LOG
}
}
function ChangeTap {
$tabSettings = @{
'apps'        = @{
'installBtn' = 'Visible';
'applyBtn' = 'Hidden';
'CurrentList' = 'AppsListView';
'searchInput' = 'Visible';
'CurrentCategory' = 'AppsCategory'
}
'tweeksTab'   = @{
'installBtn' = 'Hidden';
'applyBtn' = 'Visible';
'CurrentList' = 'TweaksListView';
'searchInput' = 'Visible';
'CurrentCategory' = 'TwaeksCategory'
}
'SettingsTab' = @{
'installBtn' = 'Hidden';
'applyBtn' = 'Hidden';
'searchInput' = 'Collapsed';
'CurrentList' = 'SettingsList'
}
'WhatsNewTab' = @{
'installBtn' = 'Hidden';
'applyBtn' = 'Hidden';
'searchInput' = 'Collapsed';
'hotdot' =  [System.Windows.Visibility]::Hidden;
}
}
foreach ($tab in $tabSettings.Keys) {
if ($itt['window'].FindName($tab).IsSelected) {
$settings = $tabSettings[$tab]
$itt.CurrentList = $settings['CurrentList']
$itt.CurrentCategory = $settings['CurrentCategory']
$itt['window'].FindName('installBtn').Visibility = $settings['installBtn']
$itt['window'].FindName('applyBtn').Visibility = $settings['applyBtn']
$itt['window'].FindName('AppsCategory').Visibility = $settings['installBtn']
$itt['window'].FindName('TwaeksCategory').Visibility = $settings['applyBtn']
$itt['window'].FindName('searchInput').Visibility = $settings['searchInput']
if ($settings.ContainsKey('hotdot') -and $itt['window'].FindName('hotdot')) {
$itt['window'].FindName('hotdot').Visibility = $settings['hotdot']
}
break
}
}
}
function Invoke-Apply {
if ($itt.ProcessRunning) {
Message -key "Please_wait" -icon "Warning" -action "OK"
return
}
$itt['window'].FindName("TwaeksCategory").SelectedIndex = 0
$selectedTweaks = Get-SelectedItems -Mode "TweaksListView"
if ($selectedTweaks.Count -le 0) {return}
Show-Selected -ListView "TweaksListView" -Mode "Filter"
$result = Message -key "Apply_msg" -icon "ask" -action "YesNo"
if ($result -eq "no") {
Show-Selected -ListView "TweaksListView" -Mode "Default"
return
}
ITT-ScriptBlock -ArgumentList $selectedTweaks -debug $debug -ScriptBlock {
param($selectedTweaks, $debug)
$itt.ProcessRunning = $true
UpdateUI -Name "applyBtn" -Content "Applying" -Width "auto"
$itt["window"].Dispatcher.Invoke([action] { Set-Taskbar -progress "Indeterminate" -value 0.01 -icon "logo" })
if((Get-ItemProperty -Path $itt.registryPath -Name "backup" -ErrorAction Stop).backup -eq 0){
Set-Statusbar -Text "ℹ Current task: Creating Restore Point..."
CreateRestorePoint
}
foreach ($tweak in $selectedTweaks) {
Add-Log -Message "::::$($tweak.Content)::::" -Level "default"
ExecuteCommand -tweak $tweak.Script
}
$itt.ProcessRunning = $false
Finish -ListView "TweaksListView"
}
}
function Invoke-Install {
if ($itt.ProcessRunning) {
Message -key "Please_wait" -icon "Warning" -action "OK"
return
}
$itt['window'].FindName("AppsCategory").SelectedIndex = 0
$selectedApps = Get-SelectedItems -Mode "AppsListView"
if ($selectedApps.Count -le 0) {return}
Show-Selected -ListView "AppsListView" -Mode "Filter"
if (-not $i) {
$result = Message -key "Install_msg" -icon "ask" -action "YesNo"
}
if ($result -eq "no") {
Show-Selected -ListView "AppsListView" -Mode "Default"
return
}
$itt.PackgeManager = (Get-ItemProperty -Path $itt.registryPath -Name "source" -ErrorAction Stop).source
ITT-ScriptBlock -ArgumentList $selectedApps $source -Debug $debug -ScriptBlock {
param($selectedApps ,$source)
UpdateUI -Name "installBtn" -Content "Downloading" -Width "auto"
$itt["window"].Dispatcher.Invoke([action] { Set-Taskbar -progress "Indeterminate" -value 0.01 -icon "logo" })
$itt.ProcessRunning = $true
foreach ($App in $selectedApps) {
Write-Host $source
Set-Statusbar -Text "ℹ Current task: Downloading $($App.Content)"
$chocoFolder = Join-Path $env:ProgramData "chocolatey\lib\$($App.Choco)"
$ITTFolder = Join-Path $env:ProgramData "itt\downloads\$($App.ITT)"
Remove-Item -Path "$chocoFolder" -Recurse -Force
Remove-Item -Path "$chocoFolder.install" -Recurse -Force
Remove-Item -Path "$env:TEMP\chocolatey" -Recurse -Force
Remove-Item -Path "$ITTFolder" -Recurse -Force
$Install_result = Install-App -Source $itt.PackgeManager -Name $App.Content -Choco $App.Choco -Scoop $App.Scoop -Winget $App.Winget -itt $App.ITT
if ($Install_result.Success) {
Set-Statusbar -Text "✔ $($Install_result.Message)"
Add-Log -Message "$($Install_result.Message)" -Level "info"
} else {
Set-Statusbar -Text "✖ $($Install_result.Message)"
Add-Log -Message "$($Install_result.Message)" -Level "ERROR"
}
}
Finish -ListView "AppsListView"
$itt.ProcessRunning = $false
}
}
function Invoke-Toggle {
Param ([string]$debug)
Switch -Wildcard ($debug) {
"showfileextensions" { Invoke-ShowFile-Extensions $(Get-ToggleStatus showfileextensions) }
"darkmode" { Invoke-DarkMode $(Get-ToggleStatus darkmode) }
"showsuperhidden" { Invoke-ShowFile $(Get-ToggleStatus showsuperhidden) }
"numlook" { Invoke-NumLock $(Get-ToggleStatus numlook) }
"stickykeys" { Invoke-StickyKeys $(Get-ToggleStatus stickykeys) }
"mouseacceleration" { Invoke-MouseAcceleration $(Get-ToggleStatus mouseacceleration) }
"endtaskontaskbarwindows11" { Invoke-TaskbarEnd $(Get-ToggleStatus endtaskontaskbarwindows11) }
"clearpagefileatshutdown" { Invoke-ClearPageFile $(Get-ToggleStatus clearpagefileatshutdown) }
"autoendtasks" { Invoke-AutoEndTasks $(Get-ToggleStatus autoendtasks) }
"performanceoptions" { Invoke-PerformanceOptions $(Get-ToggleStatus performanceoptions) }
"launchtothispc" { Invoke-LaunchTo $(Get-ToggleStatus launchtothispc) }
"disableautomaticdriverinstallation" { Invoke-DisableAutoDrivers $(Get-ToggleStatus disableautomaticdriverinstallation) }
"AlwaysshowiconsneverThumbnail" { Invoke-ShowFile-Icons $(Get-ToggleStatus AlwaysshowiconsneverThumbnail) }
"WindowsSandbox" { Invoke-WindowsSandbox $(Get-ToggleStatus WindowsSandbox) }
"WindowsSubsystemforLinux" { Invoke-WindowsSandbox $(Get-ToggleStatus WindowsSubsystemforLinux) }
"HyperVVirtualization" { Invoke-HyperV $(Get-ToggleStatus HyperVVirtualization) }
"EnableAutoTray" { Invoke-EnableAutoTray $(Get-ToggleStatus EnableAutoTray) }
}
}
function Invoke-AutoEndTasks {
Param(
$Enabled,
[string]$Path = "HKCU:\Control Panel\Desktop",
[string]$name = "AutoEndTasks"
)
Try{
if ($Enabled -eq $false){
$value = 1
Add-Log -Message "Enabled auto end tasks" -Level "info"
}
else {
$value = 0
Add-Log -Message "Disabled auto end tasks" -Level "info"
}
Set-ItemProperty -Path $Path -Name $name -Value $value -ErrorAction Stop
}
Catch [System.Security.SecurityException] {
Write-Warning "Unable to set $Path\$Name to $Value due to a Security Exception"
}
Catch [System.Management.Automation.ItemNotFoundException] {
Write-Warning $psitem.Exception.ErrorRecord
}
Catch{
Write-Warning "Unable to set $Name due to unhandled exception"
Write-Warning $psitem.Exception.StackTrace
}
}
function Invoke-LaunchTo {
Param(
$Enabled,
[string]$Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",
[string]$name = "LaunchTo"
)
Try{
if ($Enabled -eq $false){
$value = 1
Add-Log -Message "Launch to This PC" -Level "info"
}
else {
$value = 2
Add-Log -Message "Launch to Quick Access" -Level "info"
}
Set-ItemProperty -Path $Path -Name $name -Value $value -ErrorAction Stop
Refresh-Explorer
}
Catch [System.Security.SecurityException] {
Write-Warning "Unable to set $Path\$Name to $Value due to a Security Exception"
}
Catch [System.Management.Automation.ItemNotFoundException] {
Write-Warning $psitem.Exception.ErrorRecord
}
Catch{
Write-Warning "Unable to set $Name due to unhandled exception"
Write-Warning $psitem.Exception.StackTrace
}
}
function Invoke-ClearPageFile {
Param(
$Enabled,
[string]$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\\Memory Management",
[string]$name = "ClearPageFileAtShutdown"
)
Try {
if ($Enabled -eq $false) {
$value = 1
Add-Log -Message "Show End Task on taskbar" -Level "info"
}
else {
$value = 0
Add-Log -Message "Disable End Task on taskbar" -Level "info"
}
Set-ItemProperty -Path $Path -Name $name -Value $value -ErrorAction Stop
}
Catch [System.Security.SecurityException] {
Write-Warning "Unable to set $Path\$Name to $Value due to a Security Exception"
}
Catch [System.Management.Automation.ItemNotFoundException] {
Write-Warning $psitem.Exception.ErrorRecord
}
Catch {
Write-Warning "Unable to set $Name due to unhandled exception"
Write-Warning $psitem.Exception.StackTrace
}
}
function Invoke-Core-Isolation {
param ($Enabled, $Name = "Enabled", $Path = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\CredentialGuard")
Try {
if ($Enabled -eq $false) {
$value = 1
Add-Log -Message "This change require a restart" -Level "info"
}
else {
$value = 0
Add-Log -Message "This change require a restart" -Level "info"
}
Set-ItemProperty -Path $Path -Name $Name -Value $value -ErrorAction Stop
Refresh-Explorer
}
Catch [System.Security.SecurityException] {
Write-Warning "Unable to set $Path\$Name to $Value due to a Security Exception"
}
Catch [System.Management.Automation.ItemNotFoundException] {
Write-Warning $psitem.Exception.ErrorRecord
}
Catch {
Write-Warning "Unable to set $Name due to unhandled exception"
Write-Warning $psitem.Exception.StackTrace
}
}
function Invoke-DarkMode {
Param($DarkMoveEnabled)
Try{
$Theme = (Get-ItemProperty -Path $itt.registryPath -Name "Theme").Theme
if ($DarkMoveEnabled -eq $false){
$DarkMoveValue = 0
Add-Log -Message "Dark Mode" -Level "info"
if($Theme -eq "default")
{
$itt['window'].Resources.MergedDictionaries.Add($itt['window'].FindResource("Dark"))
$itt.Theme = "Dark"
}
}
else {
$DarkMoveValue = 1
Add-Log -Message "Light Mode" -Level "info"
if($Theme -eq "default")
{
$itt['window'].Resources.MergedDictionaries.Add($itt['window'].FindResource("Light"))
$itt.Theme = "Light"
}
}
$Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
Set-ItemProperty -Path $Path -Name AppsUseLightTheme -Value $DarkMoveValue
Set-ItemProperty -Path $Path -Name SystemUsesLightTheme -Value $DarkMoveValue
}
Catch [System.Security.SecurityException] {
Write-Warning "Unable to set $Path\$Name to $Value due to a Security Exception"
}
Catch [System.Management.Automation.ItemNotFoundException] {
Write-Warning $psitem.Exception.ErrorRecord
}
Catch{
Write-Warning "Unable to set $Name due to unhandled exception"
Write-Warning $psitem.Exception.StackTrace
}
}
function Invoke-DisableAutoDrivers {
Param(
$Enabled,
[string]$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching",
[string]$name = "SearchOrderConfig"
)
Try{
if ($Enabled -eq $false){
$value = 1
Add-Log -Message "Enabled auto drivers update" -Level "info"
}
else {
$value = 0
Add-Log -Message "Disabled auto drivers update" -Level "info"
}
Set-ItemProperty -Path $Path -Name $name -Value $value -ErrorAction Stop
}
Catch [System.Security.SecurityException] {
Write-Warning "Unable to set $Path\$Name to $Value due to a Security Exception"
}
Catch [System.Management.Automation.ItemNotFoundException] {
Write-Warning $psitem.Exception.ErrorRecord
}
Catch{
Write-Warning "Unable to set $Name due to unhandled exception"
Write-Warning $psitem.Exception.StackTrace
}
}
function Invoke-EnableAutoTray {
Param(
$Enabled,
[string]$Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer",
[string]$name = "EnableAutoTray"
)
Try{
if ($Enabled -eq $false){
Add-Log -Message "Enabling all tray icons..." -Level "info"
Set-ItemProperty -Path $Path -Name $name -Value 0 -ErrorAction Stop
}
else {
Add-Log -Message "Disabling auto tray icons..." -Level "info"
Remove-ItemProperty -Path $Path -Name $name -ErrorAction Stop
}
Refresh-Explorer
}
Catch [System.Security.SecurityException] {
Write-Warning "Unable to set $Path\$Name to $Value due to a Security Exception"
}
Catch [System.Management.Automation.ItemNotFoundException] {
Write-Warning $psitem.Exception.ErrorRecord
}
Catch{
Write-Warning "Unable to set $Name due to unhandled exception"
Write-Warning $psitem.Exception.StackTrace
}
}
function Invoke-HyperV {
Param($Enabled)
Try{
if ($Enabled -eq $false){
Add-Log -Message "Enabling HyperV..." -Level "info"
Start-Process powershell -ArgumentList 'dism.exe /online /disable-feature /featurename:"Microsoft-Hyper-V-All" /norestart' -Verb RunAs
Add-Log -Message "Restart required" -Level "info"
}
else {
Add-Log -Message "Disabling HyperV..." -Level "info"
Start-Process powershell -ArgumentList 'dism.exe /online /enable-feature /featurename:"Microsoft-Hyper-V-All" /all /norestart' -Verb RunAs
Add-Log -Message "Restart required" -Level "info"
}
}
Catch [System.Security.SecurityException] {
Write-Warning "Unable to set HyperV due to a Security Exception"
}
}
function Invoke-MouseAcceleration {
param (
$Mouse,
$Speed = 0,
$Threshold1  = 0,
$Threshold2  = 0,
[string]$Path = "HKCU:\Control Panel\Mouse"
)
try {
if($Mouse -eq $false)
{
Add-Log -Message "Mouse Acceleration" -Level "info"
$Speed = 1
$Threshold1 = 6
$Threshold2 = 10
}else {
$Speed = 0
$Threshold1 = 0
$Threshold2 = 0
Add-Log -Message "Mouse Acceleration" -Level "info"
}
Set-ItemProperty -Path $Path -Name MouseSpeed -Value $Speed
Set-ItemProperty -Path $Path -Name MouseThreshold1 -Value $Threshold1
Set-ItemProperty -Path $Path -Name MouseThreshold2 -Value $Threshold2
}
catch {
Add-Log -Message "Unable  set valuse" -LEVEL "ERROR"
}
}
function Invoke-NumLock {
param(
[Parameter(Mandatory = $true)]
[bool]$Enabled
)
try {
if ($Enabled -eq $false)
{
Add-Log -Message "Numlock Enabled" -Level "info"
$value = 2
}
else
{
Add-Log -Message "Numlock Disabled" -Level "info"
$value = 0
}
New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS -ErrorAction Stop
$Path = "HKU:\.Default\Control Panel\Keyboard"
$Path2 = "HKCU:\Control Panel\Keyboard"
Set-ItemProperty -Path $Path -Name InitialKeyboardIndicators -Value $value -ErrorAction Stop
Set-ItemProperty -Path $Path2 -Name InitialKeyboardIndicators -Value $value -ErrorAction Stop
}
catch {
Write-Warning "An error occurred: $($_.Exception.Message)"
}
}
function Invoke-PerformanceOptions {
Param(
$Enabled,
[string]$Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects",
[string]$name = "VisualFXSetting"
)
Try{
if ($Enabled -eq $false){
$value = 2
Add-Log -Message "Enabled auto end tasks" -Level "info"
}
else {
$value = 0
Add-Log -Message "Disabled auto end tasks" -Level "info"
}
Set-ItemProperty -Path $Path -Name $name -Value $value -ErrorAction Stop
Refresh-Explorer
}
Catch [System.Security.SecurityException] {
Write-Warning "Unable to set $Path\$Name to $Value due to a Security Exception"
}
Catch [System.Management.Automation.ItemNotFoundException] {
Write-Warning $psitem.Exception.ErrorRecord
}
Catch{
Write-Warning "Unable to set $Name due to unhandled exception"
Write-Warning $psitem.Exception.StackTrace
}
}
function Invoke-ShowFile {
Param($Enabled)
Try {
if ($Enabled -eq $false)
{
$value = 1
Add-Log -Message "Show hidden files , folders etc.." -Level "info"
}
else
{
$value = 2
Add-Log -Message "Don't Show hidden files , folders etc.." -Level "info"
}
$hiddenItemsKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $hiddenItemsKey -Name Hidden -Value $value
Set-ItemProperty -Path $hiddenItemsKey -Name ShowSuperHidden -Value $value
Refresh-Explorer
}
Catch [System.Security.SecurityException] {
Write-Warning "Unable to set registry keys due to a Security Exception"
}
Catch [System.Management.Automation.ItemNotFoundException] {
Write-Warning $psitem.Exception.ErrorRecord
}
Catch {
Write-Warning "Unable to set registry keys due to unhandled exception"
Write-Warning $psitem.Exception.StackTrace
}
}
function Invoke-ShowFile-Extensions {
Param($Enabled)
Try{
if ($Enabled -eq $false){
$value = 0
Add-Log -Message "Hidden extensions" -Level "info"
}
else {
$value = 1
Add-Log -Message "Hidden extensions" -Level "info"
}
$Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $Path -Name HideFileExt -Value $value
Refresh-Explorer
}
Catch [System.Security.SecurityException] {
Write-Warning "Unable to set $Path\$Name to $Value due to a Security Exception"
}
Catch [System.Management.Automation.ItemNotFoundException] {
Write-Warning $psitem.Exception.ErrorRecord
}
Catch{
Write-Warning "Unable to set $Name due to unhandled exception"
Write-Warning $psitem.Exception.StackTrace
}
}
function Invoke-ShowFile-Icons {
param ($Enabled, $Name = "IconsOnly", $Path = "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced")
Try {
if ($Enabled -eq $false) {
$value = 1
Add-Log -Message "ON" -Level "info"
}
else {
$value = 0
Add-Log -Message "OFF" -Level "info"
}
Set-ItemProperty -Path $Path -Name $Name -Value $value -ErrorAction Stop
Refresh-Explorer
}
Catch [System.Security.SecurityException] {
Write-Warning "Unable to set $Path\$Name to $Value due to a Security Exception"
}
Catch [System.Management.Automation.ItemNotFoundException] {
Write-Warning $psitem.Exception.ErrorRecord
}
Catch {
Write-Warning "Unable to set $Name due to unhandled exception"
Write-Warning $psitem.Exception.StackTrace
}
}
function Invoke-TaskbarEnd {
Param($Enabled)
Try{
if ($Enabled -eq $false){
$value = 1
Add-Log -Message "Show End Task on taskbar" -Level "info"
}
else {
$value = 0
Add-Log -Message "Disable End Task on taskbar" -Level "info"
}
$Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings\"
$name = "TaskbarEndTask"
if (-not (Test-Path $path)) {
New-Item -Path $path -Force | Out-Null
New-ItemProperty -Path $path -Name $name -PropertyType DWord -Value $value -Force | Out-Null
}else {
Set-ItemProperty -Path $Path -Name $name -Value $value -ErrorAction Stop
Refresh-Explorer
Add-Log -Message "This Setting require a restart" -Level "INFO"
}
}
Catch [System.Security.SecurityException] {
Write-Warning "Unable to set $Path\$Name to $Value due to a Security Exception"
}
Catch [System.Management.Automation.ItemNotFoundException] {
Write-Warning $psitem.Exception.ErrorRecord
}
Catch{
Write-Warning "Unable to set $Name due to unhandled exception"
Write-Warning $psitem.Exception.StackTrace
}
}
function Invoke-StickyKeys {
Param($Enabled)
Try {
if ($Enabled -eq $false){
$value = 510
$value2 = 510
Add-Log -Message "Sticky Keys" -Level "info"
}
else {
$value = 58
$value2 = 122
Add-Log -Message "Sticky Keys" -Level "info"
}
$Path = "HKCU:\Control Panel\Accessibility\StickyKeys"
$Path2 = "HKCU:\Control Panel\Accessibility\Keyboard Response"
Set-ItemProperty -Path $Path -Name Flags -Value $value
Set-ItemProperty -Path $Path2 -Name Flags -Value $value2
Refresh-Explorer
Add-Log -Message "This Setting require a restart" -Level "INFO"
}
Catch [System.Security.SecurityException] {
Write-Warning "Unable to set $Path\$Name to $Value due to a Security Exception"
}
Catch{
Write-Warning "Unable to set $Name due to unhandled exception"
}
}
function Invoke-WindowsSandbox {
Param($Enabled)
Try{
if ($Enabled -eq $false){
Add-Log -Message "Enabling Windows Sandbox..." -Level "info"
Start-Process powershell -ArgumentList 'Dism /online /Enable-Feature /FeatureName:"Containers-DisposableClientVM" -All /NoRestart' -Verb RunAs
Add-Log -Message "Restart required" -Level "info"
}
else {
Add-Log -Message "Disabling Windows Sandbox..." -Level "info"
Start-Process powershell -ArgumentList 'Dism /online /Disable-Feature /FeatureName:"Containers-DisposableClientVM"  /NoRestart' -Verb RunAs
Add-Log -Message "Restart required" -Level "info"
}
}
Catch [System.Security.SecurityException] {
Write-Warning "Unable to set Windows Sandbox due to a Security Exception"
}
}
function Invoke-WSL {
Param($Enabled)
Try{
if ($Enabled -eq $false){
Add-Log -Message "Enabling WSL2..." -Level "info"
Start-Process powershell -ArgumentList 'dism.exe /online /enable-feature /featurename:"Microsoft-Windows-Subsystem-Linux" /all /norestart' -Verb RunAs
Start-Process powershell -ArgumentList 'dism.exe /online /enable-feature /featurename:"VirtualMachinePlatform" /all /norestart' -Verb RunAs
Read-Host "Press ENTER to exit..."
Add-Log -Message "Restart required" -Level "info"
}
else {
Add-Log -Message "Disabling WSL2..." -Level "info"
Start-Process powershell -ArgumentList 'dism.exe /online /disable-feature /featurename:"Microsoft-Windows-Subsystem-Linux" /norestart' -Verb RunAs
Start-Process powershell -ArgumentList 'dism.exe /online /disable-feature /featurename:"VirtualMachinePlatform" /norestart' -Verb RunAs
Read-Host "Press ENTER to exit..."
Add-Log -Message "Restart required" -Level "info"
}
}
Catch [System.Security.SecurityException] {
Write-Warning "Unable to set WSL2 due to a Security Exception"
}
}
function About {
$aboutPopup = $itt['window'].FindName('AboutPopup')
$aboutPopup.FindName('ver').Text = "Version $($itt.version) $($itt.api.message)"
$aboutPopup.IsOpen = $true
}
function ITTShortcut {
$appDataPath = "$env:ProgramData/itt"
$localIconPath = Join-Path -Path $appDataPath -ChildPath "icon.ico"
Invoke-WebRequest -Uri $itt.icon -OutFile $localIconPath
$Shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut("$([Environment]::GetFolderPath('Desktop'))\ITT Emad Adel.lnk")
$Shortcut.TargetPath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
$Shortcut.Arguments = "-ExecutionPolicy Bypass -NoProfile -Command ""irm raw.githubusercontent.com/emadadeldev/ittea/main/itt.ps1 | iex"""
$Shortcut.IconLocation = "$localIconPath"
$Shortcut.Save()
}
function Find-Driver {
$gpuInfo = Get-CimInstance Win32_VideoController | Where-Object { $_.Status -eq "OK" } | Select-Object -First 1 -ExpandProperty Name
$encodedName = [System.Web.HttpUtility]::UrlEncode($gpuInfo) -replace '\+', '%20'
if (-not $gpuInfo) {
Write-Host "No GPU detected"
}
if ($gpuInfo -match "NVIDIA") {
Start-Process "https://www.nvidia.com/en-us/drivers/"
}
elseif ($gpuInfo -match "AMD" -or $gpuInfo -match "Radeon") {
Start-Process "https://www.amd.com/en/support/download/drivers.html"
}
elseif ($gpuInfo -match "Intel") {
Start-Process "https://www.intel.com/content/www/us/en/search.html?ws=idsa-suggested#q=$encodedName&sort=relevancy&f:@tabfilter=[Downloads]"
}
}
function Search {
$filter = $itt.searchInput.Text.ToLower() -replace '[^\p{L}\p{N}]', ''
$collectionView = [System.Windows.Data.CollectionViewSource]::GetDefaultView($itt['window'].FindName($itt.currentList).Items)
$collectionView.Filter = {
param ($item)
return $item.Content -match $filter -or $item.category -match $filter
}
}
function FilterByCat {
param ($Cat)
$collectionView = [System.Windows.Data.CollectionViewSource]::GetDefaultView($itt['window'].FindName($itt.CurrentList).Items)
if ($Cat -eq "All" -or [string]::IsNullOrWhiteSpace($Cat)) {
$collectionView.Filter = $null
}
else {
$collectionView.Filter = {
param ($item)
$tags = $item.category
return $tags -ieq $Cat
}
}
$collectionView.Refresh()
}
$KeyEvents = {
$modifiers = $_.KeyboardDevice.Modifiers
$key = $_.Key
switch ($key) {
"Enter" {
if ($itt.currentList -eq "AppsListView") { Invoke-Install }
elseif ($itt.currentList -eq "TweaksListView") { Invoke-Apply }
}
"S" {
if ($modifiers -eq "Ctrl") {
if ($itt.currentList -eq "AppsListView") { Invoke-Install }
elseif ($itt.currentList -eq "TweaksListView") { Invoke-Apply }
}
elseif ($modifiers -eq "Shift") { Save-File }
}
"D" {
if ($itt.ProcessRunning) { Set-Statusbar -Text "📢 Shortcut is disabled while process is running" return }
if ($modifiers -eq "Shift") { Get-file }
}
"Q" {
if ($modifiers -eq "Ctrl") {
$itt.TabControl.SelectedItem = $itt.TabControl.Items | Where-Object { $_.Name -eq "apps" }
}
elseif ($modifiers -eq "Shift") { RestorePoint }
}
"W" { if ($modifiers -eq "Ctrl") { $itt.TabControl.SelectedItem = $itt.TabControl.Items | Where-Object { $_.Name -eq "tweeksTab" } } }
"E" { if ($modifiers -eq "Ctrl") { $itt.TabControl.SelectedItem = $itt.TabControl.Items | Where-Object { $_.Name -eq "SettingsTab" } } }
"I" {
if ($modifiers -eq "Ctrl") { About }
elseif ($modifiers -eq "Shift") { ITTShortcut }
}
"C" { if ($modifiers -eq "Shift") { Start-Process explorer.exe $env:ProgramData\chocolatey\lib } }
"T" { if ($modifiers -eq "Shift") { Start-Process explorer.exe $env:ProgramData\itt } }
"G" { if ($modifiers -eq "Ctrl") { $this.Close() } }
"F" {
if ($modifiers -eq "Ctrl") {
if ($itt.SearchInput.IsFocused) {
$itt.SearchInput.MoveFocus((New-Object System.Windows.Input.TraversalRequest([System.Windows.Input.FocusNavigationDirection]::Next)))
} else {
$itt.SearchInput.Focus()
}
}
}
"A" {
if ($modifiers -eq "Ctrl" -and ($itt.CurrentCategory -eq "AppsCategory" -or $itt.CurrentCategory -eq "TwaeksCategory")) {
$itt["window"].FindName($itt.CurrentCategory).SelectedIndex = 0
}
}
}
}
function Message {
param([string]$key,[string]$NoneKey,[string]$title = "ITT",[string]$icon,[string]$action)
$iconMap = @{ info = "Information"; ask = "Question"; warning = "Warning"; default = "Question" }
$actionMap = @{ YesNo = "YesNo"; OK = "OK"; default = "OK" }
$icon = if ($iconMap.ContainsKey($icon.ToLower())) { $iconMap[$icon.ToLower()] } else { $iconMap.default }
$action = if ($actionMap.ContainsKey($action.ToLower())) { $actionMap[$action.ToLower()] } else { $actionMap.default }
$msg = if ([string]::IsNullOrWhiteSpace($key)) { $NoneKey } else { $itt.database.locales.Controls.$($itt.Language).$key }
[System.Windows.MessageBox]::Show($msg, $title, [System.Windows.MessageBoxButton]::$action, [System.Windows.MessageBoxImage]::$icon)
}
function Notify {
param(
[string]$title,
[string]$msg,
[string]$icon,
[Int32]$time
)
$notification = New-Object System.Windows.Forms.NotifyIcon
$notification.Icon = [System.Drawing.SystemIcons]::Information
$notification.BalloonTipIcon = $icon
$notification.BalloonTipText = $msg
$notification.BalloonTipTitle = $title
$notification.Visible = $true
$notification.ShowBalloonTip($time)
$notification.Dispose()
}
function FeedbackWindow {
$workerURL = "https://itt.emadadel4-a0a.workers.dev/feedback"
$window = New-Object System.Windows.Window
$window.Resources.MergedDictionaries.Add($itt["window"].Resources)
$window.Background = $window.Resources["PrimaryBackgroundColor"]
$window.Title = "Send Feedback"
$window.Icon = $itt.Icon
$window.Height = 434
$window.Width = 480
$window.WindowStartupLocation = "CenterScreen"
$window.ResizeMode = "NoResize"
$grid = New-Object System.Windows.Controls.Grid
$grid.Margin = [System.Windows.Thickness]::new(10)
$row0 = New-Object System.Windows.Controls.RowDefinition; $row0.Height = "Auto"
$row1 = New-Object System.Windows.Controls.RowDefinition; $row1.Height = "Auto"
$row2 = New-Object System.Windows.Controls.RowDefinition; $row2.Height = "Auto"
$row3 = New-Object System.Windows.Controls.RowDefinition; $row3.Height = "Auto"
$row4 = New-Object System.Windows.Controls.RowDefinition; $row4.Height = "Auto"
$row5 = New-Object System.Windows.Controls.RowDefinition; $row5.Height = "*"
$row6 = New-Object System.Windows.Controls.RowDefinition; $row6.Height = "Auto"
$grid.RowDefinitions.Add($row0)
$grid.RowDefinitions.Add($row1)
$grid.RowDefinitions.Add($row2)
$grid.RowDefinitions.Add($row3)
$grid.RowDefinitions.Add($row4)
$grid.RowDefinitions.Add($row5)
$grid.RowDefinitions.Add($row6)
$typeLabel = New-Object System.Windows.Controls.Label
$typeLabel.Content = "Feedback:"
$typeLabel.FontSize = 14
[System.Windows.Controls.Grid]::SetRow($typeLabel,0)
$grid.Children.Add($typeLabel)
$typeBox = New-Object System.Windows.Controls.ComboBox
$typeBox.Margin = [System.Windows.Thickness]::new(0,5,0,10)
$typeBox.Items.Add("Improvement")
$typeBox.Items.Add("Bug / Issue")
$typeBox.Items.Add("Feature Request")
$typeBox.Items.Add("Other")
$typeBox.SelectedIndex = 0
[System.Windows.Controls.Grid]::SetRow($typeBox,1)
$grid.Children.Add($typeBox)
$subjectLabel = New-Object System.Windows.Controls.Label
$subjectLabel.Content = "Subject:"
$subjectLabel.FontSize = 14
[System.Windows.Controls.Grid]::SetRow($subjectLabel,2)
$grid.Children.Add($subjectLabel)
$subjectBox = New-Object System.Windows.Controls.TextBox
$subjectBox.Height = 30
$subjectBox.Margin = [System.Windows.Thickness]::new(0,5,0,10)
[System.Windows.Controls.Grid]::SetRow($subjectBox,3)
$grid.Children.Add($subjectBox)
$msgLabel = New-Object System.Windows.Controls.Label
$msgLabel.Content = "Message:"
$msgLabel.FontSize = 14
[System.Windows.Controls.Grid]::SetRow($msgLabel,4)
$grid.Children.Add($msgLabel)
$msgBox = New-Object System.Windows.Controls.TextBox
$msgBox.Height = 120
$msgBox.Margin = [System.Windows.Thickness]::new(0,5,0,10)
$msgBox.AcceptsReturn = $true
$msgBox.TextWrapping = "Wrap"
[System.Windows.Controls.Grid]::SetRow($msgBox,5)
$grid.Children.Add($msgBox)
$sendButton = New-Object System.Windows.Controls.Button
$sendButton.Content = "Send"
$sendButton.Height = 35
$sendButton.Width = 100
$sendButton.HorizontalAlignment = "Center"
$sendButton.Margin = [System.Windows.Thickness]::new(0,10,0,0)
[System.Windows.Controls.Grid]::SetRow($sendButton,6)
$grid.Children.Add($sendButton)
$window.Content = $grid
$sendButton.Add_Click({
$type = $typeBox.SelectedItem
$subject = $subjectBox.Text.Trim()
$msg  = $msgBox.Text.Trim()
if (-not $subject -or -not $msg) {
[System.Windows.MessageBox]::Show("Please fill in all fields.","Warning")
return
}
if ($msg.Length -gt 250) {
[System.Windows.MessageBox]::Show("Message too long. Maximum 50 characters allowed.","Warning")
return
}
try {
$jsonBody = @{
type = $type
subject = $subject
text = $msg
} | ConvertTo-Json
Invoke-RestMethod -Uri $workerURL -Method Post -Body $jsonBody -ContentType "application/json"
[System.Windows.MessageBox]::Show($response.message)
$subjectBox.Clear()
$msgBox.Clear()
$typeBox.SelectedIndex = 0
}
catch {
[System.Windows.MessageBox]::Show("Failed to send feedback.`n$_")
}
})
$window.ShowDialog() | Out-Null
}
function System-Default {
$itt.Language = $itt.database.locales.Controls
if ($itt.Language.PSObject.Properties.Name -contains $shortCulture) {
$itt["window"].DataContext = $itt.database.locales.Controls.$shortCulture
$itt.Language = $shortCulture
}
else
{
Set-Statusbar -Text "System language is not supported yet, Fallback to English"
$itt["window"].DataContext = $itt.database.locales.Controls.en
$itt.Language = "en"
}
Set-ItemProperty -Path $itt.registryPath -Name "locales" -Value "default" -Force
}
function Set-Language {
param ([string]$lang)
if ($lang -eq "default") { System-Default }
else {
$itt.Language = $lang
$itt["window"].DataContext = $itt.database.locales.Controls.$($itt.Language)
Set-ItemProperty -Path $itt.registryPath -Name "locales" -Value $lang -Force
}
}
function SwitchToSystem {
try {
$appsTheme = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme"
$theme = if ($AppsTheme -eq "0") { "Dark" } elseif ($AppsTheme -eq "1") { "Light" } else { Write-Host "Unknown theme: $AppsTheme"; return }
$itt['window'].Resources.MergedDictionaries.Add($itt['window'].FindResource($theme))
Set-ItemProperty -Path $itt.registryPath -Name "Theme" -Value "default" -Force
$itt.Theme = $Theme
}
catch { Write-Host "Error: $_" }
}
function Set-Theme {
param ([string]$Theme)
try {
$itt['window'].Resources.MergedDictionaries.Clear()
$itt['window'].Resources.MergedDictionaries.Add($itt['window'].FindResource($Theme))
Set-ItemProperty -Path $itt.registryPath -Name "Theme" -Value $Theme -Force
$itt.Theme = $Theme
}
catch { Write-Host "Error: $_" }
}
function Set-Statusbar {
param ([string]$Text)
$itt.Statusbar.Dispatcher.Invoke([Action]{$itt.Statusbar.Text = $Text })
}
function UpdateUI {
param([string]$Name,[string]$Content,[string]$NonKey,[string]$Width = "140")
$itt['window'].Dispatcher.Invoke([Action]{
$itt.$Name.Width = $Width
if($Content)
{
$itt.$Name.Content.Inlines[1].Text = $itt.database.locales.Controls.$($itt.Language).$Content
}else{
$itt.$Name.Text = $NonKey
}
})
}
function Show-Event {
$itt['window'].FindName('date').text = '10/02/2025'.Trim()
$itt['window'].FindName('yt').add_MouseLeftButtonDown({
Start-Process('https://youtu.be/0kZFi6NT1gI')
})
$itt['window'].FindName('win').add_MouseLeftButtonDown({
Start-Process('https://linkjust.com/massgravelts')
})
$storedDate = [datetime]::ParseExact($itt['window'].FindName('date').Text, 'MM/dd/yyyy', $null)
$daysElapsed = (Get-Date) - $storedDate
if ($daysElapsed.Days -lt 1)
{
$itt['window'].FindName('hotdot').Visibility = [System.Windows.Visibility]::Visible
}
}
$MainWindowXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
x:Name="Window" Title="Install Tweaks Tool"
WindowStartupLocation="CenterScreen" Background="{DynamicResource PrimaryBackgroundColor}"
Width="1024" Height="700" MinHeight="600" MinWidth="800"
ShowInTaskbar="True"
FlowDirection="{Binding FlowDirection, TargetNullValue=LeftToRight}"
TextOptions.TextFormattingMode="Ideal" TextOptions.TextRenderingMode="Auto"
Icon="https://raw.githubusercontent.com/emadadeldev/ittea/main/static/Icons/icon.ico">
<Window.Resources>
<Storyboard x:Key="FadeOutStoryboard">
<DoubleAnimation
Storyboard.TargetProperty="Opacity"
From="0" To="1" Duration="0:0:0.2" />
</Storyboard>
<Style TargetType="TextBox">
<Setter Property="Background" Value="{DynamicResource PrimaryBackgroundColor}"/>
<Setter Property="Foreground" Value="{DynamicResource PrimaryTextColor}"/>
</Style>
<Storyboard x:Key="Logo" RepeatBehavior="Forever">
<DoubleAnimation
Storyboard.TargetProperty="Opacity"
From="0.1" To="1.0"
Duration="0:0:01" />
<DoubleAnimation
Storyboard.TargetProperty="Opacity"
From="1.0" To="0.0"
Duration="0:0:1"
BeginTime="0:0:15" />
</Storyboard>
<Style TargetType="Button">
<Setter Property="Background" Value="{DynamicResource SecondaryPrimaryBackgroundColor}"/>
<Setter Property="Foreground" Value="{DynamicResource SecondaryTextColor}"/>
<Setter Property="BorderBrush" Value="Transparent"/>
<Setter Property="Padding" Value="8"/>
<Setter Property="FontSize" Value="14"/>
<Setter Property="Template">
<Setter.Value>
<ControlTemplate TargetType="Button">
<Grid>
<Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" CornerRadius="6">
<ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
</Border>
</Grid>
</ControlTemplate>
</Setter.Value>
</Setter>
<Style.Triggers>
<Trigger Property="IsMouseOver" Value="True">
<Setter Property="Background" Value="{DynamicResource ButtonHighlightColor}"/>
<Setter Property="Foreground" Value="White"/>
</Trigger>
<Trigger Property="IsPressed" Value="True">
<Setter Property="Background" Value="{DynamicResource PressedButtonColor}"/>
</Trigger>
</Style.Triggers>
</Style>
<Style TargetType="ListView">
<Setter Property="BorderBrush" Value="{x:Null}"/>
<Setter Property="Background" Value="{x:Null}"/>
<Setter Property="SelectionMode" Value="Single"/>
<Setter Property="VirtualizingStackPanel.VirtualizationMode" Value="Recycling"/>
<Setter Property="VirtualizingStackPanel.IsVirtualizing" Value="True"/>
<Setter Property="VirtualizingStackPanel.IsContainerVirtualizable" Value="True"/>
<Setter Property="ScrollViewer.CanContentScroll" Value="True"/>
<Setter Property="SnapsToDevicePixels" Value="True"/>
</Style>
<Style TargetType="ListViewItem">
<Setter Property="Margin" Value="14,8,14,0"/>
<Setter Property="BorderThickness" Value="0.3"/>
<Setter Property="BorderBrush" Value="DarkGray"/>
<Setter Property="Padding" Value="10,10,0,0"/>
<Setter Property="Template">
<Setter.Value>
<ControlTemplate TargetType="ListViewItem">
<Border Name="bg"
CornerRadius="4"
Padding="{TemplateBinding Padding}"
BorderBrush="{TemplateBinding BorderBrush}"
BorderThickness="{TemplateBinding BorderThickness}"
Background="{TemplateBinding Background}">
<ContentPresenter HorizontalAlignment="Left"
VerticalAlignment="Center"
ContentSource="Content"/>
</Border>
</ControlTemplate>
</Setter.Value>
</Setter>
<Style.Triggers>
<Trigger Property="ItemsControl.AlternationIndex" Value="0">
<Setter Property="Background" Value="{DynamicResource itemColor1}" />
<Setter Property="BorderBrush" Value="DarkGray"/>
<Setter Property="BorderThickness" Value="0.7"/>
<Setter Property="Opacity" Value="0.5"/>
</Trigger>
<Trigger Property="ItemsControl.AlternationIndex" Value="1">
<Setter Property="Background" Value="{DynamicResource itemColor2}" />
<Setter Property="BorderBrush" Value="DarkGray"/>
<Setter Property="Opacity" Value="0.5"/>
<Setter Property="BorderThickness" Value="0.7"/>
</Trigger>
<EventTrigger RoutedEvent="FrameworkElement.Loaded">
<BeginStoryboard Storyboard="{StaticResource FadeOutStoryboard}" />
</EventTrigger>
</Style.Triggers>
</Style>
<Style TargetType="CheckBox">
<Setter Property="Foreground" Value="{DynamicResource PrimaryTextColor}"/>
<Setter Property="Margin" Value="0"/>
<Setter Property="Padding" Value="0"/>
<Setter Property="Background" Value="{x:Null}"/>
<Setter Property="BorderThickness" Value="0"/>
<Setter Property="BorderBrush" Value="DarkGray"/>
<Setter Property="Template">
<Setter.Value>
<ControlTemplate TargetType="CheckBox">
<Grid Margin="4">
<Grid.ColumnDefinitions>
<ColumnDefinition Width="Auto"/>
<ColumnDefinition Width="*" />
</Grid.ColumnDefinitions>
<Border Width="20" Height="20"
Grid.Column="0"
BorderBrush="{TemplateBinding BorderBrush}"
CornerRadius="5"
BorderThickness="{TemplateBinding BorderThickness}"
Background="{TemplateBinding Background}">
<Grid>
<TextBlock x:Name="CheckIcon" HorizontalAlignment="Center" VerticalAlignment="Center" FontSize="14"/>
<Path x:Name="CheckMark"
Margin="4"
FlowDirection="LeftToRight"
Stretch="Uniform"
Stroke="White"
StrokeThickness="2"
Data="M 0 5 L 4 8 L 10 0"
Visibility="Collapsed"
HorizontalAlignment="Center"
VerticalAlignment="Center"/>
</Grid>
</Border>
<ContentPresenter Grid.Column="1" Margin="8 0 0 0" VerticalAlignment="Center"/>
</Grid>
<ControlTemplate.Triggers>
<Trigger Property="IsChecked" Value="True">
<Setter TargetName="CheckMark" Property="Visibility" Value="Visible"/>
<Setter Property="Background" Value="{DynamicResource ButtonHighlightColor}"/>
<Setter TargetName="CheckIcon" Property="Visibility" Value="Hidden"/>
</Trigger>
<Trigger Property="IsMouseOver" Value="True">
<Setter Property="Background" Value="{DynamicResource ButtonHighlightColor}"/>
<Setter TargetName="CheckMark" Property="Visibility" Value="Visible"/>
<Setter TargetName="CheckIcon" Property="Foreground" Value="{DynamicResource ButtonHighlightColor}"/>
<Setter Property="Foreground" Value="{DynamicResource ButtonHighlightColor}"/>
<Setter Property="Cursor" Value="Hand"/>
</Trigger>
<DataTrigger Binding="{Binding SelectedItem.Tag, ElementName=taps}" Value="apps">
<Setter TargetName="CheckIcon" Property="Text" Value="📦"/>
</DataTrigger>
<DataTrigger Binding="{Binding SelectedItem.Tag, ElementName=taps}" Value="tweaks">
<Setter TargetName="CheckIcon" Property="Text" Value="🛠"/>
</DataTrigger>
</ControlTemplate.Triggers>
</ControlTemplate>
</Setter.Value>
</Setter>
</Style>
<Style x:Key="SearchBox" TargetType="TextBox">
<Setter Property="Background" Value="{DynamicResource SecondaryPrimaryBackgroundColor}"/>
<Setter Property="Foreground" Value="{DynamicResource SecondaryTextColor}"/>
<Setter Property="BorderThickness" Value="0"/>
<Setter Property="Padding" Value="8"/>
<Setter Property="Template">
<Setter.Value>
<ControlTemplate TargetType="TextBox">
<Grid>
<Border Background="{TemplateBinding Background}"
BorderThickness="{TemplateBinding BorderThickness}"
CornerRadius="15">
<ScrollViewer x:Name="PART_ContentHost"
Background="Transparent"/>
</Border>
<TextBlock x:Name="PlaceholderText"
Text="🔍 Ctrl+F"
Foreground="Gray"
Margin="12,0,0,0"
VerticalAlignment="Center"
IsHitTestVisible="False"/>
</Grid>
<ControlTemplate.Triggers>
<Trigger Property="Text" Value="">
<Setter TargetName="PlaceholderText" Property="Visibility" Value="Visible"/>
</Trigger>
<Trigger Property="Text" Value="{x:Null}">
<Setter TargetName="PlaceholderText" Property="Visibility" Value="Visible"/>
</Trigger>
<Trigger Property="Text" Value=" ">
<Setter TargetName="PlaceholderText" Property="Visibility" Value="Visible"/>
</Trigger>
<Trigger Property="Text" Value="🔍 Ctrl+F">
<Setter TargetName="PlaceholderText" Property="Visibility" Value="Collapsed"/>
</Trigger>
<Trigger Property="IsKeyboardFocused" Value="True">
<Setter TargetName="PlaceholderText" Property="Visibility" Value="Collapsed"/>
</Trigger>
</ControlTemplate.Triggers>
</ControlTemplate>
</Setter.Value>
</Setter>
</Style>
<Style TargetType="Label">
<Setter Property="Foreground" Value="{DynamicResource SecondaryTextColor}"/>
<Setter Property="Template">
<Setter.Value>
<ControlTemplate TargetType="Label">
<Border Padding="{TemplateBinding Padding}" Background="{TemplateBinding Background}"
BorderBrush="{TemplateBinding BorderBrush}"
BorderThickness="{TemplateBinding BorderThickness}"
CornerRadius="0">
<ContentPresenter HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}"
VerticalAlignment="{TemplateBinding VerticalContentAlignment}"/>
</Border>
</ControlTemplate>
</Setter.Value>
</Setter>
</Style>
<Style TargetType="Menu">
<Setter Property="Background" Value="#FFFFFF"/>
<Setter Property="Foreground" Value="#000000"/>
<Setter Property="Margin" Value="5"/>
<Setter Property="Template">
<Setter.Value>
<ControlTemplate TargetType="Menu">
<Border Background="{TemplateBinding Background}"
BorderBrush="{TemplateBinding BorderBrush}"
BorderThickness="0"
Margin="15"
CornerRadius="8">
<ItemsPresenter />
</Border>
</ControlTemplate>
</Setter.Value>
</Setter>
<Style.Triggers>
<EventTrigger RoutedEvent="FrameworkElement.Loaded">
</EventTrigger>
</Style.Triggers>
</Style>
<Style TargetType="MenuItem">
<Setter Property="Background" Value="{DynamicResource SecondaryPrimaryBackgroundColor}"/>
<Setter Property="Foreground" Value="{DynamicResource PrimaryTextColor}"/>
<Setter Property="BorderBrush" Value="{DynamicResource BorderBrushColor}"/>
<Setter Property="BorderThickness" Value="0.5"/>
<Setter Property="Template">
<Setter.Value>
<ControlTemplate TargetType="MenuItem">
<Border x:Name="Border"
BorderBrush="{TemplateBinding BorderBrush}"
BorderThickness="{TemplateBinding BorderThickness}"
Padding="8"
CornerRadius="0">
<Grid>
<Grid.ColumnDefinitions>
<ColumnDefinition Width="Auto"/>
<ColumnDefinition Width="*"/>
<ColumnDefinition Width="Auto"/>
</Grid.ColumnDefinitions>
<ContentPresenter Grid.Column="0"
ContentSource="Icon"
HorizontalAlignment="Left"
VerticalAlignment="Center"
Margin="0,0,4,0"/>
<TextBlock x:Name="TextBlock"
Grid.Column="1"
Text="{TemplateBinding Header}"
Foreground="{TemplateBinding BorderThickness}"
VerticalAlignment="Center"
Margin="0"/>
<TextBlock x:Name="ShortcutText"
Grid.Column="2"
Text="{TemplateBinding InputGestureText}"
Foreground="{DynamicResource SecondaryTextColor}"
VerticalAlignment="Center"
HorizontalAlignment="Right"
Margin="5,0"/>
<Path x:Name="Arrow"
Grid.Column="2"
Data="M0,0 L4,4 L8,0 Z"
Fill="{DynamicResource PrimaryTextColor}"
HorizontalAlignment="Center"
VerticalAlignment="Center"
Visibility="Collapsed"
Margin="4,0,0,0"/>
<Popup Name="PART_Popup"
Placement="Right"
IsOpen="{Binding IsSubmenuOpen, RelativeSource={RelativeSource TemplatedParent}}"
AllowsTransparency="True"
Focusable="False"
PopupAnimation="Fade">
<Border Background="{TemplateBinding Background}"
BorderBrush="{DynamicResource BorderBrushColor}"
BorderThickness="2"
CornerRadius="0">
<StackPanel IsItemsHost="True"
KeyboardNavigation.DirectionalNavigation="Continue"/>
</Border>
</Popup>
</Grid>
</Border>
<ControlTemplate.Triggers>
<Trigger Property="IsMouseOver" Value="True">
<Setter TargetName="Border" Property="Background" Value="Transparent"/>
<Setter TargetName="TextBlock" Property="Foreground" Value="{DynamicResource ButtonHighlightColor}"/>
<Setter TargetName="ShortcutText" Property="Foreground" Value="{DynamicResource ButtonHighlightColor}"/>
<Setter TargetName="Arrow" Property="Fill" Value="{DynamicResource ButtonHighlightColor}"/>
</Trigger>
<Trigger Property="HasItems" Value="True">
<Setter TargetName="Arrow" Property="Visibility" Value="Visible"/>
</Trigger>
</ControlTemplate.Triggers>
</ControlTemplate>
</Setter.Value>
</Setter>
</Style>
<Style x:Key="ScrollThumbs" TargetType="{x:Type Thumb}">
<Setter Property="Template">
<Setter.Value>
<ControlTemplate TargetType="{x:Type Thumb}">
<Grid x:Name="Grid">
<Rectangle HorizontalAlignment="Stretch" VerticalAlignment="Stretch" Width="Auto" Height="Auto" Fill="Transparent" />
<Border x:Name="Rectangle1" CornerRadius="5" HorizontalAlignment="Stretch" VerticalAlignment="Stretch" Width="Auto" Height="Auto" Background="{TemplateBinding Background}" />
</Grid>
<ControlTemplate.Triggers>
<Trigger Property="Tag" Value="Horizontal">
<Setter TargetName="Rectangle1" Property="Width" Value="Auto" />
<Setter TargetName="Rectangle1" Property="Height" Value="7" />
</Trigger>
</ControlTemplate.Triggers>
</ControlTemplate>
</Setter.Value>
</Setter>
</Style>
<Style x:Key="{x:Type ScrollBar}" TargetType="{x:Type ScrollBar}">
<Setter Property="Stylus.IsFlicksEnabled" Value="false" />
<Setter Property="Foreground" Value="{DynamicResource PrimaryButtonBackground}" />
<Setter Property="Background" Value="{DynamicResource SecondaryPrimaryBackgroundColor}" />
<Setter Property="Width" Value="8" />
<Setter Property="Template">
<Setter.Value>
<ControlTemplate TargetType="{x:Type ScrollBar}">
<Grid x:Name="GridRoot" Width="8" Background="{TemplateBinding Background}">
<Grid.RowDefinitions>
<RowDefinition Height="0.00001*" />
</Grid.RowDefinitions>
<Track x:Name="PART_Track" Grid.Row="0" IsDirectionReversed="true" Focusable="false">
<Track.Thumb>
<Thumb x:Name="Thumb" Background="{TemplateBinding Foreground}" Style="{DynamicResource ScrollThumbs}" />
</Track.Thumb>
<Track.IncreaseRepeatButton>
<RepeatButton x:Name="PageUp" Command="ScrollBar.PageDownCommand" Opacity="0" Focusable="false" />
</Track.IncreaseRepeatButton>
<Track.DecreaseRepeatButton>
<RepeatButton x:Name="PageDown" Command="ScrollBar.PageUpCommand" Opacity="0" Focusable="false" />
</Track.DecreaseRepeatButton>
</Track>
</Grid>
<ControlTemplate.Triggers>
<Trigger SourceName="Thumb" Property="IsMouseOver" Value="true">
<Setter Value="{DynamicResource ButtonSelectBrush}" TargetName="Thumb" Property="Background" />
</Trigger>
<Trigger SourceName="Thumb" Property="IsDragging" Value="true">
<Setter Value="{DynamicResource DarkBrush}" TargetName="Thumb" Property="Background" />
</Trigger>
<Trigger Property="IsEnabled" Value="false">
<Setter TargetName="Thumb" Property="Visibility" Value="Collapsed" />
</Trigger>
<Trigger Property="Orientation" Value="Horizontal">
<Setter TargetName="GridRoot" Property="LayoutTransform">
<Setter.Value>
<RotateTransform Angle="-90" />
</Setter.Value>
</Setter>
<Setter TargetName="PART_Track" Property="LayoutTransform">
<Setter.Value>
<RotateTransform Angle="-90" />
</Setter.Value>
</Setter>
<Setter Property="Width" Value="Auto" />
<Setter Property="Height" Value="8" />
<Setter TargetName="Thumb" Property="Tag" Value="Horizontal" />
<Setter TargetName="PageDown" Property="Command" Value="ScrollBar.PageLeftCommand" />
<Setter TargetName="PageUp" Property="Command" Value="ScrollBar.PageRightCommand" />
</Trigger>
</ControlTemplate.Triggers>
</ControlTemplate>
</Setter.Value>
</Setter>
</Style>
<Style TargetType="ScrollViewer">
<Setter Property="CanContentScroll" Value="False"/>
<Setter Property="IsDeferredScrollingEnabled" Value="False"/>
<Setter Property="VerticalScrollBarVisibility" Value="Auto"/>
<Setter Property="HorizontalScrollBarVisibility" Value="Hidden"/>
</Style>
<Style TargetType="TabControl">
<Setter Property="TabStripPlacement" Value="Left"/>
<Setter Property="Foreground" Value="{x:Null}"/>
<Setter Property="Background" Value="{x:Null}"/>
<Setter Property="BorderBrush" Value="{x:Null}"/>
</Style>
<Style TargetType="TabItem">
<Setter Property="Background" Value="{x:Null}"/>
<Setter Property="FontSize" Value="18"/>
<Setter Property="BorderBrush" Value="{x:Null}"/>
<Setter Property="Template">
<Setter.Value>
<ControlTemplate TargetType="TabItem">
<Border Name="Border"
CornerRadius="6"
BorderThickness="0"
Height="auto"
Width="auto"
Padding="8"
Cursor="Hand"
BorderBrush="Transparent"
Background="Transparent"
Margin="14,10,0,0">
<ContentPresenter
x:Name="ContentSite"
VerticalAlignment="Center"
HorizontalAlignment="Center"
ContentSource="Header"
/>
</Border>
<ControlTemplate.Triggers>
<Trigger Property="IsSelected" Value="True">
<Setter TargetName="Border" Property="Background" Value="{DynamicResource PrimaryButtonBackground}" />
<Setter Property="Foreground" Value="White" />
</Trigger>
<Trigger Property="IsSelected" Value="False">
<Setter TargetName="Border" Property="Background" Value="Transparent" />
<Setter Property="Foreground" Value="{DynamicResource PrimaryTextColor}" />
</Trigger>
<MultiTrigger>
<MultiTrigger.Conditions>
<Condition Property="IsSelected" Value="True"/>
<Condition Property="Name" Value="WhatsNewTab"/>
</MultiTrigger.Conditions>
<MultiTrigger.Setters>
<Setter TargetName="Border" Property="Background" Value="{DynamicResource ButtonHighlightColor}" />
<Setter Property="Foreground" Value="White" />
</MultiTrigger.Setters>
</MultiTrigger>
<MultiTrigger>
<MultiTrigger.Conditions>
<Condition Property="IsSelected" Value="False"/>
<Condition Property="Name" Value="WhatsNewTab"/>
</MultiTrigger.Conditions>
<MultiTrigger.Setters>
<Setter TargetName="Border" Property="Background" Value="Transparent" />
<Setter Property="Foreground" Value="{DynamicResource logo}" />
</MultiTrigger.Setters>
</MultiTrigger>
</ControlTemplate.Triggers>
</ControlTemplate>
</Setter.Value>
</Setter>
</Style>
<Style  TargetType="ComboBox">
<Setter Property="Focusable" Value="True"/>
<Setter Property="Foreground" Value="{DynamicResource SecondaryTextColor}"/>
<Setter Property="BorderThickness" Value="0"/>
<Setter Property="Margin" Value="5"/>
<Setter Property="FontSize" Value="12"/>
<Setter Property="Background" Value="Transparent"/>
<Setter Property="HorizontalAlignment" Value="Left"/>
<Setter Property="Template">
<Setter.Value>
<ControlTemplate TargetType="ComboBox">
<Border Background="{TemplateBinding Background}"
BorderBrush="{TemplateBinding BorderBrush}"
BorderThickness="{TemplateBinding BorderThickness}">
<ItemsPresenter/>
</Border>
</ControlTemplate>
</Setter.Value>
</Setter>
<Setter Property="ItemsPanel">
<Setter.Value>
<ItemsPanelTemplate>
<WrapPanel Orientation="Horizontal" HorizontalAlignment="Left"/>
</ItemsPanelTemplate>
</Setter.Value>
</Setter>
</Style>
<Style TargetType="ComboBoxItem">
<Setter Property="Margin" Value="2"/>
<Setter Property="Padding" Value="5"/>
<Setter Property="Background" Value="Transparent"/>
<Setter Property="Cursor" Value="Hand"/>
<Setter Property="HorizontalContentAlignment" Value="Left"/>
<Setter Property="Template">
<Setter.Value>
<ControlTemplate TargetType="ComboBoxItem">
<Border x:Name="Bd"
Background="{TemplateBinding Background}"
CornerRadius="3"
Padding="{TemplateBinding Padding}">
<StackPanel Orientation="Horizontal" HorizontalAlignment="Left">
<ContentPresenter
HorizontalAlignment="Left"
TextBlock.TextAlignment="Left"
RecognizesAccessKey="True"/>
</StackPanel>
</Border>
<ControlTemplate.Triggers>
<Trigger Property="IsSelected" Value="True">
<Setter TargetName="Bd" Property="Background" Value="{DynamicResource PrimaryButtonBackground}"/>
<Setter Property="Foreground" Value="{DynamicResource SecondaryTextColor2}"/>
</Trigger>
<Trigger Property="IsSelected" Value="False">
<Setter TargetName="Bd" Property="Background" Value="{DynamicResource SecondaryPrimaryBackgroundColor}"/>
<Setter Property="Foreground" Value="{DynamicResource SecondaryTextColor}"/>
</Trigger>
<Trigger Property="IsMouseOver" Value="True">
<Setter TargetName="Bd" Property="Background" Value="{DynamicResource PrimaryButtonBackground}"/>
<Setter Property="Foreground" Value="White"/>
</Trigger>
</ControlTemplate.Triggers>
</ControlTemplate>
</Setter.Value>
</Setter>
</Style>
<Style x:Key="ToggleSwitchStyle" TargetType="CheckBox">
<Setter Property="Foreground" Value="{DynamicResource PrimaryTextColor}"/>
<Setter Property="Template">
<Setter.Value>
<ControlTemplate TargetType="CheckBox">
<Grid>
<Grid.ColumnDefinitions>
<ColumnDefinition Width="Auto"/>
<ColumnDefinition Width="Auto"/>
<ColumnDefinition Width="Auto"/>
</Grid.ColumnDefinitions>
<TextBlock x:Name="CheckIcon"
Grid.Column="0"
FontSize="17"
VerticalAlignment="Center"
HorizontalAlignment="Center"
Text="⚙️"/>
<ContentPresenter Grid.Column="1"
IsHitTestVisible="False"
Margin="5,0,15,0"/>
<Grid x:Name="SwitchArea"
Grid.Column="2"
Width="40"
Height="20"
HorizontalAlignment="Right"
Background="Transparent">
<Border x:Name="Track"
Background="{DynamicResource SecondaryPrimaryBackgroundColor}"
BorderThickness="1.2"
BorderBrush="{DynamicResource ToggleSwitchBorderBrush}"
CornerRadius="10"/>
<Ellipse x:Name="Thumb"
Width="10"
Height="10"
Fill="Black"
HorizontalAlignment="Left"
VerticalAlignment="Center"
Margin="2,0,0,0"/>
</Grid>
</Grid>
<ControlTemplate.Triggers>
<Trigger Property="IsChecked" Value="True">
<Trigger.EnterActions>
<RemoveStoryboard BeginStoryboardName="ToggleSwitchLeft"/>
<BeginStoryboard x:Name="ToggleSwitchRight">
<Storyboard>
<ThicknessAnimation Storyboard.TargetName="Thumb"
Storyboard.TargetProperty="Margin"
To="22,0,0,0"
Duration="0:0:0.1"/>
</Storyboard>
</BeginStoryboard>
</Trigger.EnterActions>
<Setter TargetName="Thumb" Property="Fill" Value="{DynamicResource ToggleSwitchEnableColor}"/>
<Setter TargetName="Track" Property="Background" Value="{DynamicResource PrimaryButtonBackground}"/>
<Setter TargetName="Track" Property="BorderBrush" Value="{x:Null}"/>
</Trigger>
<Trigger Property="IsChecked" Value="False">
<Trigger.EnterActions>
<RemoveStoryboard BeginStoryboardName="ToggleSwitchRight"/>
<BeginStoryboard x:Name="ToggleSwitchLeft">
<Storyboard>
<ThicknessAnimation Storyboard.TargetName="Thumb"
Storyboard.TargetProperty="Margin"
To="5,0,0,0"
Duration="0:0:0.1"/>
</Storyboard>
</BeginStoryboard>
</Trigger.EnterActions>
<Setter TargetName="Thumb" Property="Fill" Value="{DynamicResource ToggleSwitchDisableColor}"/>
<Setter TargetName="Track" Property="Background" Value="{x:Null}"/>
<Setter TargetName="Track" Property="BorderBrush" Value="#606060"/>
<Setter TargetName="Track" Property="BorderThickness" Value="2"/>
</Trigger>
<Trigger SourceName="SwitchArea" Property="IsMouseOver" Value="True">
<Setter TargetName="Thumb" Property="Width" Value="12"/>
<Setter TargetName="Thumb" Property="Height" Value="12"/>
</Trigger>
</ControlTemplate.Triggers>
</ControlTemplate>
</Setter.Value>
</Setter>
</Style>
<Style TargetType="TextBlock" x:Key="logoText">
<Setter Property="Foreground" Value="{DynamicResource logo}"/>
<Setter Property="TextOptions.TextFormattingMode" Value="Ideal" />
<Setter Property="FontFamily" Value="Arial"/>
<Setter Property="FontWeight" Value="bold"/>
<Setter Property="FontSize" Value="60"/>
<Setter Property="TextAlignment" Value="Center"/>
<Setter Property="TextOptions.TextRenderingMode" Value="ClearType" />
</Style>
<Style TargetType="{x:Type ContextMenu}">
<Setter Property="SnapsToDevicePixels" Value="True" />
<Setter Property="OverridesDefaultStyle" Value="True" />
<Setter Property="Grid.IsSharedSizeScope" Value="true" />
<Setter Property="HasDropShadow" Value="True" />
<Setter Property="Template">
<Setter.Value>
<ControlTemplate TargetType="{x:Type ContextMenu}">
<Border x:Name="Border"
Background="{ DynamicResource PrimaryBackgroundColor }"
BorderThickness="1">
<StackPanel IsItemsHost="True"
KeyboardNavigation.DirectionalNavigation="Cycle" />
</Border>
</ControlTemplate>
</Setter.Value>
</Setter>
</Style>
<Style x:Key="BlinkingDotStyle" TargetType="Ellipse">
<Setter Property="Opacity" Value="0"/>
<Style.Triggers>
<EventTrigger RoutedEvent="Ellipse.Loaded">
<BeginStoryboard>
<Storyboard RepeatBehavior="Forever">
<DoubleAnimationUsingKeyFrames Storyboard.TargetProperty="Opacity">
<LinearDoubleKeyFrame Value="1" KeyTime="0:0:0.5"/>
<LinearDoubleKeyFrame Value="1" KeyTime="0:0:1.5"/>
<LinearDoubleKeyFrame Value="0" KeyTime="0:0:2.0"/>
<LinearDoubleKeyFrame Value="0" KeyTime="0:0:2.5"/>
</DoubleAnimationUsingKeyFrames>
</Storyboard>
</BeginStoryboard>
</EventTrigger>
</Style.Triggers>
</Style>
<Style x:Key="HighlightBorder" TargetType="Border">
<Setter Property="Background" Value="{DynamicResource SecondaryPrimaryBackgroundColor}"/>
<Setter Property="CornerRadius" Value="6"/>
<Setter Property="Padding" Value="10"/>
<Setter Property="Margin" Value="0,8,0,0"/>
<Setter Property="BorderThickness" Value="0.8"/>
<Setter Property="BorderBrush" Value="{DynamicResource BorderBrushColor}"/>
<Setter Property="SnapsToDevicePixels" Value="True"/>
<Style.Triggers>
<Trigger Property="IsMouseOver" Value="True">
<Setter Property="BorderBrush" Value="{DynamicResource ButtonHighlightColor}"/>
<Setter Property="BorderThickness" Value="0.8"/>
</Trigger>
</Style.Triggers>
</Style>
<ResourceDictionary x:Key="Dark">
<SolidColorBrush x:Key="PrimaryBackgroundColor" Color="#22272e"/>
<SolidColorBrush x:Key="SecondaryPrimaryBackgroundColor" Color="#2d333b"/>
<SolidColorBrush x:Key="PrimaryTextColor" Color="#d1d5db"/>
<SolidColorBrush x:Key="SecondaryTextColor" Color="#adbac7"/>
<SolidColorBrush x:Key="SecondaryTextColor2" Color="white"/>
<SolidColorBrush x:Key="PrimaryButtonBackground" Color="#0366d6"/>
<SolidColorBrush x:Key="ButtonHighlightColor" Color="#0969da"/>
<SolidColorBrush x:Key="ButtonBorderColor" Color="#539bf5"/>
<SolidColorBrush x:Key="BorderBrushColor" Color="#444c56"/>
<SolidColorBrush x:Key="LabelColor" Color="#373e47"/>
<SolidColorBrush x:Key="ToggleSwitchBackgroundColor" Color="#373e47"/>
<SolidColorBrush x:Key="ToggleSwitchForegroundColor" Color="#22272e"/>
<SolidColorBrush x:Key="ToggleSwitchEnableColor" Color="white"/>
<SolidColorBrush x:Key="ToggleSwitchDisableColor" Color="white"/>
<SolidColorBrush x:Key="ToggleSwitchBorderBrush" Color="#444c56"/>
<SolidColorBrush x:Key="itemColor1" Color="#2d333b"/>
<SolidColorBrush x:Key="itemColor2" Color="#333942"/>
<SolidColorBrush x:Key="logo" Color="white"/>
<ImageBrush x:Key="BackgroundImage" ImageSource="{x:Null}" Stretch="UniformToFill"/>
<x:String x:Key="SubText">Install Tweaks Tool</x:String>
</ResourceDictionary>
<ResourceDictionary x:Key="DarkKnight">
<SolidColorBrush x:Key="PrimaryBackgroundColor" Color="#0a0a0a"/>
<SolidColorBrush x:Key="SecondaryPrimaryBackgroundColor" Color="#121212"/>
<SolidColorBrush x:Key="PrimaryTextColor" Color="#d1d5db"/>
<SolidColorBrush x:Key="SecondaryTextColor" Color="#999999"/>
<SolidColorBrush x:Key="SecondaryTextColor2" Color="white"/>
<SolidColorBrush x:Key="PrimaryButtonBackground" Color="#0366d6"/>
<SolidColorBrush x:Key="ButtonHighlightColor" Color="#0366d6"/>
<SolidColorBrush x:Key="ButtonBorderColor" Color="#ff0000"/>
<SolidColorBrush x:Key="BorderBrushColor" Color="#444c56"/>
<SolidColorBrush x:Key="LabelColor" Color="#2a2a2a"/>
<SolidColorBrush x:Key="ToggleSwitchBackgroundColor" Color="#1a1a1a"/>
<SolidColorBrush x:Key="ToggleSwitchForegroundColor" Color="#0f0f0f"/>
<SolidColorBrush x:Key="ToggleSwitchEnableColor" Color="white"/>
<SolidColorBrush x:Key="ToggleSwitchDisableColor" Color="white"/>
<SolidColorBrush x:Key="ToggleSwitchBorderBrush" Color="#444444"/>
<SolidColorBrush x:Key="itemColor1" Color="#CC141414"/>
<SolidColorBrush x:Key="itemColor2" Color="#991C1C1C"/>
<SolidColorBrush x:Key="logo" Color="#0366d6"/>
<ImageBrush x:Key="BackgroundImage" ImageSource="https://images.hdqwalls.com/wallpapers/the-batman-fan-made-4k-xx.jpg" Stretch="UniformToFill" Opacity="0.4" />
<x:String x:Key="SubText">I am not a hero</x:String>
</ResourceDictionary>
<ResourceDictionary x:Key="Light">
<SolidColorBrush x:Key="PrimaryBackgroundColor" Color="#ffffff"/>
<SolidColorBrush x:Key="SecondaryPrimaryBackgroundColor" Color="#f6f8fa"/>
<SolidColorBrush x:Key="PrimaryTextColor" Color="#24292e"/>
<SolidColorBrush x:Key="SecondaryTextColor" Color="#57606a"/>
<SolidColorBrush x:Key="SecondaryTextColor2" Color="white"/>
<SolidColorBrush x:Key="PrimaryButtonBackground" Color="#0969da"/>
<SolidColorBrush x:Key="ButtonHighlightColor" Color="#218bff"/>
<SolidColorBrush x:Key="ButtonBorderColor" Color="#0969da"/>
<SolidColorBrush x:Key="BorderBrushColor" Color="#d0d7de"/>
<SolidColorBrush x:Key="Label" Color="#d8e0e7"/>
<SolidColorBrush x:Key="ToggleSwitchBackgroundColor" Color="#d0d7de"/>
<SolidColorBrush x:Key="ToggleSwitchForegroundColor" Color="#f6f8fa"/>
<SolidColorBrush x:Key="ToggleSwitchEnableColor" Color="white"/>
<SolidColorBrush x:Key="ToggleSwitchDisableColor" Color="black"/>
<SolidColorBrush x:Key="ToggleSwitchBorderBrush" Color="#d0d7de"/>
<SolidColorBrush x:Key="itemColor1" Color="#f6f8fa"/>
<SolidColorBrush x:Key="itemColor2" Color="#ebf0f4"/>
<SolidColorBrush x:Key="logo" Color="#0969da"/>
<ImageBrush x:Key="BackgroundImage" ImageSource="{x:Null}" Stretch="UniformToFill"/>
<x:String x:Key="SubText">Install Tweaks Tool</x:String>
</ResourceDictionary>
<ResourceDictionary x:Key="Palestine">
<SolidColorBrush x:Key="PrimaryBackgroundColor" Color="black"/>
<SolidColorBrush x:Key="SecondaryPrimaryBackgroundColor" Color="black"/>
<SolidColorBrush x:Key="PrimaryTextColor" Color="#d1d5db"/>
<SolidColorBrush x:Key="SecondaryTextColor" Color="#999999"/>
<SolidColorBrush x:Key="SecondaryTextColor2" Color="white"/>
<SolidColorBrush x:Key="PrimaryButtonBackground" Color="#00B583"/>
<SolidColorBrush x:Key="ButtonHighlightColor" Color="#00B583"/>
<SolidColorBrush x:Key="ButtonBorderColor" Color="#007A3D"/>
<SolidColorBrush x:Key="BorderBrushColor" Color="black"/>
<SolidColorBrush x:Key="LabelColor" Color="#444444"/>
<SolidColorBrush x:Key="ToggleSwitchBackgroundColor" Color="#202020"/>
<SolidColorBrush x:Key="ToggleSwitchForegroundColor" Color="#2b2b2b"/>
<SolidColorBrush x:Key="ToggleSwitchEnableColor" Color="white"/>
<SolidColorBrush x:Key="ToggleSwitchDisableColor" Color="white"/>
<SolidColorBrush x:Key="ToggleSwitchBorderBrush" Color="#777777"/>
<SolidColorBrush x:Key="itemColor1" Color="#CC000000"/>
<SolidColorBrush x:Key="itemColor2" Color="#99000002"/>
<SolidColorBrush x:Key="logo" Color="#00B583"/>
<ImageBrush x:Key="BackgroundImage" ImageSource="https://w.wallhaven.cc/full/we/wallhaven-wegrj6.jpg" Stretch="UniformToFill" Opacity="0.3"/>
<x:String x:Key="SubText">#StandWithPalestine</x:String>
</ResourceDictionary>
</Window.Resources>
<Grid Background="{DynamicResource BackgroundImage}" >
<Grid.RowDefinitions>
<RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/>
</Grid.RowDefinitions>
<Grid>
<Grid.ColumnDefinitions>
<ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/>
</Grid.ColumnDefinitions>
<Menu Grid.Row="0" Grid.Column="0" Background="{DynamicResource SecondaryPrimaryBackgroundColor}" BorderBrush="Transparent" BorderThickness="0" HorizontalAlignment="Left">
<MenuItem Header="{Binding Management, TargetNullValue=Management}" VerticalAlignment="Center" HorizontalAlignment="Left" >
<MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="15" Text=""/></MenuItem.Icon>
<MenuItem Name="sysinfo" Header="{Binding System_Info, TargetNullValue=System Info}"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="poweroption" Header="{Binding Power_Options, TargetNullValue=Power Options}"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="deviceManager"><MenuItem.Header><Binding Path="Device_Manager" TargetNullValue="Device Manager"/></MenuItem.Header><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="services" Header="{Binding Services, TargetNullValue=Services}"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="network" Header="{Binding Networks, TargetNullValue=Networks}"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="appsfeatures" Header="{Binding Apps_features, TargetNullValue=Programs and Features}"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="taskmgr" Header="{Binding Task_Manager, TargetNullValue=Task Manager}"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="diskmgmt" Header="{Binding Disk_Managment, TargetNullValue=Disk Management}"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="msconfig" Header="{Binding Msconfig, TargetNullValue=System Configuration}"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="ev" Header="{Binding Environment_Variables, TargetNullValue=Environment Variables}"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text="&#xE81E;"/></MenuItem.Icon></MenuItem>
<MenuItem Name="spp" Header="{Binding System_Protection, TargetNullValue=System Protection}"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
</MenuItem>
<MenuItem Header="{Binding Preferences, TargetNullValue=Preferences}" VerticalAlignment="Center" HorizontalAlignment="Left" >
<MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="15" Text=""/></MenuItem.Icon>
<MenuItem Name="restorepoint" Header="{Binding Create_restore_point, TargetNullValue=Restore Point}" InputGestureText="Shift+Q"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Header="{Binding package_manager, TargetNullValue=Package Manager}" ToolTip="Select Package Manager"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon><MenuItem Name="auto" Header="{Binding auto, TargetNullValue=Auto}" ToolTip="Automatically install using the best available method"/><MenuItem Name="choco" Header="Choco"/><MenuItem Name="winget" Header="Winget"/></MenuItem>
<MenuItem Header="{Binding Portable_Downloads_Folder}"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon><MenuItem Name="chocoloc" Header="Choco" InputGestureText="Shift+C"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem><MenuItem Name="itt" Header="ITT" InputGestureText="Shift+T"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem></MenuItem>
<MenuItem Name="save" Header="{Binding Save, TargetNullValue=Save}" ToolTip="Save selected apps" InputGestureText="Shift+S"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="load" Header="{Binding Restore, TargetNullValue=Restore}" ToolTip="Restore selected apps" InputGestureText="Shift+D"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Header="{Binding Theme}"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon><MenuItem Name="systheme" Header="{Binding Use_system_setting, TargetNullValue=System}" ToolTip="Use system theme if available"/><MenuItem Name="Dark" Header="Dark"/>
<MenuItem Name="DarkKnight" Header="The Dark Knight"/>
<MenuItem Name="Light" Header="Light"/>
<MenuItem Name="Palestine" Header="Palestine"/></MenuItem>
<MenuItem Header="{Binding Language, TargetNullValue=Language}"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon><MenuItem Name="systemlang" Header="{Binding Use_system_setting, TargetNullValue=System Language}"/><MenuItem Name="ar" Header="عربي"/>
<MenuItem Name="de" Header="Deutsch"/>
<MenuItem Name="en" Header="English"/>
<MenuItem Name="es" Header="Español"/>
<MenuItem Name="fr" Header="Français"/>
<MenuItem Name="hi" Header="अंग्रेज़ी"/>
<MenuItem Name="it" Header="Italiano"/>
<MenuItem Name="ko" Header="한국어"/>
<MenuItem Name="ru" Header="Русский"/>
<MenuItem Name="tr" Header="Türkçe"/>
<MenuItem Name="zh" Header="中文"/></MenuItem>
<MenuItem Name="ittshortcut" Header="{Binding Create_desktop_shortcut, TargetNullValue=Create Shortcut}" InputGestureText="Shift+I"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="15" Text=""/></MenuItem.Icon></MenuItem>
</MenuItem>
<MenuItem Header="{Binding Third_party, TargetNullValue=Third Party}" VerticalAlignment="Center" HorizontalAlignment="Center" >
<MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="15" Text=""/></MenuItem.Icon>
<MenuItem Name="finddriver" Header="Find GPU Driver" ToolTip="Find GPU Driver on official manufacturer website"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="mas" Header="Windows activation" ToolTip="Windows activation"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="winoffice" Header="Windows/Office ISO" ToolTip="Windows and Office Original ISO"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="idm" Header="IDM Trial Reset" ToolTip="Get rid of IDM Active message"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="shelltube" Header="ShellTube" ToolTip="Download YouTube video easily"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="spotifydown" Header="Spotify Downloader" ToolTip="SpotifyDown allows you to download tracks, playlists and albums from Spotify instantly."><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Header="{Binding Browsers_extensions, TargetNullValue=Browsers Extensions}"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon><MenuItem Name="uBlock" Header="uBlockOrigin"/><MenuItem Header="Youtube"><MenuItem Name="Unhook" Header="Unhook Customize YouTube"/><MenuItem Name="efy" Header="Enhancer for YouTube"/></MenuItem></MenuItem>
<MenuItem Name="sordum" Header="Sordum tools" ToolTip="Collection of free utilities designed to enhance or control various aspects of the Windows operating system"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="techpowerup" Header="TechPowerUp" ToolTip="Collection of free TechPowerUp utilities."><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="majorgeeks" Header="Major Geeks" ToolTip="Website that provides trusted, safe, and curated software downloads for Windows users. It focuses on high-quality tools."><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="webtor" Header="Webtor" ToolTip="Web-based platform that allows users to stream torrent files directly in their browser without needing to download them."><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
<MenuItem Name="asustool" Header="ASUS Setup Tool" ToolTip="Tool that manages the setup installation for the legacy Aura Sync, LiveDash, AiSuite3"><MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="16" Text=""/></MenuItem.Icon></MenuItem>
</MenuItem>
<MenuItem Name="dev" ToolTip="Send your feedback" Header="{Binding About, TargetNullValue=About}" VerticalAlignment="Center" HorizontalAlignment="Center" >
<MenuItem.Icon><TextBlock FontFamily="Segoe MDL2 Assets" FontSize="15" Text=""/></MenuItem.Icon>
</MenuItem>
</Menu>
<Grid Grid.Column="1" HorizontalAlignment="Right" Margin="0,0,20,0">
<Grid.ColumnDefinitions>
<ColumnDefinition Width="Auto"/><ColumnDefinition Width="Auto"/>
</Grid.ColumnDefinitions>
<Grid HorizontalAlignment="Left" Grid.Column="1" VerticalAlignment="Center">
<TextBox Name="searchInput" Width="120" Padding="8"
Style="{StaticResource SearchBox}"
HorizontalAlignment="Left" VerticalAlignment="Center"/>
</Grid>
</Grid>
</Grid>
<TabControl Name="taps" Grid.Row="1" SelectedIndex="1">
<TabItem Name="WhatsNewTab">
<TabItem.Header>
<Grid>
<TextBlock Text="itt" FontFamily="Arial" FontWeight="Bold" FontSize="50" HorizontalAlignment="Center" VerticalAlignment="Center"/>
<Ellipse Width="9" Height="9" Fill="Red" Style="{StaticResource BlinkingDotStyle}" HorizontalAlignment="Center" VerticalAlignment="Top" Visibility="Hidden" Margin="40,0,0,0" x:Name="hotdot"/>
</Grid>
</TabItem.Header>
<Border Background="transparent" Padding="20">
<Grid>
<Grid.RowDefinitions>
<RowDefinition Height="Auto"/>
<RowDefinition Height="*"/>
<RowDefinition Height="Auto"/>
</Grid.RowDefinitions>
<StackPanel x:Name="MainStackPanel" Background="Transparent" Orientation="Vertical" Margin="25,25,0,0">
<Grid Background="Transparent">
<StackPanel>
<TextBlock Name="title" FontSize="20" Text="What&apos;s New" Foreground="{DynamicResource SecondaryTextColor}" FontWeight="SemiBold" TextWrapping="Wrap" VerticalAlignment="Center" HorizontalAlignment="Left"/>
<TextBlock Name="date" Visibility="Hidden" Margin="5,5,0,0" FontSize="12" Text="8/29/2024" Foreground="{DynamicResource SecondaryTextColor}" TextWrapping="Wrap" VerticalAlignment="Center" HorizontalAlignment="Left"/>
</StackPanel>
</Grid>
</StackPanel>
<Grid Grid.Row="1" Background="Transparent" Margin="25,0,0,0" HorizontalAlignment="Stretch" VerticalAlignment="Stretch">
<ScrollViewer Name="ScrollViewer" VerticalScrollBarVisibility="Auto">
<StackPanel><TextBlock Text='▶️ Watch a demo' FontSize='20' Padding='10 25 0 20' Foreground='{DynamicResource PrimaryTextColor}' FontWeight='bold' TextWrapping='Wrap'/>
<Image x:Name='yt' Cursor='Hand' ToolTip='Click to visit' Margin='15,0,0,15' Height='Auto' Width='388' HorizontalAlignment='Left'>
<Image.Source>
<BitmapImage UriSource='https://img.youtube.com/vi/0kZFi6NT1gI/maxresdefault.jpg' CacheOption='OnLoad'/>
</Image.Source>
</Image>
<TextBlock Text='💠 Windows 10 LTS' FontSize='20' Padding='10 25 0 20' Foreground='{DynamicResource PrimaryTextColor}' FontWeight='bold' TextWrapping='Wrap'/>
<Image x:Name='win' Cursor='Hand' ToolTip='Click to visit' Margin='15,0,0,15' Height='Auto' Width='388' HorizontalAlignment='Left'>
<Image.Source>
<BitmapImage UriSource='https://raw.githubusercontent.com/emadadeldev/ittea/refs/heads/main/static/Images/windows10lts.jpg' CacheOption='OnLoad'/>
</Image.Source>
</Image>
<TextBlock Text='Windows 10 LTS official ISO – the stable, long-term support version' FontSize='15' HorizontalAlignment='Left' Padding='10 0 0 10' Foreground='{DynamicResource PrimaryTextColor}' TextWrapping='Wrap' MaxWidth='450'/>
<TextBlock Text='Keyboard Shortcuts' FontSize='20' Padding='10 25 0 20' Foreground='{DynamicResource PrimaryTextColor}' FontWeight='bold' TextWrapping='Wrap'/>
<StackPanel Orientation='Vertical'>
<TextBlock Text='• Ctrl+A: Clear category filter.' Padding='35,0,0,0' FontSize='15' HorizontalAlignment='Left' Width='Auto' Height='Auto' Foreground='{DynamicResource PrimaryTextColor}' TextWrapping='Wrap'/>
</StackPanel>
<StackPanel Orientation='Vertical'>
<TextBlock Text='• Ctrl+F: toggle search mode.' Padding='35,0,0,0' FontSize='15' HorizontalAlignment='Left' Width='Auto' Height='Auto' Foreground='{DynamicResource PrimaryTextColor}' TextWrapping='Wrap'/>
</StackPanel>
<StackPanel Orientation='Vertical'>
<TextBlock Text='• Ctrl+Q: Switch to Apps.' Padding='35,0,0,0' FontSize='15' HorizontalAlignment='Left' Width='Auto' Height='Auto' Foreground='{DynamicResource PrimaryTextColor}' TextWrapping='Wrap'/>
</StackPanel>
<StackPanel Orientation='Vertical'>
<TextBlock Text='• Ctrl+W: Switch to Tweaks.' Padding='35,0,0,0' FontSize='15' HorizontalAlignment='Left' Width='Auto' Height='Auto' Foreground='{DynamicResource PrimaryTextColor}' TextWrapping='Wrap'/>
</StackPanel>
<StackPanel Orientation='Vertical'>
<TextBlock Text='• Ctrl+E: Switch to Settings.' Padding='35,0,0,0' FontSize='15' HorizontalAlignment='Left' Width='Auto' Height='Auto' Foreground='{DynamicResource PrimaryTextColor}' TextWrapping='Wrap'/>
</StackPanel>
<StackPanel Orientation='Vertical'>
<TextBlock Text='• Ctrl+S: Install selected Apps/Tweaks.' Padding='35,0,0,0' FontSize='15' HorizontalAlignment='Left' Width='Auto' Height='Auto' Foreground='{DynamicResource PrimaryTextColor}' TextWrapping='Wrap'/>
</StackPanel>
<StackPanel Orientation='Vertical'>
<TextBlock Text='• Shift+S: Save selected.' Padding='35,0,0,0' FontSize='15' HorizontalAlignment='Left' Width='Auto' Height='Auto' Foreground='{DynamicResource PrimaryTextColor}' TextWrapping='Wrap'/>
</StackPanel>
<StackPanel Orientation='Vertical'>
<TextBlock Text='• Shift+D: Load save file.' Padding='35,0,0,0' FontSize='15' HorizontalAlignment='Left' Width='Auto' Height='Auto' Foreground='{DynamicResource PrimaryTextColor}' TextWrapping='Wrap'/>
</StackPanel>
<StackPanel Orientation='Vertical'>
<TextBlock Text='• Shift+P: Open Choco folder.' Padding='35,0,0,0' FontSize='15' HorizontalAlignment='Left' Width='Auto' Height='Auto' Foreground='{DynamicResource PrimaryTextColor}' TextWrapping='Wrap'/>
</StackPanel>
<StackPanel Orientation='Vertical'>
<TextBlock Text='• Shift+T: Open ITT folder.' Padding='35,0,0,0' FontSize='15' HorizontalAlignment='Left' Width='Auto' Height='Auto' Foreground='{DynamicResource PrimaryTextColor}' TextWrapping='Wrap'/>
</StackPanel>
<StackPanel Orientation='Vertical'>
<TextBlock Text='• Shift+Q: Restore point.' Padding='35,0,0,0' FontSize='15' HorizontalAlignment='Left' Width='Auto' Height='Auto' Foreground='{DynamicResource PrimaryTextColor}' TextWrapping='Wrap'/>
</StackPanel>
<StackPanel Orientation='Vertical'>
<TextBlock Text='• Shift+I: ITT Shortcut.' Padding='35,0,0,0' FontSize='15' HorizontalAlignment='Left' Width='Auto' Height='Auto' Foreground='{DynamicResource PrimaryTextColor}' TextWrapping='Wrap'/>
</StackPanel>
<StackPanel Orientation='Vertical'>
<TextBlock Text='• Ctrl+G: Close application.' Padding='35,0,0,0' FontSize='15' HorizontalAlignment='Left' Width='Auto' Height='Auto' Foreground='{DynamicResource PrimaryTextColor}' TextWrapping='Wrap'/>
</StackPanel>
</StackPanel>
</ScrollViewer>
</Grid>
</Grid>
</Border>
</TabItem>
<TabItem Name="apps" Header="{Binding apps, TargetNullValue=Apps}" Tag="apps">
<TabItem.HeaderTemplate>
<DataTemplate>
<StackPanel Orientation="Vertical">
<TextBlock Text="📦" FontSize="18" HorizontalAlignment="Center"/>
<TextBlock Text="{Binding}" FontSize="12" HorizontalAlignment="Center"/>
</StackPanel>
</DataTemplate>
</TabItem.HeaderTemplate>
<Grid>
<Grid.RowDefinitions>
<RowDefinition Height="Auto"/>
<RowDefinition Height="*"/>
</Grid.RowDefinitions>
<ComboBox Name="AppsCategory" Grid.Row="0" SelectedIndex="0" Width="Auto" VerticalAlignment="Center" HorizontalAlignment="Center" VirtualizingStackPanel.IsVirtualizing="True" VirtualizingStackPanel.VirtualizationMode="Recycling">
<ComboBoxItem Tag="All">
<TextBlock>
<Run Text="🏷 "/>
<Run Text="{Binding all, TargetNullValue=All}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Web Browsers">
<TextBlock>
<Run Text="🌐 "/>
<Run Text="{Binding web browsers, TargetNullValue=Web Browsers}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Media">
<TextBlock>
<Run Text="🎬 "/>
<Run Text="{Binding media, TargetNullValue=Media}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Media Tools">
<TextBlock>
<Run Text="🎚 "/>
<Run Text="{Binding media tools, TargetNullValue=Media Tools}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Documents">
<TextBlock>
<Run Text="📃 "/>
<Run Text="{Binding documents, TargetNullValue=Documents}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Compression">
<TextBlock>
<Run Text="📀 "/>
<Run Text="{Binding compression, TargetNullValue=Compression}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Communication">
<TextBlock>
<Run Text="📞 "/>
<Run Text="{Binding communication, TargetNullValue=Communication}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="File Sharing">
<TextBlock>
<Run Text="📁 "/>
<Run Text="{Binding file sharing, TargetNullValue=File Sharing}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Imaging">
<TextBlock>
<Run Text="📷 "/>
<Run Text="{Binding imaging, TargetNullValue=Imaging}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Gaming">
<TextBlock>
<Run Text="🎮 "/>
<Run Text="{Binding gaming, TargetNullValue=Gaming}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Utilities">
<TextBlock>
<Run Text="🔨 "/>
<Run Text="{Binding utilities, TargetNullValue=Utilities}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Disk Tools">
<TextBlock>
<Run Text="💽 "/>
<Run Text="{Binding disk tools, TargetNullValue=Disk Tools}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Development">
<TextBlock>
<Run Text="👩‍💻 "/>
<Run Text="{Binding development, TargetNullValue=Development}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Security">
<TextBlock>
<Run Text="🛡 "/>
<Run Text="{Binding security, TargetNullValue=Security}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Portable">
<TextBlock>
<Run Text="💼 "/>
<Run Text="{Binding portable, TargetNullValue=Portable}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Runtimes">
<TextBlock>
<Run Text="📈 "/>
<Run Text="{Binding runtimes, TargetNullValue=Runtimes}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Drivers">
<TextBlock>
<Run Text="🔌 "/>
<Run Text="{Binding drivers, TargetNullValue=Drivers}"/>
</TextBlock>
</ComboBoxItem>
</ComboBox>
<ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
<Grid HorizontalAlignment="Center" Margin="10">
<ItemsControl Name="AppsListView">
<ItemsControl.ItemsPanel>
<ItemsPanelTemplate>
<WrapPanel IsItemsHost="True"
Margin="5"
HorizontalAlignment="Center"
/>
</ItemsPanelTemplate>
</ItemsControl.ItemsPanel>
<ItemsControl.ItemTemplate>
<DataTemplate>
<Border Background="{DynamicResource SecondaryPrimaryBackgroundColor}"
CornerRadius="5"
Padding="10"
Margin="5"
BorderBrush="{DynamicResource BorderBrushColor}"
BorderThickness="1.2">
<Grid>
<Grid.RowDefinitions>
<RowDefinition Height="auto"/>
</Grid.RowDefinitions>
<CheckBox
Grid.Row="0"
Content="{Binding Content}"
IsChecked="{Binding IsChecked}"
ToolTip="{Binding Description}"
FontSize="14"
FontWeight="SemiBold"
HorizontalContentAlignment="Stretch"/>
</Grid>
</Border>
</DataTemplate>
</ItemsControl.ItemTemplate>
</ItemsControl>
</Grid>
</ScrollViewer>
</Grid>
</TabItem>
<TabItem x:Name="tweeksTab" Header="{Binding tweaks, TargetNullValue=Tweaks}" Tag="tweaks">
<TabItem.HeaderTemplate>
<DataTemplate>
<StackPanel Orientation="Vertical">
<TextBlock Text="🛠" FontSize="18" HorizontalAlignment="Center"/>
<TextBlock Text="{Binding}" FontSize="12" HorizontalAlignment="Center" TextWrapping="Wrap" Margin="0,5,0,0"/>
</StackPanel>
</DataTemplate>
</TabItem.HeaderTemplate>
<Grid>
<Grid.RowDefinitions>
<RowDefinition Height="Auto"/>
<RowDefinition Height="*"/>
</Grid.RowDefinitions>
<ComboBox Name="TwaeksCategory" Grid.Row="0" SelectedIndex="0" Width="Auto" VerticalAlignment="Center" HorizontalAlignment="Center" VirtualizingStackPanel.IsVirtualizing="True" VirtualizingStackPanel.VirtualizationMode="Recycling" IsReadOnly="True" Visibility="Collapsed">
<ComboBoxItem Tag="all">
<TextBlock>
<Run Text="🏷 "/>
<Run Text="{Binding all, TargetNullValue=All}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Privacy">
<TextBlock>
<Run Text="🔒 "/>
<Run Text="{Binding privacy, TargetNullValue=Privacy}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Fixer">
<TextBlock>
<Run Text="🔧 "/>
<Run Text="{Binding fixer, TargetNullValue=Fixer}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Performance">
<TextBlock>
<Run Text="⚡ "/>
<Run Text="{Binding performance, TargetNullValue=Performance}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Personalization">
<TextBlock>
<Run Text="🎨 "/>
<Run Text="{Binding personalization, TargetNullValue=Personalization}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Power">
<TextBlock>
<Run Text="🔋 "/>
<Run Text="{Binding power, TargetNullValue=Power}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Protection">
<TextBlock>
<Run Text="🛡 "/>
<Run Text="{Binding protection, TargetNullValue=Protection}"/>
</TextBlock>
</ComboBoxItem>
<ComboBoxItem Tag="Classic">
<TextBlock>
<Run Text="🕰 "/>
<Run Text="{Binding classic, TargetNullValue=Classic}"/>
</TextBlock>
</ComboBoxItem>
</ComboBox>
<ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
<Grid HorizontalAlignment="Center" Margin="10">
<ItemsControl Name="TweaksListView">
<ItemsControl.ItemsPanel>
<ItemsPanelTemplate>
<WrapPanel IsItemsHost="True"
Margin="5"
HorizontalAlignment="Center"
/>
</ItemsPanelTemplate>
</ItemsControl.ItemsPanel>
<ItemsControl.ItemTemplate>
<DataTemplate>
<Border Background="{DynamicResource SecondaryPrimaryBackgroundColor}"
CornerRadius="5"
Padding="10"
Margin="5"
BorderBrush="{DynamicResource BorderBrushColor}"
BorderThickness="1.2">
<StackPanel>
<CheckBox
Grid.Row="0"
Content="{Binding Content}"
IsChecked="{Binding IsChecked}"
ToolTip="{Binding Description}"
FontSize="14"
FontWeight="SemiBold"
HorizontalContentAlignment="Stretch"/>
<TextBlock Text="{Binding Requires}" Margin="5" FontSize="12" FontFamily="Segoe UI Emoji" Foreground="{DynamicResource SecondaryTextColor}"/>
</StackPanel>
</Border>
</DataTemplate>
</ItemsControl.ItemTemplate>
</ItemsControl>
</Grid>
</ScrollViewer>
</Grid>
</TabItem>
<TabItem x:Name="SettingsTab" Header="{Binding settings, TargetNullValue=Settings}">
<TabItem.HeaderTemplate>
<DataTemplate>
<StackPanel Orientation="Vertical">
<TextBlock Text="⚙" FontSize="18" HorizontalAlignment="Center"/>
<TextBlock Text="{Binding}" FontSize="12" HorizontalAlignment="Center"/>
</StackPanel>
</DataTemplate>
</TabItem.HeaderTemplate>
<ListView Name="SettingsList" AlternationCount="2">
<ListView.ItemsPanel>
<ItemsPanelTemplate>
<VirtualizingStackPanel/>
</ItemsPanelTemplate>
</ListView.ItemsPanel>        <StackPanel Orientation="Vertical" Margin="0">
<CheckBox Content="Show file extensions" FontSize="15" Margin="5,8,0,15" Tag="" Style="{StaticResource ToggleSwitchStyle}" Name="Showfileextensions" ToolTip="Show file extensions in Windows displays the suffix at the end of file names like .txt .jpg .exe"/>
</StackPanel>        <StackPanel Orientation="Vertical" Margin="0">
<CheckBox Content="Show Super Hidden" FontSize="15" Margin="5,8,0,15" Tag="" Style="{StaticResource ToggleSwitchStyle}" Name="ShowSuperHidden" ToolTip="Show Super Hidden displays files and folders"/>
</StackPanel>        <StackPanel Orientation="Vertical" Margin="0">
<CheckBox Content="Dark Mode" FontSize="15" Margin="5,8,0,15" Tag="" Style="{StaticResource ToggleSwitchStyle}" Name="DarkMode" ToolTip="Dark Mode is a setting that changes the screen to darker colors reducing eye strain and saving battery life on OLED screens"/>
</StackPanel>        <StackPanel Orientation="Vertical" Margin="0">
<CheckBox Content="NumLook" FontSize="15" Margin="5,8,0,15" Tag="" Style="{StaticResource ToggleSwitchStyle}" Name="NumLook" ToolTip="Toggle the Num Lock key state when your computer starts"/>
</StackPanel>        <StackPanel Orientation="Vertical" Margin="0">
<CheckBox Content="Sticky Keys" FontSize="15" Margin="5,8,0,15" Tag="" Style="{StaticResource ToggleSwitchStyle}" Name="StickyKeys" ToolTip="Sticky keys is an accessibility feature of some graphical user interfaces which assists users who have physical disabilities"/>
</StackPanel>        <StackPanel Orientation="Vertical" Margin="0">
<CheckBox Content="Mouse Acceleration" FontSize="15" Margin="5,8,0,15" Tag="" Style="{StaticResource ToggleSwitchStyle}" Name="MouseAcceleration" ToolTip="Cursor movement is affected by the speed of your physical mouse movements"/>
</StackPanel>        <StackPanel Orientation="Vertical" Margin="0">
<CheckBox Content="End Task On Taskbar Windows 11" FontSize="15" Margin="5,8,0,15" Tag="" Style="{StaticResource ToggleSwitchStyle}" Name="EndTaskOnTaskbarWindows11" ToolTip="End task when right clicking a program in the taskbar"/>
</StackPanel>        <StackPanel Orientation="Vertical" Margin="0">
<CheckBox Content="Clear Page File At Shutdown" FontSize="15" Margin="5,8,0,15" Tag="" Style="{StaticResource ToggleSwitchStyle}" Name="ClearPageFileAtShutdown" ToolTip="Removes sensitive data stored in virtual memory when the system shuts down"/>
</StackPanel>        <StackPanel Orientation="Vertical" Margin="0">
<CheckBox Content="Auto End Tasks" FontSize="15" Margin="5,8,0,15" Tag="" Style="{StaticResource ToggleSwitchStyle}" Name="AutoEndTasks" ToolTip="Automatically end tasks that are not responding"/>
</StackPanel>        <StackPanel Orientation="Vertical" Margin="0">
<CheckBox Content="Performance Options" FontSize="15" Margin="5,8,0,15" Tag="" Style="{StaticResource ToggleSwitchStyle}" Name="PerformanceOptions" ToolTip="Adjust for best performance"/>
</StackPanel>        <StackPanel Orientation="Vertical" Margin="0">
<CheckBox Content="Launch To This PC" FontSize="15" Margin="5,8,0,15" Tag="" Style="{StaticResource ToggleSwitchStyle}" Name="LaunchToThisPC" ToolTip="File Explorer open directly to This PC"/>
</StackPanel>        <StackPanel Orientation="Vertical" Margin="0">
<CheckBox Content="Disable Automatic Driver Installation" FontSize="15" Margin="5,8,0,15" Tag="" Style="{StaticResource ToggleSwitchStyle}" Name="DisableAutomaticDriverInstallation" ToolTip="Automatically downloading and installing drivers"/>
</StackPanel>        <StackPanel Orientation="Vertical" Margin="0">
<CheckBox Content="Always show icons never Thumbnail" FontSize="15" Margin="5,8,0,15" Tag="" Style="{StaticResource ToggleSwitchStyle}" Name="AlwaysshowiconsneverThumbnail" ToolTip="Show icons in the file explorer instead of thumbnails"/>
</StackPanel>        <StackPanel Orientation="Vertical" Margin="0">
<CheckBox Content="Windows Sandbox" FontSize="15" Margin="5,8,0,15" Tag="" Style="{StaticResource ToggleSwitchStyle}" Name="WindowsSandbox" ToolTip="Windows Sandbox is a feature that allows you to run a sandboxed version of Windows"/>
</StackPanel>        <StackPanel Orientation="Vertical" Margin="0">
<CheckBox Content="Windows Subsystem for Linux" FontSize="15" Margin="5,8,0,15" Tag="" Style="{StaticResource ToggleSwitchStyle}" Name="WindowsSubsystemforLinux" ToolTip="Windows Subsystem for Linux is an optional feature of Windows that allows Linux programs to run natively on Windows without the need for a separate virtual machine or dual booting"/>
</StackPanel>        <StackPanel Orientation="Vertical" Margin="0">
<CheckBox Content="HyperV Virtualization" FontSize="15" Margin="5,8,0,15" Tag="" Style="{StaticResource ToggleSwitchStyle}" Name="HyperVVirtualization" ToolTip="HyperV is a hardware virtualization product developed by Microsoft that allows users to create and manage virtual machines"/>
</StackPanel>        <StackPanel Orientation="Vertical" Margin="0">
<CheckBox Content="Enable Auto Tray" FontSize="15" Margin="5,8,0,15" Tag="" Style="{StaticResource ToggleSwitchStyle}" Name="EnableAutoTray" ToolTip="Enables all tray icons"/>
</StackPanel>
</ListView>
</TabItem>
</TabControl>
<Grid Row="2">
<Grid.ColumnDefinitions>
<ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/>
</Grid.ColumnDefinitions>
<Grid Column="0">
<Button Name="installBtn" FontWeight="SemiBold" VerticalAlignment="Center" Width="144" Height="40" Margin="8">
<TextBlock>
<Run Text="  " FontFamily="Segoe MDL2 Assets"/>
<Run Text="{Binding INSTALL, TargetNullValue=INSTALL}"/>
</TextBlock>
</Button>
<Button Name="applyBtn" Visibility="Collapsed" FontWeight="SemiBold" VerticalAlignment="Center" Width="144" Height="40" Margin="8">
<TextBlock >
<Run Text="  " FontFamily="Segoe MDL2 Assets"/>
<Run Text="{Binding Apply, TargetNullValue=Apply}"/>
</TextBlock>
</Button>
</Grid>
<Grid Column="1" VerticalAlignment="Center" HorizontalAlignment="Left">
<TextBlock Name="statusbar" Text="{Binding Welcome, TargetNullValue=Save time and install all your programs at once and debloat Windows and more. Be part of ITT and contribute to improving it}" Foreground="{DynamicResource PrimaryTextColor}" Padding="15" Width="Auto"
HorizontalAlignment="Left" VerticalAlignment="Center" TextWrapping="Wrap"/>
</Grid>
</Grid>
<Popup x:Name="AboutPopup"
AllowsTransparency="True"
Placement="Center"
StaysOpen="false"
PopupAnimation="Fade"
IsOpen="false">
<Border Background="{DynamicResource PrimaryBackgroundColor}"
BorderBrush="{DynamicResource BorderBrushColor}"
BorderThickness="2"
Width="533" Height="400"
Padding="8"
CornerRadius="8"
SnapsToDevicePixels="True">
<Grid>
<Grid.ColumnDefinitions>
<ColumnDefinition Width="222"/>
<ColumnDefinition Width="*"/>
</Grid.ColumnDefinitions>
<Grid Grid.Column="0">
<StackPanel Orientation="Vertical" Margin="0,25,0,0">
<TextBlock Text="itt"
FontSize="80" FontFamily="Arial" FontWeight="Bold"
HorizontalAlignment="Center" Foreground="{DynamicResource logo}"/>
<TextBlock Text="Install Tweaks Tool"
FontSize="13" FontFamily="Arial" FontWeight="SemiBold"
HorizontalAlignment="Center" Foreground="{DynamicResource PrimaryTextColor}"/>
<TextBlock Text="9/30/2025" Name="ver" Margin="0,5,0,0"
FontSize="12" FontFamily="Arial" FontWeight="Regular"
HorizontalAlignment="Center" TextAlignment="Left" Foreground="{DynamicResource PrimaryTextColor}"/>
<TextBlock Text="Contributors"
FontSize="13" FontFamily="Arial"
Foreground="{DynamicResource PrimaryTextColor}" HorizontalAlignment="Center" Margin="0,15,0,0"/>
<ScrollViewer VerticalScrollBarVisibility="Auto" Margin="0,15,0,0" Height="170">
<StackPanel Orientation="Vertical" Margin="15,0,0,0">
<TextBlock Text="emadadeldev" Margin="1" Foreground="{DynamicResource PrimaryTextColor}" />
<TextBlock Text="youssefmhd" Margin="1" Foreground="{DynamicResource PrimaryTextColor}" />
</StackPanel>
</ScrollViewer>
</StackPanel>
</Grid>
<StackPanel Orientation="Vertical" Grid.Column="1" Margin="8" VerticalAlignment="Center">
<Border Name="github" Style="{StaticResource HighlightBorder}">
<StackPanel Orientation="Vertical">
<TextBlock Text="🛠 Source code"
FontSize="16" FontFamily="Segoe UI" Foreground="{DynamicResource PrimaryTextColor}"/>
<TextBlock Text="Browse the full project on GitHub" Margin="0,2,0,0"
FontSize="12" FontFamily="Segoe UI" Foreground="{DynamicResource PrimaryTextColor}"/>
</StackPanel>
</Border>
<Border Name="translate" Style="{StaticResource HighlightBorder}">
<StackPanel Orientation="Vertical">
<TextBlock Text="🌍 Help to translate"
FontSize="16" FontFamily="Segoe UI" Foreground="{DynamicResource PrimaryTextColor}"/>
<TextBlock Text="Contribute your language to the project" Margin="0,2,0,0"
FontSize="12" FontFamily="Segoe UI" Foreground="{DynamicResource PrimaryTextColor}"/>
</StackPanel>
</Border>
<Border Name="community" Style="{StaticResource HighlightBorder}">
<StackPanel Orientation="Vertical">
<TextBlock Text="💬 Community chat"
FontSize="16" FontFamily="Segoe UI" Foreground="{DynamicResource PrimaryTextColor}"/>
<TextBlock Text="Join our group and stay connected" Margin="0,2,0,0"
FontSize="12" FontFamily="Segoe UI" Foreground="{DynamicResource PrimaryTextColor}"/>
</StackPanel>
</Border>
<Border Name="feedback" Style="{StaticResource HighlightBorder}">
<StackPanel Orientation="Vertical">
<TextBlock Text="📝 Feedback"
FontSize="16" FontFamily="Segoe UI" Foreground="{DynamicResource PrimaryTextColor}"/>
<TextBlock Text="Suggestions, or bug reports" TextWrapping="Wrap" Margin="0,2,0,0"
FontSize="12" FontFamily="Segoe UI" Foreground="{DynamicResource PrimaryTextColor}"/>
</StackPanel>
</Border>
<Border Name="donate" Style="{StaticResource HighlightBorder}">
<StackPanel Orientation="Vertical">
<TextBlock Text="❤ Donate"
FontSize="16" FontFamily="Segoe UI" Foreground="{DynamicResource PrimaryTextColor}"/>
<TextBlock Text="Be listed as one of our contributors" Margin="0,2,0,0"
FontSize="12" FontFamily="Segoe UI" Foreground="{DynamicResource PrimaryTextColor}"/>
</StackPanel>
</Border>
</StackPanel>
</Grid>
</Border>
</Popup>
</Grid>
</Window>
"@
$MaxThreads = [int]$env:NUMBER_OF_PROCESSORS
$HashVars = New-Object System.Management.Automation.Runspaces.SessionStateVariableEntry `
-ArgumentList 'itt', $itt, $null
$InitialSessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
$InitialSessionState.Variables.Add($HashVars)
$Functions = @(
'Install-App', 'Install-Dependencies', 'Install-Winget', 'Add-Log', 'Finish', 'Message',
'Notify', 'UpdateUI', 'ExecuteCommand', 'Set-Registry', 'Set-Taskbar',
'Refresh-Explorer', 'CreateRestorePoint', 'Set-Statusbar'
)
foreach ($Func in $Functions) {
$Command = Get-Command $Func -ErrorAction SilentlyContinue
if ($Command) {
$InitialSessionState.Commands.Add(
(New-Object System.Management.Automation.Runspaces.SessionStateFunctionEntry `
$Command.Name, $Command.ScriptBlock.ToString())
)
}
}
$itt.Runspace = [RunspaceFactory]::CreateRunspacePool(
1, $MaxThreads, $InitialSessionState, $Host
)
$itt.Runspace.Open()
try {
[xml]$MainXaml = $MainWindowXaml
$itt["window"] = [Windows.Markup.XamlReader]::Load([System.Xml.XmlNodeReader]$MainXaml)
}
catch {
Write-Output "Error initializing UI: $($_.Exception.Message)"
}
$itt.CurrentList
$itt.CurrentCategory
$itt.TabControl = $itt["window"].FindName("taps")
$itt.AppsListView = $itt["window"].FindName("AppsListView")
$itt.TweaksListView = $itt["window"].FindName("TweaksListView")
$itt.searchInput = $itt["window"].FindName("searchInput")
$itt.SettingsListView = $itt["window"].FindName("SettingsList")
$itt.Description = $itt["window"].FindName("description")
$itt.Statusbar = $itt["window"].FindName("statusbar")
$itt.InstallBtn = $itt["window"].FindName("installBtn")
$itt.ApplyBtn = $itt["window"].FindName("applyBtn")
$itt.installText = $itt["window"].FindName("installText")
$itt.installIcon = $itt["window"].FindName("installIcon")
$itt.applyText = $itt["window"].FindName("applyText")
$itt.applyIcon = $itt["window"].FindName("applyIcon")
$itt.QuoteIcon = $itt["window"].FindName("QuoteIcon")
try {
$appsTheme = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme"
$fullCulture = Get-ItemPropertyValue -Path "HKCU:\Control Panel\International" -Name "LocaleName"
$shortCulture = $fullCulture.Split('-')[0]
if (-not (Test-Path $itt.registryPath)) {
New-Item -Path $itt.registryPath -Force | Out-Null
Set-ItemProperty -Path $itt.registryPath -Name "Theme" -Value "default" -Force
Set-ItemProperty -Path $itt.registryPath -Name "locales" -Value "default" -Force
Set-ItemProperty -Path $itt.registryPath -Name "backup" -Value 0 -Force
Set-ItemProperty -Path $itt.registryPath -Name "source" -Value "auto" -Force
$itt['window'].FindName('hotdot').Visibility = [System.Windows.Visibility]::Visible
}
else {
$itt['window'].FindName('hotdot').Visibility = [System.Windows.Visibility]::Hidden
}
try {
$itt.Theme = (Get-ItemProperty -Path $itt.registryPath -Name "Theme" -ErrorAction Stop).Theme
$itt.Locales = (Get-ItemProperty -Path $itt.registryPath -Name "locales" -ErrorAction Stop).locales
$itt.backup = (Get-ItemProperty -Path $itt.registryPath -Name "backup" -ErrorAction Stop).backup
$itt.PackgeManager = (Get-ItemProperty -Path $itt.registryPath -Name "source" -ErrorAction Stop).source
}
catch {
New-ItemProperty -Path $itt.registryPath -Name "Theme" -Value "default" -PropertyType String -Force *> $Null
New-ItemProperty -Path $itt.registryPath -Name "locales" -Value "default" -PropertyType String -Force *> $Null
New-ItemProperty -Path $itt.registryPath -Name "backup" -Value 0 -PropertyType DWORD -Force *> $Null
New-ItemProperty -Path $itt.registryPath -Name "source" -Value "auto" -PropertyType String -Force *> $Null
}
$h = [System.Net.Http.HttpClientHandler]::new()
$h.AutomaticDecompression = [System.Net.DecompressionMethods] 'GZip,Deflate'
$c = [System.Net.Http.HttpClient]::new($h)
$appsUrl = "https://raw.githubusercontent.com/emadadeldev/ittea/refs/heads/main/static/Database/Applications.json"
$tweaksUrl = "https://raw.githubusercontent.com/emadadeldev/ittea/refs/heads/main/static/Database/Tweaks.json"
while ($true) {
try {
$aTask, $tTask = $c.GetStringAsync($appsUrl), $c.GetStringAsync($tweaksUrl)
[Threading.Tasks.Task]::WaitAll($aTask, $tTask)
$appsData = $aTask.Result | ConvertFrom-Json
$tweaksData = $tTask.Result | ConvertFrom-Json
if ($appsData -and $tweaksData) {
$itt.AppsListView.ItemsSource = $appsData
$itt.TweaksListView.ItemsSource = $tweaksData
$splash.Close()
break
}
else {
Write-Host "Still loading data..." -ForegroundColor Yellow
}
}
catch {
Write-Host "Unstable internet connection detected. Retrying in 10 seconds..." -ForegroundColor Yellow
}
Start-Sleep 10
}
try {
$Locales = switch ($itt.Locales) {
"default" {
switch ($shortCulture) {
"ar" {"ar"}
"de" {"de"}
"en" {"en"}
"es" {"es"}
"fr" {"fr"}
"hi" {"hi"}
"it" {"it"}
"ko" {"ko"}
"ru" {"ru"}
"tr" {"tr"}
"zh" {"zh"}
default { "en" }
}
}
"ar" {"ar"}
"de" {"de"}
"en" {"en"}
"es" {"es"}
"fr" {"fr"}
"hi" {"hi"}
"it" {"it"}
"ko" {"ko"}
"ru" {"ru"}
"tr" {"tr"}
"zh" {"zh"}
default { "en" }
}
$itt["window"].DataContext = $itt.database.locales.Controls.$Locales
$itt.Language = $Locales
}
catch {
$itt["window"].DataContext = $itt.database.locales.Controls.en
}
try {
$Themes = switch ($itt.Theme) {
"Dark" {"Dark"}
"DarkKnight" {"DarkKnight"}
"Light" {"Light"}
"Palestine" {"Palestine"}
default {
switch ($appsTheme) {
"0" {
"Dark"
Set-ItemProperty -Path $itt.registryPath -Name "Theme" -Value "default" -Force
}
"1" {
"Light"
Set-ItemProperty -Path $itt.registryPath -Name "Theme" -Value "default" -Force
}
}
}
}
$itt["window"].Resources.MergedDictionaries.Add($itt["window"].FindResource($Themes))
$itt.Theme = $Themes
}
catch {
$fallback = switch ($appsTheme) {
"0" { "Dark" }
"1" { "Light" }
}
Set-ItemProperty -Path $itt.registryPath -Name "Theme" -Value "default" -Force
$itt["window"].Resources.MergedDictionaries.Add($itt["window"].FindResource($fallback))
$itt.Theme = $fallback
}
$itt["window"].title = "Install Tweaks Tool | Emad Adel"
$itt["window"].TaskbarItemInfo = New-Object System.Windows.Shell.TaskbarItemInfo
if (-not $Debug) { Set-Taskbar -progress "None" -icon "logo" }
}
catch {
Write-Output "Error: $_"
}
$MainXaml.SelectNodes("//*[@Name]") | ForEach-Object {
$name = $_.Name
$element = $itt["window"].FindName($name)
if ($element) {
$itt[$name] = $element
$type = $element.GetType().Name
switch ($type) {
"Button" { $element.Add_Click({ Invoke-Button $this.Name $this.Content }) }
"MenuItem" { $element.Add_Click({ Invoke-Button $this.Name -Content $this.Header }) }
"TextBox" { $element.Add_TextChanged({ Invoke-Button $this.Name $this.Text }) }
"TextBlock" { $element.Add_MouseLeftButtonDown({ Invoke-Button $this.Name $this.Text }) }
"ComboBox" { $element.add_SelectionChanged({ Invoke-Button $this.Name $this.SelectedItem.Content }) }
"TabControl" {
$element.add_SelectionChanged({ Invoke-Button $this.Name $this.SelectedItem.Name })
ChangeTap
}
"CheckBox" {
$element.IsChecked = Get-ToggleStatus -ToggleSwitch $name
$element.Add_Click({ Invoke-Toggle $this.Name })
}
"Border" {
$element.Add_MouseLeftButtonDown({ Invoke-Button $this.Name $this.Text })
}
}
}
}
$onClosingEvent = {
param($s, $c)
$result = Message -key "Exit_msg" -icon "ask" -action "YesNo"
if ($result -eq "Yes") {
$itt.runspace.Dispose()
$itt.runspace.Close()
$script:powershell.Dispose()
$script:powershell.Stop()
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
}
else {
$c.Cancel = $true
}
}
$itt["window"].Add_ContentRendered({
Startup
Show-Event
})
$itt["window"].add_Closing($onClosingEvent)
$itt["window"].Add_PreViewKeyDown($KeyEvents)
$itt["window"].Activate() | Out-Null
$itt["window"].ShowDialog() | Out-Null
$itt.runspace.Dispose()
$itt.runspace.Close()
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
$script:powershell.Dispose()
$script:powershell.Stop()
Stop-Transcript *> $null
