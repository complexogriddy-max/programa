# System Requirements Specification (SRS) for "Perfect Scene Creator"

## 1. Project Overview
**Role:** Senior Full-Stack Architect & AI Systems Specialist
**Objective:** Architect and implement a highly specialized, local network-based web application for professional 2D scene generation.
**Core Function:** "Perfect Scene Creator" – A sequential, minimalist wizard for composing complex scenes involving custom characters (AI generated), scenarios, actions, and camera angles, integrated with Google Gemini 3 (Prompt Engineer) and "Google Nanobana Pro" (Image Generation API).

---

## 2. Technical Stack & Architecture

### 2.1 Backend (Local Network Server)
- **Runtime:** Node.js (Latest LTS) with Express or Fastify.
- **Function:**
    - Serve static frontend assets to local network devices.
    - Handle local file upload/storage (Character References, Generated Images).
    - Proxy requests to external APIs (Gemini 3, Nanobana Pro) to secure keys.
    - Maintain session state for the "Scene Wizard" flow.
- **Data Structure:** JSON-based local database (or SQLite) for storing:
    - `Characters` (ID, Name, ReferenceImagePaths, GeneratedStyleImages).
    - `Scenarios` (ID, Name, ReferenceImagePaths).
    - `Scenes` (ID, PromptData, GeneratedImagePaths, Status).

### 2.2 Frontend (Web Interface)
- **Language:** HTML5, CSS3 (SCSS/Sass pre-processor recommended), Vanilla JavaScript (ES6+ Modules) or lightweight Component Framework (e.g., React/Vue/Svelte) if state management complexity demands it. **Preference:** React + TypeScript for type safety and component modularity.
- **Styling Strategy:**
    - **Methodology:** BEM (Block Element Modifier) or CSS Modules.
    - **Responsive Design:** Mobile-first, fluid layouts using Flexbox/Grid.
    - **Theme:** Strict Minimalist "White Void".
        - **Initial State:** Entire screen is white.
        - **Interaction:** Text elements fade in sequentially. No cluttered dashboards.
        - **Typography:** Clean, sans-serif, high readability (e.g., Inter, Roboto).
- **Localization:**
    - **Interface Language:** Portuguese (pt-BR).
    - **Codebase/Comments/System Logs:** English (en-US).

---

## 3. User Interface & Workflow Logic

### 3.1 Design Philosophy: "Sequential Disclosure"
- The application must **not** overwhelm the user.
- **Avoid:** Standard dashboard layouts with sidebars/columns immediately visible.
- **Implement:** A step-by-step "Conversation" interface.
    1. Screen is blank.
    2. Question/Prompt text fades in.
    3. User interacts (Selects/Types/Uploads).
    4. Transition to next step (Smooth fade/slide).

### 3.2 Detailed Workflow Steps

#### Step 1: Character Selection
- **UI:** Display a grid of **Media Placeholders** representing the character catalog.
- **Action:** User selects a character from the visual grid.
- **Data:** System retrieves `character_id` and associated reference images.

#### Step 2: Outfit Configuration
- **System Prompt:** "Do you want to keep the outfit from the attached photo, or apply a new outfit?"
- **Option A (Keep):** Use original reference image.
- **Option B (New):**
    - **Action:** User uploads a reference image for the new outfit.
    - **Process:** Trigger "Asset Generation" via Nanobana Pro to merge Character + New Outfit -> Save new variant to Media Gallery.
- **Result:** Character is locked in for the scene.

#### Step 3: Scenario Selection
- **UI:** Display grid of **Scenario Placeholders**.
- **Action:** User selects a background/environment.

#### Step 4: Action & Props
- **System Prompt:** "What is the character doing?"
- **Input:** Text field for action description (e.g., "Running," "Eating").
- **Sub-feature:** "Add Reference Object"
    - **Action:** User can upload a reference image for specific props (e.g., a specific cup, sword, phone).
    - **Constraint:** System must track which character interacts with which prop.

#### Step 5: Camera & Composition
- **System Prompt:** "Define the camera angle and framing."
- **Input:** Options or text input (e.g., "Low angle," "Close-up," "Drone shot").

#### Step 6: Scene Grouping
- **Action:** Compile all data (Character + Outfit + Scenario + Action + Props + Angle).
- **Output:** Generate Scene 1.
- **Post-Process:** Scene 1 is saved to a "Project Folder".
- **Loop:** Interface resets for "Scene 2", preserving context if needed.

---

## 4. AI Integration & Prompt Engineering

### 4.1 Gemini 3 Integration (Prompt Refinement)
- **Role:** Taking raw user inputs (in Portuguese) and converting them into highly structured, technical English prompts for image generation.
- **Input Processing:**
    - Translate PT-BR user input to English.
    - Enhance descriptions based on context (e.g., "sitting" -> "sitting comfortably on a wooden chair, relaxed posture").
    - **Strict Formatting:** Output must be a valid JSON object.

### 4.2 Image Generation Rules (Nanobana Pro API)
- **Style Enforcer:** "SpongeBob SquarePants 2D Animation Style".
- **Strict Constraints (Negative Prompts):**
    - `NO Photorealism`
    - `NO 3D Render / CGI`
    - `NO Human skin tones / Human textures`
    - `NO Shading that implies depth/volume (Flat 2D only)`
- **Character Consistency Rules:**
    - **Facial Features:** Must retain the *identify* of the uploaded photo (Beard style, Hair style, Tattoos, scars) but rendered in SpongeBob style 2D line art.
    - **Proportions:** **CRITICAL:** Use realistic proportions relative to the uploaded photo. Do **NOT** use the exaggerated, squash-and-stretch proportions typical of the show. Characters should look fit/proportional but drawn in the show's artistic style.
    - **Clothing:** NEVER use the default outfits of SpongeBob characters (e.g., SquarePants, Patrick's shorts). Always use the User's specific outfit selection.

### 4.3 API Payload Structure (Draft)
```json
{
  "api_endpoint": "https://api.google.nanobana.pro/v1/generate",
  "method": "POST",
  "headers": {
    "Authorization": "Bearer [USER_PROVIDED_API_KEY]",
    "Content-Type": "application/json"
  },
  "body": {
    "prompt": "(Masterpiece, Best Quality, 2D Animation Style:1.5), [Subject Description in English], [Action Description], [Camera Angle], distinctive features: [List of Tattoos/Hair/Beard], wearing [Outfit Description], in [Scenario Description], flat color, thick outlines.",
    "negative_prompt": "realistic, photorealistic, 3D, CGI, render, human skin texture, human noise, shading, gradient, volumetric lighting, low quality, jpeg artifacts, text, signature, watermark, original spongebob clothes.",
    "input_image": "[BASE64_ENCODED_REFERENCE_IMAGE]",
    "control_strength": 0.85, 
    "style_preset": "spongebob_2d"
  }
}
```

---

## 5. Deployment Instructions
1.  **Initialize Project:**
    -   Create directory structure: `/client`, `/server`, `/assets`.
    -   `npm init -y` inside root.
2.  **Install Dependencies:**
    -   `npm install express cors dotenv multer axios` (Backend).
    -   `npx create-react-app client` or `npm create vite@latest client -- --template react-ts` (Frontend).
3.  **Environment Setup:**
    -   Create `.env` file for `NANOBANA_API_KEY` and `GEMINI_API_KEY`.
4.  **Run Development Server:**
    -   `npm run dev` (Concurrent backend + frontend start).
