# app/controllers/code_execution_controller.rb
class CodeExecutionController < ApplicationController
  protect_from_forgery with: :null_session

  def run_code
    code = params[:code]
    language = params[:language]
    packages = params[:packages] || []

    output = execute_code_in_docker(code, language, packages)

    render json: { output: output }
  end

  private

  def execute_code_in_docker(code, language, packages)
    Dir.mktmpdir do |dir|
      file_path = File.join(dir, "code.#{language_extension(language)}")
      File.write(file_path, code)

      case language
      when 'python'
        requirements_path = File.join(dir, 'requirements.txt')
        File.open(requirements_path, 'w') do |file|
          packages.each { |pkg| file.puts(pkg) }
        end
      when 'ruby'
        gemfile_path = File.join(dir, 'Gemfile')
        File.open(gemfile_path, 'w') do |file|
          file.puts("source 'https://rubygems.org'")
          packages.each { |pkg| file.puts("gem '#{pkg}'") }
        end
        File.write(File.join(dir, 'Gemfile.lock'), '')
      when 'typescript'
        package_json_path = File.join(dir, 'package.json')
        File.open(package_json_path, 'w') do |file|
          file.puts('{"dependencies": {')
          packages.each_with_index do |pkg, index|
            file.puts("\"#{pkg}\": \"latest\"#{',' unless index == packages.size - 1}")
          end
          file.puts('}}')
        end
        File.write(File.join(dir, 'package-lock.json'), '')
      end

      docker_image = language_docker_image(language)
      command = "docker run --rm -v #{dir}:/code #{docker_image}"

      output = `#{command}`
      output
    end
  end

  def language_extension(language)
    case language
    when 'python' then 'py'
    when 'ruby' then 'rb'
    when 'c' then 'c'
    when 'cpp' then 'cpp'
    when 'typescript' then 'ts'
    when 'r' then 'r'
    when 'kotlin' then 'kt'
    when 'go' then 'go'
    when 'rust' then 'rs'
    else 'txt'
    end
  end

  def language_docker_image(language)
    case language
    when 'python' then 'my-python-runner'
    when 'ruby' then 'my-ruby-runner'
    when 'c' then 'my-c-runner'
    when 'cpp' then 'my-cpp-runner'
    when 'typescript' then 'my-typescript-runner'
    when 'r' then 'my-r-runner'
    when 'kotlin' then 'my-kotlin-runner'
    when 'go' then 'my-go-runner'
    when 'rust' then 'my-rust-runner'
    else 'alpine'
    end
  end
end
