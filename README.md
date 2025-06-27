# 🔐 SSL Certificate Expiry Checker

A PowerShell script that checks SSL certificate expiration dates for a list of websites and sends alert emails if any are expiring soon.

---

## 📦 Features
- ✅ Check SSL expiry for any number of domains
- 📧 Send alerts via SMTP if expiry is within a set threshold
- 💾 Lightweight, no dependencies beyond PowerShell
- 🗓 Easy to schedule using Task Scheduler or cron

---

## 📂 Files

| File            | Description                            |
|-----------------|----------------------------------------|
| `Check-SSLCerts.ps1` | Main script to run the check       |
| `domains.csv`        | List of domains to monitor         |
| `config.json`        | Email settings + threshold         |


