@echo off
setlocal enabledelayedexpansion

set "PROD_REG=k3d-higiliqs.local:12345"
cd ..
set "BASE_DIR=%cd%"
@REM set "BASE_DIR=%BASE_DIR:~0,-1%"
set "DOCKERFILES_DIR=%BASE_DIR%\dockerfiles"
set "REPOS_DIR=%BASE_DIR%\repos"

echo "BASE_DIR: %BASE_DIR%"
echo "DOCKERFILES_DIR: %DOCKERFILES_DIR%"
echo "REPOS_DIR: %REPOS_DIR%"

REM Loop through Dockerfiles
echo "Building and pushing Dockerfiles from %DOCKERFILES_DIR%..."
cd %DOCKERFILES_DIR%
for %%F in (Dockerfile.*) do (
    echo "Processing %%F..."
    
    REM Check if this is Dockerfile.bckpg and set custom tag
    if "%%F"=="Dockerfile.bckpg" (
        set "from_tag=bckpg:0.1.0"
    ) else (
        REM Extract tag from the FROM line in Dockerfile
        for /f "tokens=2 delims= " %%T in ('findstr /b "FROM" "%%F"') do (
            set "from_tag=%%~nxT"
        )
    )
    
    set "full_tag=%PROD_REG%/!from_tag!"
    
    echo "Building !full_tag! from %%F..."
    docker build -f %%F -t !full_tag! .
    echo "Pushing !full_tag!..."
    docker push !full_tag!
)

echo "Building and pushing Saleor, Saleor Dashboard, Dummy Payment App, and Register Payments..."

cd %REPOS_DIR%\saleor
docker build -t "%PROD_REG%/saleor:3.20.80" .
docker push "%PROD_REG%/saleor:3.20.80"

cd %REPOS_DIR%\saleor-dashboard
docker build -t "%PROD_REG%/saleor-dashboard:3.20.34" .
docker push "%PROD_REG%/saleor-dashboard:3.20.34"

cd %REPOS_DIR%\dummy-payment-app
docker build -t "%PROD_REG%/dummy-payment-app:0.1.0" .
docker push "%PROD_REG%/dummy-payment-app:0.1.0"

cd %BASE_DIR%\scripts
docker build -t "%PROD_REG%/register-payments:0.1.0" .
docker push "%PROD_REG%/register-payments:0.1.0"

endlocal