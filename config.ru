require "./app"

# initialize with default credentials from file
$app = AppState.new(JSON.parse(File.read("credentials/test_credentials.json")))

AuthAPI.use Authenticator, app: $app
run Cuba