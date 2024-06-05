class ProjectMailer < ApplicationMailer
  def collaborator_invitation(project, collaborator)
    @project = project
    @collaborator = collaborator
    mail(to: @collaborator.email, subject: "Invitation to collaborate on project #{@project.name}")
  end
end
