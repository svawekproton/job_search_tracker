# Job Search Tracker - Detailed Design Specification

## 1. Design Philosophy
The goal is to create a professional, minimalist, and highly functional interface that minimizes cognitive load during the stressful process of job hunting. The design focuses on "Actionability" and "Visibility."

## 2. Visual Identity
- **Typography:** Primary font is **Inter** (via Google Fonts or system stack). It provides excellent readability for dense data.
- **Color Palette:**
  - **Background:** `#F8F9FA` (Light Gray) - creates a soft canvas.
  - **Primary Accents:** `#0D6EFD` (Bootstrap Blue) for primary actions.
  - **Status Colors:**
    - `Applied`: Soft Blue (`#CFE2FF` bg, `#084298` text)
    - `Interviewing`: Soft Yellow/Orange (`#FFF3CD` bg, `#856404` text)
    - `Offered`: Soft Green (`#D1E7DD` bg, `#0F5132` text)
    - `Rejected`: Soft Red (`#F8D7DA` bg, `#842029` text)
    - `Withdrawn`: Neutral Gray (`#E2E3E5` bg, `#41464B` text)

## 3. Layout & Page Specifications

### A. Dashboard (The Control Center)
- **Top Metrics Row:** 4 large, borderless cards with subtle icons (using Bootstrap Icons) showing total applications, active interviews, offers, and success rate.
- **Main View (2-column):**
  - **Left (70%):** "Upcoming Interviews" list. Uses a timeline UI where each entry shows the company logo (or initial), time, and event type.
  - **Right (30%):** "Quick Stats" or "Recent Activity" feed using a condensed list group.

### B. Job Applications Index (The Pipeline)
- **Header:** Integrated search bar with "Add New Application" button as a primary CTA.
- **Filter Bar:** A horizontal button group or dropdowns for filtering by Status, Date Range, or Location.
- **Card-based List:**
  - Each job is a card (`.card`) with a hover effect (`.shadow-sm` on hover).
  - Left border of the card is color-coded based on the status.
  - Display: Company Name (H5), Position, Location, and a relative date (e.g., "Applied 2 days ago").

### C. Job Application Show Page (The Detail View)
Split-pane layout for maximum information density without clutter.
- **Left Sidebar (33%):**
  - **Company Info:** Basic metadata (URL, Location).
  - **Status Switcher:** A prominent dropdown to change status instantly via Turbo.
  - **Documents:** A dedicated section for CV and Cover Letter with "Download" and "Preview" buttons.
- **Main Content (66%):**
  - **Job Description:** Rendered via ActionText with a "Read More" toggle if too long.
  - **Tabbed Activity Interface:**
    - **Tab 1: Timeline:** Combined view of all Notes and Events in chronological order.
    - **Tab 2: Notes:** Grid of rich-text notes with category tags.
    - **Tab 3: Interview Prep:** A specialized view showing only "Question/Answer" category notes.

### D. Forms & Modals
- **Contextual Modals:** Adding a Note or Scheduling an Event happens in a Bootstrap Modal. This prevents the user from losing context of the job application they are looking at.
- **Rich Text:** Trix editor (ActionText) customized with a simplified toolbar to fit inside compact note blocks.

## 4. Interactive Components (UX)
- **Turbo Streams:** When a note is added, it slides into the timeline with a fade-in animation without a full page reload.
- **Stimulus Controllers:** - `status-updater`: Changes the card's border color and badge text immediately upon selection.
  - `clipboard`: One-click copy for the job URL or company name.
  - `file-preview`: Shows the filename and size immediately after selecting a file for upload.

## 5. Mobile Responsiveness
- **Navigation:** Bottom navigation bar for mobile users (Dashboard, Jobs, Settings).
- **Cards:** Stacked layout where the status badge moves to the top right of the card.
