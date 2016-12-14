require_relative "../lib/havenondemand.rb"

$client = HODClient.new("YOUR_API_KEY", "v1")
$parser = HODResponseParser.new()


params = {}
params["text"] = "Haven OnDemand is awesome"
params["language"] = 'eng'
hodApp = 'analyzesentiment'
r = $client.post_request(hodApp, params, false, nil)
puts r
