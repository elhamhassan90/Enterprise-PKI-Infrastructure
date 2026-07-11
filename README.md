# Enterprise Public Key Infrastructure (PKI) with Microsoft AD CS & IIS HTTPS

## Project Overview

This project demonstrates the design and implementation of a complete Enterprise Public Key Infrastructure (PKI) using Microsoft Active Directory Certificate Services (AD CS).

The infrastructure includes an Offline Root Certification Authority, an Enterprise Subordinate (Issuing) Certification Authority, custom certificate templates, Active Directory integration, and secure HTTPS deployment for IIS web servers.

The project also demonstrates two different certificate enrollment methods:

- Manual Certificate Enrollment (CSR → Issue → Import)
- Active Directory Domain Certificate Enrollment

By implementing both methods, this project explains how certificate enrollment works internally and how enterprises issue and manage SSL/TLS certificates for internal services.


# Project Goals

- Build a complete Enterprise PKI Infrastructure
- Deploy an Offline Root Certification Authority
- Deploy an Enterprise Subordinate Certification Authority
- Configure Active Directory Certificate Services (AD CS)
- Create and Publish Custom Certificate Templates
- Secure IIS Websites using HTTPS
- Understand the complete Certificate Lifecycle
- Compare Manual Certificate Enrollment with Domain Certificate Enrollment
- Simulate a real enterprise PKI deployment

---

# Infrastructure

| Server | Hostname | IP Address | Role |
|---------|----------|-----------|------|
| DC | DC.egyptsystems.local | 192.168.100.10 | Active Directory Domain Controller & DNS |
| Root CA | ROOTCA | 192.168.100.20 | Offline Standalone Root Certification Authority |
| Issuing CA | IssuingCA.egyptsystems.local | 192.168.100.30 | Enterprise Subordinate Certification Authority |
| IIS Server | IIS.egyptsystems.local | 192.168.100.32 | IIS Web Server (Manual Certificate Enrollment) |
| IIS2 Server | IIS2.egyptsystems.local | 192.168.100.33 | IIS Web Server (Domain Certificate Enrollment) |

---

# Active Directory Information

| Item | Value |
|------|-------|
| Domain Name | egyptsystems.local |
| Forest Functional Level | Windows Server 2019 |
| DNS | Active Directory Integrated |
| Enterprise CA | egyptsystems-ISSUINGCA-CA-2 |
| Root CA | ROOTCA-CA |

---
# Core Technologies

- Windows Server 2019
- Active Directory Domain Services (AD DS)
- Active Directory Certificate Services (AD CS)
- Enterprise PKI
- Offline Root CA
- Enterprise Issuing CA
- IIS (Internet Information Services)
- SSL/TLS
- HTTPS
- Certificate Templates
- DNS
- Group Policy

# Enterprise PKI Architecture

The Enterprise PKI hierarchy consists of two Certification Authorities:

- **Offline Standalone Root Certification Authority**
- **Enterprise Subordinate (Issuing) Certification Authority**

The Root CA is responsible only for establishing trust by issuing and signing the certificate of the Enterprise Issuing CA.

To maximize security, the Root CA remains offline after the initial deployment and is powered on only when administrative tasks are required, such as renewing the Issuing CA certificate or publishing updated CRLs.

The Enterprise Issuing CA is integrated with Active Directory and is responsible for issuing certificates to domain users, computers, servers, and enterprise services.

This two-tier hierarchy is considered the Microsoft recommended PKI design for enterprise environments because it provides a strong balance between security, scalability, and manageability.

---

## Architecture Diagram

```text
                               Enterprise PKI Hierarchy


                         Offline Standalone Root CA
                      ┌──────────────────────────────┐
                      │           ROOTCA             │
                      │      192.168.100.20          │
                      │                              │
                      │  • Root of Trust             │
                      │  • Self-Signed Certificate   │
                      │  • Signs Issuing CA          │
                      │  • Normally Offline          │
                      └──────────────┬───────────────┘
                                     │
                     Signs the Subordinate CA Certificate
                                     │
                                     ▼
                  Enterprise Subordinate (Issuing) CA
                 ┌─────────────────────────────────────┐
                 │             IssuingCA               │
                 │         192.168.100.21              │
                 │                                     │
                 │ • Enterprise CA                     │
                 │ • Integrated with Active Directory  │
                 │ • Publishes Certificate Templates   │
                 │ • Issues Client & Server Certificates│
                 └─────────────────┬───────────────────┘
                                   │
          ┌────────────────────────┼────────────────────────┐
          │                        │                        │
          ▼                        ▼                        ▼
    Domain Users            Domain Computers          IIS Web Servers
                                                    (HTTPS Certificates)
```

### Trust Flow

```
Offline Root CA
        │
        ▼
Signs the Issuing CA Certificate
        │
        ▼
Enterprise Issuing CA
        │
        ▼
Issues Certificates
        │
        ▼
Users • Computers • IIS • Services
```

> **Security Note**
>
> The Root Certification Authority is kept offline after deployment. This significantly reduces the attack surface because private keys of the Root CA remain isolated from the production network.

# Certificate Enrollment Methods

One of the primary objectives of this project is to demonstrate two different approaches for requesting and deploying SSL/TLS certificates in a Microsoft Enterprise PKI environment.

Although both methods ultimately produce the same result—a trusted certificate installed on the IIS web server—the enrollment process is different.

Understanding both approaches provides a deeper understanding of how certificates are issued in real enterprise environments.

---

# Method 1 — Manual Certificate Enrollment

This method is commonly used for:

- Linux Servers
- Network Devices
- Firewalls
- Load Balancers
- Appliances
- Servers outside the Active Directory domain

In this approach, the web server generates its own private key locally and creates a Certificate Signing Request (CSR).

The CSR contains only the public key and identity information. It **does not include the private key**, which always remains securely stored on the IIS server.

The request is then submitted manually to the Enterprise Issuing CA.

After approval, the Certification Authority issues a certificate that is imported back to the same IIS server to complete the certificate installation.

## Manual Enrollment Workflow

```text
Generate Private Key
        │
        ▼
Create Certificate Request (CSR)
        │
        ▼
Submit CSR to Enterprise CA
        │
        ▼
Certificate Issued
        │
        ▼
Complete Certificate Request
        │
        ▼
HTTPS Binding
```

### Why use this method?

- The server is not domain joined.
- Manual approval is required.
- Greater administrative control.
- Common for external systems and appliances.

---

# Method 2 — Active Directory Domain Certificate Enrollment

This method is designed specifically for domain-joined Windows servers.

Instead of generating a CSR manually, IIS communicates directly with Active Directory Certificate Services.

The server authenticates using its Active Directory computer account and requests a certificate from the published Certificate Template.

If the server has the required permissions (Read + Enroll), the Enterprise Issuing CA automatically issues the certificate.

No manual CSR submission or certificate import is required.

## Domain Enrollment Workflow

```text
Create Domain Certificate
        │
        ▼
Authenticate with Active Directory
        │
        ▼
Enterprise Issuing CA
        │
        ▼
Certificate Issued Automatically
        │
        ▼
HTTPS Binding
```

### Why use this method?

- Fast deployment.
- Fully integrated with Active Directory.
- Simplified certificate management.
- Ideal for Windows enterprise environments.

---

# Manual vs Domain Enrollment

| Manual Certificate Request | Domain Certificate |
|----------------------------|-------------------|
| Requires a CSR | No CSR required |
| Manual submission | Automatic enrollment |
| Manual certificate import | Automatic installation |
| Works for any platform | Windows domain members only |
| Administrator approval may be required | Usually automatic |
| Common for Linux and appliances | Common for Windows Servers |

---

# Project Implementation

To demonstrate both enrollment methods, this project includes two IIS web servers.

| Server | Enrollment Method |
|---------|------------------|
| IIS.egyptsystems.local | Manual Certificate Request (CSR → Issue → Import) |
| IIS2.egyptsystems.local | Active Directory Domain Certificate |

Using two separate web servers allows a clear comparison between the traditional manual certificate lifecycle and Microsoft's automated enterprise certificate enrollment process.

# Technology Stack

This project combines several Microsoft infrastructure technologies to build a complete Enterprise Public Key Infrastructure (PKI) environment.

---

## Operating Systems

- Windows Server 2019 Standard

---

## Identity Services

- Active Directory Domain Services (AD DS)
- Active Directory DNS

---

## Certificate Services

- Active Directory Certificate Services (AD CS)
- Offline Standalone Root Certification Authority
- Enterprise Subordinate Certification Authority
- Certificate Templates
- Certificate Enrollment
- Certificate Revocation Lists (CRL)
- Authority Information Access (AIA)

---

## Web Services

- Internet Information Services (IIS)
- HTTP
- HTTPS
- SSL/TLS

---

## Security

- Public Key Infrastructure (PKI)
- RSA Cryptography
- X.509 Certificates
- Certificate Trust Chain
- Digital Signatures

---

## Networking

- TCP/IP
- DNS Name Resolution
- HTTP (Port 80)
- HTTPS (Port 443)

---

## Administration Tools

- Microsoft Management Console (MMC)
- Certificate Authority Console
- Certification Authority Web Enrollment
- IIS Manager
- PowerShell
- CertReq
- CertUtil

---

## Project Features

- Offline Root Certification Authority

- Enterprise Issuing Certification Authority

- Active Directory Integration

- Custom Web Server Certificate Template

- Manual Certificate Enrollment (CSR)

- Active Directory Certificate Enrollment

- IIS HTTPS Configuration

- SSL/TLS Certificate Deployment

- Complete Certificate Trust Chain

- Enterprise PKI Architecture

- Real-World Microsoft PKI Design

The following sections document the complete implementation of the Enterprise PKI environment.

Each phase includes the objective, configuration steps, verification, and screenshots to demonstrate the deployment process from start to finish.

# Project Implementation Phases

The project was implemented following the same deployment sequence commonly used in enterprise environments. Each phase builds on the previous one to create a complete Public Key Infrastructure (PKI) capable of issuing and managing digital certificates for internal services.

| Phase | Description |
|--------|-------------|
| Phase 1 | Deploy Active Directory Domain Services (AD DS) |
| Phase 2 | Deploy Offline Standalone Root Certification Authority |
| Phase 3 | Configure Root CA CDP & AIA Extensions |
| Phase 4 | Publish Root CA Certificate and CRL |
| Phase 5 | Deploy Enterprise Subordinate Issuing CA |
| Phase 6 | Issue and Complete the Subordinate CA Certificate |
| Phase 7 | Configure Issuing CA CDP & AIA Extensions |
| Phase 8 | Create Custom Web Server Certificate Template |
| Phase 9 | Configure Certificate Template Permissions |
| Phase 10 | Deploy IIS Web Server (Manual Certificate Enrollment) |
| Phase 11 | Request and Install SSL Certificate Manually |
| Phase 12 | Configure HTTPS Binding |
| Phase 13 | Deploy Second IIS Web Server |
| Phase 14 | Request Certificate using Active Directory Enrollment |
| Phase 15 | Configure HTTPS on IIS2 |
| Phase 16 | Compare Both Certificate Enrollment Methods |

---

# Implementation Guide

The following sections explain every phase of the project in the same order used during the implementation.

Each phase includes:

- The objective of the phase.
- Why this configuration is required.
- The implementation steps.
- Configuration commands.
- Verification steps.
- Screenshots of the completed configuration.

Following these phases allows the entire Enterprise PKI environment to be reproduced from scratch.

---

# Phase 1 — Deploy Active Directory Domain Services (AD DS)

## Objective

The first step was to build the Active Directory infrastructure that serves as the foundation of the entire PKI environment.

Enterprise Certification Authorities depend on Active Directory to publish certificate templates, authenticate users and computers, support automatic certificate enrollment, and manage certificate-related objects throughout the domain.

Without Active Directory, features such as Enterprise Certificate Templates and Domain Certificate Enrollment cannot be used.

---

## Server Information

| Item | Value |
|------|-------|
| Server | DC |
| Hostname | DC.egyptsystems.local |
| IP Address | 192.168.100.10 |
| Role | Active Directory Domain Controller & DNS Server |
| Domain | egyptsystems.local |

---

## Implementation

The following tasks were completed during this phase:

- Installed the Active Directory Domain Services (AD DS) role.
- Promoted the server to a Domain Controller.
- Created a new Active Directory forest.
- Configured DNS.
- Verified Active Directory functionality.
- Joined all required member servers to the domain.

---

## Verification

The deployment was verified by confirming that:

- Active Directory Users and Computers opens successfully.
- DNS Manager is working correctly.
- Domain authentication functions properly.
- Domain name resolution is successful.
- Domain-joined servers can communicate with the Domain Controller.

---
# Phase 2 — Deploy Offline Standalone Root Certification Authority

## Objective

In this phase, the Offline Root Certification Authority (Root CA) is deployed.

The Root CA is the highest level of trust in the PKI hierarchy. Its primary responsibility is to issue and sign the certificate of the Enterprise Subordinate Certification Authority.

To improve security, the Root CA remains offline most of the time and is only powered on when administrative tasks such as issuing or renewing subordinate CA certificates are required.

---

## Server Information

| Item | Value |
|------|-------|
| Server | RootCA |
| Hostname | ROOTCA |
| IP Address | 192.168.100.20 |
| Role | Offline Standalone Root Certification Authority |

---

## Why an Offline Root CA?

Keeping the Root CA offline significantly improves the security of the PKI environment.

If an Issuing CA or another server is compromised, the Root CA private key remains protected because it is not continuously connected to the network.

This design follows Microsoft PKI best practices and is commonly used in enterprise environments.

---

## Implementation

### Install Active Directory Certificate Services

Install the **Active Directory Certificate Services (AD CS)** role on the **RootCA** server.

This server will become the trusted root of the entire PKI hierarchy.

---

### Configure the Certification Authority

Configure the server as a **Standalone Root Certification Authority**.

A Standalone Root CA is independent of Active Directory and serves as the trust anchor for all certificates issued within the PKI environment.

---

## Verification

Verify that:

- The **Certification Authority** console opens successfully.
- The Root CA service is running.
- The Root CA certificate has been created successfully.

---

## Screenshots

The following screenshots show the successful deployment of the Active Directory environment.

<img width="1622" height="877" alt="image" src="https://github.com/user-attachments/assets/cfaba09d-9a84-4af7-b897-695efc996bc1" />

<img width="1612" height="916" alt="image" src="https://github.com/user-attachments/assets/d8e2aa0e-259a-49f0-818c-e7bd60228dad" />

<img width="1632" height="916" alt="image" src="https://github.com/user-attachments/assets/da5f0d62-9904-4e2e-9bbb-4df125c130c6" />

# Phase 3 — Configure Root CA CDP & AIA Extensions

## Objective

In this phase, the Certificate Revocation List (CRL) Distribution Point (CDP) and Authority Information Access (AIA) locations are configured on the Offline Root Certification Authority.

These extensions are embedded into every certificate issued by the CA. They allow clients to locate the Root CA certificate and verify whether a certificate has been revoked.

Properly configuring CDP and AIA is an essential step in building a functional and trusted PKI environment.

---

## Why is this step required?

When a client receives a certificate, it must be able to answer two important questions:

- **Who issued this certificate?**
- **Has this certificate been revoked?**

The **AIA (Authority Information Access)** extension tells clients where to download the CA certificate.

The **CDP (CRL Distribution Point)** extension tells clients where to download the latest Certificate Revocation List (CRL).

Without these extensions, certificate chain validation may fail, causing browsers and applications to reject otherwise valid certificates.

---

## Server Information

| Item | Value |
|------|-------|
| Server | RootCA |
| Hostname | ROOTCA |
| Role | Offline Standalone Root Certification Authority |

---

## Configure CDP and AIA Extensions

Run the following script to configure the CDP and AIA publication locations.

```cmd
1-SetCDP_AIA.cmd
```

### 1-SetCDP_AIA.cmd

```cmd
certutil -setreg CA\CRLPublicationURLs "1:C:\Windows\System32\CertSrv\CertEnroll\%3%8%9.crl\n2:http://pki.EgyptSystems.local/pki/%3%8%9.crl"

certutil -setreg CA\CACertPublicationURLs "2:http://pki.EgyptSystems.local/pki/%1_%3%4.crt"

net stop certsvc

net start certsvc

certutil -crl
```

---

## What does this script do?

The script performs the following tasks:

- Configures the local location where the CRL will be generated.
- Configures the HTTP location that clients will use to download the CRL.
- Configures the HTTP location that clients will use to download the Root CA certificate.
- Restarts the Active Directory Certificate Services service to apply the new configuration.
- Generates a new Certificate Revocation List (CRL).

At this stage, the Root CA is now configured to publish certificate revocation information that clients will use later during certificate validation.

---

## Verification

Verify that:

- The new CDP location has been configured successfully.
- The AIA location has been configured successfully.
- A new CRL file has been generated without errors.

---

## Screenshots

The following screenshot shows the successful configuration of the CDP and AIA extensions.

<img width="1028" height="951" alt="image" src="https://github.com/user-attachments/assets/8de6ebd5-ae03-4482-b69f-bf95cbcaa6e3" />

# Phase 4 — Publish Root CA Certificate and CRL

## Objective

In this phase, the Root CA certificate and the Certificate Revocation List (CRL) are exported and published.

These files are required because every server and client in the PKI environment must trust the Root Certification Authority before they can trust any certificates issued by the Enterprise Issuing CA.

The exported files will later be copied to the Issuing CA server to establish the trust relationship between both Certification Authorities.

---

## Why is this step required?

The Root CA is the trust anchor of the entire PKI hierarchy.

Before the Enterprise Issuing CA can begin issuing certificates, it must:

- Trust the Root CA certificate.
- Verify the Root CA's Certificate Revocation List (CRL).
- Publish the Root CA certificate inside Active Directory so that all domain-joined computers can trust it automatically.

Without this step, clients will not be able to build a valid certificate chain, causing certificate validation to fail.

---

## Server Information

| Item | Value |
|------|-------|
| Server | RootCA |
| Hostname | ROOTCA |
| Role | Offline Standalone Root Certification Authority |

---

## Export the Root CA Certificate and CRL

Run the following script to export the Root CA certificate and the Certificate Revocation List.

```cmd
2-CopyRootCert.cmd
```

### 2-CopyRootCert.cmd

```cmd
dir C:\Windows\System32\CertSrv\CertEnroll\*.cr*

pause

xcopy C:\Windows\System32\CertSrv\CertEnroll\*.cr* C:\Export
```

---

## What does this script do?

The script performs the following tasks:

- Displays the generated certificate and CRL files.
- Creates a copy of all required PKI files.
- Saves the exported files to **C:\Export** for distribution.

The exported files include:

- Root CA Certificate (.crt)
- Certificate Revocation List (.crl)

These files will be imported into the Enterprise Issuing CA during the next phase.

---

## Verification

Verify that the following files exist in:

```text
C:\Export
```

Example:

```text
RootCA_ROOTCA-CA.crt

ROOTCA-CA.crl
```

---

## Copy the exported files

Copy the exported files from:

```text
RootCA

C:\Export
```

to:

```text
IssuingCA

C:\Import
```

These files will be used during the installation of the Enterprise Subordinate Certification Authority.

---

## Publish the Root CA Certificate

Log on to the **IssuingCA** server and run the following script to publish the Root CA certificate and import it into the local certificate stores.

```cmd
3-DistRootCert.cmd
```

### 3-DistRootCert.cmd

```cmd
certutil -dspublish -f C:\Import\RootCA_ROOTCA-CA.crt RootCA

certutil -addstore -f Root C:\Import\RootCA_ROOTCA-CA.crt

certutil -addstore -f CA C:\Import\RootCA_ROOTCA-CA.crt

certutil -addstore -f CA C:\Import\ROOTCA-CA.crl

pause
```

---

## What does this script do?

This script prepares the Enterprise PKI environment by:

- Publishing the Root CA certificate to Active Directory.
- Adding the Root CA certificate to the Trusted Root Certification Authorities store.
- Adding the Root CA certificate to the Intermediate Certification Authorities store.
- Importing the latest Certificate Revocation List (CRL).

After completing these tasks, the Issuing CA server fully trusts the Offline Root CA and is ready to receive its own CA certificate.

---

## Verification

Verify that:

- The Root CA certificate has been successfully published.
- The Root CA certificate appears in the Trusted Root Certification Authorities store.
- The CRL has been imported successfully.
- No errors are displayed during execution.

---

## Screenshots

The following screenshots show the successful export and publication of the Root CA certificate and CRL.

<img width="1337" height="921" alt="image" src="https://github.com/user-attachments/assets/982a18d5-c843-4143-8b92-d9c02deec1fd" />


# Phase 5 — Deploy Enterprise Subordinate Issuing CA

## Objective

In this phase, the Enterprise Subordinate Certification Authority (Issuing CA) is deployed.

Unlike the Offline Root CA, the Issuing CA is responsible for issuing certificates to users, computers, web servers, and services throughout the enterprise.

Instead of creating its own self-signed CA certificate, the Issuing CA generates a Certificate Signing Request (CSR) that must be signed by the Offline Root CA. This establishes the trust relationship between the two Certification Authorities.

---

## Why is this step required?

Following Microsoft PKI best practices, the Root CA should never issue certificates directly to users or servers.

Instead:

- The **Offline Root CA** only signs subordinate Certification Authorities.
- The **Enterprise Issuing CA** handles all day-to-day certificate issuance.

This design keeps the Root CA protected while allowing certificate services to remain available inside the enterprise.

---

## Server Information

| Item | Value |
|------|-------|
| Server | IssuingCA |
| Hostname | IssuingCA.egyptsystems.local |
| IP Address | 192.168.100.30 |
| Role | Enterprise Subordinate Certification Authority |

---

## Install Active Directory Certificate Services

Install the **Active Directory Certificate Services (AD CS)** role on the **IssuingCA** server.

This server will later become the Enterprise Certification Authority responsible for issuing certificates across the domain.

---

## Configure the Certification Authority

Configure the server as an **Enterprise Subordinate Certification Authority**.

During the configuration wizard:

- Select **Enterprise CA**.
- Select **Subordinate CA**.
- Generate a new private key.
- Complete the wizard until Windows asks for the parent CA certificate.

Since the Root CA is offline, the certificate cannot be issued immediately.

Instead, the wizard generates a **Certificate Signing Request (CSR)**.

---

## Generate the Certificate Request

Save the generated Certificate Signing Request (.req) to a file.

This request contains:

- The Issuing CA public key.
- The Issuing CA identity.
- Information required by the Root CA to issue the subordinate certificate.

The private key **never leaves the Issuing CA server**.

Only the request file is sent to the Root CA.

---

## Verification

Verify that:

- The configuration wizard completes successfully.
- A Certificate Request (.req) file is generated.
- The request file is saved successfully.

---

## Screenshots

The following screenshot shows the successful configuration of the Enterprise Subordinate Certification Authority.

<img width="1630" height="917" alt="image" src="https://github.com/user-attachments/assets/6f650512-3bb6-4054-9438-53e878d65f82" />

---

## Copy the Certificate Request

Copy the generated request file from the **IssuingCA** server to the **RootCA** server.

The Offline Root CA will use this request to issue the Enterprise Subordinate CA certificate during the next phase.

---

### End of Phase 5

At this point:

- ✅ The Enterprise Issuing CA has been installed.
- ✅ A new private key has been created.
- ✅ A Certificate Signing Request (CSR) has been generated.
- ✅ The request is ready to be signed by the Offline Root CA.

The next phase will complete the trust relationship by issuing the Subordinate CA certificate from the Root CA.

# Phase 6 — Issue and Complete the Subordinate CA Certificate

## Objective

In this phase, the Offline Root Certification Authority signs the Certificate Signing Request (CSR) generated by the Enterprise Issuing CA.

Once the request is approved, the issued certificate is transferred back to the Issuing CA to complete its installation.

This step establishes the trust relationship between the Root CA and the Enterprise Issuing CA.

---

## Why is this step required?

When the Enterprise Issuing CA was installed, it generated only a Certificate Signing Request (CSR).

At this point, the Issuing CA has:

- A private key.
- A public key inside the request file.

However, it is **not yet a trusted Certification Authority**.

The Offline Root CA must review the request and issue a CA certificate before the Issuing CA can begin issuing certificates to domain resources.

---

## Server Information

| Item | Value |
|------|-------|
| Server | RootCA |
| Hostname | ROOTCA |
| Role | Offline Standalone Root Certification Authority |

---

## Submit the Certificate Request

Copy the Certificate Request (.req) file from the **IssuingCA** server to the **RootCA** server.

Open **Windows PowerShell** on the RootCA server and submit the request.

```powershell
certreq -submit IssuingCA.EgyptSystems.local_IssuingCA.req
```

This command sends the Certificate Signing Request to the Offline Root CA for approval.

---

## Screenshots

<img width="1507" height="916" alt="image" src="https://github.com/user-attachments/assets/71fd96d6-4a06-4451-89d3-63629e848751" />

---

## Approve the Certificate Request

Open the **Certification Authority** console.

Navigate to:

```text
Pending Requests
```

Locate the request submitted by the **IssuingCA** server.

Right-click the request and select:

```text
All Tasks
    └── Issue
```

Once approved, the request is automatically moved to:

```text
Issued Certificates
```

This means the Offline Root CA has signed the Enterprise Issuing CA certificate.

---

## Screenshots

<img width="1632" height="878" alt="image" src="https://github.com/user-attachments/assets/1791051a-938d-443c-a2bf-bc86ddbce751" />

---

## Retrieve the Issued Certificate

Still on the **RootCA** server, retrieve the issued certificate by using its Request ID.

```powershell
certreq -retrieve 3 C:\IssuingCA.EgyptSystems.local_IssuingCA.crt
```

> **Important**
>
> The Request ID shown above (**3**) is only an example.
>
> Always use the Request ID assigned by your Certification Authority.

This command exports the signed CA certificate to a file.

---

## Screenshots

<img width="1240" height="920" alt="image" src="https://github.com/user-attachments/assets/1ff14dcb-48cf-44bb-88e1-9c8453d8fc7a" />

---

## Copy the Issued Certificate

Copy the generated certificate:

```text
IssuingCA.EgyptSystems.local_IssuingCA.crt
```

from the **RootCA** server to the **IssuingCA** server.

Place the certificate inside:

```text
C:\PKI
```

---

## Complete the Issuing CA Installation

Return to the **IssuingCA** server.

Complete the Certification Authority configuration by selecting the certificate issued by the Offline Root CA.

Once the installation finishes successfully, the Enterprise Issuing CA becomes operational and is ready to issue certificates for users, computers, and services.

---

## Verification

Verify that:

- The Issuing CA configuration completes successfully.
- The Certification Authority service starts without errors.
- The Enterprise Issuing CA console opens successfully.
- The CA certificate is installed correctly.

---

## Screenshots

<img width="1527" height="921" alt="image" src="https://github.com/user-attachments/assets/2a277e0d-cd95-4f94-b26f-0f17eac58d65" />

<img width="1326" height="923" alt="image" src="https://github.com/user-attachments/assets/4592dee2-130e-4d85-8819-b5a53ffa3f53" />

<img width="1286" height="922" alt="image" src="https://github.com/user-attachments/assets/e8fba6a6-0821-452a-81ac-6056da1c623b" />

---

## Phase Summary

At the end of this phase:

- The Offline Root CA has successfully signed the Enterprise Issuing CA.
- The trust relationship between both Certification Authorities has been established.
- The Enterprise Issuing CA is now fully operational.
- The PKI infrastructure is ready to issue certificates to enterprise resources.

# Phase 7 — Configure Issuing CA CDP & AIA Extensions

## Objective

After the Enterprise Issuing Certification Authority has been installed and its certificate has been issued by the Root CA, the next step is to configure the locations where clients can retrieve:

- The Certification Authority certificate (AIA)
- The Certificate Revocation List (CRL)

Publishing these locations allows domain computers and web browsers to validate every certificate issued by the Enterprise CA.

---

## Why is this required?

Whenever a client receives a certificate, it performs two important checks:

- Who issued this certificate?
- Has this certificate been revoked?

The answers are stored inside every issued certificate as AIA and CDP extensions.

Without properly configuring these extensions, certificate validation may fail.

---

## Server Information

| Item | Value |
|------|-------|
| Server | IssuingCA |
| Hostname | IssuingCA.egyptsystems.local |
| Role | Enterprise Subordinate Certification Authority |

---

## Step 1

Configure the CDP and AIA publication locations.

Run the following script.

```cmd
4-SetCDP_AIA.cmd
```

```cmd
certutil -setreg CA\CRLPublicationURLs "1:C:\Windows\System32\CertSrv\CertEnroll\%3%8%9.crl\n2:http://pki.EgyptSystems.local/pki/%3%8%9.crl"

certutil -setreg CA\CACertPublicationURLs "1:C:\Windows\System32\CertSrv\CertEnroll\%1_%3%4.crt\n2:http://pki.EgyptSystems.local/pki/%1_%3%4.crt"

net stop certsvc

net start certsvc

certutil -crl
```

### What does this script do?

- Configures where the Issuing CA publishes its Certificate Revocation List (CRL).
- Configures where clients can download the Issuing CA certificate (AIA).
- Restarts the Certificate Services service.
- Generates a new CRL using the updated configuration.

---

## Step 2

Verify that the new CRL and CA certificate were successfully generated.

Open the following folder:

```text
C:\Windows\System32\CertSrv\CertEnroll
```

You should find:

- Issuing CA Certificate (.crt)
- Certificate Revocation List (.crl)

These files will later be published to the HTTP PKI location.

---

## Verification

The configuration is considered successful when:

- The Certificate Services service starts successfully.
- A new CRL is generated.
- The CA certificate is available in the CertEnroll folder.
- No errors are reported by CertUtil.

---

## Screenshots

> The following screenshots demonstrate the successful configuration of the Issuing CA CDP and AIA extensions.

<img width="1160" height="917" alt="image" src="https://github.com/user-attachments/assets/95abc0bd-672d-4231-a43f-33e9809bf946" />

<img width="1152" height="920" alt="image" src="https://github.com/user-attachments/assets/eb495d38-557e-4d73-a4a3-68739d86f061" />


# Phase 8 — Create Custom Web Server Certificate Template

## Objective

In this phase, a custom certificate template is created for IIS web servers.

Instead of using the default **Web Server** template provided by Microsoft, a new template is duplicated and customized specifically for the EgyptSystems environment.

Creating a separate template allows administrators to control exactly who can request certificates and what settings those certificates should use without modifying Microsoft's built-in templates.

---

## Why create a custom template?

Microsoft provides several default certificate templates such as:

- Web Server
- User
- Computer
- Domain Controller

Although these templates can be used directly, modifying them is not recommended.

Instead, enterprise environments duplicate the default template and customize the copy.

This approach provides several advantages:

- The original Microsoft template remains unchanged.
- Permissions can be configured independently.
- Certificate settings can be customized without affecting other services.
- Future changes become easier to manage.

---

## Server Information

| Item | Value |
|------|-------|
| Server | IssuingCA |
| Role | Enterprise Certification Authority |

---

## Step 1
Open the **Certification Authority** console.

Navigate to:

```text
Certificate Templates
```

Right-click:

```text
Manage
```

This opens the Certificate Templates Management Console.

---

## Step 2

Locate the default template:

```text
Web Server
```

Right-click the template and select:

```text
Duplicate Template
```

A new template will be created based on the Microsoft Web Server template.

 ###### **OR**  On IssuingCA server from run "certtmpl.msc" --> choose web server and duplicate template 

---

## Step 3

Configure the General tab.

Rename the template.

Example:

```text
_EGYPTSYSTEMSWebServer
```

This makes it easy to identify certificates that belong to the EgyptSystems PKI.

---

## Step 4

Review the remaining template settings.

The duplicated template already contains the required settings for SSL/TLS certificates, including:

- Server Authentication
- Key Usage
- Enhanced Key Usage
- Cryptographic settings

Since these defaults are appropriate for IIS web servers, no additional changes are required at this stage.

---

## Step 5

Click **OK** to save the new template.

At this point, the template exists in Active Directory but is **not yet available** for certificate enrollment.

It must first be published by the Enterprise Certification Authority.

---

## Step 6

Return to the **Certification Authority** console.

Expand:

```text
Certificate Templates
```

Right-click:

```text
Certificate Templates

│

└── New

      │

      └── Certificate Template to Issue
```

---

## Step 7

Select the newly created template.

Example:

```text
_EGYPTSYSTEMSWebServer
```

Click:

```text
OK
```

The template is now published by the Enterprise Certification Authority.

From this point onward, authorized computers and users can request certificates based on this template.

---

## Verification

Verify that the template appears under:

```text
Certificate Templates
```

inside the Certification Authority console.

Its presence confirms that the Enterprise CA is ready to issue Web Server certificates using the custom template.

---

## Screenshots

> The following screenshots demonstrate the creation and publication of the custom Web Server certificate template.
<img width="1632" height="878" alt="image" src="https://github.com/user-attachments/assets/cfab2e3c-f7f7-4b8f-b746-c8c9bdc8bddb" />

<img width="1632" height="878" alt="image" src="https://github.com/user-attachments/assets/3ec6da24-0588-43c3-8f1e-dcac9d8d53b8" />

<img width="1625" height="912" alt="image" src="https://github.com/user-attachments/assets/57cbc8d3-d40e-40c9-b83f-bf52c1c5d46c" />

<img width="1632" height="878" alt="image" src="https://github.com/user-attachments/assets/82326f9b-cab2-442e-9e25-e7c9fb51d698" />

<img width="1632" height="878" alt="image" src="https://github.com/user-attachments/assets/e4e2e8f2-33fc-4e34-8799-07baad72727c" />

<img width="1277" height="917" alt="image" src="https://github.com/user-attachments/assets/d1cda517-b182-4731-8cda-adbc43d84dfa" />


# Phase 9 — Configure Certificate Template Permissions

## Objective

After creating and publishing the custom certificate template, the next step is to define which users or computers are allowed to request certificates from the Enterprise Certification Authority.

Without the appropriate permissions, the certificate template will either:

- Not appear during certificate enrollment.
- Be unavailable for IIS.
- Cause the certificate request to fail.

---

## Why is this required?

Publishing a certificate template makes it available on the Certification Authority.

However, publishing alone is not enough.

The Certification Authority also checks whether the requesting computer or user has permission to use that template.

Only accounts with the appropriate permissions can enroll for certificates.

---

## Server Information

| Item | Value |
|------|-------|
| Server | IssuingCA |
| Role | Enterprise Certification Authority |

---

## Step 1

Open the **Certificate Templates Console**.

Navigate to:

```text
Certificate Templates

│

└── Manage
```

Locate the custom template:

```text
_EGYPTSYSTEMSWebServer
```

Right-click the template and select:

```text
Properties
```

---

## Step 2

Open the **Security** tab.

This tab determines who is allowed to request certificates using this template.

---

## Step 3

Add the following security principal:

```text
Domain Computers
```

> In the beginning of this project, the IIS computer account was added directly.
>
> Later, it was replaced with **Domain Computers**, which is the recommended approach because it allows any authorized domain-joined web server to request certificates without modifying the template again.

---

## Step 4

Grant the following permissions:

```text
✔ Read

✔ Enroll

✔ Autoenroll
```

These permissions allow domain computers to:

- View the template.
- Request certificates.
- Automatically enroll for certificates when applicable.

---

## Why use Domain Computers instead of IIS$?

Initially, the template permissions were assigned directly to the IIS server computer account.

Example:

```text
IIS$
```

While this works correctly, it limits the template to a single server.

Using the **Domain Computers** group is more scalable and reflects how certificate templates are typically configured in enterprise environments.

This approach allows any authorized domain-joined server to request certificates using the same template.

---

## Step 5

Click:

```text
Apply
```

Then click:

```text
OK
```

The template is now ready to issue certificates to authorized domain computers.

---

## Verification

Verify that:

- The **Domain Computers** group appears in the Security tab.
- The permissions **Read**, **Enroll**, and **Autoenroll** are granted.
- No permission errors are displayed.

After this step, IIS servers can successfully request certificates using the custom template.

---

## Screenshots

> The following screenshots demonstrate the security configuration of the custom certificate template.

<img width="1612" height="923" alt="image" src="https://github.com/user-attachments/assets/acf6a4bf-7b35-4cdd-8098-91e9d8efae88" />

<img width="1237" height="927" alt="image" src="https://github.com/user-attachments/assets/5c71feef-04a3-48ea-b871-fab32feb32a4" />

<img width="1632" height="878" alt="image" src="https://github.com/user-attachments/assets/fcc7dfdd-1bc3-4904-a7bc-23049570a2ab" />

# Phase 10 — Deploy IIS Web Server (Manual Certificate Enrollment)

## Objective

In this phase, the first IIS web server is deployed and configured to host an internal website.

Before securing the website with HTTPS, it is important to verify that the website is working correctly over HTTP.

This server will use the **Manual Certificate Enrollment** method, which helps demonstrate how SSL/TLS certificates are requested and installed manually in enterprise environments.

---

## Why deploy the IIS server first?

Before requesting an SSL/TLS certificate, the web server itself must already be operational.

The typical deployment sequence is:

```text
Install IIS

↓

Deploy Website

↓

Verify HTTP Access

↓

Request SSL Certificate

↓

Enable HTTPS
```

This ensures that any connectivity issues are resolved before introducing certificate-related configurations.

---

## Server Information

| Item | Value |
|------|-------|
| Server | IIS |
| Hostname | IIS.egyptsystems.local |
| IP Address | 192.168.100.32 |
| Role | IIS Web Server |
| Enrollment Method | Manual Certificate Enrollment |

---

## Step 1

Install the **Web Server (IIS)** role.

After the installation completes, verify that IIS Manager opens successfully.

---

## Step 2

Create a simple website.

The website can contain a basic HTML page that will be used to verify both HTTP and HTTPS connectivity throughout the project.

---

## Step 3

Verify DNS name resolution.

Open a browser and navigate to:

```text
http://iis.egyptsystems.local
```

The website should open successfully using HTTP.

At this stage, HTTPS has **not** been configured yet.

---

## Why test HTTP first?

Testing HTTP confirms that:

- IIS is installed correctly.
- The website is running.
- DNS resolution is working.
- Network connectivity is functioning properly.

If HTTP does not work, there is no point in troubleshooting HTTPS until the basic web service is operational.

---

## Verification

The deployment is considered successful when:

- IIS Manager opens successfully.
- The website is accessible over HTTP.
- DNS resolves **iis.egyptsystems.local** correctly.
- No SSL certificate is installed yet.

---

## Screenshots

> The following screenshots demonstrate the successful deployment of the IIS web server and website before enabling HTTPS.

Befoe Installing Certificate, It opens Http and doesn't open https

<img width="1610" height="917" alt="image" src="https://github.com/user-attachments/assets/ca330858-f568-480f-9f42-8b1305853a31" />

<img width="1633" height="917" alt="image" src="https://github.com/user-attachments/assets/5cde8804-bf8b-47a9-80e2-8a0de7f7ddf7" />


# Phase 11 — Request and Install SSL Certificate Manually

## Objective

In this phase, the first IIS web server requests an SSL/TLS certificate using the **Manual Certificate Enrollment** method.

Unlike Active Directory Certificate Enrollment, this approach requires the administrator to manually generate a Certificate Signing Request (CSR), submit it to the Enterprise Certification Authority, retrieve the issued certificate, and complete the installation on the IIS server.

This phase demonstrates the complete lifecycle of an SSL certificate in a typical enterprise environment.

---

## Why use Manual Certificate Enrollment?

Manual enrollment is commonly used when:

- The server is not joined to Active Directory.
- Certificates are issued by an external or third-party Certification Authority.
- Full administrator control over the enrollment process is required.
- Automatic enrollment is unavailable.

Most importantly, it demonstrates how the **private key never leaves the IIS server**.

---

## Server Information

| Item | Value |
|------|-------|
| Server | IIS |
| Hostname | IIS.egyptsystems.local |
| IP Address | 192.168.100.32 |
| Enrollment Method | Manual Certificate Enrollment |

---

# Step 1

Open **Internet Information Services (IIS) Manager**.

Select the server.

Open:

```text
Server Certificates
```

Click:

```text
Create Certificate Request...
```

---

## What happens when clicking "Create Certificate Request"?

At this stage IIS does **not** communicate with the Certification Authority.

Instead IIS performs two local operations:

- Generates a new Private Key.
- Creates a Certificate Signing Request (CSR).

The CSR contains:

- Server identity
- Public Key
- Organization information

The private key remains securely stored on the IIS server.

---

# Step 2

Enter the certificate information.

Example:

```text
Common Name (CN):
IIS.EGYPTSYSTEMS.LOCAL

Organization:
EGYPTSYSTEMS

Organizational Unit:
IT

City:
IT

State:
IT

Country:
EG
```

Click **Next**.

---

# Step 3

Choose the cryptographic provider.

Example:

```text
Microsoft RSA SChannel Cryptographic Provider
```

Key Length:

```text
2048
```

Click **Next**.

---

# Step 4

Save the Certificate Signing Request.

Example:

```text
C:\IIS_Request.req
```

---

## Verification

The IIS server has now generated:

- Private Key
- Certificate Signing Request (.req)

Only the CSR file will be sent to the Certification Authority.

---

# Step 5

Copy the CSR file from the IIS server to the Enterprise Certification Authority.

```text
Source

IIS

C:\IIS_Request.req
```

↓

```text
Destination

IssuingCA

C:\IIS_Request.req
```

---

# Step 6

Open Windows PowerShell on the **IssuingCA** server.

Submit the certificate request.

```powershell
certreq -submit C:\IIS_Request.req
```

---

## First Issue Encountered

The request failed.

```text
The request contains no certificate template information.
```

The CSR did not specify which Certificate Template should be used.

---

# Step 7

Submit the request again while specifying the Certificate Template.

```powershell
certreq -submit -attrib "CertificateTemplate:_EGYPTSYSTEMSWebServer" C:\IIS_Request.req
```

---

## Second Issue Encountered

The request failed again.

```text
The requested certificate template is not supported by this CA.
```

The template name contained an error.

After correcting the template name, the request was submitted again.

---

# Step 8

Submit the request using the correct template.

```powershell
certreq -submit -attrib "CertificateTemplate:_EGYPTSYSTEMSWebServer" C:\IIS_Request.req
```

The Enterprise Certification Authority successfully issued the certificate.

---

# Step 9

Save the issued certificate.

Example:

```text
C:\IIS_Request.cer
```

---

# Step 10

Copy the issued certificate back to the IIS server.

```text
Source

IssuingCA

C:\IIS_Request.cer
```

↓

```text
Destination

IIS

C:\IIS_Request.cer
```

---

# Step 11

Return to **IIS Manager**.

Open:

```text
Server Certificates
```

Click:

```text
Complete Certificate Request...
```

Browse to:

```text
C:\IIS_Request.cer
```

Choose:

```text
Personal
```

Click:

```text
OK
```

---

## Why use "Complete Certificate Request" instead of Import?

Initially, the certificate was imported manually.

This resulted in the following error:

```text
Certificate does not contain private key.
```

This occurred because the issued certificate contains only the public certificate.

The private key was generated earlier during **Create Certificate Request** and remained on the IIS server.

The **Complete Certificate Request** option automatically links the issued certificate with its existing private key.

---

## Verification

Run:

```powershell
certutil -store my
```

Verify that:

- The certificate appears in the Personal store.
- The Subject is:

```text
CN=IIS.EGYPTSYSTEMS.LOCAL
```

- The certificate contains a private key.

Example:

```text
Encryption test passed
```

This confirms that the SSL certificate has been installed successfully.

---

## Screenshots

> The following screenshots demonstrate the complete manual certificate enrollment process, including CSR creation, request submission, certificate issuance, copying the certificate back to IIS, and successfully completing the certificate request.

<img width="1497" height="820" alt="image" src="https://github.com/user-attachments/assets/c5837340-708f-4caf-859a-ced50ba4729b" />

<img width="1463" height="645" alt="image" src="https://github.com/user-attachments/assets/6c39a358-8a21-4d3b-9dda-f5ed360810a7" />

<img width="1597" height="788" alt="image" src="https://github.com/user-attachments/assets/4f583059-47c2-4676-98a9-42b2c0e3dbc7" />


-------------------------------------------------------------------------------------

# Phase 12 — Configure HTTPS Binding

## Objective

At this stage, the SSL certificate has already been installed on the IIS server.

However, the website is still serving traffic over HTTP because IIS has not yet been instructed to use the certificate.

In this phase, the certificate is bound to the website, enabling secure HTTPS communication.

---

## Why is HTTPS Binding required?

Installing a certificate alone does **not** secure a website.

IIS must know:

- Which website should use the certificate.
- Which certificate should be presented to clients.
- Which TCP port should listen for HTTPS traffic.

This is accomplished by creating an HTTPS Binding.

---

## Server Information

| Item | Value |
|------|-------|
| Server | IIS |
| Hostname | IIS.egyptsystems.local |
| Website | Default Web Site |
| Port | 443 |

---

# Before Configuring HTTPS

Before adding the SSL certificate, the website was accessible only through HTTP.

Example:

```text
http://iis.egyptsystems.local
```

At this point:

- HTTP worked successfully.
- HTTPS was unavailable because no SSL certificate had been assigned to the website.

---

## Step 1

Open **Internet Information Services (IIS) Manager**.

Navigate to:

```text
Sites

↓

Default Web Site
```

Click:

```text
Bindings...
```

---

## Step 2

Click:

```text
Add...
```

Configure the binding as follows:

```text
Type : https

IP Address : All Unassigned

Port : 443

Host Name : (Leave Empty)
```

---

## Step 3

Select the SSL certificate.

Example:

```text
CN=IIS.EGYPTSYSTEMS.LOCAL
```

Click:

```text
OK
```

The website is now configured to accept HTTPS connections.

---

## Step 4

Close the Bindings window.

Restart IIS if necessary.

```cmd
iisreset
```

---

## Verification

Open a browser.

Navigate to:

```text
https://iis.egyptsystems.local
```

The website should now open over HTTPS.

---

## Issue Encountered

After configuring HTTPS, modern web browsers displayed the following warning:

```text
Your connection isn't private

NET::ERR_CERT_COMMON_NAME_INVALID
```

---

## Why did this happen?

The certificate contained the following Subject:

```text
CN=IIS.EGYPTSYSTEMS.LOCAL
```

However, modern browsers validate the **Subject Alternative Name (SAN)** extension instead of relying only on the Common Name (CN).

Because the certificate was issued without a SAN entry, browsers such as Google Chrome and Microsoft Edge considered the certificate invalid, even though it had been issued by the Enterprise Certification Authority.

Interestingly, Internet Explorer accepted the certificate because older browsers still support Common Name (CN) validation.

---

## Important Note

This behavior is expected and does **not** indicate a problem with the PKI deployment.

The Enterprise PKI infrastructure is functioning correctly.

The warning appears only because modern browsers require the Subject Alternative Name (SAN) extension.

In production environments, certificate templates are typically configured to automatically include SAN values during certificate enrollment.

---

## Verification

The HTTPS configuration is considered successful when:

- The website is reachable using HTTPS.
- IIS is listening on TCP Port 443.
- The SSL certificate is correctly bound to the website.
- The browser presents the certificate issued by the Enterprise Certification Authority.

---

## Screenshots

> The following screenshots demonstrate the complete HTTPS binding configuration, including the IIS binding settings, successful HTTPS access, and the browser warning related to the missing Subject Alternative Name (SAN).

**(Keep all your screenshots here exactly as they are, including the HTTPS binding configuration and the browser warning.)**



IIS (Server Name) --> Server Certificates --> Edit Binding --> Add --> https

<img width="1460" height="922" alt="image" src="https://github.com/user-attachments/assets/8951aaf5-bc7d-4b8c-8041-76bb0bd02bb9" />

IIS (Server Name) --> Server Certificates --> SSL Setting --> Enable Require SSL

<img width="1415" height="927" alt="image" src="https://github.com/user-attachments/assets/6adf5522-eaf2-48a9-9087-2691f1d771b8" />

###### After Adding Certificate

<img width="1691" height="827" alt="image" src="https://github.com/user-attachments/assets/a2cc94b7-1318-428a-abda-6844b3961082" />


<img width="1572" height="818" alt="image" src="https://github.com/user-attachments/assets/7a0edf46-fa27-467d-8fd4-3f1adba7a5e4" />


# Phase 13 — Deploy Second IIS Web Server

## Objective

The purpose of this phase is to deploy a second IIS web server that will demonstrate **Active Directory Certificate Enrollment**.

Unlike the first IIS server, which used the manual CSR method, this server will obtain its SSL certificate directly from the Enterprise Certification Authority using Active Directory integration.

This approach is commonly used in enterprise environments because it simplifies certificate deployment and reduces administrative effort.

---

## Server Information

| Item | Value |
|------|-------|
| Server | IIS2 |
| Hostname | IIS2.egyptsystems.local |
| IP Address | 192.168.100.33 |
| Role | IIS Web Server (Domain Certificate Enrollment) |

---

## Configuration

In this phase, the following tasks were completed:

- Installed Windows Server.
- Assigned a static IP address.
- Joined the server to the **egyptsystems.local** domain.
- Installed the **Web Server (IIS)** role.
- Verified that IIS was installed successfully.
- Created a test website.
- Configured DNS to resolve **iis2.egyptsystems.local**.

At this point, the server is fully prepared to request its SSL certificate directly from the Enterprise Certification Authority in the next phase.

---

## Verification

The deployment was verified by confirming:

- The server successfully joined the Active Directory domain.
- IIS Manager opens successfully.
- The default website is accessible over HTTP.
- DNS correctly resolves **iis2.egyptsystems.local**.

---

## Screenshots

> The following screenshots demonstrate the successful deployment and configuration of the second IIS web server.

<img width="1487" height="922" alt="image" src="https://github.com/user-attachments/assets/1d5033a0-db04-40c2-842b-af5fd32eb43f" />

<img width="1472" height="927" alt="image" src="https://github.com/user-attachments/assets/d7f5c0c4-7d8d-4091-8882-42b3de79f10d" />


# Phase 14 — Request Certificate using Active Directory Enrollment

## Objective

The purpose of this phase is to request an SSL/TLS certificate directly from the Enterprise Certification Authority using **Active Directory Certificate Enrollment**.

Unlike the previous method, no Certificate Signing Request (CSR) is generated manually, and there is no need to copy files between servers or manually complete the certificate request.

Active Directory communicates with the Enterprise CA automatically, making certificate enrollment much faster and easier.

---

## Server Information

| Item | Value |
|------|-------|
| Server | IIS2 |
| Hostname | IIS2.egyptsystems.local |
| IP Address | 192.168.100.33 |
| Enrollment Method | Active Directory Certificate Enrollment |

---

## How Domain Certificate Enrollment Works

The certificate enrollment process is completed automatically through Active Directory.

The workflow is as follows:

```text
IIS2 Server
      │
      ▼
Create Domain Certificate
      │
      ▼
Active Directory
      │
      ▼
Enterprise Issuing CA
      │
      ▼
Certificate Issued Automatically
      │
      ▼
Certificate Installed in Local Computer Personal Store
```

Unlike the manual enrollment process:

- No CSR file is generated.
- No request file is copied to the CA.
- No certificate file is copied back.
- No Complete Certificate Request step is required.

The private key is generated and stored locally on the IIS2 server, while the Enterprise CA automatically issues the certificate through Active Directory.

---

# Configuration

### Step 1

Open **Internet Information Services (IIS) Manager**.

Navigate to:

```text
Server Name

└── Server Certificates
```

---

### Step 2

From the **Actions** pane, select:

```text
Create Domain Certificate
```

This option is available because:

- The server is joined to the Active Directory domain.
- An Enterprise Certification Authority is available.
- Certificate Templates have already been published.

---

### Step 3

Enter the certificate subject information.

Example:

| Field | Value |
|------|------|
| Common Name | IIS2.EGYPTSYSTEMS.LOCAL |
| Organization | EGYPTSYSTEMS |
| Organizational Unit | IT |
| City | IT |
| State | IT |
| Country | EG |

---

### Step 4

Click **Next**.

IIS will automatically contact Active Directory to retrieve all available certificate templates.

Select the custom Web Server certificate template created earlier in this project.

Example:

```text
_EGYPTSYSTEMSWebServer
```

---

### Step 5

Choose the Enterprise Certification Authority.

Example:

```text
egyptsystems-ISSUINGCA-CA-2
```

Provide a friendly name for the certificate.

Example:

```text
IIS2 SSL Certificate
```

Click **Finish**.

---

## What Happens Behind the Scenes

When **Finish** is clicked, Windows automatically performs the following operations:

1. Generates a new private key on the IIS2 server.
2. Creates the certificate request internally.
3. Sends the request to the Enterprise CA through Active Directory.
4. The Enterprise CA validates the certificate template and permissions.
5. The certificate is issued automatically.
6. Windows installs the certificate into the Local Computer Personal certificate store.
7. IIS can immediately use the certificate without any manual import.

All these operations happen automatically in just a few seconds.

---

## Verification

The deployment was verified by confirming:

- The certificate appears under **Server Certificates** in IIS.
- The certificate is stored in **Local Computer → Personal → Certificates**.
- The certificate was issued by **egyptsystems-ISSUINGCA-CA-2**.
- The certificate contains the correct subject name.
- The certificate includes its associated private key.

---

## Screenshots

> The following screenshots demonstrate the complete Active Directory certificate enrollment process.

<img width="1682" height="826" alt="image" src="https://github.com/user-attachments/assets/8b529f6e-8384-445a-9547-836d3cf19c8a" />

<img width="1498" height="810" alt="image" src="https://github.com/user-attachments/assets/f0e58af1-c084-4429-a3e0-e74097ad637f" />

<img width="1523" height="822" alt="image" src="https://github.com/user-attachments/assets/ad1b8961-c1ca-40b1-b93e-98a8a579674d" />



# Phase 15 — Configure HTTPS on IIS2

## Objective

In this phase, the SSL/TLS certificate obtained through **Active Directory Certificate Enrollment** is assigned to the IIS website.

After configuring the HTTPS binding, the website is able to serve encrypted HTTPS traffic using the certificate that was automatically issued by the Enterprise Certification Authority.

---

## Server Information

| Item | Value |
|------|-------|
| Server | IIS2 |
| Hostname | IIS2.egyptsystems.local |
| IP Address | 192.168.100.33 |
| Certificate Source | Active Directory Certificate Enrollment |

---

## Configuration

### Step 1

Open **Internet Information Services (IIS) Manager**.

Navigate to:

```text
Sites

└── Default Web Site
```

or select your website if a custom website was created.

---

### Step 2

From the **Actions** pane, click:

```text
Bindings...
```

---

### Step 3

Click:

```text
Add...
```

Configure the HTTPS binding using the following settings.

| Setting | Value |
|----------|-------|
| Type | HTTPS |
| IP Address | All Unassigned |
| Port | 443 |
| Host Name | IIS2.egyptsystems.local *(Optional)* |
| SSL Certificate | IIS2 SSL Certificate |

Click **OK**.

---

### Step 4

Close the **Site Bindings** window.

The IIS website is now configured to use the SSL certificate for HTTPS communication.

---

## Verification

Verify that the HTTPS binding has been created successfully.

Navigate to:

```text
Default Web Site

└── Bindings
```

Confirm that an HTTPS binding exists on port **443** and that the correct SSL certificate is selected.

---

### Step 5

Open a web browser and access:

```text
https://iis2.egyptsystems.local
```

The website should load successfully over HTTPS.

If the Root CA certificate is trusted by the client and the certificate Subject Name matches the URL, the browser will establish a secure TLS connection.

---

## Behind the Scenes

When the HTTPS binding is created, IIS does not copy or modify the certificate.

Instead, IIS references the certificate already stored in the **Local Computer → Personal** certificate store and uses its associated private key to perform the TLS handshake with connecting clients.

This allows all communication between the client and the web server to be encrypted using SSL/TLS.

---

## Verification Checklist

Verify the following:

- HTTPS binding exists on port **443**.
- The correct SSL certificate is selected.
- The certificate contains a private key.
- The certificate was issued by **egyptsystems-ISSUINGCA-CA-2**.
- The website opens successfully using **HTTPS**.
- The browser displays the secure connection (provided the client trusts the Root CA and the certificate name matches the URL).

---

## Screenshots

> The following screenshots demonstrate the HTTPS configuration and successful SSL deployment on the second IIS server.

<img width="1487" height="812" alt="image" src="https://github.com/user-attachments/assets/987445e6-46d7-4d0c-aacc-9ad93957dfd6" />

<img width="1682" height="805" alt="image" src="https://github.com/user-attachments/assets/f0a89abd-182a-40e3-b083-e40affe8e786" />

##### After Adding Certificate

<img width="1547" height="835" alt="image" src="https://github.com/user-attachments/assets/76e74c7b-b5ee-4cf2-a5d9-9c4b9f2e8b78" />

<img width="1226" height="787" alt="image" src="https://github.com/user-attachments/assets/ccdcd533-3e32-4971-9113-ac487b921f3f" />


# Phase 16 — Compare Both Certificate Enrollment Methods

## Objective

This project demonstrated two different approaches for deploying SSL/TLS certificates in an enterprise environment.

Although both methods produce a valid certificate issued by the Enterprise Certification Authority, the enrollment process is different.

Understanding both approaches is essential because enterprise environments may use either method depending on their security policies, infrastructure design, and operational requirements.

---

# Certificate Enrollment Workflow Comparison

## Method 1 — Manual Certificate Enrollment

```text
IIS Server
     │
     ▼
Create Certificate Request (CSR)
     │
     ▼
Copy CSR to Issuing CA
     │
     ▼
Submit Request
     │
     ▼
Certificate Issued
     │
     ▼
Copy Certificate back to IIS
     │
     ▼
Complete Certificate Request
     │
     ▼
Configure HTTPS Binding
```

---

## Method 2 — Active Directory Certificate Enrollment

```text
IIS2 Server
     │
     ▼
Create Domain Certificate
     │
     ▼
Active Directory
     │
     ▼
Enterprise Issuing CA
     │
     ▼
Certificate Issued Automatically
     │
     ▼
Certificate Installed Automatically
     │
     ▼
Configure HTTPS Binding
```

---

# Feature Comparison

| Feature | Manual Enrollment | Domain Enrollment |
|----------|-------------------|-------------------|
| Requires CSR | ✅ Yes | ❌ No |
| Copy Request File | ✅ Yes | ❌ No |
| Copy Certificate File | ✅ Yes | ❌ No |
| Manual Import | ✅ Yes | ❌ No |
| Uses Active Directory | ❌ No | ✅ Yes |
| Automatic Certificate Installation | ❌ No | ✅ Yes |
| Private Key Generated Locally | ✅ Yes | ✅ Yes |
| Enterprise CA Required | ✅ Yes | ✅ Yes |
| Administrative Effort | Higher | Lower |
| Deployment Speed | Slower | Faster |

---

# Advantages of Manual Certificate Enrollment

- Provides full control over the certificate request process.
- Can be used for standalone or non-domain servers.
- Useful when requesting certificates for external services.
- Commonly used for DMZ servers and isolated environments.

---

# Advantages of Active Directory Certificate Enrollment

- Fully integrated with Active Directory.
- No manual file transfer is required.
- No certificate import is required.
- Simplifies certificate management.
- Faster deployment.
- Reduces administrative effort.
- Scales easily across large enterprise environments.

---

# Private Key Comparison

One of the most important concepts demonstrated in this project is how the private key is handled.

### Manual Enrollment

The private key is generated locally when the Certificate Signing Request (CSR) is created.

Only the public key is included in the CSR and sent to the Certification Authority.

After the issued certificate is imported back to the IIS server, Windows associates it with the existing private key.

---

### Domain Enrollment

The private key is also generated locally on the IIS2 server.

However, Windows performs the certificate request automatically in the background through Active Directory.

After the Enterprise CA issues the certificate, Windows automatically installs it and associates it with the previously generated private key.

---

# Enterprise Recommendation

In enterprise environments, both methods are important and serve different purposes.

Manual Certificate Enrollment is typically used for:

- Standalone servers
- Non-domain joined servers
- DMZ environments
- External certificate requests

Active Directory Certificate Enrollment is typically used for:

- Domain-joined servers
- Internal web servers
- Enterprise applications
- Automated certificate deployment

---

# Project Summary

During this project, a complete Enterprise Public Key Infrastructure (PKI) was successfully designed and implemented using Microsoft Active Directory Certificate Services (AD CS).

The implementation included:

- Active Directory Domain Services (AD DS)
- Offline Standalone Root Certification Authority
- Enterprise Subordinate Issuing Certification Authority
- CDP and AIA configuration
- Root Certificate and CRL publication
- Custom Web Server Certificate Template
- Certificate Template permissions
- Manual Certificate Enrollment
- Active Directory Certificate Enrollment
- IIS HTTPS configuration
- SSL/TLS deployment on two IIS web servers

By implementing both certificate enrollment methods, this project provides a practical understanding of how SSL/TLS certificates are requested, issued, installed, and managed in enterprise environments.

---

# Conclusion

This project demonstrates the complete lifecycle of enterprise certificate management using Microsoft AD CS.

From building the PKI hierarchy to securing IIS web servers with HTTPS, every stage reflects the processes commonly used in real enterprise infrastructures.

By implementing both Manual Certificate Enrollment and Active Directory Certificate Enrollment, this project highlights not only **how** certificates are deployed, but also **why** different enrollment methods are used in different enterprise scenarios.

------------------------------------------------------------------------

## 👩‍💻 Author

**Elham Hassan**

🔧 DevOps Enthusiast | System Administrator | Automation Engineer | Cloud/DevOps Engineer

🖥️ Built and tested in a Windows Server & VMware Environment

📬 GitHub: https://github.com/elhamhassan90

🔗 LinkedIn: https://www.linkedin.com/in/elham-hasan-6b029433a

---

⭐ If you found this project useful, consider giving it a star. It helps others discover the project and supports my work.





