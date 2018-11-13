post '/login' do
  params = JSON.parse(request.body.read)
  if params['username'] && params['password']
    user = User.find_by(username: params['username'])
    if user && user.authenticate(params['password'])
      token = UserToken.create(
        user_id: user.id,
        uuid: SecureRandom.uuid,
        expiration_time: Time.zone.now.since(1.hours)
      )
      status 201
      { user: user, token: token.uuid }.to_json
    else
      body 'ユーザー名またはパスワードが不明です'
      status 401
    end
  else
    body '指定されたKeyが存在しません'
    status 400
  end
end

post '/sign_up' do
  params = JSON.parse(request.body.read)
  if params['username'] && params['password']
    new_user = User.new(
      username: params['username'],
      password: params['password'],
      password_confirmation: params['password']
    )
    if new_user.save
      token = UserToken.create(
        user_id: new_user.id,
        uuid: SecureRandom.uuid,
        expiration_time: Time.zone.now.since(1.hours)
      )
      status 201
      { user: new_user, token: token.uuid }.to_json
    else
      body '新規ユーザーの作成に失敗しました'
      status 500
    end
  else
    body '指定されたKeyが存在しません'
    status 400
  end
end

post '/verification' do
  params = JSON.parse(request.body.read)
  token = UserToken.find_by(uuid: params['token'])
  if token && token.user && Time.zone.now < token.expiration_time
    status 200
  else
    status 400
  end
end

