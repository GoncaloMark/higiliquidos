import requests
import os
import time

GRAPHQL_URL = os.getenv("SALEOR_URL", "http://saleor-api.higiliquidos.svc.cluster.local/graphql/")
EMAIL = os.getenv("SUPERUSER_EMAIL", "admin@higiliquidos.com")
PASSWORD = os.getenv("SUPERUSER_PASSWORD", "admin")

login_payload = {
    "query": """
    mutation TokenCreate($email: String!, $password: String!) {
        tokenCreate(email: $email, password: $password) {
            token
            errors {
                field
                message
            }
        }
    }
    """,
    "variables": {
        "email": EMAIL,
        "password": PASSWORD
    }
}

response = requests.post(GRAPHQL_URL, json=login_payload)
data = response.json()

if "errors" in data or data.get("data", {}).get("tokenCreate", {}).get("token") is None:
    print("Login failed:", data)
    exit(1)

access_token = data["data"]["tokenCreate"]["token"]
print("Access token retrieved:", access_token)

headers = {
    "Authorization": f"Bearer {access_token}",
    "Content-Type": "application/json"
}

install_payload = {
    "operationName": "AppInstall",
    "variables": {
        "input": {
            "appName": "Dummy Payment App",
            "manifestUrl": "http://payments-api.higiliquidos.svc.cluster.local/api/manifest",
            "permissions": [
                "HANDLE_PAYMENTS",
                "MANAGE_CHECKOUTS",
                "MANAGE_ORDERS"
            ]
        }
    },
    "query": """
    mutation AppInstall($input: AppInstallInput!) {
        appInstall(input: $input) {
            appInstallation {
                id
                status
                appName
                manifestUrl
                __typename
            }
            errors {
                ...AppError
                __typename
            }
            __typename
        }
    }

    fragment AppError on AppError {
        field
        message
        code
        permissions
        __typename
    }
    """
}

install_response = requests.post(GRAPHQL_URL, json=install_payload, headers=headers)
install_data = install_response.json()
print("Install response:", install_response.status_code)
print(install_data)

if "errors" in install_data or not install_data.get("data", {}).get("appInstall", {}).get("appInstallation"):
    print("App installation failed:", install_data)
    exit(1)

app_installation = install_data["data"]["appInstall"]["appInstallation"]
app_id = app_installation["id"]
app_name = app_installation["appName"]

print(f"App installation initiated for '{app_name}' with ID: {app_id}")

check_status_query = {
    "query": """
    query GetAppsInstallations {
        appsInstallations {
            id
            status
            appName
            manifestUrl
            __typename
        }
    }
    """
}

max_wait_time = 300  # 5 minutes 
check_interval = 5   # Check every 5 seconds
elapsed_time = 0

print("Waiting for app installation to complete...")

while elapsed_time < max_wait_time:
    status_response = requests.post(GRAPHQL_URL, json=check_status_query, headers=headers)
    status_data = status_response.json()
    
    if "errors" in status_data:
        print("Error checking status:", status_data)
        break
    
    target_installation = None
    installations = status_data.get("data", {}).get("appsInstallations", [])
    
    for installation in installations:
        if installation["id"] == app_id:
            target_installation = installation
            break
    
    if not target_installation:
        print(f"Could not find app installation with ID: {app_id}")
        break
    
    installation_status = target_installation.get("status")
    
    print(f"Current status: {installation_status}")
    
    if installation_status == "INSTALLED":
        print(f"App '{app_name}' successfully installed!")
        break
    elif installation_status == "FAILED":
        print(f"App installation failed for '{app_name}', attempting retry...")
        
        # Retry installation
        retry_payload = {
            "query": """
            mutation AppRetryInstall($id: ID!) {
                appRetryInstall(id: $id) {
                    appErrors {
                        field
                        message
                        code
                        __typename
                    }
                    appInstallation {
                        id
                        status
                        __typename
                    }
                    __typename
                }
            }
            """,
            "variables": {
                "id": app_id
            }
        }
        
        retry_response = requests.post(GRAPHQL_URL, json=retry_payload, headers=headers)
        retry_data = retry_response.json()
        
        if "errors" in retry_data or retry_data.get("data", {}).get("appRetryInstall", {}).get("appErrors"):
            print("Failed to retry app installation:", retry_data)
            exit(1)
        
        retry_installation = retry_data.get("data", {}).get("appRetryInstall", {}).get("appInstallation")
        if retry_installation:
            print(f"Retry initiated, new status: {retry_installation.get('status')}")
        
        time.sleep(check_interval)
        elapsed_time += check_interval
    elif installation_status == "PENDING":
        print(f"App installation still pending... (waited {elapsed_time}s)")
        time.sleep(check_interval)
        elapsed_time += check_interval
    else:
        print(f"Unknown status: {installation_status}")
        time.sleep(check_interval)
        elapsed_time += check_interval

if elapsed_time >= max_wait_time:
    print(f"Timeout: App installation did not complete within {max_wait_time} seconds")
    exit(1)

get_apps_query = {
    "query": """
    query GetApps {
        apps(first: 5) {
            edges {
                node {
                    id
                    name
                    isActive
                    __typename
                }
            }
        }
    }
    """
}

apps_response = requests.post(GRAPHQL_URL, json=get_apps_query, headers=headers)
apps_data = apps_response.json()

if "errors" in apps_data:
    print("Error fetching apps:", apps_data)
    exit(1)

target_app = None
for edge in apps_data.get("data", {}).get("apps", {}).get("edges", []):
    app = edge["node"]
    if app["name"] == app_name:
        target_app = app
        break

if not target_app:
    print(f"Could not find installed app '{app_name}'")
    exit(1)

print(f"Found app: {target_app['name']} (ID: {target_app['id']}, Active: {target_app['isActive']})")

if not target_app["isActive"]:
    print("App is not active, activating...")
    
    activate_payload = {
        "query": """
        mutation AppActivate($id: ID!) {
            appActivate(id: $id) {
                app {
                    id
                    name
                    isActive
                    __typename
                }
                errors {
                    field
                    message
                    code
                    __typename
                }
                __typename
            }
        }
        """,
        "variables": {
            "id": target_app["id"]
        }
    }
    
    activate_response = requests.post(GRAPHQL_URL, json=activate_payload, headers=headers)
    activate_data = activate_response.json()
    
    if "errors" in activate_data or activate_data.get("data", {}).get("appActivate", {}).get("errors"):
        print("Failed to activate app:", activate_data)
        exit(1)
    
    activated_app = activate_data["data"]["appActivate"]["app"]
    print(f"App '{activated_app['name']}' activated successfully! (Active: {activated_app['isActive']})")
else:
    print(f"App '{target_app['name']}' is already active!")

print("App installation and activation completed successfully!")