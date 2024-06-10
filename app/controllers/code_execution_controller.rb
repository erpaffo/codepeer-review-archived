# app/controllers/code_execution_controller.rb
class CodeExecutionController < ApplicationController
  protect_from_forgery with: :null_session

  def run_code
    code = params[:code]
    language = detect_language_from_code(code)

    output = execute_code_in_docker(code, language)

    render json: { output: output }
  end

  private

  def detect_language_from_code(code)
    # Logica per rilevare il linguaggio dal codice
    'python' # Esempio: sempre Python
  end

  def execute_code_in_docker(code, language)
    Dir.mktmpdir do |dir|
      file_path = File.join(dir, "code.#{language_extension(language)}")
      File.write(file_path, code)

      docker_image = language_docker_image(language)
      command = "docker run --rm -v #{dir}:/code #{docker_image}"

      output = `#{command}`
      output
    end
  end

  def language_extension(language)
    case language
    when 'python'
      'py'
    # Aggiungi altri linguaggi qui
    else
      'txt'
    end
  end

  def language_docker_image(language)
    case language
    when 'python'
      'my-python-runner'
    # Aggiungi altri linguaggi qui
    else
      'alpine'
    end
  end
end
