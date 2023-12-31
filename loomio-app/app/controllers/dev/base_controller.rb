class Dev::BaseController < ApplicationController
  before_action :ensure_not_production

  def index
    @routes = self.class.action_methods.select do |action|
      /^(test_|setup_|view_)/.match action
    end
    render 'dev/main/index', layout: false
  end

  def import_test_data
    GroupExportService.import('tmp/test.json')
    sign_in User.first
    redirect_to Group.order('memberships_count desc').first
  end

  def last_email(to: nil)
    @email = if to.present?
      ActionMailer::Base.deliveries.filter { |email| Array(email.to).include?(to.email) }
    else
      ActionMailer::Base.deliveries
    end.last
    render template: 'dev/main/last_email', layout: false
  end

  private

  def ensure_not_production
    raise "Development and testing only" if Rails.env.production?
  end
end
