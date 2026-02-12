# Perfect Scene Creator - Setup Guide

## Prerequisites
This project requires **Node.js** to run. 

### 1. Install Node.js
1. Download and install Node.js (LTS version) from [https://nodejs.org/](https://nodejs.org/).
2. Verify installation by opening a terminal (PowerShell or CMD) and running:
   ```bash
   node -v
   npm -v
   ```

## Installation

### 1. Backend Setup
Open a terminal in the `server` directory and install dependencies:
```bash
cd e:\Programa\server
npm install
```

### 2. Frontend Setup
Open a terminal in the `client` directory and install dependencies:
```bash
cd e:\Programa\client
npm install
```

## Running the Application

### 1. Start the Backend
In the `server` terminal:
```bash
npm start
```
*The server will run on `http://localhost:3000`*

### 2. Start the Frontend
In the `client` terminal:
```bash
npm run dev
```
*The application will be accessible at `http://localhost:5173` (or similar)*

## Configuration
- **Gemini API Key**: Already configured in `server/.env`.
- **Nanobana Pro API**: Currently using a placeholder. To enable, update `NANOBANA_API_KEY` in `server/.env`.
