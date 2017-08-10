# Use this file to easily define all of your cron jobs.

every 60.seconds do
  region = ENV['AWS_REGION'] or raise 'Missing AWS region'
  rake "write_item[\"#{region}\"]"
end
