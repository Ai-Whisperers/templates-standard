### 🧩 Process Manifest — Google Drive ↔ n8n Integration (Concise)

**Objective:**
Establish OAuth-based connection between Google Drive and n8n for secure file access (e.g., listing / downloading JPEGs).

---

#### **Steps**

1. **Create Google Cloud Project**

   * Go to [Google Cloud Console](https://console.cloud.google.com) → “Select project” → **New Project** → name `n8n-GoogleDrive-tutorial`.

2. **Enable API**

   * In menu: **API & Services → Library → Search “Google Drive API” → Enable**.

3. **Configure OAuth Consent Screen**

   * Type: **External**
   * App name + support email → **Create + Publish App** (required before auth).

4. **Create OAuth Credentials**

   * **API & Services → Credentials → Create Credentials → OAuth Client ID**
   * App Type: **Web Application**
   * Add **Authorized Redirect URI** = copy from n8n credentials popup.
   * Copy `Client ID` and `Client Secret`.

5. **Connect in n8n**

   * Node: **Google Drive → “Download a File”** (or other action).
   * Create New Credentials → Paste `Client ID` + `Secret` → Sign in with Google.
   * Approve unverified app → Allow scopes → Connection Success.

6. **Test Workflow**

   * Node Resource: **File / Folder** → Filter by MIME type `image/jpeg`.
   * Use Folder ID to fetch image metadata (JSON IDs + names).
   * Confirm via **Execute Step**.

---

#### **Result**

n8n can securely access Google Drive files via OAuth 2.0; verified connection; ready for automations (e.g., download images from Drive folders).

---

#### **Manifest Meta**

```yaml
integration: Google Drive ↔ n8n
auth: OAuth 2.0
api: drive.googleapis.com
scopes: https://www.googleapis.com/auth/drive.readonly
status: operational
last_verified: YYYY-MM-DD
```
