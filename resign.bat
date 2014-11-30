@ECHO OFF
 REM key的名称，key文件需要放在和bat文件同一目录下
 SET KEYSTORE_NAME=debug.keystore
 REM key的别名
 SET KEYSTORE_ALIAS=androiddebugkey
 REM key的密码
 SET KEYSTORE_STOREPASS=android
 SET KEYSTORE_KEYPASS=android
 REM 临时生成的apk文件名称
 SET TEMP_PREFIX=temp_
 SET TEMP_RESIGNER=resigner_
 FOR %%I IN (*.apk) DO (
     ECHO Resigner %%I
     REM *****BUILD A FOLDER WITH THE SAME NAME.
     ECHO BUILD A FOLDER WITH THE SAME NAME.
  REM 创建一个文件夹，创建之前如果存在需要先删除
  RD /S /Q %%I_
     MD %%I_
  REM 复制需要重新签名的apk文件以及debugkey到新的文件夹中
     COPY %%I %%I_
  COPY %KEYSTORE_NAME% %%I_
     CD %%I_
     REM 解压缩APK文件
     JAR -xvf %%I
     REM 删除复制到新文件夹中的APK文件
     DEL %%I
     REM 删除MANIFEST
     RD /S /Q META-INF
      
     ECHO RECOMPRESS THE APK
     REM 重新压缩成apk文件
     JAR -cvf %TEMP_PREFIX%%%I -C ./ .
  
  ECHO JARSIGNER %%I
     REM 对jar包重新签名，这里签名放在下面的删除文件之前，如果放在删除文件后面需要加入不要把debug.key删除掉
     JARSIGNER -VERBOSE -KEYSTORE %KEYSTORE_NAME% -STOREPASS %KEYSTORE_STOREPASS% %TEMP_PREFIX%%%I %KEYSTORE_ALIAS% -KEYPASS %KEYSTORE_KEYPASS%
  
     REM 删除解压出来的文件夹
     REM *****CLEAR FOLDER
     FOR /D %%J IN (*) DO (
         ECHO DELETE FOLDER %%J
         RD /S /Q %%J
     )
     REM *删除解压出来的文件，签名的APK文件需要保留
     FOR %%J IN (*) DO (
         IF %%J NEQ %TEMP_PREFIX%%%I (
             ECHO DELETE FILE %%J
             DEL %%J
         )
     )
    
     ECHO ZIPALIGN %%I
     REM 使用android的zipalign工具对apk文件进行优化
     ZIPALIGN -v 4 %TEMP_PREFIX%%%I %TEMP_RESIGNER%%%I
     REM 检查apk文件是否被优化
     ZIPALIGN -c -v 4 %TEMP_RESIGNER%%%I
     ECHO DELETE TEMP APK
     REM 删除优化前的APK文件，保留优化后的APK
     DEL %TEMP_PREFIX%%%I
     CD ..
 )
 PAUSE
 @ECHO ON