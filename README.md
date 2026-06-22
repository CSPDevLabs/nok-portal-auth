# Keycloak \- NetOpsKube

Keycloak is used as the Identity Provider (IdP) for NetOpsKube and provides authentication and authorization through OpenID Connect (OIDC). Authentication is enforced using OAuth2 Proxy integrated with the Kubernetes NGINX Ingress Controller.


| Component | Purpose |
| :---- | :---- |
| Keycloak | Identity Provider (OIDC) |
| PostgreSQL | Persistent storage for Keycloak users, roles, groups, sessions, and realm data |
| OAuth2 Proxy | OIDC authentication proxy |
| NGINX Ingress | Protects application endpoints using OAuth2 Proxy authentication |

---

## Access Keycloak Admin Console

URL: http://keycloak.nok.local:8080/admin/master/console

Default administrator credentials are configured in keycloak-admin-secret.yaml

Username - admin

Password - admin

---

## Realm Configuration

Realm configuration is automatically imported during deployment.

Name: netopskube

---

## Session Settings

| Setting | Value |
| :---- | :---- |
| Access Token Lifespan | 5 Minutes |
| SSO Session Idle Timeout | 8 Hours |
| SSO Session Max Lifespan | 10 Hours |
| Offline Session Idle Timeout | 30 Days |
| Login Action Timeout | 30 Minutes |

### Session Behaviour

* Users remain logged in while active.
* If no activity occurs for 8 hours, the session expires.
* A session can never exceed 10 hours regardless of activity.
* Access tokens are refreshed automatically while the SSO session remains valid.
* Logout immediately terminates the Keycloak session and OAuth2 Proxy session.

---

## User Management

User accounts are created manually through the Keycloak Admin Console.

Navigation: Users → Create User

### Required Fields

* Username
* Email
* First Name
* Last Name

### Recommended User Creation Procedure

1. Create user.
2. Set password.
3. Disable temporary password option if password reset is not required.
4. Ensure no Required Actions are assigned unless explicitly needed.

---

## Password Policy

The following password policy is enforced:

* Minimum 8 characters
* At least 1 uppercase letter
* At least 1 lowercase letter
* At least 1 digit
* At least 1 special character

### Example Valid Passwords
  
Welcome@1  
NetOps#2026

---

## PostgreSQL Persistence

Keycloak uses a dedicated PostgreSQL StatefulSet.

Storage is backed by a PersistentVolumeClaim (PVC).

Data stored in PostgreSQL includes:

* Users
* Password hashes
* Roles
* Groups
* Client configuration
* Sessions
* Realm settings

### Data Retention

The following operations preserve data:

* Keycloak pod restart
* Keycloak deployment restart
* PostgreSQL pod restart
* Kubernetes node reboot
* Ubuntu server reboot

### Data Loss Scenarios

The following operations remove all Keycloak data:

* Deleting namespace nok-bng
* Deleting Keycloak PostgreSQL PVC
* Deleting Keycloak PostgreSQL PV
* Redeployment

User accounts are not restored unless they are recreated manually.

---

## Deployment

Authentication components are deployed using:

```bash
make configure-auth
```

Authentication deployment can be enabled or disabled using:

```bash
KEYCLOAK_ENABLED=YES
```

If you wish to skip Keycloak integration, just mention 'NO'.

When enabled, the following components are deployed:

* PostgreSQL
* Keycloak
* OAuth2 Proxy
* Keycloak Ingress
* OAuth2 Proxy Ingress
* Authentication annotations on application ingresses

---

## Authentication Flow

* User accesses NetOpsKube application.
* NGINX Ingress redirects unauthenticated users to OAuth2 Proxy.
* OAuth2 Proxy redirects user to Keycloak.
* User authenticates with Keycloak.
* OAuth2 Proxy establishes session.
* User gains access to the application.