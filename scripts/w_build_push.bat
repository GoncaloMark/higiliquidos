@echo off
setlocal enabledelayedexpansion

set "PROD_REG=k3d-higiliqs.local:12345"

REM Loop through Dockerfiles
@REM for %%F in (..\dockerfiles\Dockerfile.*) do (
@REM     for /f "tokens=2 delims= " %%A in ('findstr /b "FROM" %%F ^| more +0') do (
@REM         set "TAG=%%A"
@REM         for %%T in (!TAG!) do (
@REM             for /f "delims=/ tokens=2" %%X in ("%%T") do (
@REM                 set "from_tag=%%X"
@REM                 set "full_tag=%PROD_REG%/!from_tag!"
@REM                 echo Building %%F as !full_tag!...
@REM                 @REM docker build -f %%F -t !full_tag! .
@REM                 echo Pushing !full_tag!...
@REM                 docker push !full_tag!
@REM             )
@REM         )
@REM     )
@REM )

@REM cd ../dockerfiles
@REM docker build -f Dockerfile.postgres -t "%PROD_REG%/postgres:17-alpine" .
@REM docker push "%PROD_REG%/postgres:17-alpine"

@REM docker build -f Dockerfile.redis -t "%PROD_REG%/redis:7.0.11-alpine" .
@REM docker push "%PROD_REG%/redis:7.0.11-alpine"


@REM cd ..\repos\saleor
@REM docker build -t "%PROD_REG%/saleor:3.20.80" .
@REM docker push "%PROD_REG%/saleor:3.20.80"

@REM cd ..\saleor-dashboard
@REM docker build -t "%PROD_REG%/saleor-dashboard:3.20.34" .
@REM docker push "%PROD_REG%/saleor-dashboard:3.20.34"

cd ..\repos\dummy-payment-app
docker build -t "%PROD_REG%/dummy-payment-app:0.1.0" .
docker push "%PROD_REG%/dummy-payment-app:0.1.0"

@REM cd ..\..\scripts
@REM docker build -t "%PROD_REG%/register-payments:0.1.0" .
@REM docker push "%PROD_REG%/register-payments:0.1.0"

endlocal
