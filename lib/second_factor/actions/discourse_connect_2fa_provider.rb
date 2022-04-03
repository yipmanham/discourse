# frozen_string_literal: true

module SecondFactor::Actions
  class DiscourseConnect2faProvider < Base
    def no_second_factors_enabled!(params)
    end

    def second_factor_auth_required!(params)
    end

    def second_factor_auth_completed!(callback_params)
    end
  end
end
