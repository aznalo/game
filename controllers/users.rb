post '/login' do
  params = JSON.parse(request.body.read)
  p params
  user = User.find_by(username: params['name'])
  if user && user.authenticate(params['password'])
    body 'ユーザー認証が成功'
    status 201
  else
    body 'ユーザー名またはパスワードが不明'
    status 401
  end
end

post '/sign_up' do
  params = JSON.parse(request.body.read)
  new_user = User.new(
    username: params['username'],
    password: params['password'],
    password_confirmation: params['password']
  )
  if new_user
    body '新規ユーザーの作成が成功'
    status 201
  else
    body '新規ユーザーの作成に失敗'
    status 500
  end
end
