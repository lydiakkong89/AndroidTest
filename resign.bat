@ECHO OFF
 REM key�����ƣ�key�ļ���Ҫ���ں�bat�ļ�ͬһĿ¼��
 SET KEYSTORE_NAME=debug.keystore
 REM key�ı���
 SET KEYSTORE_ALIAS=androiddebugkey
 REM key������
 SET KEYSTORE_STOREPASS=android
 SET KEYSTORE_KEYPASS=android
 REM ��ʱ���ɵ�apk�ļ�����
 SET TEMP_PREFIX=temp_
 SET TEMP_RESIGNER=resigner_
 FOR %%I IN (*.apk) DO (
     ECHO Resigner %%I
     REM *****BUILD A FOLDER WITH THE SAME NAME.
     ECHO BUILD A FOLDER WITH THE SAME NAME.
  REM ����һ���ļ��У�����֮ǰ���������Ҫ��ɾ��
  RD /S /Q %%I_
     MD %%I_
  REM ������Ҫ����ǩ����apk�ļ��Լ�debugkey���µ��ļ�����
     COPY %%I %%I_
  COPY %KEYSTORE_NAME% %%I_
     CD %%I_
     REM ��ѹ��APK�ļ�
     JAR -xvf %%I
     REM ɾ�����Ƶ����ļ����е�APK�ļ�
     DEL %%I
     REM ɾ��MANIFEST
     RD /S /Q META-INF
      
     ECHO RECOMPRESS THE APK
     REM ����ѹ����apk�ļ�
     JAR -cvf %TEMP_PREFIX%%%I -C ./ .
  
  ECHO JARSIGNER %%I
     REM ��jar������ǩ��������ǩ�����������ɾ���ļ�֮ǰ���������ɾ���ļ�������Ҫ���벻Ҫ��debug.keyɾ����
     JARSIGNER -VERBOSE -KEYSTORE %KEYSTORE_NAME% -STOREPASS %KEYSTORE_STOREPASS% %TEMP_PREFIX%%%I %KEYSTORE_ALIAS% -KEYPASS %KEYSTORE_KEYPASS%
  
     REM ɾ����ѹ�������ļ���
     REM *****CLEAR FOLDER
     FOR /D %%J IN (*) DO (
         ECHO DELETE FOLDER %%J
         RD /S /Q %%J
     )
     REM *ɾ����ѹ�������ļ���ǩ����APK�ļ���Ҫ����
     FOR %%J IN (*) DO (
         IF %%J NEQ %TEMP_PREFIX%%%I (
             ECHO DELETE FILE %%J
             DEL %%J
         )
     )
    
     ECHO ZIPALIGN %%I
     REM ʹ��android��zipalign���߶�apk�ļ������Ż�
     ZIPALIGN -v 4 %TEMP_PREFIX%%%I %TEMP_RESIGNER%%%I
     REM ���apk�ļ��Ƿ��Ż�
     ZIPALIGN -c -v 4 %TEMP_RESIGNER%%%I
     ECHO DELETE TEMP APK
     REM ɾ���Ż�ǰ��APK�ļ��������Ż����APK
     DEL %TEMP_PREFIX%%%I
     CD ..
 )
 PAUSE
 @ECHO ON