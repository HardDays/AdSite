class NewsMailer < ApplicationMailer
      layout 'mailer'

    def news_email(user, news)
        @user = user
        @news = news
        mail(from:'patrimoinemail@gmail.com', to: @user.email, subject: "Patrimoine announce: #{@news.title}")
    end
end
