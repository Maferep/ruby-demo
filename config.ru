require "./app"
AuthAPI.use Authenticator, app: $app
run Cuba