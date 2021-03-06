require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'AUTHENTICATION' do
    it "allows only unauthenticated users to create account" do
      expect(controller).to(
        filter(:before, with: :redirect_authenticated_user, only: [:new, :create])
      )
    end
  end

  describe 'ACTIONS' do
    log_out

    describe 'GET #new' do
      it "renders 'users/new'" do
        get :new
        expect(response).to render_template('users/new')
        expect(response.status).to eq 200
      end
    end

    describe 'POST #create' do
      context 'VALID PARAMS' do
        let(:valid_params) { { user: FactoryGirl.attributes_for(:user) } }

        it 'creates new user' do
          expect do
            post :create, params: valid_params
          end.to change(User, :count).by(1)
        end

        it 'calls create method of UserRecorder' do
          expect_any_instance_of(UserRecorder).to receive(:create) { FactoryGirl.create :user }
          post :create, params: valid_params
        end

        it 'authenticates created user' do
          valid_params[:user][:email] = 'new@user.com'
          post :create, params: valid_params
          expect(current_user.email).to eq valid_params[:user][:email]
        end

        it 'sets flash[:notice] message' do
          post :create, params: valid_params
          expect(flash[:notice]).to be_present
        end

        it 'redirects to root_path' do
          post :create, params: valid_params
          expect(response).to redirect_to root_path
        end
      end

      context 'INVALID PARAMS' do
        let(:invalid_params) { { user: FactoryGirl.attributes_for(:invalid_user) } }

        it 'does not create new user' do
          expect do
            post :create, params: invalid_params
          end.not_to change(User, :count)
        end

        it 'calls create method of UserRecorder' do
          expect_any_instance_of(UserRecorder).to receive(:create) { FactoryGirl.build :invalid_user }
          post :create, params: invalid_params
        end

        it "renders 'users/new'" do
          post :create, params: invalid_params
          expect(response).to render_template('users/new')
          expect(response.status).to eq 422
        end
      end
    end
  end
end
