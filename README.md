# NetOpsKube Portal Authentication

A lightweight Flask-based authentication service used for protecting NetOpsKube portal applications through NGINX Ingress external authentication.

## Overview

This service provides a simple login page and session-based authentication mechanism for applications exposed through Kubernetes Ingress.

The application is designed to work with the NGINX Ingress Controller using:

- `nginx.ingress.kubernetes.io/auth-url`
- `nginx.ingress.kubernetes.io/auth-signin`

annotations.

---

# Authentication Flow

1. User accesses the protected application URL.

2. NGINX Ingress sends an authentication request to:

```text
/auth
```

3. If the authentication cookie is missing or invalid:
   - the auth service returns `401 Unauthorized`
   - NGINX redirects the user to:

```text
/login
```

4. User submits username and password through the login page.

5. Flask validates the credentials using environment variables injected from Kubernetes Secrets.

6. On successful login:
   - an authentication cookie is created
   - the user is redirected back to the originally requested URL

7. Future requests containing the cookie are allowed by the `/auth` endpoint.


# Kubernetes Secret Integration

Credentials are not hardcoded inside the application.

The Flask service reads credentials from Kubernetes Secrets through environment variables:

```python
PORTAL_USERNAME
PORTAL_PASSWORD
```

# Container Build

The application container includes:

- Flask application (`app.py`)
- HTML login template (`templates/login.html`)
- Python dependencies (`requirements.txt`)


# Tech Stack

- Python
- Flask
- Kubernetes
- NGINX Ingress Controller
- Docker