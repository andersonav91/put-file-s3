# Require the bundler gem and then call Bundler.require to load in all gems
# listed in Gemfile.
require 'bundler'
Bundler.require
require 'fileutils'

# you have to set the AWS_SECRET_ACCESS_KEY, AWS_ACCESS_KEY_ID env vars too
#
# put file to s3
post '/putFile' do
  content_type :json
  begin
    # upload the file
    tempfile = params[:file][:tempfile]
    filename = params[:file][:filename]
    FileUtils.cp(tempfile.path, "public/#{filename}")

    require 'aws-sdk-s3'
    s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
    obj = s3.bucket(ENV['S3_BUCKET_NAME']).object(filename)
    obj.upload_file(tempfile.path, { acl: 'public-read' })
    return { url: obj.public_url, status: "ok" }.to_json
  rescue  Exception => error
    return { message: error.to_s, status: "error", trace: error.backtrace }.to_json
  end
end

post '/helloWorld' do
  content_type :json
  return { message: "Hello World", status: "ok" }.to_json
end

post '/addition' do
  content_type :json
  number1 = params[:number1].to_f rescue 0
  number2 = params[:number2].to_f rescue 0
  return { result: (number2 + number1), status: "ok" }.to_json
end

get '/' do
  content_type :json
  return { response: "I´m exists", status: "ok" }.to_json
end

post '/printFileName' do
  content_type :json
  fileName = params[:name] rescue "empty"
  return { response: fileName, status: "ok" }.to_json
end