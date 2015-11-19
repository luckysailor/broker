require 'quickbase_sync/session'

module QuickbaseSync
  class Export < QuickbaseSync::Session
    
   def initialize(opt={})
     super(opt)
   end
   
   def query
     res = client.dbid_bji2vn2ck.qid_22.records.map { |r| r.to_s }
     sign_out && res
   end 
   
  end
end