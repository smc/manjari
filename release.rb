# frozen_string_literal: true

require 'gitlab'

API_URL = ENV['CI_API_V4_URL']
TOKEN = ENV['GITLAB_API_TOKEN']
PROJECT_NAME = ENV['CI_PROJECT_NAME']
PROJECT_ID = ENV['CI_PROJECT_ID']
VERSION = ENV['CI_COMMIT_TAG']

client = Gitlab.client(endpoint: API_URL, private_token: TOKEN)

assets_details = Dir['build/*'].map do |item|
  {
    name: File.basename(item),
    url: "#{API_URL}/projects/#{PROJECT_ID}/jobs/artifacts/#{VERSION}/raw/build/#{File.basename(item)}?job=build-tag"
  }
end

release_details = {
  name: VERSION,
  tag_name: VERSION,
  description: "Release #{VERSION} of #{PROJECT_NAME}",
  assets: {
    links: assets_details
  }
}

client.create_project_release(PROJECT_ID, release_details)
