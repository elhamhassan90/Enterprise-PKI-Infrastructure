<img width="1463" height="645" alt="image" src="https://github.com/user-attachments/assets/63edec76-d3b6-492d-8d40-e333971f5909" /># Enterprise-PKI-Infrastructure
Enterprise-PKI-Infrastructure
=========================
=========================

# Enterprise Public Key Infrastructure (PKI) with Microsoft AD CS & IIS HTTPS

## Project Overview

This project demonstrates the design and implementation of a complete Enterprise Public Key Infrastructure (PKI) using Microsoft Active Directory Certificate Services (AD CS).

The infrastructure includes an Offline Root Certification Authority, an Enterprise Subordinate (Issuing) Certification Authority, custom certificate templates, Active Directory integration, and secure HTTPS deployment for IIS web servers.

The project also demonstrates two different certificate enrollment methods:

- Manual Certificate Enrollment (CSR → Issue → Import)
- Active Directory Domain Certificate Enrollment

By implementing both methods, this project explains how certificate enrollment works internally and how enterprises issue and manage SSL/TLS certificates for internal services.

---
```
Project Overview
│
├── Project Goals
├── Infrastructure
├── Active Directory Information
├── PKI Architecture
├── Certificate Enrollment Methods
├── Technologies Used
│
├──────────────────────────────
│
├── Phase 1 - Deploy Active Directory
├── Phase 2 - Install Offline Root CA
├── Phase 3 - Install Issuing CA
├── Phase 4 - Configure Certificate Templates
├── Phase 5 - IIS Server (Manual Request)
├── Phase 6 - IIS2 Server (Domain Certificate)
├── Phase 7 - HTTPS Verification
└── Conclusion
```
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

> **Note:** Replace the IP addresses above if your environment uses different addresses.

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
# Certificate Enrollment Methods

This project demonstrates two different approaches for requesting SSL/TLS certificates.

### Method 1 — Manual Certificate Enrollment

The certificate request is generated manually from IIS.

Workflow:

Create Certificate Request (CSR)

↓

Submit Request to Enterprise CA

↓

Issue Certificate

↓

Complete Certificate Request

↓

Configure HTTPS Binding

This approach explains how IIS communicates with AD CS manually and how the private key remains on the web server during the certificate enrollment process.

---

### Method 2 — Active Directory Certificate Enrollment

The second IIS server requests its certificate directly from the Enterprise Certification Authority using Active Directory integration.

Workflow:

Create Domain Certificate

↓

Enterprise CA

↓

Certificate Issued Automatically

↓

HTTPS Binding

This method is commonly used in enterprise environments because it simplifies certificate deployment and management.

---

# Technologies Used

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


==========================
==========================
# Enterprise PKI Infrastructure




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

***The Result :
<img width="1028" height="951" alt="image" src="https://github.com/user-attachments/assets/8de6ebd5-ae03-4482-b69f-bf95cbcaa6e3" />

### Step 4

Run the following script to export the Root CA certificate.

```cmd
2-CopyRootCert.cmd
```
--------------------------------------------
```
dir C:\Windows\System32\CertSrv\CertEnroll\*.cr*
pause
xcopy C:\Windows\System32\CertSrv\CertEnroll\*.cr* c:\export
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
```
certutil -dspublish -f c:\import\RootCA_ROOTCA-CA.crt rootCA 
certutil -addstore -f root c:\import\RootCA_ROOTCA-CA.crt 
certutil -addstore -f root c:\import\ROOTCA-CA.crl
pause
```
<img width="1337" height="921" alt="image" src="https://github.com/user-attachments/assets/982a18d5-c843-4143-8b92-d9c02deec1fd" />


### Step 2

Install the **Active Directory Certificate Services** role.

### Step 3

Configure the server as an **Enterprise Subordinate Certification Authority**.
<img width="1630" height="917" alt="image" src="https://github.com/user-attachments/assets/6f650512-3bb6-4054-9438-53e878d65f82" />


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
<img width="1507" height="916" alt="image" src="https://github.com/user-attachments/assets/71fd96d6-4a06-4451-89d3-63629e848751" />

Approve the pending request using the **Certification Authority** console.
Open the **Certification Authority** console.

Navigate to:

```text
Pending Requests
```

Locate the pending request from the **IssuingCA** server.

Right-click the request and select:

```text
All Tasks
│
└── Issue
```

The request will be moved to:

```text
Issued Certificates
```


Issue the certificate.

<img width="1632" height="878" alt="image" src="https://github.com/user-attachments/assets/1791051a-938d-443c-a2bf-bc86ddbce751" />

#### Copy the issued certificate back to the **IssuingCA** server.




Retrieve the issued certificate.

Open **Windows PowerShell** and run:

```powershell
certreq -retrieve 3 C:\IssuingCA.EgyptSystems.local_IssuingCA.crt
```
<img width="1240" height="920" alt="image" src="https://github.com/user-attachments/assets/1ff14dcb-48cf-44bb-88e1-9c8453d8fc7a" />

> **Important**
>
> The value **3** is only an example.
>
> Use the actual **Request ID** assigned by your Certification Authority.

The issued certificate will be saved as:

```text
C:\IssuingCA.EgyptSystems.local_IssuingCA.crt
```

<img width="1527" height="921" alt="image" src="https://github.com/user-attachments/assets/2a277e0d-cd95-4f94-b26f-0f17eac58d65" />



Copy the issued certificate back to the IssuingCA server under C/PKI/.
Complete the Enterprise Issuing CA configuration.

<img width="1326" height="923" alt="image" src="https://github.com/user-attachments/assets/4592dee2-130e-4d85-8819-b5a53ffa3f53" />


<img width="1286" height="922" alt="image" src="https://github.com/user-attachments/assets/e8fba6a6-0821-452a-81ac-6056da1c623b" />

---

New Server And Installing IIS on it 
Befoe Installing Certificate 
It opens Http and doesn't open https

<img width="1610" height="917" alt="image" src="https://github.com/user-attachments/assets/ca330858-f568-480f-9f42-8b1305853a31" />

<img width="1633" height="917" alt="image" src="https://github.com/user-attachments/assets/5cde8804-bf8b-47a9-80e2-8a0de7f7ddf7" />

On IssuingCA server from run "certtmpl.msc"
choose web server and duplicate template 

<img width="1632" height="878" alt="image" src="https://github.com/user-attachments/assets/cfab2e3c-f7f7-4b8f-b746-c8c9bdc8bddb" />

<img width="1632" height="878" alt="image" src="https://github.com/user-attachments/assets/3ec6da24-0588-43c3-8f1e-dcac9d8d53b8" />

<img width="1625" height="912" alt="image" src="https://github.com/user-attachments/assets/57cbc8d3-d40e-40c9-b83f-bf52c1c5d46c" />

<img width="1632" height="878" alt="image" src="https://github.com/user-attachments/assets/82326f9b-cab2-442e-9e25-e7c9fb51d698" />

<img width="1632" height="878" alt="image" src="https://github.com/user-attachments/assets/e4e2e8f2-33fc-4e34-8799-07baad72727c" />

<img width="1277" height="917" alt="image" src="https://github.com/user-attachments/assets/d1cda517-b182-4731-8cda-adbc43d84dfa" />


========================================
add the server group instead of specializing IIS server or genralizing Domain Computers 

<img width="1612" height="923" alt="image" src="https://github.com/user-attachments/assets/acf6a4bf-7b35-4cdd-8098-91e9d8efae88" />

################ -xxxxxxxxxx--

<img width="1237" height="927" alt="image" src="https://github.com/user-attachments/assets/5c71feef-04a3-48ea-b871-fab32feb32a4" />


<img width="1632" height="878" alt="image" src="https://github.com/user-attachments/assets/fcc7dfdd-1bc3-4904-a7bc-23049570a2ab" />


ON IIS Server we can request certificate 

=======================================================================================================================================
=======================================================================================================================================
=======================================================================================================================================
=======================================================================================================================================

# Understanding the Certificate Enrollment Process

Before requesting a certificate, it is important to understand how the PKI environment works. Instead of memorizing steps, understand the purpose of each component.

## The Story

Imagine a company called **EgyptSystems**.

The company has an internal website:

```
http://iis.egyptsystems.local
```

The IT Manager decides that the website must use **HTTPS** instead of HTTP.

The obvious question is:

> Where does the SSL certificate come from?

The answer is:

**The Enterprise Issuing CA.**

---

# The PKI Hierarchy

Our PKI infrastructure looks like this:

```
Offline Root CA
        │
        │ Signs only one certificate
        ▼
Enterprise Issuing CA
        │
        │ Issues certificates
        ▼
Servers, Users, Computers, Websites
```

The **Root CA** is never used to issue certificates directly to servers.

Its only job is to establish trust by signing the Enterprise Issuing CA.

After that, the **Issuing CA** becomes responsible for issuing certificates to every server, computer, user, and service inside the company.

---

# Why Do We Need Certificate Templates?

Imagine three different requests arrive at the CA.

Person 1:

> I need a certificate for my IIS website.

Person 2:

> I need a certificate for VPN authentication.

Person 3:

> I need a certificate for a user smart card.

Should they all receive the same certificate?

**No.**

Each certificate has a different purpose.

That is why Active Directory Certificate Services uses **Certificate Templates**.

A Certificate Template is simply a **set of rules** that defines:

- Who is allowed to request the certificate
- What the certificate can be used for
- How long it is valid
- Which cryptographic settings will be used
- Whether approval is required before issuing it

Think of a template as a blueprint or policy—not the certificate itself.

---

# Why Duplicate the Default Web Server Template?

Microsoft provides a built-in template called:

```
Web Server
```

It is considered the default template.

Changing Microsoft's default templates is not recommended because they may be used by other services.

Instead, organizations create a copy.

Example:

```
Web Server
        │
        ▼
Duplicate
        │
        ▼
EgyptSystems Web Server
```

Now we can safely customize our own template without affecting the original one.

This is considered a best practice in enterprise environments.

---

# Why Did We Configure Security on the Template?

Many beginners think this setting identifies which server will receive the certificate.

That is NOT correct.

The Security tab controls:

> Who is allowed to REQUEST certificates from this template.

For example, if only the IIS server is granted the **Enroll** permission, then only that server can request certificates using this template.

Any other server attempting to use the template will be denied.

The Security settings protect the enrollment process—not the certificate itself.

---

# Understanding Certificate Requests

One of the most confusing topics is the difference between the available IIS options.

Let's simplify them.

---

## Option 1 — Create Certificate Request

This option only creates a **Certificate Signing Request (CSR)**.

The server performs these actions:

1. Generates a private key.
2. Generates a CSR.
3. Saves the CSR into a file.

Example:

```
server.req
```

Nothing is sent to the Certification Authority.

No certificate is issued.

This option is commonly used when requesting certificates from an external CA or when the CA is offline.

Flow:

```
IIS Server
      │
      ▼
Generate Private Key
      │
      ▼
Generate CSR
      │
      ▼
Save Request File
```

---

## Option 2 — Create Domain Certificate

This option is much smarter.

The IIS server automatically:

1. Generates the private key.
2. Generates the CSR.
3. Sends the request directly to the Enterprise Issuing CA.
4. Receives the signed certificate.
5. Installs the certificate into the local certificate store.

Everything happens automatically because the server is joined to the Active Directory domain.

Flow:

```
IIS Server
      │
      ▼
Generate Private Key
      │
      ▼
Generate CSR
      │
      ▼
Send Request to Enterprise CA
      │
      ▼
Certificate Issued
      │
      ▼
Certificate Installed
```

---

# Why Didn't My Request Appear Under Pending Requests?

Whether a request appears under **Pending Requests** depends on the Certificate Template configuration.

If the template requires **Certificate Manager Approval**, the request will wait for an administrator to approve it.

```
Request
    │
    ▼
Pending Requests
    │
Administrator Approval
    │
    ▼
Certificate Issued
```

If approval is **not required**, the Enterprise CA issues the certificate immediately.

The request never appears in Pending Requests.

This is the most common configuration in enterprise environments for internal certificates.

---

# What Does "Import Certificate" Mean?

Importing a certificate does **NOT** create a certificate.

It simply installs an existing certificate into the local certificate store.

Example:

```
server.cer
```

or

```
server.pfx
```

The certificate has already been issued.

Importing only tells Windows:

> "Store this certificate so applications can use it."

---

# Why Configure HTTPS Binding?

After the certificate is installed, IIS still doesn't know which certificate should be used by the website.

HTTPS Binding tells IIS:

> "Use THIS certificate for THIS website."

Without the HTTPS binding, the certificate exists on the server but the website will continue using HTTP.

---

# What Does SSL Settings Do?

SSL Settings are different from certificate enrollment.

These settings control how the website behaves.

For example:

- Require SSL
- Ignore SSL
- Accept Client Certificates
- Require Client Certificates

These options define the website's security policy after the certificate has already been installed.

---

# Complete Certificate Enrollment Workflow

The complete certificate lifecycle in our project is:

```
Create Certificate Template
            │
            ▼
Publish Template
            │
            ▼
IIS Server Requests Certificate
            │
            ▼
Private Key Generated Locally
            │
            ▼
CSR Generated
            │
            ▼
CSR Sent to Enterprise Issuing CA
            │
            ▼
Certificate Issued
            │
            ▼
Certificate Installed
            │
            ▼
HTTPS Binding Configured
            │
            ▼
Website Secured with HTTPS
```

Once you understand this workflow, you no longer need to memorize the steps. You understand **why** each step exists and how every component communicates with the others in a real enterprise PKI environment.


===================================================================================================================================================
===================================================================================================================================================

# Certificate Enrollment Scenarios

To better understand how certificates are requested and deployed in different environments, this project demonstrates **two certificate enrollment methods** using two separate IIS web servers.

The goal is not only to deploy SSL certificates but also to understand how each enrollment method works behind the scenes.

---

## Scenario 1 – Automatic Certificate Enrollment (Domain Integrated)


## Scenario 2 – Manual Certificate Enrollment

**Server**

- IIS (Joined to Active Directory)

**Enrollment Method**

- Create Certificate Request

**Description**

This server demonstrates the manual certificate enrollment process.

Instead of communicating directly with the Enterprise CA, IIS only generates:

- A Private Key (stored securely on the server)
- A Certificate Signing Request (CSR)

The CSR file is then manually copied to the Enterprise Issuing CA.

The Enterprise CA signs the request and generates the certificate.

The signed certificate is then manually copied back to the IIS server and imported using:

**Complete Certificate Request**

After the certificate is installed, it is bound to the IIS website to enable HTTPS.

**Purpose**

This method is commonly used when:

- The Certification Authority is offline.
- The certificate is issued by a third-party CA.
- Security policies require manual approval.
- Servers cannot communicate directly with the Enterprise CA.

---

**Server**

- IIS2 (Joined to Active Directory)

**Enrollment Method**

- Create Domain Certificate

**Description**

This server demonstrates the enterprise certificate enrollment process.

Since the server is joined to the Active Directory domain and communicates directly with the Enterprise Issuing CA, IIS automatically:

1. Generates a private key locally.
2. Creates a Certificate Signing Request (CSR).
3. Sends the request directly to the Enterprise Issuing CA.
4. Receives the signed certificate.
5. Installs the certificate into the Local Computer Certificate Store.

Finally, the certificate is bound to the IIS website to enable HTTPS.

**Purpose**

This is the method most commonly used in enterprise environments where servers are domain-joined and integrated with Active Directory Certificate Services (AD CS).

---




# Why Demonstrate Both Methods?

Understanding both enrollment methods provides a deeper understanding of how Public Key Infrastructure (PKI) operates in real enterprise environments.

The automatic enrollment method demonstrates the convenience of Active Directory integration, while the manual enrollment method explains the complete certificate lifecycle—from generating a CSR to importing the signed certificate.

By implementing both approaches, this project reflects real-world enterprise scenarios rather than focusing on a single deployment method.

============================================================================================
============================================================================================
ON IIS Befoe Installing Certificate 
It opens Http and doesn't open https

<img width="1372" height="927" alt="image" src="https://github.com/user-attachments/assets/3ab990fa-a785-478d-83ee-87c1b4399af3" />

<img width="1162" height="932" alt="image" src="https://github.com/user-attachments/assets/cf76b4fb-b5a2-4023-bec5-e5cc694d7582" />


                 IIS Server

                      │
                      │
        Create Certificate Request
                      │
                      ▼
        Generate Private Key 🔑
                      │
                      ▼
            Generate CSR (.req)
                      │
          (Nothing is sent yet)
                      │
          Copy the .req file manually
                      │
                      ▼
              Enterprise Issuing CA
                      │
            certreq -submit request
                      │
                      ▼
             Certificate Issued (.cer)



IIS (Server Name) --> Server Certificates --> Create Certificate Request --> Save File in C:\IIS_Request.req  and copy it to the IssuingCA server  

####### Steps for adding certificate on IIS Server via (Create Certificate Request)

<img width="1497" height="820" alt="image" src="https://github.com/user-attachments/assets/c5837340-708f-4caf-859a-ced50ba4729b" />

ON IssuingCA Server Execute this PowerShell Command 
```
certreq -submit -attrib "CertificateTemplate:_EGYPTSYSTEMSWebServer" C:\IIS_Request.req
```
<img width="1463" height="645" alt="image" src="https://github.com/user-attachments/assets/6c39a358-8a21-4d3b-9dda-f5ed360810a7" />

and Copy The Certificate Back to the IIS Server
IIS (Server Name) --> Server Certificates --> Complete Certificate Request --> Choose Certificate File (*.cer)

<img width="1597" height="788" alt="image" src="https://github.com/user-attachments/assets/4f583059-47c2-4676-98a9-42b2c0e3dbc7" />

IIS (Server Name) --> Server Certificates --> Edit Binding --> Add --> https

<img width="1460" height="922" alt="image" src="https://github.com/user-attachments/assets/8951aaf5-bc7d-4b8c-8041-76bb0bd02bb9" />

IIS (Server Name) --> Server Certificates --> SSL Setting --> Enable Require SSL

<img width="1415" height="927" alt="image" src="https://github.com/user-attachments/assets/6adf5522-eaf2-48a9-9087-2691f1d771b8" />

After Adding Certificate

<img width="1691" height="827" alt="image" src="https://github.com/user-attachments/assets/a2cc94b7-1318-428a-abda-6844b3961082" />


<img width="1572" height="818" alt="image" src="https://github.com/user-attachments/assets/7a0edf46-fa27-467d-8fd4-3f1adba7a5e4" />


===============================================================
===============================================================


ON IIS2 Before Installing Certificate 

<img width="1487" height="922" alt="image" src="https://github.com/user-attachments/assets/1d5033a0-db04-40c2-842b-af5fd32eb43f" />

<img width="1472" height="927" alt="image" src="https://github.com/user-attachments/assets/d7f5c0c4-7d8d-4091-8882-42b3de79f10d" />


####### Steps for adding certificate on IIS2 via (Create Domain Certificate)

IIS2 (Server Name) --> Server Certificates --> Create Domain Certificate --> Common Name: (iis2.egyptsystems.local)

<img width="1682" height="826" alt="image" src="https://github.com/user-attachments/assets/8b529f6e-8384-445a-9547-836d3cf19c8a" />

<img width="1498" height="810" alt="image" src="https://github.com/user-attachments/assets/f0e58af1-c084-4429-a3e0-e74097ad637f" />

<img width="1523" height="822" alt="image" src="https://github.com/user-attachments/assets/ad1b8961-c1ca-40b1-b93e-98a8a579674d" />

<img width="1487" height="812" alt="image" src="https://github.com/user-attachments/assets/99a4f6f7-be34-49d4-a840-03ab1ca58bec" />

IIS2 (Server Name) --> Server Certificates --> Edit Binding --> Add --> https

<img width="1487" height="812" alt="image" src="https://github.com/user-attachments/assets/987445e6-46d7-4d0c-aacc-9ad93957dfd6" />

IIS (Server Name) --> Server Certificates --> SSL Setting --> Enable Require SSL

<img width="1682" height="805" alt="image" src="https://github.com/user-attachments/assets/f0a89abd-182a-40e3-b083-e40affe8e786" />

After Adding Certificate

<img width="1547" height="835" alt="image" src="https://github.com/user-attachments/assets/76e74c7b-b5ee-4cf2-a5d9-9c4b9f2e8b78" />

<img width="1226" height="787" alt="image" src="https://github.com/user-attachments/assets/ccdcd533-3e32-4971-9113-ac487b921f3f" />



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
