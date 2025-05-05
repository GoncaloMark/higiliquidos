import requests
import os

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

# Extract token or show errors
if "errors" in data or data.get("data", {}).get("tokenCreate", {}).get("token") is None:
    print("Login failed:", data)
    exit(1)

access_token = data["data"]["tokenCreate"]["token"]
print("Access token retrieved:", access_token)

# Step 2: Install app using token
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

headers = {
    "Authorization": f"Bearer {access_token}",
    "Content-Type": "application/json"
}

install_response = requests.post(GRAPHQL_URL, json=install_payload, headers=headers)
print("Install response:", install_response.status_code)
print(install_response.json())