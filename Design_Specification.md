# Job Search Tracker - Design Specification

This document describes the current UI direction and separates implemented behavior from future design goals.

## 1. Design Philosophy

The interface should stay professional, minimal, and useful during a job search. The product favors visibility, fast status updates, and low-friction note/event capture over decorative UI.

## 2. Visual Identity

- **Typography:** The app currently relies on the configured Rails/Bootstrap font stack. Inter remains an optional future refinement.
- **Color Palette:**
  - **Background:** Light gray Bootstrap surface (`bg-light`)
  - **Primary Accents:** Bootstrap primary blue for main actions
  - **Status Colors:**
    - `Applied`: soft blue
    - `Interviewing`: soft yellow/orange
    - `Offered`: soft green
    - `Rejected`: soft red
    - `Withdrawn`: neutral gray

## 3. Implemented Layout & Pages

### Dashboard

Implemented:

- Four metric cards for total applications, active interviews, offers, and success rate.
- Upcoming interviews list based on future scheduled events.
- Recent activity list based on recently updated applications.
- Link to the application pipeline.

Future refinements:

- More detailed recent activity that includes notes and events, not only applications.
- Additional quick stats if they support repeated job-search workflow.

### Job Applications Index

Implemented:

- Header with primary new-application action.
- Search by company, position, and location.
- Status filter button group.
- Card-based application list with status-colored left border.
- Empty state when no applications match the current filters.

Future refinements:

- Date-range and location-specific filters.
- More compact controls for very large pipelines.

### Job Application Show Page

Implemented:

- Two-column desktop layout.
- Sidebar with company, position, status switcher, location, URL, applied date, and uploaded documents.
- Status badge and card border update via Stimulus before the server response.
- Clipboard copy button for the job URL.
- Main content area for the job description.
- Tabbed activity area with Timeline, Notes, and Interview Prep tabs.
- Combined timeline of notes and events.
- Modal entry points for adding notes and events.

Currently plain text:

- Job application `description` is stored as a text column and rendered with `simple_format`.

Future refinements:

- Read-more toggle for long descriptions.
- True preview actions for uploaded documents. Current document actions link to the stored file.
- Possible Action Text migration for job descriptions if rich job-description formatting is required.

### Forms & Modals

Implemented:

- Bootstrap modal forms for adding notes and events from the show page.
- Action Text rich text editor for note content.
- Plain text area for event notes.
- File-selection preview behavior for CV and cover letter fields.

Future refinements:

- More robust inline Turbo validation handling for failed modal submissions.
- Further Trix toolbar customization if note blocks become too visually dense.

## 4. Interactive Components

Implemented Stimulus controllers:

- `status-updater`: updates the visible status badge and card border color immediately.
- `clipboard`: copies the job URL.
- `file-preview`: shows selected upload filename and size.
- `modal-trigger`: opens note and event modals.

Implemented Turbo behavior:

- Successful note and event creation appends content to the relevant activity areas without a full page reload.

Future refinements:

- Animation for newly inserted timeline items.
- Improved Turbo Stream validation responses that keep failed modal submissions in context.

## 5. Mobile Responsiveness

Implemented:

- Responsive Bootstrap layout that stacks content on smaller screens.
- Bottom mobile navigation with Dashboard and Pipeline destinations.

Known gap:

- The Settings item in the mobile navigation is a placeholder and does not yet have a destination.
