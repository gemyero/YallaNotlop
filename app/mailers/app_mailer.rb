class AppMailer < ApplicationMailer

    def send_mail(email, body, subject)
        mail(
            to: email,
            subject: subject,
            body: body
        )
    end

end
