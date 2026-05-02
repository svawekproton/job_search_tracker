json.extract! job_application, :id, :company_name, :position, :status, :applied_at, :url, :location, :description, :created_at, :updated_at
json.url job_application_url(job_application, format: :json)
