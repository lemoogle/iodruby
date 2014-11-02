require_relative "../lib/iodruby.rb"

$apikey="1642237f-8d30-4263-b2f9-12efab36c779"



def test_post
  client= IODClient.new("http://api.idolondemand.com",$apikey)
  r=client.post("querytextindex",{:text=>"hello",:absolute_max_result=>1000})
  puts "\n",r.json()["documents"][0]["reference"],"\n"
end


def test_post_async
  client= IODClient.new("http://api.idolondemand.com",$apikey)
  r=client.post("querytextindex",{:text=>"hello"},async=true)
  #returns jobid
  puts r.jobID
  # will return status of call, queued or finished
  puts r.status().json()
  # Will wait until result to return
  puts r.result().json()
end



def test_indexing(index="mytestindex")
  client= IODClient.new("http://api.idolondemand.com",$apikey)
  index=client.getIndex("myrssdb")

  doc={:title=>"title",:reference=>"ref",:content=>"content"}
  index.pushDoc(doc)
  puts index.commit().json()
end



def test_createIndex
  client= IODClient.new("http://api.idolondemand.com",$apikey)
  index=client.createIndex("mytestindex",flavor="explorer")
  puts index.json()
end



def test_deleteIndex
  client= IODClient.new("http://api.idolondemand.com",$apikey)
  puts client.deleteIndex("mytestindex")
end

def test_createConnector
  client= IODClient.new("http://api.idolondemand.com",$apikey)
  conn=IODConnector.new("mytestconnector",client)
  puts conn.create(type="web",config={ "url" => "http://www.idolondemand.com" })
  puts conn.delete()
end


test_createConnector()

#test_createIndex()
