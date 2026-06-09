require "rails_helper"

RSpec.describe "Job application flow", type: :system do
  self.use_transactional_tests = false

  let(:email_address) { "system@example.com" }

  before do
    User.where(email_address:).destroy_all
  end

  after do
    User.where(email_address:).destroy_all
  end

  let!(:user) { User.create!(email_address:, password: "password", password_confirmation: "password") }
  let!(:job_application) do
    user.job_applications.create!(
      company_name: "Acme",
      position: "Engineer",
      status: :applied,
      applied_at: Date.current,
      description: "Build products."
    )
  end

  it "logs in, previews a status change, and keeps invalid modal submissions open" do
    visit new_session_path
    fill_in "Email address", with: email_address
    fill_in "Password", with: "password"
    click_button "Sign in"
    expect(page).to have_current_path(root_path, ignore_query: true)
    click_link email_address
    expect(page).to have_button("Logout")

    visit job_application_path(job_application)
    select "Interviewing", from: "job_application_status"

    expect(page).to have_css("[data-status-updater-target='badge']", text: "Interviewing")
    expect(page).to have_content("Job application was successfully updated.")

    # Reset headless Chrome's native select state before exercising modal clicks.
    visit job_application_path(job_application)
    expect(page).to have_css("[data-status-updater-target='badge']", text: "Interviewing")

    page.execute_script("document.querySelector('[data-modal-selector-value=\"#addNoteModal\"]').click()")
    expect(page).to have_css("#addNoteModal.show")
    page.execute_script("document.querySelector('#addNoteModal input[type=\"submit\"]').click()")

    within "#addNoteModal" do
      expect(page).to have_content("Please fix the following:")
    end
    page.execute_script("document.querySelector('#addNoteModal .btn-close').click()")
    expect(page).to have_no_css("#addNoteModal.show")

    page.execute_script("document.querySelector('[data-modal-selector-value=\"#addEventModal\"]').click()")
    expect(page).to have_css("#addEventModal.show")

    # Exercise server-side validation instead of the browser's required-field guard.
    page.execute_script(<<~JS)
      document.querySelector("#new_event").querySelectorAll("[required]").forEach((field) => {
        field.removeAttribute("required")
      })
    JS
    page.execute_script("document.querySelector('#addEventModal input[type=\"submit\"]').click()")

    within "#addEventModal" do
      expect(page).to have_content("Please fix the following:")
    end
  end
end
