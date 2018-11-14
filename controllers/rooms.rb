get '/room' do
  rooms = []
  Room.all.each do |r|
    rooms << {
      room: r,
      users: r.users
    }
  end
  rooms.to_json
end

get '/room/:id' do
  room = Room.find_by(id: params[:id])
  {
    room: room,
    users: room.users
  }.to_json
end

post '/room' do
  params = JSON.parse(request.body.read)
  room = Room.new(
    name: params['name'],
    password: params['password'],
    password_confirmation: params['password']
  )
  if room.save
    status 201
    {
      room: room,
      users: []
    }.to_json
  else
    body 'ルームの作成に失敗しました'
    status 500
  end
end

post '/join-room' do
  params = JSON.parse(request.body.read)
  user = User.find_by(id: params['user_id'])
  room = Room.find_by(id: params['room_id'])
  if user && room
    if UserRoom.already_joined(user.id).empty?
      ur = UserRoom.new(
        user: user,
        room: room
      )
      if ur.save
        body 'ゲームに参加しました'
        status 201
      else
        body 'ゲーム参加できませんでした'
        status 500
      end
    else
      body '参加中のゲームは終了していません'
      status 409
    end
  else
    body '指定されたユーザーまたはルームが存在しません'
    status 404
  end
end
