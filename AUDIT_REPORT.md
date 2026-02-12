# Professional DevOps & Architecture Audit

## 1. Local Run Map
Follow these steps to set up the application on a fresh machine.

| Step | Scope | Command | Purpose |
| :--- | :--- | :--- | :--- |
| **1** | System | `node -v` | Ensure Node.js (v18+) is installed. |
| **2** | Backend | `cd server && npm install` | Install server dependencies. |
| **3** | Frontend | `cd ../client && npm install` | Install client dependencies. |
| **4** | Config | `cp .env.example .env` (in /server) | Initialize local environment variables. |
| **5** | Build | `cd ../client && npm run build` | Generate production frontend assets. |
| **6** | Run | `cd ../server && node server.js` | Start the unified server on port 3000. |
| **7** | Verify | Navigate to `http://localhost:3000` | Confirm the application is running. |

## 2. Environment Variables & Secrets Audit
All variables are loaded via `dotenv` in the `server` directory.

| VAR_NAME | Required? | Default | Where Used | Purpose | Example Value |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `GEMINI_API_KEY` | **YES** | None | `geminiService.js`, `nanobanaService.js` | Auth for Google AI Services | `AIzaSy...` |
| `PORT` | NO | 3000 | `server.js` | Server listener port | `3000` |

### Secret Hygiene Score: 8/10
- ✅ `.env` is NOT in the repo (good).
- ✅ Keys are not hardcoded in the main logic (using process.env).
- ⚠️ **Improvement**: Add validation to fail-fast if `GEMINI_API_KEY` is missing or in wrong format.

## 3. API Configuration Verification

### Integration: Google Gemini (Text & Image)
- **Base URL**: `https://generativelanguage.googleapis.com/v1beta/`
- **Auth Method**: API Key via Query Parameter (`?key=...`)
- **Models**: `gemini-2.5-pro` (Text), `gemini-3-pro-image-preview` (Image).
- **Critical Risk**: Image generation can exceed 30s. Missing explicit Axios timeouts.
- **Critical Risk**: `nanobanaService.js` uses `v1beta`. Ensure the provided key has preview access.

## 4. Required Fixes (Hardening)

### Fix A: Axios Timeouts & Resilience
Current implementation lacks timeouts. For image generation, we need at least 60s.

```diff
// server/nanobanaService.js
- const response = await axios.post(API_URL, payload, {
-     headers: { 'Content-Type': 'application/json' }
- });
+ const response = await axios.post(API_URL, payload, {
+     headers: { 'Content-Type': 'application/json' },
+     timeout: 90000 // 90 second timeout for image rendering
+ });
```

### Fix B: Filename Sanitization
`server.js` currently uses `file.originalname`.

```diff
// server/server.js
- cb(null, `${Date.now()}-${file.originalname}`);
+ const crypto = require('crypto');
+ const ext = path.extname(file.originalname);
+ const hash = crypto.createHash('md5').update(file.originalname + Date.now()).digest('hex');
+ cb(null, `${hash}${ext}`);
```

## 5. Final Checklist (Top 10 Failure Points)
1. **Missing .env**: Ensure `server/.env` exists.
2. **Invalid API Key**: Key must start with `AIza`.
3. **Billing Tier**: Image generation (`gemini-3-pro`) requires **Tier 1** in AI Studio.
4. **Build Missing**: If `client/dist` is missing, server will show 404. Run `npm run build`.
5. **Port Conflict**: If something else is on port 3000, the app won't start.
6. **Node Version**: Ensure Node.js >= 18.
7. **CORS**: Ensure `app.use(cors())` stays before routes.
8. **Relative Pathing**: Ensure `API_BASE_URL` in `App.tsx` is relative (`/api`).
9. **Internet Connectivity**: App requires access to `generativelanguage.googleapis.com`.
10. **Directory Permissions**: Ensure the `server/uploads` folder is writeable.
