import requests
import os

SALEOR_URL = os.getenv("SALEOR_URL", "http://saleor-api.higiliquidos.svc.cluster.local/graphql/")
SUPERUSER_EMAIL = os.getenv("SUPERUSER_EMAIL", "admin@higiliquidos.com")
SUPERUSER_PASSWORD = os.getenv("SUPERUSER_PASSWORD", "admin")

auth_response = requests.post(SALEOR_URL, json={
    "query": """
    mutation TokenAuth($email: String!, $password: String!) {
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
        "email": SUPERUSER_EMAIL,
        "password": SUPERUSER_PASSWORD,
    }
})
token = auth_response.json()['data']['tokenCreate']['token']
headers = {"Authorization": f"Bearer {token}"}

install_response = requests.post(SALEOR_URL, json={
    "query": """
    mutation {
    appInstall(
        input: {
        appName: "Payments App"
        manifestUrl: "http://payments-api.higiliquidos.svc.cluster.local//api/manifest"
        permissions: [HANDLE_PAYMENTS]
        }
    ) {
        appInstallation {
        id
        status
        appName
        manifestUrl
        }
        appErrors {
        field
        message
        code
        permissions
        }
    }
}
    """
}, headers=headers)

print(install_response.json())
