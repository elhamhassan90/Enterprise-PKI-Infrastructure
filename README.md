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

# Screenshots

Project screenshots will be added during each deployment phase.

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
