# LOCAL SETUP GUIDE

## Prerequisites
- **Node.js**: version 18.0.0 or higher.
- **Google Gemini API Key**: with Billing enabled (Tier 1).

## 1. Installation
Run the following commands in order:

```bash
# Clone the repository (if not already local)
# Install dependencies
cd server
npm install
cd ../client
npm install
```

## 2. Configuration
Create a `.env` file in the `server` directory:

```bash
cd ../server
cp .env.example .env
```
Edit the `.env` file and paste your `GEMINI_API_KEY`.

## 3. Deployment
Run the automated startup script:

```bash
cd ..
.\start_app.bat
```

## 4. Verification
Once the script finishes, open your browser at:
`http://localhost:3000`

---
*Note: The first run might take a minute as it builds the frontend static assets.*
