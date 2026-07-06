# Enterprise-PKI-Infrastructure
Enterprise-PKI-Infrastructure


# Enterprise PKI Infrastructure

A production-style Microsoft Active Directory Certificate Services (AD CS) project that demonstrates how to design, deploy, secure, and manage a complete two-tier Public Key Infrastructure (PKI) environment for enterprise organizations.

This project follows industry best practices by implementing an Offline Root Certification Authority and an Enterprise Issuing Certification Authority integrated with Active Directory. Every configuration is documented step by step to simulate a real-world enterprise deployment.

---

# Project Objectives

- Build a secure Enterprise Public Key Infrastructure (PKI)
- Deploy an Offline Standalone Root CA
- Deploy an Enterprise Issuing CA
- Integrate AD CS with Active Directory
- Configure Certificate Revocation Lists (CRL)
- Configure Authority Information Access (AIA)
- Configure CRL Distribution Points (CDP)
- Publish the Root Certificate
- Configure Certificate Templates
- Enable Certificate Auto Enrollment
- Issue certificates for Users, Computers, Servers and Services
- Configure HTTPS certificates
- Implement Certificate Renewal
- Implement Certificate Revocation
- Backup and Restore Certification Authorities
- Follow Enterprise Security Best Practices

---

# Infrastructure Overview

## Domain

```text
EgyptSystems.local
```

## Servers

| Server | Role | IP Address | Domain Joined |
|---------|------|------------|---------------|
| AD | Domain Controller | 192.168.100.10 | ✅ |
| RootCA | Offline Standalone Root Certification Authority | 192.168.100.20 | ❌ |
| IssuingCA | Enterprise Issuing Certification Authority | 192.168.100.21 | ✅ |

---

# PKI Architecture

```text
                      Offline Root CA
                          RootCA
                   192.168.100.20
                           │
                           │
                  Signs Subordinate CA
                           │
                           ▼
            Enterprise Issuing CA
                   IssuingCA
                192.168.100.21
                           │
      Issues Certificates to Enterprise Resources
                           │
       Users • Computers • Servers • Services
```

---

# Technologies

- Windows Server
- Active Directory Domain Services
- Active Directory Certificate Services (AD CS)
- DNS
- Group Policy
- PowerShell
- MMC
- PKIView
- Certification Authority Console
- Certificate Templates Console

---

# Security Features

- Offline Root Certification Authority
- Enterprise Issuing Certification Authority
- Certificate Chain Validation
- Certificate Revocation
- Private Key Protection
- Least Privilege Administration
- Backup and Recovery Strategy
- Enterprise Security Best Practices

---

# Project Implementation

- [ ] Configure Active Directory
- [ ] Configure DNS
- [ ] Configure Static IP Addresses
- [ ] Install Active Directory Certificate Services
- [ ] Configure Offline Root CA
- [ ] Configure Enterprise Issuing CA
- [ ] Publish Root Certificate
- [ ] Configure CRL Distribution Points (CDP)
- [ ] Configure Authority Information Access (AIA)
- [ ] Publish Certificate Revocation Lists
- [ ] Create Custom Certificate Templates
- [ ] Configure Certificate Auto Enrollment
- [ ] Deploy User Certificates
- [ ] Deploy Computer Certificates
- [ ] Deploy Web Server Certificates
- [ ] Configure HTTPS
- [ ] Validate Certificate Trust Chain
- [ ] Revoke Certificates
- [ ] Renew Certificates
- [ ] Backup Certification Authorities
- [ ] Restore Certification Authorities
- [ ] Validate Enterprise PKI Health

---

# Repository Structure

```text
Enterprise-PKI-Infrastructure/
│
├── README.md
├── Documentation/
├── PowerShell/
├── Screenshots/
├── Certificate-Templates/
├── Group-Policy/
├── Certificates/
├── CRL/
├── Backup/
└── Diagrams/
```

---

# Project Progress

| Component | Status |
|----------|--------|
| Active Directory | ⏳ |
| Offline Root CA | ⏳ |
| Enterprise Issuing CA | ⏳ |
| Certificate Templates | ⏳ |
| Auto Enrollment | ⏳ |
| CRL & AIA | ⏳ |
| HTTPS Certificates | ⏳ |
| Backup & Recovery | ⏳ |

---
# Phase 1 - Offline Root Certification Authority

- Install Active Directory Certificate Services (AD CS)
- Configure a Standalone Offline Root Certification Authority
- Generate the Root CA private key
- Configure the CA database location
- Configure the validity period
- Configure CDP (CRL Distribution Point)
- Configure AIA (Authority Information Access)
- Restart Certificate Services
- Export the Root CA Certificate
- Backup the Root CA Private Key
# Screenshots

Project screenshots will be added during each deployment phase.
<img width="1622" height="877" alt="image" src="https://github.com/user-attachments/assets/cfaba09d-9a84-4af7-b897-695efc996bc1" />
<img width="1612" height="916" alt="image" src="https://github.com/user-attachments/assets/d8e2aa0e-259a-49f0-818c-e7bd60228dad" />

<img width="1632" height="916" alt="image" src="https://github.com/user-attachments/assets/da5f0d62-9904-4e2e-9bbb-4df125c130c6" />


# Phase 2 - Export Root CA Files

- Export the Root CA Certificate
- Export the Certificate Revocation List (CRL)
- Copy exported files to C:\Export
- Transfer exported files to the Issuing CA



# Phase 3 - Enterprise Issuing Certification Authority

- Import the Root CA Certificate
- Trust the Root Certification Authority
- Install Active Directory Certificate Services
- Configure Enterprise Subordinate CA
- Generate the Subordinate CA Request
- Save the Request File
- Transfer the Request File to the Root CAز






# Phase 4 - Sign the Subordinate CA Request

- Submit the Request using certreq
- Approve the Pending Request
- Issue the Subordinate CA Certificate
- Copy the Issued Certificate back to the Issuing CA




# Phase 5 - Complete Enterprise Issuing CA Configuration

- Install the Issued CA Certificate
- Start Certificate Services
- Publish CRL
- Verify Certificate Chain
- Verify Enterprise PKI Health
====================================================================================================================
====================================================================================================================


# Phase 1 - Configure Offline Root Certification Authority

## Objectives

- Install the Active Directory Certificate Services (AD CS) role.
- Configure the Standalone Offline Root Certification Authority.
- Configure the Authority Information Access (AIA) and CRL Distribution Point (CDP).
- Export the Root CA certificate.
- Transfer the Root CA certificate to the Enterprise Issuing CA.

---

## Tasks

### Step 1

Install the **Active Directory Certificate Services** role on the **RootCA** server.

### Step 2

Configure the server as a **Standalone Root Certification Authority**.

### Step 3

Run the following script to configure the AIA and CDP locations.

```cmd
1-SetCDP_AIA.cmd
```
1-SetCDP_AIA.cmd
```
certutil -setreg CA\CRLPublicationURLs "1:C:\Windows\System32\CertSrv\CertEnroll\%3%8%9.crl\n2:http://pki.EgyptSystems.local/pki/%3%8%9.crl"

certutil -setreg CA\CACertPublicationURLs "2:http://pki.EgyptSystems.local/pki/%1_%3%4.crt"

net stop certsvc

net start certsvc

certutil -crl
```
### Step 4

Run the following script to export the Root CA certificate.

```cmd
2-CopyRootCert.cmd
```

The exported certificate files will be copied to:

```text
C:\Export
```

### Step 5

Copy the exported certificate files from:

```text
RootCA
C:\Export
```

to

```text
IssuingCA
C:\Import
```

---

# Phase 2 - Configure Enterprise Issuing Certification Authority

## Tasks

### Step 1

Import the Root CA certificate by running:

```cmd
3-DistRootCert.cmd
```

### Step 2

Install the **Active Directory Certificate Services** role.

### Step 3

Configure the server as an **Enterprise Subordinate Certification Authority**.

### Step 4

Save the generated certificate request to a file.

### Step 5

Copy the certificate request file to the **RootCA** server.

---

# Phase 3 - Issue the Subordinate CA Certificate

Open **Windows PowerShell** on the **RootCA** server.

Run:

```powershell
certreq -submit IssuingCA.EgyptSystems.local_IssuingCA.req
```

Approve the pending request using the **Certification Authority** console.

Issue the certificate.

Copy the issued certificate back to the **IssuingCA** server.

Complete the Enterprise Issuing CA configuration.







---




# Author

**Elham Hasan**

Microsoft Infrastructure Engineer

### Skills

- Windows Server
- Active Directory
- Active Directory Certificate Services (AD CS)
- Microsoft Azure
- PowerShell
- Linux System Administration
- Infrastructure Automation

---

# License

This project is published for educational purposes and professional portfolio demonstration.
