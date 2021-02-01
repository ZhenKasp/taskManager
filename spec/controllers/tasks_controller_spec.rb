describe TasksController, type: :controller do
  describe 'GET#index' do
    subject { get(:index) }

    context 'when user is authenticated' do
      let(:user) { create(:user, tasks: [task]) }
      let(:task) { create(:task) }

      before { sign_in(user) }

      it { is_expected.to have_http_status(200) }
      it { is_expected.to render_template(:index) }

      it 'assigns user tasks to instance variable' do
        subject

        expected_task = { task.due_time.to_date => [task] }

        expect(controller.instance_variable_get(:@tasks)).to eq(expected_task)
      end
    end

    context 'when user is not authenticated' do
      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to('/users/sign_in') }
    end
  end

  describe 'GET#show' do
    subject { get(:show, id: task_id) }

    context 'when user is authenticated' do
      let(:user) { create(:user, tasks: user_tasks) }

      let(:user_tasks) { create_list(:task, 2) }
      let(:not_user_task) { create(:task) }

      before { sign_in(user) }

      context 'when user has task with provided id' do
        let(:task_id) { user_tasks.last.id }

        it { is_expected.to have_http_status(200) }
        it { is_expected.to render_template(:show) }

        it 'assigns tasks with provided id to instance variable' do
          subject

          expect(controller.instance_variable_get(:@task)).to eq(user_tasks.last)
        end
      end

      context 'when user does not have task with provided id' do
        let(:error_response) { { 'error' => 'Something bad happen. Try again later.' } }
        let(:task_id) { not_user_task.id }

        it { is_expected.to have_http_status(400) }

        it 'returns json error' do
          subject

          expect(JSON.parse(response.body)).to eq(error_response)
        end
      end
    end

    context 'when user is not authenticated' do
      let(:task_id) { 0 }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to('/users/sign_in') }
    end
  end

  describe 'GET#new' do
    subject { get(:new, task: task_params) }

    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:task_params) { { title: 'task_params title', body: 'task_params body' } }

      before { sign_in(user) }

      it 'builds new task', :aggregate_failures do
        subject

        task = controller.instance_variable_get(:@task)

        expect(task.user_id).to eq(user.id)
        expect(task.title).to eq(task_params[:title])
        expect(task.body).to eq(task_params[:body])
      end

      it { is_expected.to have_http_status(200) }
      it { is_expected.to render_template(:new) }
    end

    context 'when user is not authenticated' do
      let(:task_params) { {} }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to('/users/sign_in') }
    end
  end

  describe 'POST#create' do
    subject { post(:create, task: task_params) }

    context 'when user is authenticated' do
      context 'and task_params are valid' do
        let(:user) { create(:user) }
        let(:task_params) { { title: 'task_params title', body: 'task_params body' } }

        before { sign_in(user) }

        it 'creates new task', :aggregate_failures do
          subject

          task = controller.instance_variable_get(:@task)

          expect(task[:id]).not_to be_nil
          expect(task[:title]).to eq(task_params[:title])
          expect(task[:body]).to eq(task_params[:body])
        end

        it { is_expected.to have_http_status(302) }
        it { is_expected.to redirect_to(controller.instance_variable_get(:@task)) }
      end

      context 'and task_params are not valid' do
        let(:user) { create(:user) }
        let(:task_params) { { title: 'task_params title', body: 'body' } }

        before { sign_in(user) }

        it { is_expected.to render_template(:new) }
      end
    end

    context 'when user is not authenticated' do
      let(:task_params) { { title: 'task_params title', body: 'task_params body' } }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to('/users/sign_in') }
    end
  end

  describe 'GET#edit' do
    subject { get(:edit, id: task_id) }

    context 'when user is authenticated' do
      let(:user) { create(:user, tasks: [task1]) }

      let(:task1) { create(:task) }
      let(:task2) { create(:task) }

      before { sign_in(user) }

      context 'when user has task with provided id' do
        let(:task_id) { task1.id }

        it { is_expected.to have_http_status(200) }
        it { is_expected.to render_template(:edit) }

        it 'assigns tasks with provided id to instance variable' do
          subject

          expect(controller.instance_variable_get(:@task)).to eq(task1)
        end
      end

      context 'when user does not have task with provided id' do
        let(:error_response) { { 'error' => 'Something bad happen. Try again later.' } }
        let(:task_id) { task2.id }

        it { is_expected.to have_http_status(400) }

        it 'returns json error' do
          subject

          expect(JSON.parse(response.body)).to eq(error_response)
        end
      end
    end

    context 'when user is not authenticated' do
      let(:task_id) { 0 }

      it { is_expected.to have_http_status(302) }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to('/users/sign_in') }
    end
  end

  describe 'PUT#update' do
    subject { put(:update, id: task_id, task: task_params) }

    context 'when user is authenticated' do
      context 'and task_params are valid' do
        let(:user) { create(:user) }
        let(:task1) { create(:task, user_id: user.id) }
        let(:task2) { create(:task) }
        let(:task_params) { { title: 'task_params title', body: 'task_params body' } }

        before { sign_in(user) }

        context 'when user has task with provided id' do
          let(:task_id) { task1.id }

          it { is_expected.to have_http_status(302) }
          it { is_expected.to redirect_to(task_path(id: task_id)) }

          it 'updates task with provided params' do
            subject

            task = controller.instance_variable_get(:@task)

            expect(task.title).to eq(task_params[:title])
            expect(task.body).to eq(task_params[:body])
          end
        end

        context 'when user does not have task with provided id' do
          let(:error_response) { { 'error' => 'Something bad happen. Try again later.' } }
          let(:task_id) { task2.id }

          it { is_expected.to have_http_status(400) }

          it 'returns json error' do
            subject

            expect(JSON.parse(response.body)).to eq(error_response)
          end
        end
      end

      context 'and task_params are not valid' do
        let(:user) { create(:user) }
        let(:task) { create(:task, user_id: user.id) }
        let(:task_params) { { title: 'task_params title', body: 'body' } }
        let(:task_id) { task.id }

        before { sign_in(user) }

        it { is_expected.to render_template(:edit) }
      end
    end

    context 'when user is not authenticated' do
      let(:task_params) { { title: 'task_params title', body: 'task_params body' } }
      let(:task_id) { 0 }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to('/users/sign_in') }
    end
  end

  describe 'DELETE#destroy' do
    subject { delete(:destroy, id: task_id) }

    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let!(:task1) { create(:task, user_id: user.id) }
      let(:task2) { create(:task) }

      before { sign_in(user) }

      context 'when user has task with provided id' do
        let(:task_id) { task1.id }

        it { is_expected.to have_http_status(302) }
        it { is_expected.to redirect_to(root_path) }

        it 'destroys a task' do
          expect { subject }.to change { Task.count }.from(1).to(0)
        end
      end

      context 'when user does not have task with provided id' do
        let(:error_response) { { 'error' => 'Something bad happen. Try again later.' } }
        let(:task_id) { task2.id }

        it { is_expected.to have_http_status(400) }

        it 'returns json error' do
          subject

          expect(JSON.parse(response.body)).to eq(error_response)
        end
      end
    end

    context 'when user is not authenticated' do
      let(:task_id) { 0 }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to('/users/sign_in') }
    end
  end
end
