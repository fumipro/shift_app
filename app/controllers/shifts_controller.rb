class ShiftsController < ApplicationController
  before_action :logged_in_user,
                only: %i[submission edit update destroy register_shift home notices notice_show register_shift]
  before_action :admin_user,
                only: %i[notice_new notice_create notice_edit notice_update notice_destroy event_new event_create event_edit
                         event_update event_destroy all_shift register_shift workday_new workday_create workday_destroy]
  before_action :no_admin_user,
                only: %i[submission]

  protect_from_forgery

  def home
    @workdays = Workday.where(user_id: current_user.id)
    @all_workdays = Workday.all
    @notices = Notice.first(5)
    @events = Event.all
  end

  def notices
    @notices = Notice.all
  end

  def notice_show
    @notice = Notice.find_by(id: params[:id])
  end

  def notice_new
    @notice = Notice.new
  end

  def notice_create
    @notice = Notice.new(notice_params)
    if @notice.save
      flash[:success] = '記入しました。'
      redirect_to('/')
    else
      flash[:danger] = @notice.errors.full_messages
      redirect_to('/notice/new')
    end
  end

  def notice_destroy
    Notice.find_by(id: params[:id]).destroy
    flash[:success] = '削除しました。'
    lastpath = Rails.application.routes.recognize_path(request.referer)
    if lastpath[:action] == 'home'
      redirect_to('/')
    else
      redirect_to('/notices')
    end
  end

  def notice_edit
    @notice = Notice.find(params[:id])
  end

  def notice_update
    @notice = Notice.find(params[:id])
    if @notice.update(notice_params)
      flash[:success] = '編集が完了しました。'
      redirect_to("/notice/#{params[:id]}/show")
    else
      flash[:danger] = @notice.errors.full_messages
      redirect_to("/notice/#{@notice.id}/edit")
    end
  end

  def event_new
    @event = Event.new
  end

  def event_create
    @event = Event.new(event_params)
    @event.date = @event.start_time
    if @event.save
      flash[:success] = '記入しました。'
      redirect_to('/')
    else
      flash[:danger] = @event.errors.full_messages
      redirect_to('/event/new')
    end
  end

  def events
    @events = Event.all
  end

  def event_destroy
    Event.find(params[:id]).destroy
    flash[:success] = '削除しました。'
    lastpath = Rails.application.routes.recognize_path(request.referer)
    if lastpath[:action] == 'home'
      redirect_to('/')
    else
      redirect_to('/events')
    end
  end

  def event_edit
    @event = Event.find(params[:id])
  end

  def event_update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      flash[:success] = '編集が完了しました。'
      redirect_to('/')
    else
      flash[:danger] = @event.errors.full_messages
      redirect_to("/event/#{@event.id}/edit")
    end
  end

  def register_shift
    @month = params[:month] ? Date.parse(params[:month]) : Time.zone.today
    @users = User.where.not(id: 1)
    @shifts = Shift.where(user_id: current_user.id)
  end

  def all_shift
    @month = params[:month] ? Date.parse(params[:month]) : Time.zone.today
    @users = User.where.not(id: 1)
    @workday = Workday.where(user_id: current_user.id)
  end

  def submission
    @shifts = Shift.where(user_id: current_user.id)
    @shift = Shift.new
    @events = Event.all
  end

  def new
    @shift = Shift.new
  end

  def create
    @shift = current_user.shifts.build(shift_params)
    if @shift.save
      flash[:success] = '記入しました。'
      redirect_to('/shifts')
    else
      flash[:danger] = @shift.errors.full_messages
      redirect_to("/shifts/new/#{@shift.user_id}/#{@shift.date}")
    end
  end

  def edit
    @shift = Shift.find_by(user_id: current_user.id, date: params[:date])
  end

  def update
    date = request.referer.slice(-10, 10)
    @shift = Shift.find_by(user_id: current_user.id, date: date)
    if @shift.present?
      @shift.save
      if @shift.update(shift_params)
        flash[:success] = '編集が完了しました。'
        redirect_to('/shifts')
      else
        flash[:danger] = @shift.errors.full_messages
        redirect_to("/shifts/edit/#{@shift.user_id}/#{@shift.date}")
      end
    else
      flash[:danger] = '編集に失敗しました。'
      redirect_to('/shifts')
    end
  end

  def destroy
    Shift.find_by(date: params[:format]).destroy
    redirect_to('/shifts')
  end

  def workday_new
    @workday = Workday.new
    @user = User.find_by(id: params[:user_id])
    @shift = Shift.find_by(user_id: params[:user_id], date: params[:date])
  end

  def workday_create
    @workday = Workday.new(workday_params)
    if @workday.save
      flash[:success] = 'シフトを登録しました。'
      redirect_to('/register_shift')
    else
      flash[:danger] = @workday.errors.full_messages
      redirect_to("/register_shift/new/#{@workday.user_id}/#{@workday.date}")
    end
  end

  def workday_show
    @all_workday = Workday.where(date: params[:date])
  end

  def workday_destroy
    Workday.find_by(user_id: params[:user_id], date: params[:date]).destroy
    flash[:success] = 'シフトを取り消しました'
    redirect_to('/register_shift')
  end

  private

  def shift_params
    params.require(:shift).permit(:begin_time, :finish_time, :date, :start_time, :user_id)
  end

  def workday_params
    params.require(:workday).permit(:begin_time, :finish_time, :date, :start_time, :user_id)
  end

  def notice_params
    params.require(:notice).permit(:title, :content)
  end

  def event_params
    params.require(:event).permit(:title, :start_time, :holiday)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'ログインしてください。'
      redirect_to login_url
    end
  end

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  # 管理者でないことを確認
  def no_admin_user
    redirect_to(root_url) unless !current_user.admin?
  end
end
