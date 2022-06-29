require 'open-uri'
require 'json'
class VideosController < ApplicationController
  before_action :set_video, only: %i[ show edit update destroy ]

  # GET /videos or /videos.json
  def index
    @videos = Video.all.order(id: :desc)
    @newvideo = Video.new
  end

  # GET /videos/1 or /videos/1.json
  def show
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos or /videos.json
  def create
    @video = Video.new(video_params)

    #URLから動画情報を登録
    url = @video.url.gsub(/http.+v=/, "")
    url = url.gsub(/http.+be\//, "")
    url = url.gsub(/&.+./, "")
    @video.url = url
    url = 'https://www.googleapis.com/youtube/v3/videos?id=' + url + '&key=' + ENV['YOTUBE_API_KEY'] + '&part=snippet,contentDetails,statistics'

    begin
      #動画情報取得
      json = URI.open(url)
      objs = JSON.parse(json.read)

      @video.title = objs['items'][0]['snippet']['title']
      @video.channel_id = objs['items'][0]['snippet']['channelId']
      @video.channel_name = objs['items'][0]['snippet']['channelTitle']
      @video.description = objs['items'][0]['snippet']['description']
      @video.posted_date = objs['items'][0]['snippet']['publishedAt'].to_datetime
      @video.play_count = objs['items'][0]['statistics']['viewCount']
      video_time = objs['items'][0]['contentDetails']['duration'].to_s
      #一時間以上で分が00の場合Hの後を00に
      if video_time.include?('H') && !video_time.include?('M') && video_time.include?('S')
        video_time.gsub!('H',':00:')
      else
        video_time.gsub!('H',':')
      end
      video_time.gsub!('PT','')
      video_time.gsub!('M',':')
      video_time.gsub!('S','')
      @video.time = video_time
      #動画の時間が2:2:2とかだったら2:02:02に変換する
      i = 0
      while @video.time.length > i
        if i > 0
          if @video.time.length == 2
            if @video.time.include?(':')
              @video.time.gsub!(':',':00')
            else
              @video.time = '0:' + @video.time
            end
          end
          if (@video.time[i-1] == ':' && @video.time[i+1] == ':') ||#両隣が : だったら
             (@video.time[i-1] == ':' && @video.time.length-1 == i) #左がが : で最後の文字だったら
            @video.time.insert(i, '0') #iの位置に0を挿入
          end
          if (@video.time[i] == ':' && @video.time.length-1 == i) #最後の文字が : だったら
            @video.time.insert(i+1, '0') #iの次の位置に00を挿入
            @video.time.insert(i+2, '0') #iの次の位置に00を挿入
          end
        end
        i += 1
      end
    rescue
      urlError = true
    end
  
    #チャンネル情報取得
    url = "https://www.googleapis.com/youtube/v3/channels?id=#{objs['items'][0]['snippet']['channelId']}&key=#{ENV['YOTUBE_API_KEY']}&part=snippet,brandingSettings,contentDetails,statistics,topicDetails"
    begin
      json = URI.open(url)
      objs = JSON.parse(json.read)

      @video.channel_icon = objs['items'][0]['snippet']['thumbnails']['default']['url']
      @video.channel_member_count = objs['items'][0]['statistics']['subscriberCount']
    rescue
      urlError = true
    end
    
    @video.view_rate = ((@video.play_count.to_f / @video.channel_member_count.to_f) * 100.0).round(1).to_s
    #保存
    if @video.save
      redirect_to videos_path
    end
  end

  # PATCH/PUT /videos/1 or /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to video_url(@video), notice: "Video was successfully updated." }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1 or /videos/1.json
  def destroy
    @video.destroy

    respond_to do |format|
      format.html { redirect_to videos_url, notice: "Video was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def all_delete
    @videos = Video.all
    @videos.destroy_all

    redirect_to videos_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def video_params
      params.require(:video).permit(:title, :url, :time, :posted_date, :description, :play_count, :channel_id, :channel_name, :channel_url)
    end
end
