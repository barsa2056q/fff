@echo off
REM Gradle wrapper batch file (Windows)
setlocal
set DIRNAME=%~dp0
set CLASSPATH=%DIRNAME%gradle\wrapper\gradle-wrapper.jar
if not exist "%CLASSPATH%" (
  echo Gradle wrapper JAR not found: %CLASSPATH%
  echo You can generate wrapper files by running: gradle wrapper
  exit /b 1
)
if defined JAVA_HOME (
  set JAVACMD=%JAVA_HOME%\bin\java.exe
) else (
  set JAVACMD=java
)
set DEFAULT_JVM_OPTS=-Xmx1024m
"%JAVACMD%" %DEFAULT_JVM_OPTS% -classpath "%CLASSPATH%" org.gradle.wrapper.GradleWrapperMain %*
endlocal