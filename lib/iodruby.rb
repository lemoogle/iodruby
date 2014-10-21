require "iodruby/version"


require 'active_model'
require 'Unirest'
require 'active_support'
require 'httpclient'



module Iodruby



class IODError < StandardError

end

class IODClient
  @@version=1
  @@apidefault=1
  def initialize(url, apikey)
    # Instance variables

    @url = url
    @apikey = apikey

  end



  def deleteIndex(index)
    puts index.class.name
    if index.class.name=="IODIndex"
      index=index.name
    end

    data=Hash.new
    data[:index]=index

    delete=post("deletetextindex",data)
  confirm=delete["confirm"]
  data[:confirm]=confirm
  delete=post("deletetextindex",data)

  end


  def post(handler, data=Hash.new)
    data[:apikey]=@apikey
    data[:fake]=File.new("new.rb", 'rb')

    response=Unirest.post "#{@url}/#{@@version}/api/sync/#{handler}/v#{@@apidefault}",
                        headers:{ "Accept" => "application/json" },
                        parameters:data

=begin
  clnt = HTTPClient.new
  response= clnt.post('#{@url}/#{@@version}/api/sync/#{handler}/v#{@@apidefault}', data)
  puts "MARTIN"
  puts response
=end
     if response.code == 200
      return response.body
    else
      puts data[:json].encoding.name
    File.open('text.txt', 'w') { |file| file.write(data[:json]) }
      puts response.body
      raise IODError.new "Error #{response.body["error"]} -- #{response.body["reason"]}"
    end
  end


  def postasync(handler, data=Hash.new)
    data[:apikey]=@apikey
    response=Unirest.post "#{@url}/#{@@version}/api/async/#{handler}/v#{@@apidefault}",
                        headers:{ "Accept" => "application/json" },
                        parameters:data

     if response.code == 200
      return response.body
    else
      raise IODError.new "Error #{response.body["error"]} -- #{response.body["reason"]}"
    end
  end


  def getIndex(name)
    indexes=this.listIndexes()

    index=IODIndex.new(name,client:self)
    #puts (index in indexes)

  end



  def createIndex(name)
    data=Hash.new
    data[:index]=name
    data[:flavor]="standard"
    data[:type]="normal"
    self.post("createtextindex",data)
    return IODIndex.new(name,client:self)
  end

  def listIndexes()
    r=post("listindex")

    indexes=r["index"].map { |index| IODIndex.new(index["index"],index["flavor"],index["type"],client:self)}

  end


  def addDoc(doc, index)
      self.addDocs([doc],index)
  end

  def addDocs(docs, index)
      puts docs
      puts docs.length
      jsondocs= docs.map { |doc| doc.data}
    docs=Hash.new
    docs[:documents]=jsondocs
    #puts docs.to_json
    docs=docs.to_json
    #docs=render :json => JSON::dump(docs)
    data={json:docs,index:index}

    return self.post("addtotextindex",data)
  end

end




class IODIndex

    attr_reader :client
    attr_reader :name


  def initialize(name,flavor="standard",type="normal",client:nil)
    @name=name

    @client=client
    @docs=[]
  end

    def query(text,data=Hash.new)
      data[:database_match]=@name

      data[:text]=text
    result=@client.post("querytextindex",data)
    result["documents"].map!{|doc| IODDoc.new(doc) }
      return result
    end
   def size()
      return @docs.length
    end
  def pushDoc(doc)
    @docs.push(doc)

  end

  def commit()
#		docs={document:@docs}
#		data={json:docs.to_json,index:@name}
#		puts docs.to_json

    #r=@client.post("addtotextindex",data)
    #@docs=[]
    addDocs(@docs)
    @docs=[]
  end

  def addDoc(doc)
    docs=Hash.new

#		docs[:document]=[doc.data]
#		data={json:docs.to_json,index:@name}
#		@client.postasync("addtotextindex",data)
    puts @client.addDoc(doc,@name)
  end


  def addDocs(docs)

#		docs[:document]=[doc.data]
#		data={json:docs.to_json,index:@name}
#		@client.postasync("addtotextindex",data)

    puts @client.addDocs(docs,@name)
  end

  def delete()
    clientcheck()
    @client.deleteIndex(self)
  end

  def ==(other_object)
    comparison_object.equal?(self) || (comparison_object.instance_of?(self.class) && @name == other_object.name)
  end
end



class IODDoc

    attr_accessor :data
    attr_accessor :sentiment
    attr_accessor :entities
  def initialize(data)
    #@query=query
    @entities=Hash.new
    @data=data
  end

  def to_json(options={})
      return render :json => JSON::dump(@data)
  end



end


end
