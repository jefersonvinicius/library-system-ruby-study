class ApplicationController < ActionController::API
    before_action :parse_token

    PER_PAGE = 5
  
    def make_meta(total_records:)
        @total_pages = (total_records / PER_PAGE).ceil + 1
        return {
        first_page: [0, 1].include?(current_page),
        last_page: current_page >= @total_pages,
        total_pages: @total_pages,
        page: current_page,
        total_records: total_records,
        per_page: PER_PAGE
        }
    end

    def current_page
        params.fetch(:page, 1).to_i
    end

    def offset
        (current_page - 1) * PER_PAGE
    end

    def render_not_found(args = nil)
        data = args.nil? ? nil : args.map{ |k,v| "#{k} = #{v}"}.join(", ")
        message = data.nil? ? "Model not found" : "Not found #{(self.class.to_s.sub! 'Controller', '').singularize} with #{data}" 
        render json: {message: message}, status: :not_found
    end

    def render_already_exists(**args)
        data = args.nil? ? nil : args.map{ |k,v| "#{k} = #{v}"}.join(", ")
        message = "#{(self.class.to_s.sub! 'Controller', '').singularize} with #{data} already exists"
        render json: {message: message}, status: :conflict
    end

    protected

        def current_user_id
            @token_decoded.id
        end

        def parse_token
            @token = request.headers['Authorization']&.split(' ')&.pop
            @token_decoded = Jwt.decode(@token)
        end

        def auth_jwt
            return render json: {message: 'Token not provided'}, status: :unauthorized if @token.nil?
            return render json: {message: 'Forbidden'}, status: :forbidden if @token_decoded.nil?
        end

        def auth_admin
            auth_jwt
            return render json: {message: 'You aren\'t an admin'}, status: :forbidden if !@token_decoded.is_admin
        end
end
