class CodeExecutionController < ApplicationController
  protect_from_forgery with: :null_session

  def run_code
    code = params[:code]
    file_path = params[:file_path]
    repository = params[:repository]

    language = detect_language_from_file_path(file_path)
    output = execute_code_in_docker(code, language, repository)

    render json: { output: output }
  end

  private

  def detect_language_from_file_path(file_path)
    extension = File.extname(file_path).downcase
    case extension
    when '.py'
      'python'
    when '.rb'
      'ruby'
    when '.c'
      'c'
    when '.cpp'
      'cpp'
    when '.ts'
      'typescript'
    when '.r'
      'r'
    when '.kt'
      'kotlin'
    when '.go'
      'go'
    when '.rs'
      'rust'
    else
      'plaintext'
    end
  end

  def execute_code_in_docker(code, language, repository)
    Dir.mktmpdir do |dir|
      file_path = File.join(dir, "code.#{language_extension(language)}")
      File.write(file_path, code)

      download_repository(repository, dir)

      docker_image = language_docker_image(language)
      case language
      when 'c'
        compile_command = "docker run --rm -v #{dir}:/code #{docker_image} gcc /code/code.c -o /code/code.out && chmod +x #{dir}/code.out"
        compile_output = `#{compile_command}`
        run_command = "docker run --rm -v #{dir}:/code #{docker_image} /code/code.out"
        output = `#{run_command}`
      when 'cpp'
        compile_command = "docker run --rm -v #{dir}:/code #{docker_image} g++ /code/code.cpp -o /code/code.out && chmod +x #{dir}/code.out"
        compile_output = `#{compile_command}`
        run_command = "docker run --rm -v #{dir}:/code #{docker_image} /code/code.out"
        output = `#{run_command}`
      when 'rust'
        compile_command = "docker run --rm -v #{dir}:/code #{docker_image} rustc /code/code.rs -o /code/code.out && chmod +x #{dir}/code.out"
        compile_output = `#{compile_command}`
        run_command = "docker run --rm -v #{dir}:/code #{docker_image} /code/code.out"
        output = `#{run_command}`
      else
        run_command = "docker run --rm -v #{dir}:/code #{docker_image} /code/code.#{language_extension(language)}"
        output = `#{run_command}`
      end

      output
    end
  end

  def download_repository(repository, dir)
    client = Octokit::Client.new(access_token: current_user.token)
    repo = client.repository(repository)
    zipball = client.archive_link(repo.full_name, { format: 'zipball' })
    `curl -L #{zipball} -o #{dir}/repo.zip`
    `unzip #{dir}/repo.zip -d #{dir}`
  end

  def language_extension(language)
    case language
    when 'python'
      'py'
    when 'ruby'
      'rb'
    when 'c'
      'c'
    when 'cpp'
      'cpp'
    when 'typescript'
      'ts'
    when 'r'
      'r'
    when 'kotlin'
      'kt'
    when 'go'
      'go'
    when 'rust'
      'rs'
    else
      'txt'
    end
  end

  def language_docker_image(language)
    case language
    when 'python'
      'my-python-runner'
    when 'ruby'
      'my-ruby-runner'
    when 'c'
      'my-c-runner'
    when 'cpp'
      'my-cpp-runner'
    when 'typescript'
      'my-typescript-runner'
    when 'r'
      'my-r-runner'
    when 'kotlin'
      'my-kotlin-runner'
    when 'go'
      'my-go-runner'
    when 'rust'
      'my-rust-runner'
    else
      'alpine'
    end
  end
end
